---
name: dispatch
description: Run frontier tickets in parallel - local worktree agents at night, unattended runs by day.
argument-hint: "[night|day] [feature]"
disable-model-invocation: true
hide: true
metadata:
  opencode/slash: "true"
  opencode/autoinvoke: "false"
---

# Dispatch

Fan frontier tickets out to agents that work while you review. Read `../gem/CONVENTIONS.md` first. Mode is `night` unless the argument says `day`.

## Steps

1. **Compute the frontier** for the product (or the named feature). Empty → recommend `plan-tonight` and stop.

2. **Pick the batch.**
   - Tickets in the batch share no `touches` area, so their diffs merge cleanly.
   - **At most three.** Every ticket you dispatch is a diff you must review tonight; more agents than review bandwidth just moves the queue.
   - `day` mode takes only `risk: low` tickets with fully observable Done-when lists: tests, refactors, small contained features.

   Show the batch with why each was chosen, and get the user's yes.

3. **Write a brief per ticket** (see Briefs in CONVENTIONS). The brief tells the agent to follow the `ship-ticket` skill at its absolute path (resolve `../ship-ticket/SKILL.md`) and end with that skill's report.

4. **Launch.**
   - `night`: follow Parallel agents in CONVENTIONS: subagents in one turn if your agent has them, otherwise worktrees plus one headless command per ticket for the user to start.
   - `day`: the runs happen while the user is at work, so they need a runner that keeps going without this session:
     - Claude Code: use the `schedule` skill to create a one-time cloud run per ticket against the GitHub repo.
     - Any agent with a cloud task runner: submit one task per ticket.
     - Otherwise, if this machine stays on: start each headless command from Parallel agents in the background with `nohup`, logging to `<worktree>/.run.log`.

     Cloud runs can't read the vault, so their brief inlines the ticket, spec excerpts, glossary terms and the verify command, and asks for a PR as the output. Write `dispatched: <runner> <date>` into each ticket.

   While night agents run, point the user at whatever sits in `review` (`fresh-review`), so nobody waits on anybody.

5. **Collect.** For each finished agent, check its claims yourself: run verify in its worktree or read the PR's CI, and confirm every Done-when item has evidence. Then set the status: `review` with a PR link, or back to `ready` with the reason written under `## Attempts` in the ticket.

   Done when every dispatched ticket is in `review` with green evidence, or back in `ready` with a written reason.

6. **Summarize**: a table of ticket, outcome, PR, and anything an agent flagged for the human to read.
