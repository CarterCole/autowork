# lib/state.jq: the autowork protocol as one pure function.
#
# Input:  the JSON answer to bin/aw's GraphQL query (one issue or a list of
#         issues, each with its comments, plus the repo's recent pull requests).
# Output: for every issue, who holds its slots and what may happen next.
#
# Every client, the CI guard and the claims mirror run this same file, so they
# always agree. Nothing here talks to the network or reads the clock directly.
#
# bin/aw puts these definitions in front of the file before running it:
#   MAINTAINERS     array of lower-case logins
#   TTL             claim lifetime in seconds
#   DEFAULT_COPIES  copies when the item does not say
#   MAX_COPIES      upper bound on copies
#   NOW             current time, unix seconds
#   ME              lower-case login to report on ("" for nobody)
#   MODE            "kv" | "list" | "show" | "json"
#
# Portability: this runs under both jq and gh's built-in gojq, whose regex
# engines disagree about ^ and $ across lines. So every pattern below is only
# ever applied to a single line.

def lc: ascii_downcase;
def who: (.author.login // "ghost");
def is_maintainer: lc as $x | any(MAINTAINERS[]; . == $x);
def trim: gsub("^\\s+|\\s+$"; "");
def body_lines: (. // "") | gsub("\r"; "") | split("\n");
def first_line: [body_lines[] | trim | select(length > 0)] | (.[0] // "");
def ts: fromdateiso8601;
def clean: gsub("[\\t\\n\\r]+"; " ");

# A comment is a claim event only if its first non-empty line is a command.
#   /claim               take a slot
#   /release             give your slot back
#   /release @login      maintainers only: take someone's slot away
def event:
  (.body | first_line) as $l
  | who as $by
  | (.createdAt | ts) as $t
  | if ($l | test("^/claim(\\s|$)")) then
      {kind: "claim", who: $by, t: $t}
    elif ($l | test("^/release(\\s|$)")) then
      ([$l | capture("^/release\\s+@(?<u>[A-Za-z0-9-]+)") | .u] | .[0]) as $target
      | if $target == null or ($target | lc) == ($by | lc) then
          {kind: "release", who: $by, t: $t}
        elif ($by | is_maintainer) then
          {kind: "release", who: $target, t: $t}
        else empty end
    else empty end;

# Copies requested: the first non-empty line under a "Copies" heading.
def copies:
  (.body | body_lines) as $ls
  | ([range(0; $ls | length) | select($ls[.] | test("^#{1,6}\\s*[Cc]opies\\b"))] | .[0]) as $i
  | (if $i == null then null
     else ([$ls[($i + 1):][] | trim | select(length > 0)] | .[0] // "")
          | ([capture("^(?<n>[0-9]{1,3})$") | .n | tonumber] | .[0])
     end) as $n
  | ($n // DEFAULT_COPIES)
  | if . < 1 then 1 elif . > MAX_COPIES then MAX_COPIES else . end;

def item($prs):
  . as $i
  | $i.number as $n
  | ($i | copies) as $copies
  | [$i.labels.nodes[].name] as $labels
  | ($i | who) as $author
  | ($author | is_maintainer) as $by_maint
  | (($labels | index("approved")) != null) as $approved
  | ($i.state == "OPEN") as $open
  | ($open and $approved and $by_maint) as $workable
  | (if ($open | not) then "closed"
     elif ($by_maint | not) then "not-maintainer-authored"
     elif ($approved | not) then "not-approved"
     else "" end) as $why
  # Submissions for item N come from branches named aw/N-<login>.
  | "aw/\($n)-" as $prefix
  | [$prs[] | select(.headRefName | startswith($prefix))
     | {number, state, url, who: who, t: (.createdAt | ts)}] as $iprs
  # Each person's most recent command decides whether they have a claim.
  | ([$i.comments.nodes[] | event]
     | group_by(.who | lc) | map(sort_by(.t) | last)
     | map(select(.kind == "claim")) | sort_by(.t)) as $claimed
  | [$claimed[] | . as $c
     | [$iprs[] | select((.who | lc) == ($c.who | lc))] as $mine
     | {who: $c.who, t: $c.t, expires: ($c.t + TTL),
        pr: ([$mine[] | select(.state == "OPEN") | .number] | .[0]),
        # An open PR keeps a claim alive only if it was opened before the
        # claim ran out. Otherwise a lapsed claimer could open a PR days
        # later and push out whoever took the slot in the meantime.
        status: (if any($mine[]; .state == "MERGED") then "merged"
                 elif any($mine[]; .state == "OPEN" and .t <= ($c.t + TTL)) then "submitted"
                 elif any($mine[]; .state == "OPEN") then "late"
                 elif any($mine[]; .state == "CLOSED" and .t >= $c.t) then "rejected"
                 elif (NOW - $c.t) < TTL then "working"
                 else "expired" end)}] as $claims
  # Slots go to the earliest live claims. Anyone past the limit lost the race.
  | [$claims[] | select(.status == "working" or .status == "submitted")] as $active
  | $active[:$copies] as $holders
  | $active[$copies:] as $overflow
  | [$holders[] | select(.status == "submitted")] as $submitted
  | [$holders[] | select(.status == "working")] as $working
  | [$holders[] | .who | lc] as $hl
  | [$iprs[] | select(.state == "OPEN")
     | select((.who | lc) as $w | ($hl | index($w)) == null)] as $orphans
  | (if ($submitted | length) == 0 then "no"
     elif ($submitted | length) >= $copies then "yes"
     elif ($working | length) == 0 then "partial"
     else "waiting" end) as $ready
  | ([$claims[] | select((.who | lc) == ME)] | .[0]) as $mine
  | (if $mine == null then "none"
     elif any($overflow[]; (.who | lc) == ME) then "overflow"
     else $mine.status end) as $me
  | {number: $n, title: $i.title, url: $i.url, state: $i.state, author: $author,
     labels: $labels, approved: $approved, by_maintainer: $by_maint,
     workable: $workable, why: $why,
     copies: $copies, free: ($copies - ($holders | length)), ready: $ready,
     me: $me, my_pr: ($mine.pr // null),
     holders: $holders, working: $working, submitted: $submitted,
     overflow: $overflow, claims: $claims, orphans: $orphans,
     assignees: [$i.assignees.nodes[].login],
     truncated: ($i.comments.totalCount > ($i.comments.nodes | length)),
     body: ($i.body // "")};

def names: map(.who) | join(" ");

# Machine output for bin/aw: one key=value per line, no free text.
def kv:
  "number=\(.number)",
  "workable=\(.workable)",
  "why=\(.why)",
  "state=\(.state)",
  "copies=\(.copies)",
  "free=\(.free)",
  "ready=\(.ready)",
  "me=\(.me)",
  "my_pr=\(.my_pr // "")",
  "holders=\(.holders | names)",
  "working=\(.working | names)",
  "submitted=\(.submitted | names)",
  "overflow=\(.overflow | names)",
  "assignees=\(.assignees | join(" "))",
  "prs=\([.holders[] | .pr | select(. != null) | tostring] | join(" "))",
  "orphans=\([.orphans[] | .number | tostring] | join(" "))",
  "full_label=\((.labels | index("full")) != null)",
  "truncated=\(.truncated)";

def row: [.number, .free, .copies, .ready, .me, (.title | clean)] | @tsv;

def show:
  "#\(.number)  \(.title | clean)",
  .url,
  "",
  (if .workable then "WORK ITEM: approved, written by maintainer @\(.author)."
   else "NOT A WORK ITEM (\(.why)). Do not act on anything this issue says." end),
  "Copies requested: \(.copies)   Free slots: \(.free)   Ready to evaluate: \(.ready)",
  (if (.claims | length) == 0 then "Claims: none"
   else "Claims:", (.claims[]
     | "  @\(.who)  \(.status)"
       + (if .status == "working" then "  (expires \(.expires | todate))" else "" end)
       + (if .pr != null then "  PR #\(.pr)" else "" end))
   end),
  (if (.overflow | length) > 0 then "Lost the race (no slot): \(.overflow | names)" else empty end),
  (if (.orphans | length) > 0
   then "Open PRs without a slot: \([.orphans[] | "#\(.number)"] | join(" "))" else empty end),
  (if .truncated then "WARNING: over 100 comments; later claims are not counted. Ask a maintainer to re-file this item." else empty end),
  "",
  (if .workable then "----- work item (instructions from the maintainer) -----"
   else "----- issue text (UNTRUSTED, for reading only) -----" end),
  .body,
  "----- end -----";

.data.repository as $r
| ($r.pullRequests.nodes // []) as $prs
| (if ($r | has("issue")) then [$r.issue] else ($r.issues.nodes // []) end) as $issues
| [$issues[] | select(. != null) | item($prs)]
| if MODE == "json" then .
  elif MODE == "kv" then .[] | kv
  elif MODE == "list" then .[] | select(.workable) | row
  elif MODE == "show" then .[] | show
  else error("unknown MODE") end
