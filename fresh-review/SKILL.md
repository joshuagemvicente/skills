---
name: fresh-review
description: Review a ticket's diff in fresh context against spec, risk and design, then hand you the merge call.
argument-hint: "[ticket, PR number, or branch; blank = every ticket in review]"
disable-model-invocation: true
hide: true
metadata:
  opencode/slash: "true"
  opencode/autoinvoke: "false"
---

# Fresh review

The agent that wrote the code is the worst one to review it: it shares the author's blind spots. Reviewers here start with fresh context. Read `../gem/CONVENTIONS.md` first.

If this session wrote the code under review and your agent has no subagent tool, tell the user to start a new session and run this skill there.

## Steps

1. **Gather** for each ticket: the diff against its base branch, the ticket, the spec, `CONTEXT.md`, decision files in the touched areas, and the repo's coding standards file if one exists.

2. **Review on three axes.** Run each axis as its own fresh reviewer: subagents launched in one turn if your agent has them, otherwise headless runs (see Parallel agents in CONVENTIONS), otherwise one axis at a time in this fresh session. Each returns findings as `file:line`, the claim, and a concrete failure scenario.
   - **Spec**: every Done-when criterion gets met / not met with evidence. Anything in the diff the ticket didn't ask for.
   - **Risk**: the reviewer follows `../bug-hunt/SKILL.md` (depth `deep` for `risk: high` tickets, `standard` otherwise) and returns its findings. It covers bugs on edge cases and error paths; authorization on every new endpoint or action; input validation; secrets; migration safety (reversible? safe on existing rows?); jobs and webhooks (idempotent, safe to retry, safe to run twice concurrently); money arithmetic.
   - **Design**: fits the existing seams and patterns; names match `CONTEXT.md`; tests exercise behaviour through the seam rather than internals; no dead code or speculative abstraction.

3. **Refute.** For every finding, try to disprove it against the actual code. Keep only findings that survive. Rank them: **blocker**, **should-fix**, **nit**.

4. **Mark human hunks.** For `risk: high` tickets, list the specific hunks the user must read themselves. You narrow where to look; the human signs off on schema, auth and money.

5. **Verdict.**
   - Blockers or should-fixes → write them into the ticket under `## Review`, set `status: in-progress`, recommend `ship-ticket` on it.
   - Clean → present the verdict and ask the user to merge. After the merge, set `status: done` and remove the worktree.

   Done when every Done-when criterion has a verdict with evidence and every reported finding survived refutation.

6. **Feed the loop.** A finding that is mechanical (a banned API, an import shape, a missing await) is a **lesson** that belongs in a lint rule or test, not in a future review. List those for `wrap`.
