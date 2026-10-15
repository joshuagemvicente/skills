# Gem workflow conventions

Shared reference for the gem workflow skills (`gem`, `agent-ready`, `plan-tonight`, `dispatch`, `ship-ticket`, `fresh-review`, `wrap`). Every skill that reads or writes the vault follows this file. The skills run under any agent that loads `SKILL.md` files (Claude Code, OpenCode, omp, pi, Codex), so each capability below names a portable default and treats agent-specific tools as a faster branch.

## Locating files

Sibling skills are installed side by side, so `../<skill>/` from any skill's directory reaches another skill (e.g. `../gem/CONVENTIONS.md`). The canonical install is `~/.agents/skills/<skill>/`. When you hand a path to another agent, resolve it to an absolute path first.

## Vault

The vault root is the single line in `~/.config/gem/vault`. If that file is missing, ask the user for their Obsidian vault path once, write it there, and continue.

```
<vault>/
  Inbox/                          raw ideas, one note each, any shape
  Products/<product>/
    CONTEXT.md                    domain glossary: the product's words and what they mean
    decisions/NNNN-<slug>.md      one decision per file: context, decision, rejected options, consequences
    specs/<feature>.md
    tickets/<feature>/NN-<slug>.md
    handoffs/YYYY-MM-DD-<slug>.md
    lessons.md                    append-only log written by /wrap
```

`<product>` is the git repo's directory name. Create missing folders as you need them.

## Agent instructions file

`AGENTS.md` at the repo root is the single source of truth for repo instructions; OpenCode, omp, pi and Codex read it directly. `CLAUDE.md` holds one line, `@AGENTS.md`, so Claude Code imports the same file.

## Asking the user

Applies every time a skill says ask, confirm, interview, or get the user's yes.

1. **Use your agent's structured question tool** when it has one, so the user picks from options instead of typing: Claude Code `AskUserQuestion`, OpenCode `question`, omp `ask`, Codex `request_user_input`; in any other agent, its tool that presents multiple-choice questions.
2. **No such tool** (pi, or the tool is off in this mode): write the question as plain text in the same shape, then end your turn and wait for the reply.

Every question has the same shape whichever route it takes: one decision per question, 2–4 options, your recommended option first and marked "(Recommended)", one line of trade-off per option, and free text always allowed. Batch independent questions into one call; ask dependent ones in sequence.

**No human present** (a subagent, a headless or cloud run from a brief): take the recommended option, record it under **Assumptions** in your report, and continue. A decision that is expensive to reverse (schema, money, deletion, anything public) stops the run instead: report the question with your recommendation and leave the ticket `blocked`.

## Tickets

A ticket is a **tracer bullet**: a thin, complete path through every layer (schema, API, UI, tests) that is demoable on its own, fits one fresh context window, and produces a diff a human can review in about ten minutes. Size tickets for review, not for writing: review bandwidth is the bottleneck of the whole loop.

```markdown
---
status: ready            # ready | in-progress | review | done | blocked
blocked-by: []           # ticket numbers in the same feature, e.g. [01, 03]
touches: []              # codebase areas, e.g. [auth, billing/webhooks]; drives overlap checks
risk: low                # low | high (high = schema, auth, payments, money, prod config, deletion)
branch:
pr:
---
# NN: <title>

**Why:** one line, linking the spec.

**What to build:** the end-to-end behaviour, from the user's perspective.

**Done when:**
- [ ] <observable criterion>
- [ ] verify command is green
```

The **frontier** is every `ready` ticket whose `blocked-by` tickets are all `done`.

Status moves in one direction, each move owned by one skill:

| Move | Owner |
|---|---|
| ready → in-progress | ship-ticket (claims it) |
| in-progress → review | ship-ticket (PR open, verify green) |
| review → done | fresh-review (approved, user merged) |
| review → in-progress | fresh-review (findings written into the ticket) |
| any → blocked | whoever hits the blocker, with the reason under `## Blocked` |

## Verify command

Each repo has exactly one command that defines **green**: typecheck, lint and tests together. `AGENTS.md` names it on a line starting `Verify:`. A claim of green is backed by that command's output from this session. If a repo has no `Verify:` line, run `agent-ready` first.

## Briefs

A **brief** is a self-contained prompt for an agent that shares none of your context. It inlines: the goal, the full ticket text, the relevant spec excerpts and glossary terms, where in the code to start, the absolute worktree path, the constraints, the Done-when list, exactly what to return, and the line "No human is watching this run: follow No human present under Asking the user." Cloud agents cannot read the vault, so everything they need goes in the brief itself.

## Parallel agents

Pick the first branch your agent supports:

1. **Subagent tool** (Claude Code's Agent tool, OpenCode's task tool, omp's task tool): launch every subagent in one turn. If the tool has a worktree option (Claude Code: `isolation: "worktree"`), use it; otherwise create each worktree yourself first and put its absolute path in the brief.
2. **No subagent tool**: create the worktrees, write each brief to `<worktree>/.brief.md`, and print one headless command per ticket for the user to run in separate terminals, run from inside that worktree: `claude -p "$(cat .brief.md)"`, `opencode run "$(cat .brief.md)"`, `omp -p "$(cat .brief.md)"`, or `codex exec "$(cat .brief.md)"`.

Worktrees live at `../<repo>-wt/<branch>`, created with `git worktree add ../<repo>-wt/<branch> -b <branch>`.
