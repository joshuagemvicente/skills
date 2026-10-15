#!/usr/bin/env bash
# Install skills from this repo for every agent on this machine.
#
#   ./install.sh          build-loop skills (top-level folders)
#   ./install.sh --team   team skills (team/)
#   ./install.sh --all    both
#
#   ~/.agents/skills/<name>   -> this repo   (canonical; read by OpenCode, omp, pi, Codex)
#   ~/.claude/skills/<name>   -> canonical   (Claude Code)
#   ~/.pi/agent/skills/<name> -> canonical   (pi)
#
# Symlinks, so editing a skill here updates every agent at once.
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"
canonical="$HOME/.agents/skills"
agent_dirs=("$HOME/.claude/skills" "$HOME/.pi/agent/skills")

case "${1:-}" in
  "")      sources=("$repo") ;;
  --team)  sources=("$repo/team") ;;
  --all)   sources=("$repo" "$repo/team") ;;
  *)       echo "usage: $0 [--team | --all]" >&2; exit 1 ;;
esac

link() { # link <target> <path>
  if [ -e "$2" ] && [ ! -L "$2" ]; then
    echo "  skip $2: exists and is not a symlink"
    return
  fi
  ln -sfn "$1" "$2"
}

mkdir -p "$canonical"
for src in "${sources[@]}"; do
  for dir in "$src"/*/; do
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
done
