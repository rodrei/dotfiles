# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal dotfiles repo (forked from holman/dotfiles), organized **by topic**: each top-level directory (`git/`, `ruby/`, `zsh/`, `tmux/`, ...) holds everything for that tool. There is no build, lint, or test suite — verify shell changes by opening a fresh shell (`exec zsh`) and confirming no startup errors.

## Commands

- `script/bootstrap` — initial setup: generates `git/gitconfig.symlink` from the `.example` template (prompts for name/email), symlinks all `*.symlink` files into `$HOME`, then runs `bin/dot` on macOS.
- `bin/dot` — periodic maintenance: applies macOS defaults, installs/updates Homebrew, runs `script/install`.
- `script/install` — runs `brew bundle` against the `Brewfile`, then executes every `install.sh` found in topic directories.

## File conventions (enforced by zsh/zshrc.symlink and script/bootstrap)

These naming conventions drive everything — files are discovered by glob, never listed explicitly:

- `topic/*.zsh` — auto-sourced into every shell.
- `topic/path.zsh` — sourced **first** (sets up `$PATH`). Note: `system/_path.zsh` uses an underscore prefix so it sorts first but is NOT matched by the `path.zsh` glob — it loads with the general pass.
- `topic/completion.zsh` — sourced **last**, after `compinit` runs. Anything defined here overrides completions that compinit registered from `fpath` (including Homebrew's `site-functions`) — prefer relying on Homebrew-shipped completions over vendoring copies here; a vendored stale copy has caused compctl/compsys clashes before.
- `topic/*.symlink` — symlinked by `script/bootstrap` into `$HOME` as `.<name>` (extension stripped). The canonical zshrc is `zsh/zshrc.symlink`; edit it there, not `~/.zshrc`.
- `topic/*.configlink` — symlinked by `script/bootstrap` into `~/.config` as `<name>` (extension stripped), for XDG-style configs. E.g. `nvim/nvim.configlink` → `~/.config/nvim`; edit the nvim config there (through either path — they're the same files).
- `topic/install.sh` — picked up and executed by `script/install`.
- `bin/` — on `$PATH` in every shell.
- `functions/` — zsh autoloaded functions and completions (added to `fpath` by `zsh/fpath.zsh`).

Load order in `zsh/zshrc.symlink`: `~/.localrc` (private env vars, not in repo) → all `path.zsh` → all other `*.zsh` → `compinit` → all `completion.zsh`.

## Gotchas

- `git/gitconfig.symlink` is generated and gitignored; the template is `git/gitconfig.symlink.example`.
- `zsh/zshrc.symlink` also contains machine-specific additions appended below the framework section (nvm, yarn, fzf); rbenv is initialized in `ruby/rbenv.zsh`.
