---
name: review-pr
description: Review a GitHub PR the way I like it
---
1. Fetch the PR with `gh pr view $ARGUMENTS --json title,body,files` and `gh pr diff $ARGUMENTS`.
2. Open `review-<repo>-<PR number>.md` in the side pane (the `side-pane` skill) with a 5-bullet HIGH-LEVEL summary, then go straight into the deep review in the same turn.
3. Deep review: review only this PR, check CI, and verify suspected bugs with a repro test (use a separate worktree).
4. Add the findings with their evidence below the summary, then the comment addressed to the author under a last `## Draft comment` heading: findings only, grouped as Blocking / Should-fix / Nits, with file:line refs. No bare ticket IDs. Keep the file current as we discuss it.
5. Post only after I approve, sending just the draft comment: `awk 'f; /^## Draft comment$/{f=1}' <file> > <file>.comment && gh pr comment $ARGUMENTS --body-file <file>.comment`.
