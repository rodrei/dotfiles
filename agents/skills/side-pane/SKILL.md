---
name: side-pane
description: Side pane beside the conversation, in a Herdr split on the right. Use it for material the user keeps in view while you talk (a review, plan, comparison, anything longer than a screen), and for options or questions the user answers in the chat.
---

The side pane is a pane to the right of yours that shows one Markdown file at a time, rendered by `glowbox` (glow with code blocks drawn as boxes). The file is the shared reference: name it in the chat, edit it as the conversation changes it, and keep chat replies to what changed. Answers that fit in a few paragraphs stay in the chat.

Outside Herdr (`HERDR_ENV` unset), write the file the same way and show its content in the chat.

## Files

Each topic gets one Markdown file in `/tmp/side-pane/<tab>/`, where `<tab>` is `$HERDR_TAB_ID` with `:` replaced by `-`. Name it after the topic, such as `review-attuned-10125.md`.

For options and questions, number them (1, 2, 3) or label them (A, B, C) so the user can answer in the chat by number.

## Show the file

The side pane is the pane in this tab labelled `side-pane`: `herdr pane list --workspace "$HERDR_WORKSPACE_ID"` lists each pane's `tab_id` and `label`. When this tab has none, create it without taking the user's focus:

```
herdr pane split --current --direction right --no-focus   # new pane: .result.pane.pane_id
herdr pane rename <pane> side-pane
```

Show the file, and show it again after every edit or topic change, since glowbox renders once:

```
herdr pane send-keys <pane> q ctrl+u
herdr pane run <pane> "clear; glowbox <file>"
```

`q` quits the pager showing the previous version and `ctrl+u` clears the prompt, so the pair works whether the pane is in the pager or at a prompt.

## Lifetime

The pane stays open across topics. Close it with `herdr pane close <pane>` when the user asks.
