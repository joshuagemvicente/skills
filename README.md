# gem-skills

My agent workflow, packaged as [Agent Skills](https://agentskills.io): plain `SKILL.md` folders that work in Claude Code, OpenCode, omp, pi and Codex. All skills are user-invoked: none of them cost context until I call one.

## The loop

```
agent-ready      once per repo: verify command, git + agent hooks, lean AGENTS.md
      │
plan-tonight     idea → grilled spec → tracer-bullet tickets (in the vault)
      │
dispatch         night: ≤3 parallel worktree agents   day: unattended runs
ship-ticket      one ticket by hand: red → green → PR
      │
fresh-review     spec / risk / design review in fresh context → I merge
      │
wrap             lessons → guardrails, handoff, tomorrow's dispatch
```

Lost? `gem` reads the current state and says which one to run.

`bug-hunt` works on any PR or diff, inside or outside the loop: a CodeRabbit-style review with a walkthrough, cross-file impact, systematic edge cases from a catalog, and only findings proven by a concrete failing input. `--post` sends it to the PR as one GitHub review with inline, one-click suggestions. `fresh-review` and the team `pr-preflight` use it when it's installed.

## Calling a skill

| Agent | Syntax | Hidden from auto-invocation by |
|---|---|---|
| Claude Code | `/plan-tonight` | `disable-model-invocation: true` |
| OpenCode | `/plan-tonight` | `metadata.opencode/slash` + `opencode/autoinvoke: "false"` |
| omp, pi | `/skill:plan-tonight` | `hide: true` |
| Codex | `$plan-tonight` | `agents/openai.yaml` → `allow_implicit_invocation: false` |

Each agent ignores the other agents' frontmatter keys.

## Install

Pick one method per machine; mixing them puts two installs on the same paths.

**Machine where I edit the skills** (any machine I code on, since `wrap` edits and commits skills):

```sh
git clone git@github.com:joshuagemvicente/gem-skills.git ~/projects/gem-skills
cd ~/projects/gem-skills && ./install.sh
```

`install.sh` symlinks each skill into `~/.agents/skills` (read by OpenCode, omp, Codex), then into `~/.claude/skills` and `~/.pi/agent/skills`, so edits here reach every agent immediately.

**Machine that only uses them**, via the [skills CLI](https://github.com/vercel-labs/skills):

```sh
npx skills add joshuagemvicente/gem-skills -g -s '*' -a claude-code opencode pi codex -y
```

## Update

| Installed with | Update with |
|---|---|
| `install.sh` | `git pull`, plus `./install.sh` if a skill was added or renamed |
| `npx skills` | `npx skills update -g` |

Then start a new agent session; agents read skills when a session starts.

On first use a skill asks for the Obsidian vault path and stores it in `~/.config/gem/vault`. Vault layout, ticket format, status rules and the parallel-agent fallbacks live in [`gem/CONVENTIONS.md`](gem/CONVENTIONS.md).

## Portability rules for edits

- Repo instructions go in `AGENTS.md`; `CLAUDE.md` is just `@AGENTS.md`.
- Reach sibling files by relative path (`../gem/CONVENTIONS.md`), never an agent's home directory.
- Name a capability, then give agent-specific tools as branches with a portable fallback (git hooks, `git worktree`, headless CLI runs).
- New skill: copy an existing folder so the frontmatter and `agents/openai.yaml` come with it, then run `./install.sh`.

## Team skills

A separate set in [`team/`](team/), for working on a team where PRs go through a reviewer and QA. Not installed by default.

| Skill | When |
|---|---|
| `dev-kpis` | Scoreboard for first-pass approval, revision-ceiling compliance, secure-checklist rate and on-time delivery; says what to fix next |
| `estimate-story` | Commit to a calibrated estimate, re-forecast halfway, log the actual |
| `pr-preflight` | Before every review request: checks, acceptance evidence, secure checklist, reviewer and QA passes |
| `secure-review` | Apply the secure coding checklist item by item and output it completed |
| `address-review` | A PR comes back: one complete fix cycle, replies drafted, preflight re-run |

Install:

```sh
./install.sh --team        # or --all for both sets
npx skills add https://github.com/joshuagemvicente/gem-skills/tree/main/team -g -s '*' -a claude-code opencode pi codex -y
```

Team specifics (reviewer, revision ceiling, checklist path, targets) and the evidence ledger live in `~/.config/gem/team/` on each machine, never in this repo. The first team skill you run asks for them.

## Changing a skill

| Change | What to do |
|---|---|
| Edit a skill's text | Save the file, start a new agent session, then commit and push so other machines can update. |
| Add, rename or delete a skill | Run `./install.sh` (delete the old symlinks by hand after a rename or delete), then commit and push. |

`wrap` edits these files when the workflow itself was wrong. Commit those edits here so improvements stick.
