#!/usr/bin/env bash
# Install every skill in this repo for every agent on this machine.
#
#   ~/.agents/skills/<name>   -> this repo   (canonical; read by OpenCode, omp, Codex)
#   ~/.claude/skills/<name>   -> canonical   (Claude Code, also read by OpenCode and omp)
#   ~/.pi/agent/skills/<name> -> canonical   (pi)
#
# Symlinks, so editing a skill here updates every agent at once.
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"
canonical="$HOME/.agents/skills"
agent_dirs=("$HOME/.claude/skills" "$HOME/.pi/agent/skills")

link() { # link <target> <path>
  if [ -e "$2" ] && [ ! -L "$2" ]; then
    echo "  skip $2: exists and is not a symlink"
    return
  fi
  ln -sfn "$1" "$2"
}

mkdir -p "$canonical"
for dir in "$repo"/*/; do
  name="$(basename "$dir")"
  [ -f "$dir/SKILL.md" ] || continue
  link "${dir%/}" "$canonical/$name"
  for agent_dir in "${agent_dirs[@]}"; do
    [ -d "$(dirname "$agent_dir")" ] || continue   # agent not installed
    mkdir -p "$agent_dir"
    link "$canonical/$name" "$agent_dir/$name"
  done
  echo "installed $name"
done
