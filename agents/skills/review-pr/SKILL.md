---
name: review-pr
description: Review a GitHub PR the way I like it
---
1. Fetch the PR with `gh pr view $ARGUMENTS --json title,body,files` and `gh pr diff $ARGUMENTS`.
2. Give me a 5-bullet HIGH-LEVEL summary first, then STOP and wait.
3. On 'go deep': review only this PR, check CI, and verify suspected bugs with a repro test (use a separate worktree).
4. Draft the comment addressed to the author: findings only, grouped as Blocking / Should-fix / Nits, with file:line refs. No bare ticket IDs.
5. Post only after I approve: `gh pr comment $ARGUMENTS --body-file /tmp/review.md`.
