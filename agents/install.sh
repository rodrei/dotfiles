#!/bin/sh
#
# Global agent instructions
#
# ~/.claude, ~/.codex and ~/.config/opencode each hold runtime state next to their
# config, and none of them are reachable by the *.symlink or *.configlink globs, so
# AGENTS.md is linked into each one from here.

set -e

src="$(cd "$(dirname "$0")" && pwd)/AGENTS.md"

for dst in "$HOME/.claude/CLAUDE.md" \
           "$HOME/.codex/AGENTS.md" \
           "$HOME/.config/opencode/AGENTS.md"
do
  if [ "$(readlink "$dst")" = "$src" ]
  then
    continue
  fi

  mkdir -p "$(dirname "$dst")"

  if [ -e "$dst" ] || [ -L "$dst" ]
  then
    mv "$dst" "$dst.backup"
    echo "  moved $dst to $dst.backup"
  fi

  ln -s "$src" "$dst"
  echo "  linked $src to $dst"
done
