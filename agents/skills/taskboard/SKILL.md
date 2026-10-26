---
name: taskboard
description: Manage the user's taskboard (http://dashboard.localhost), the Kanban board of their tasks. Use when the user asks to queue a task for later, check what's on their board or plate, change, move or finish a card, or delete one.
---

# Taskboard

The `taskboard` CLI changes the board through its server. If it says "board not
reachable", the server is down: tell the user, and restart it with
`launchctl kickstart -k gui/$(id -u)/local.taskboard`.

## Find a card

`taskboard list` prints every card not yet archived: ID, status, kind, title
and PR. Match the user's words against the titles and PRs; when two cards fit,
ask which one.

## Queue a task

```
taskboard add --title T --kind K --dir DIR --description D [--pr URL]
```

The card lands in To do. Later the user clicks ▶ Start on it, which opens a
Herdr workspace named after the title in DIR, starts Claude there and sends
the title and description as its first message. So:

- `--description` says what the task is and carries every link, ticket and
  detail from this conversation the new session needs, since it starts with no
  other context. For a PR review, make it `/review-pr <url>`: a description
  that starts with a slash command is sent alone, so the user's review skill
  runs.
- `--dir` is the absolute path of the repo the task works in.
- `--title` is `<ticket or PR id> (<its title>)`, such as
  `attuned #10125 (Serve GitHub execution manifests)`; `gh pr view <url>` gives
  the title when you only have the link.
- `--kind`: `review` (someone else's PR), `build` (changes that end in a PR of
  the user's) or `other`.
- `--pr` attaches the PR now, so the board tracks it before the task starts and
  moves a review card to Done if the PR merges first.

## Change or move a card

```
taskboard set ID [--title T] [--kind K] [--description D] [--pr URL] [--status todo|in_progress|waiting_review|done]
```

Without an ID, `set` changes the card for the Herdr workspace you run in. Cards
with a PR move on their own as it's opened, reviewed and merged; set
`--status` when the user moves one by hand or says a task without a PR is
finished.

## Finish or delete

- Finished work: `taskboard set ID --status done`. The card stays under Done
  until the 6 AM archive, so the user sees what they got through.
- `taskboard rm ID` deletes a card for good: a duplicate, a mistake, or a task
  the user dropped. If its Herdr workspace is still open, the next prompt there
  starts a fresh card.
