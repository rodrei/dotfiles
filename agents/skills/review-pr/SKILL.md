---
name: review-pr
description: Review a GitHub PR the way I like it
---
1. Fetch the PR with `gh pr view $ARGUMENTS --json title,body,files` and `gh pr diff $ARGUMENTS`.
2. When `HERDR_ENV` is 1, name the Herdr workspace after the review if it still has its default name. `herdr workspace get "$HERDR_WORKSPACE_ID"` shows its `label`, `tab_count` and `pane_count`; Herdr's default label is the name of the git repo or directory the workspace opened in, such as `attuned`. With one tab, one pane and a default label, run `herdr workspace rename "$HERDR_WORKSPACE_ID" "<name>"`: `Review <repo> <PR number>` for one PR, such as `Review attuned 10125`, or `Review <topic>` for several, the topic a few words for what the PRs change together. Any other label is one I chose: keep it.
3. Give me a 5-bullet HIGH-LEVEL summary first, then go straight into the deep review in the same turn.
4. Deep review: review only this PR, check CI, and verify suspected bugs with a repro test (use a separate worktree).
5. Give me the findings, and draft the comment addressed to the author: findings only, grouped as Blocking / Should-fix / Nits, with file:line refs. No bare ticket IDs.
6. Post only after I approve: `gh pr comment $ARGUMENTS --body-file /tmp/review.md`.
