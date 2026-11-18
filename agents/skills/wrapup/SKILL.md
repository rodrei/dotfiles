---
name: wrapup
description: Finish this session's task. Close its card, remove its worktrees and close its Herdr workspace.
disable-model-invocation: true
---

# Wrap up

The user is done with this session's task. Close out what belongs to it in the order below. The last step closes this session's Herdr workspace, which ends the session. Anything you can't verify as safe to close stays where it is, goes in the report, and keeps the workspace open: a wrapup that left something behind ends with the report, so the user sees what's left.

## 1. Card

This session's card is the one the prompt's "Taskboard:" line names. If there's no card, or you're outside Herdr, skip this step and step 4's card check.

Find the card's status and PRs in `taskboard list`. A PR is **settled** when it's merged or closed, or when it's someone else's and the user approved it. Check with `gh pr view URL --json state,author,reviews`, comparing against the user's login from `gh api user --jq .login`. Check each PR after everything else this prompt asked for, such as an approval, is done.

- `done` or `wont_do`: nothing to do.
- Any other status, with every PR settled or no PRs: run `taskboard set ID --status done`.
- Any PR not settled: leave the card and report which PR. The card blocks the close.

## 2. Review reactions

A review task is one whose PRs include someone else's. Its PRs are the card's, or without a card the ones this session reviewed. For any other task, skip this step.

For each PR the user approved (the `gh pr view` check in step 1), tick the message that asked for the review in #team-platform (`C09CYK97SM6`), with the Slack connector:

1. Search for the PR's URL without `https://`, such as `github.com/Attuned-Corp/attuned/pull/10125`, with the filter `in:<#C09CYK97SM6>`. The message is the latest match someone else wrote.
2. If the user approved every PR that message links, react to it with `white_check_mark` and `claude`.

The step is done when every approved PR's message has both reactions, or the PR is in the report as having no message. The close goes ahead whatever this step finds.

## 3. Worktrees

This task's worktrees are the ones under `~/code/worktrees/` that this session created or worked in, including the one the session runs in. Leave every other worktree alone, however stale it looks.

Check each one:

- **Clean**: `git -C PATH status --porcelain` prints nothing.
- **Saved**: the branch is pushed (`git -C PATH rev-list @{u}..HEAD` prints nothing), or it's merged. A branch counts as merged when `git merge-base --is-ancestor BRANCH origin/main` passes after a fetch, or when `gh pr list --head BRANCH --state merged --json headRefOid` shows a PR whose head is the branch tip. The second check covers squash merges.

If a worktree fails either check, leave it and report why. If it passes, find the workspaces it's open in:

- Herdr TUI (`HERDR_ENV=1`): `herdr worktree list --cwd PATH` shows its `open_workspace_id`.
- Herdr app (`HC_TERMINAL_ID` set): it's open in every space with a terminal inside it. `hc ls --json` lists each terminal's `address` and `cwd`. For each terminal whose `cwd` is PATH or below it, `hc get ADDRESS --json | jq -r '.labels["herdr.space"]'` is its space. A terminal without that label is a background job outside the window: count it as another workspace.

Then:

- **Not open**: run `git -C MAIN_CHECKOUT worktree remove PATH`. If the branch is merged, also delete it with `git -C MAIN_CHECKOUT branch -D BRANCH`.
- **Open in this workspace only** (`$HERDR_WORKSPACE_ID` in the TUI, the `herdr.space` label of `$HC_TERMINAL_ID` in the app): its removal is part of step 4's close.
- **Open in another workspace**: leave it and report it. Removing it would pull the folder out from under whatever runs there, and in the TUI it closes that workspace.

Remove worktrees with `git` rather than `herdr worktree remove`. The Herdr command closes the worktree's workspace and keeps the branch, so for this session's own worktree it would end the session before the branch could be deleted.

## 4. Close the workspace

Outside Herdr, skip this step.

Close only when steps 1 and 3 left nothing behind and the card shows `done` or `wont_do` in `taskboard list`. Then list this workspace's panes. If one runs something other than this session and the side pane, ask the user before closing, because closing ends whatever runs there.

- Herdr TUI: `herdr pane list --workspace "$HERDR_WORKSPACE_ID"`. This session is `$HERDR_PANE_ID`, and the side pane is labelled `side-pane`.
- Herdr app: this space's terminals in `herdr-app ls`. This session is `$HC_TERMINAL_ID`, and the side pane is the terminal `hc ls --json --label herdr.space=SPACE --label side-pane=1` lists.

First write the report as the message text: the card's move, the reactions added, the worktrees removed, the branches deleted. Then, in the same message, run the close as the last tool call. It ends this session, so nothing after it reaches the user. The command starts by checking the card again, so a card that isn't closed stops it before anything is removed. If this workspace's worktree passed step 3, the command removes it too:

```
taskboard list | grep -qE '^#ID +(done|wont_do) ' && cd MAIN_CHECKOUT && git worktree remove PATH && git branch -D BRANCH && CLOSE
```

CLOSE is `herdr workspace close "$HERDR_WORKSPACE_ID"` in the TUI, and `herdr-app do space.close '{"id":"SPACE","confirmed":true}'` in the app, SPACE being this terminal's `herdr.space` label.

Leave out `git branch -D BRANCH` when the branch isn't merged, and the worktree part when there's no worktree to remove. Leave out the `taskboard list` check only when step 1 found no card. If the check stops the command, report that the card isn't closed.

If the TUI close fails with `workspace_group_close_required`, this is a main checkout whose worktree workspaces are still open. Report that and leave the workspace open. Never add `--group`.
