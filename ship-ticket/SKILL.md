---
name: ship-ticket
description: Implement one ticket in a worktree, red to green, and open a PR.
argument-hint: "<ticket path, or feature/NN>"
disable-model-invocation: true
hide: true
metadata:
  opencode/slash: "true"
  opencode/autoinvoke: "false"
---

# Ship ticket

One ticket, one worktree, one PR. Read `../gem/CONVENTIONS.md` first. When `dispatch` runs you from a brief, follow the same steps; your final message is the report in step 8.

## Steps

1. **Claim.** Read the ticket, its spec, `CONTEXT.md`, and any decision files it touches. If the brief inlines them instead (a cloud run), use the brief. Confirm every `blocked-by` ticket is `done`; otherwise stop and report which one gates it. Set `status: in-progress` and `branch: t/<feature>-<NN>`.

2. **Isolate.** If the brief names a worktree, work there. If you're on the main checkout, create one (`git worktree add ../<repo>-wt/<branch> -b <branch>`, or your agent's worktree tool) and install dependencies in it.

3. **Baseline.** Run the verify command from `AGENTS.md` before touching anything. Note any failures that already existed so you neither chase nor hide them.

4. **Plan in five lines or fewer**: the seam you'll test at, the files you expect to touch. Work that lands outside the ticket's `touches` is a scope signal: note it, and if it grows past a few lines, stop and ask.

5. **Red, then green.** Write the failing test at the seam first and watch it go **red** for the right reason. Implement until it goes **green**. Run typecheck and the single test file often; run the full verify at the end.
   - The same red surviving three different attempts → stop guessing; use the `diagnosing-bugs` skill if available, otherwise form one hypothesis at a time and test each with a single targeted log or assertion.
   - Found something else worth doing → write it as a note in the vault's `Inbox/` (or list it in the report on a cloud run) and keep this diff on the ticket.

6. **Prove Done-when.** For each criterion, attach evidence: the test name, the command output, or a screenshot for UI (a Playwright script, or the `webapp-testing` skill if available). An unchecked criterion means the ticket isn't shipped.

7. **Ship.** Full verify green. Commit with a message naming the ticket. If the repo has a remote, push and open a PR with `gh pr create` (the `pr` skill writes the body if available), linking the ticket. Set `status: review` and fill `pr`.

8. **Report**, at most ten lines:
   - what changed, in one line
   - each Done-when criterion with its evidence
   - **Assumptions** you made without a human (see Asking the user in CONVENTIONS)
   - anything that surprised you (a **lesson** candidate for `wrap`)
   - Inbox notes you created
   - hunks the human should read themselves if `risk: high`
