---
name: herdr-app
description: Drive the Herdr app (the windowed Herdr, `herdr-app` and `hc` CLIs) when this session runs in it (`HC_TERMINAL_ID` set). Use when the user mentions Herdr, herdr-app, hc or herdr-core and asks to show something in a space, tab or pane, or to start, watch or message another agent or program in an hc terminal. For the Herdr TUI (`HERDR_ENV=1`), use the herdr skill.
---

# Herdr app

The Herdr app is two CLIs. `herdr-app` changes what the user sees: spaces,
tabs, panes, focus. `hc` (herdr-core) runs, reads, messages and waits on the
terminals behind them, which keep running when the window closes. Neither is
`herdr`, the Herdr TUI.

Both print their current manual. Read the one the task needs before the first
command, every session: the CLIs change between releases, and the manual is
the installed version's.

```sh
herdr-app --skill    # the window: spaces, tabs, panes, focus, layouts, mods
hc --skill           # terminals: delegate to agents, run slow commands, wait, read
```

Then confirm exact arguments with `herdr-app commands` or `hc <command> --help`.

## Identity

- This terminal is `$HC_TERMINAL_ID` (such as `t5`). It is not a pane ID:
  `herdr-app ls` maps terminals to their space, tab and pane.
- The environment has no space or tab ID. This terminal's labels carry them:
  `hc get "$HC_TERMINAL_ID" --json | jq '.labels'` shows `herdr.space` and
  `herdr.tab`.
- `herdr-app ls` shows each terminal's `status` (`working`, `idle`, `done`,
  `blocked`): its agent's state.

## The user's screen

New spaces and tabs appear on the user's screen at once: create them only
when the user asks, with an explicit name. For work the user doesn't need to see, use
`hc run --bg`, which stays out of the window. Leave the app, its core and
terminals you didn't start running.
