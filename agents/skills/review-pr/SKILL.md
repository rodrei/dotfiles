---
name: review-pr
description: Review a GitHub PR the way I like it
---
1. Fetch the PR with `gh pr view $ARGUMENTS --json title,body,files` and `gh pr diff $ARGUMENTS`.
2. When `HERDR_ENV` is 1, name the Herdr workspace after the review if it still has its default name. `herdr workspace get "$HERDR_WORKSPACE_ID"` shows its `label`, `tab_count` and `pane_count`; Herdr's default label is the name of the git repo or directory the workspace opened in, such as `attuned`. With one tab, one pane and a default label, run `herdr workspace rename "$HERDR_WORKSPACE_ID" "<name>"`: `Review <repo> <PR number>` for one PR, such as `Review attuned 10125`, or `Review <topic>` for several, the topic a few words for what the PRs change together. Any other label is one I chose: keep it.
3. Open `review-<repo>-<PR number>.md` in the side pane (the `side-pane` skill) with a 5-bullet HIGH-LEVEL summary, then go straight into the deep review in the same turn.
4. Deep review: review only this PR, check CI, and verify suspected bugs with a repro test (use a separate worktree).
5. Add the findings with their evidence below the summary, then the comment addressed to the author under a last `## Draft comment` heading: findings only, grouped as Blocking / Should-fix / Nits, with file:line refs. No bare ticket IDs. Keep the file current as we discuss it.
6. Post only after I approve, sending just the draft comment: `awk 'f; /^## Draft comment$/{f=1}' <file> > <file>.comment && gh pr comment $ARGUMENTS --body-file <file>.comment`.
