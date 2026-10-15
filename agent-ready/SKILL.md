---
name: agent-ready
description: Make a repo agent-ready - one verify command, guardrail hooks, a lean AGENTS.md, a seeded glossary.
disable-model-invocation: true
hide: true
metadata:
  opencode/slash: "true"
  opencode/autoinvoke: "false"
---

# Agent-ready

An agent is only as good as the feedback loop around it. This skill builds that loop for the current repo, for every agent at once. Read `../gem/CONVENTIONS.md` first.

The bar: **a fresh agent of any brand that knows only `AGENTS.md` can go from checkout to green, and finds out it broke something before you do.**

## Steps

1. **Find the checks.** Read `package.json` scripts (or the build tool's equivalent), CI workflows, and existing hooks (`.husky/`, `.git/hooks/`, `.claude/settings.json`, `.opencode/plugin/`). List each check that exists: typecheck, lint, unit tests, e2e. Done when every check is listed with whether it is wired into anything.

2. **Build the verify command.** Compose typecheck + lint + tests into one script (e.g. `pnpm verify`). Run it. Record the result: green, or the list of failures that already existed. Pre-existing failures go to the user as a list; this pass leaves them unfixed so the baseline is honest.
   - If verify takes over ~3 minutes, add a fast variant (typecheck + tests related to changed files) and name both.

3. **Wire the guardrails.** Git hooks are the agent-neutral layer: every agent commits through git, so they hold for all of them.
   - **Pre-commit** runs the fast verify. If the repo has no pre-commit hook, use the `setup-pre-commit` skill if available, otherwise install husky + lint-staged directly.
   - **End-of-turn hook** for the agents that support one, running the fast verify only when the working tree has changes (`git diff --quiet HEAD || <fast verify>`):
     - Claude Code: a `Stop` hook in `.claude/settings.json` that blocks the stop with the failure output (load `update-config` for the exact syntax).
     - OpenCode: a plugin in `.opencode/plugin/` that runs the check on the `session.idle` event.
     - Other agents rely on the pre-commit hook.

   Done when you've made a deliberate type error, watched the hooks catch it, and reverted it.

4. **Write a lean `AGENTS.md`.** Under ~60 lines. Cache only what the agent can't find by looking:
   - one paragraph: what the product is and who uses it
   - `Verify: <command>` (and `Verify-fast:` if it exists)
   - how to run the app locally, if it isn't the obvious script
   - **navigation pointers**: where each major area lives, one line each
   - hard guardrails, written as the positive rule plus the boundary (e.g. "Migrations run against the dev database only; `prisma migrate deploy` is production and needs the user")
   - pointers to the vault's `Products/<product>/CONTEXT.md` and `decisions/`

   If a `CLAUDE.md` holds the instructions today, move its content into `AGENTS.md`, prune it to this shape, and leave `CLAUDE.md` as the single line `@AGENTS.md`. Show the user the before/after line count.

5. **Seed the glossary.** If `Products/<product>/CONTEXT.md` is missing, draft it from the domain models (the Prisma schema, core types, route names): each term, one-line meaning, and any two words the code uses for the same thing. Use the `domain-modeling` skill if the domain is tangled.

6. **Prove it.** Hand a fresh agent only this brief: "Read AGENTS.md, run the verify command, report the result and anything in AGENTS.md you couldn't act on." Use a subagent if your agent has one, otherwise a headless run (see Parallel agents in CONVENTIONS). Fix every gap it reports.

7. **Report**: verify command and its current state, hooks added per agent, `AGENTS.md` line count, glossary term count, and pre-existing failures worth a ticket.
