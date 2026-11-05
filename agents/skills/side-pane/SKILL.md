---
name: side-pane
description: Side pane beside the conversation, in a Herdr split on the right. Use it for material the user keeps in view while you talk (a review, plan, comparison, anything longer than a screen), for options the user picks from, and for questions the user answers in a form.
---

The side pane is a browser (`terminal-browser`) in a pane to the right of yours, showing one file per topic. The file is the shared reference: name it in the chat, edit it as the conversation changes it, and keep chat replies to what changed. Answers that fit in a few paragraphs stay in the chat.

Outside Herdr (`HERDR_ENV` unset), write the file the same way and show its content in the chat.

## Files

Each topic gets one file in `/tmp/side-pane/<tab>/`, where `<tab>` is `$HERDR_TAB_ID` with `:` replaced by `-`. Name it after the topic, such as `review-attuned-10125.md`.

- **Reading**: Markdown. terminal-browser renders it, tables and code included.
- **Picking and asking**: a self-contained HTML page (inline CSS, no network), with `<meta name="color-scheme" content="light dark">` so it follows the user's theme. Put every choice and question in one `<form>` as a named control. Give each option a short label (A, B, C) the user can also say in the chat.

## Show the file

`terminal-browser ls` lists the browser in this tab, if any, with its tabs; the location column ends with the browser's pane ID.

- **No browser in this tab**: create the pane yourself and start the browser in it, so the user's focus and visible workspace stay where they are (`terminal-browser open --split` takes focus, and Herdr brings that pane's workspace to the front):
  ```
  herdr pane split --current --direction right --no-focus   # new pane: .result.pane.pane_id
  herdr pane run <pane> "terminal-browser open <file>"
  ```
- **Browser open, file not in it**: `terminal-browser new-tab <file>`.
- **File already open, content changed**: `terminal-browser action --tab <n> -- reload`.

Close each round of `terminal-browser action` calls with `terminal-browser action done`, which clears the indicator the user sees on the page.

## Read answers

Tell the user to answer in the pane and say "done". Then read the form:

```
terminal-browser action --tab <n> -- eval "JSON.stringify([...new FormData(document.forms[0])])"
```

It returns `[name, value]` pairs, one per checked or filled control. The user may answer in the chat instead; take either.

## Lifetime

The pane stays open across topics: each new topic is a new tab in the same browser. Close it with `herdr pane close <browser pane>` when the user asks.

The `terminal-browser` skill covers the rest of the CLI.
