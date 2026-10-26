---
name: taskboard
description: Manage the user's taskboard (http://dashboard.localhost), the Kanban board of their tasks. Use when a prompt starts or switches to a task worth tracking, or when the user asks to queue a task for later, check what's on their board or plate, change, move or finish a card, or delete one.
---

# Taskboard

The `taskboard` CLI changes the board through its server; keep the board
current without making a show of it. If the CLI says "board not reachable", the
server is down: tell the user, and restart it with
`launchctl kickstart -k gui/$(id -u)/local.taskboard`.

## This session's card

In Herdr, every prompt arrives with a "Taskboard:" line naming this session's
card, or saying it has none. Cards follow tasks, not sessions: the user often
takes one session through several tasks, and opens new tabs for old ones.

When a prompt starts a task worth tracking (a PR to review, a ticket or change
to build, an investigation; not a quick question) and it isn't this session's
card:

1. Run `taskboard list` and look for a card that already covers it: the same
   PR, ticket or subject, or a `(Taskboard card #N)` line in the prompt. If
   there is one, run `taskboard start N`.
2. Otherwise create one: `taskboard start --title T --kind K --description D [--pr URL]`.

`start` moves the card to In progress and makes it this session's card; the
previous card stays where it was. When unsure whether the task changed, keep
the current card.

Then keep the card current with `taskboard set --title|--kind|--description|--pr`
(without an ID it changes this session's card), and attach the PR as soon as
there is one.

## Card fields

- `--title`: `<ticket or PR id> (<its title>)`, such as
  `attuned #10125 (Serve GitHub execution manifests)`; `gh pr view <url>` gives
  the title when you only have the link.
- `--kind`: `review` (someone else's PR), `build` (changes that end in a PR of
  the user's) or `other`.
- `--description`: what the task is and why, in a sentence or two; for a
  queued task, more (see below).
- `--pr`: the PR, which the board then follows.

## Done

The board moves a card to Done by itself once its PR settles it: a review card
when the user approves the PR or it merges, a build or other card when its PR
merges. Comments, change requests and closed PRs leave a card where it is.

Never move a card to Done on your own judgement. When a task looks finished but
no PR settles it, ask the user whether to move the card to Done, and run
`taskboard set ID --status done` only if they say yes. The user saying a task is
finished counts as a yes.

## Queue a task for later

```
taskboard add --title T --kind K --dir DIR --description D [--pr URL]
```

The card lands in To do. The user picks it up later with ▶ Start, which opens a
Herdr workspace in DIR, starts Claude there and sends the title, description
and card number, or by copying that same prompt into a session. So:

- `--description` carries every link, ticket and detail from this conversation
  the new session needs, since it starts with no other context. For a PR
  review, make it `/review-pr <url>`: a description that starts with a slash
  command is sent alone, so the user's review skill runs.
- `--dir` is the absolute path of the repo the task works in.
- `--pr` attaches the PR now, so the board follows it before the task starts.

## Change, move or delete any card

```
taskboard list
taskboard set ID [--title T] [--kind K] [--description D] [--pr URL] [--status todo|in_progress|waiting_review|done]
taskboard rm ID
```

`rm` deletes a card for good: a duplicate, a mistake, or a task the user
dropped. A finished task goes to Done instead, so the user sees what they got
through.
