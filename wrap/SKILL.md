---
name: wrap
description: Close a session - turn lessons into guardrails, write the handoff, queue tomorrow's day-dispatch.
disable-model-invocation: true
hide: true
metadata:
  opencode/slash: "true"
  opencode/autoinvoke: "false"
---

# Wrap

The compounding step. Every correction you made tonight should be one you never make again. Read `../gem/CONVENTIONS.md` first.

## Steps

1. **Take stock.** List the tickets touched this session and their statuses, uncommitted changes in any worktree, and worktrees whose branch is already merged. Offer to remove the merged worktrees.

2. **Harvest lessons.** Scan this session, the agent reports, and `fresh-review` output for: corrections the user gave, mistakes repeated more than once, time lost finding a file, information an agent needed but couldn't reach. Each becomes a **lesson**.

3. **Fix each lesson at the strongest rung** that can hold it:
   1. a **guardrail**: lint rule, test, type, or git hook; deterministic beats remembered, and it binds every agent
   2. an `AGENTS.md` line: a navigation pointer, or a rule stated as the positive target
   3. an edit to a gem skill in `~/projects/gem-skills/`, when the workflow itself was wrong
   4. a line in the vault's `lessons.md`, for judgement calls nothing above can hold

   A lesson that changes no future behaviour gets dropped. Propose the fixes as a list, apply the approved ones, and commit skill edits in the gem-skills repo.

4. **Write the handoff** to `handoffs/YYYY-MM-DD-<slug>.md`:
   - **Where it stands**: one line per active ticket.
   - **Next**: the frontier, in the order you'd take it.
   - **Open questions**: things only the user can decide.
   - **Gotchas**: anything a fresh agent would trip on.

   Link specs, tickets, PRs and decisions instead of restating them. Redact secrets.

5. **Queue tomorrow.** Pick the best `risk: low` frontier ticket for `dispatch day` and put it at the top of the handoff, so the morning is one command.

6. **Print** a three-line summary: shipped, in review, next.
