#!/bin/sh
#
# Global agent instructions and skills
#
# ~/.claude, ~/.codex and ~/.config/opencode each hold runtime state next to their
# config, and none of them are reachable by the *.symlink or *.configlink globs, so
# AGENTS.md is linked into each one from here. Skills are linked one at a time into
# ~/.claude/skills, which also holds skills installed by `npx skills` and other repos.

set -e

dir="$(cd "$(dirname "$0")" && pwd)"

link_file () {
  src=$1 dst=$2

  if [ "$(readlink "$dst")" = "$src" ]
  then
    return
  fi

  mkdir -p "$(dirname "$dst")"

  if [ -e "$dst" ] || [ -L "$dst" ]
  then
    mv "$dst" "$dst.backup"
    echo "  moved $dst to $dst.backup"
  fi

  ln -s "$src" "$dst"
  echo "  linked $src to $dst"
}

for dst in "$HOME/.claude/CLAUDE.md" \
           "$HOME/.codex/AGENTS.md" \
           "$HOME/.config/opencode/AGENTS.md"
do
  link_file "$dir/AGENTS.md" "$dst"
done

for skill in "$dir"/skills/*
do
  link_file "$skill" "$HOME/.claude/skills/$(basename "$skill")"
done
