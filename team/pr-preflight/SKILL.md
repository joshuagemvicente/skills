---
name: pr-preflight
description: Make a PR approvable on the first review - verify, apply the secure checklist, review it as the reviewer and QA would, then submit.
argument-hint: "[PR number or branch; blank = current branch]"
disable-model-invocation: true
hide: true
metadata:
  opencode/slash: "true"
  opencode/autoinvoke: "false"
---

# PR preflight

The cheapest review cycle is the one that never happens. Before the reviewer sees the PR, catch everything the reviewer and QA would send back. Read `../dev-kpis/CONVENTIONS.md` first.

The bar: **you can't name one comment the reviewer is likely to leave.**

## Steps

1. **Gather**: the diff against the target branch, the story and its acceptance criteria (from the tracker, or ask the user to paste them), the repo's `AGENTS.md`/`CONTRIBUTING`, PR template, and the **Return reasons** table from the ledger.

2. **Mechanical pass.** Run the repo's checks: typecheck, lint, tests, build. Then scan the diff for leftovers: debug logs, commented-out code, TODOs without a ticket, unrelated formatting churn, files outside the story's scope. Fix every one.

3. **Acceptance.** For each acceptance criterion, attach evidence: a test name, a command output, or a screenshot. A criterion without evidence is a QA return waiting to happen.

4. **Secure checklist.** Follow `../secure-review/SKILL.md` in full on this diff. Every item ends Pass or N/A with evidence; any Fail is fixed before moving on.

5. **Review with the reviewer's eyes.** In fresh context (a subagent if your agent has one, otherwise a deliberate second pass), review the diff as a strict reviewer would: naming, error handling, edge cases, test quality, consistency with the surrounding patterns, needless complexity. Then explicitly check **every recurring category** in the ledger's Return reasons; those are this reviewer's known preferences.

6. **Test with QA's eyes.** QA returns count against the revision ceiling too. Exercise the paths QA will try: empty, invalid and boundary inputs, permissions and roles, error messages, loading and failure states, the responsive layouts if it's UI. Fix what breaks.

7. **Loop.** Steps 2–6 repeat until a full pass finds nothing. Done when every check passes, every criterion has evidence, the checklist has no Fail, and neither review pass produced a finding.

8. **Write the PR description**: what and why (linking the story), how to test it step by step, screenshots for UI, risks and anything you'd like the reviewer to look at closely, and the completed secure checklist (under the `checklist-name` from config).

9. **Submit.** Show the user the description and the verdict **READY**. On their yes, open or update the PR and request review. Add the PR row to the ledger (CONVENTIONS row rules).
