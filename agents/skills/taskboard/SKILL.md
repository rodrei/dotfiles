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
2. Otherwise create one:
   `taskboard start --title T --description D [--jira URL] [--pr URL]`.

`start` moves the card to In progress and makes it this session's card; the
previous card stays where it was. When unsure whether the task changed, keep
the current card.

Then keep the card current with `taskboard set --title|--description|--jira`
(without an ID it changes this session's card), and attach its PRs and
artifacts.

## PRs

Attach every PR the task is about with `taskboard set --pr URL`: the PR you
review, including one linked in the card's description, and each PR you open,
as soon as it exists. `--pr` adds to the card's PRs and can repeat, so a task
spanning several PRs follows them all. `taskboard set --drop-pr URL` detaches
one attached by mistake.

The board follows attached PRs on GitHub and moves the card itself. Whose PR it
is decides how: the user's own PRs move the card to Waiting review when opened
or pushed, and back to In progress when a reviewer requests changes.

## Artifacts

Attach every artifact you publish for the task (a plan, a report, a review
write-up) with `taskboard set --artifact 'TITLE=URL'`, as soon as it exists.
The card links it under its title as `Artifact: TITLE`, so give the artifact's
own title. `--artifact` adds to the card's artifacts and can repeat; passing a
URL the card already has gives it the new title. `taskboard set
--drop-artifact URL` detaches one.

## Card fields

- `--title`: what the task is, such as `Serve GitHub execution manifests`,
  usually the ticket's or PR's title. It starts with the task, never a ticket
  ID: the card shows its Jira issue and PRs as links below the title. For a
  review of someone else's PR: `Review: <PR id> (<its title>)`, such as
  `Review: attuned #10125 (Serve GitHub execution manifests)`.
  `gh pr view <url>` gives the title when you only have the link.
- `--jira`: the URL of the task's Jira issue, such as
  `https://spanapp.atlassian.net/browse/SPAN-12207`, when it has one.
  `--jira ''` removes it.
- `--description`: what the task is and why, in a sentence or two; for a
  queued task, more (see below).

## Done

The board moves a card to Done by itself once every PR it follows is settled:
merged, or, for someone else's PR, approved by the user. Comments, change
requests and closed PRs leave a card where it is.

Never move a card to Done on your own judgement. When a task looks finished but
no PR settles it, ask the user whether to move the card to Done, and run
`taskboard set ID --status done` only if they say yes. The user saying a task is
finished counts as a yes.

When the user drops a task, mark its card won't do with
`taskboard set ID --status wont_do`. It closes the card like Done, struck
through, so the user still sees what they let go.

## Queue a task for later

```
taskboard add --title T --dir DIR --description D [--jira URL] [--pr URL] [--artifact TITLE=URL]
```

The card lands in To do. The user picks it up later with ▶ Start, which opens a
Herdr workspace in DIR, starts Claude there and sends the title, Jira link,
description and card number, or by copying that same prompt into a session.
So:

- `--description` carries every link, ticket and detail from this conversation
  the new session needs, since it starts with no other context. For a PR
  review, make it `/review-pr <url>`: a description that starts with a slash
  command is sent alone, so the user's review skill runs.
- `--dir` is the absolute path of the repo the task works in.
- `--pr` attaches a PR now, so the board follows it before the task starts.

## Change, move or delete any card

```
taskboard list
taskboard set ID [--title T] [--description D] [--jira URL] [--pr URL] [--drop-pr URL] [--artifact TITLE=URL] [--drop-artifact URL] [--status todo|in_progress|waiting_review|done|wont_do]
taskboard rm ID
```

`rm` deletes a card for good: a duplicate or a mistake. A finished task goes to
Done and a dropped one to won't do instead, so the user sees what they got
through.
