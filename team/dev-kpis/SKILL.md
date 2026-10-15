---
name: dev-kpis
description: Scoreboard for the four developer indicators, with the evidence behind each number and the skill to run next.
argument-hint: "[period, e.g. 2026-10 or 'last 30 days'; blank = current period]"
disable-model-invocation: true
hide: true
metadata:
  opencode/slash: "true"
  opencode/autoinvoke: "false"
---

# Dev KPIs

Router and scoreboard for the team skills. Read [`CONVENTIONS.md`](CONVENTIONS.md) first.

## The skills

| Skill | When | Moves |
|---|---|---|
| `estimate-story` | Committing to a story; halfway through; when it's done | On-time delivery |
| `pr-preflight` | Before every review request | First-pass approval, ceiling compliance, secure checklist |
| `secure-review` | Inside every preflight, or alone on any diff | Secure-checklist rate |
| `address-review` | A PR comes back from review or QA | Ceiling compliance |

## Steps

1. **Load** the config and the ledger (create either from CONVENTIONS if missing).

2. **Reconcile** the ledger for the period. If the team's repo is on GitHub and `gh` works, list the user's PRs in the period (`gh pr list --author @me --state all`) and their reviews; add any PR missing from the ledger, and flag rows whose status disagrees with GitHub. Otherwise ask the user about open rows with no outcome yet.

   Done when every PR and story in the period has an outcome or is explicitly still open.

3. **Score.** Compute each indicator for the period from closed rows, exactly per the formulas in CONVENTIONS. Show:

   | Indicator | Rate | Target | Count | Status |
   |---|---|---|---|---|

   Status is **on track**, **at risk** (within 5 points of target, or one more miss would drop it below), or **below**. Secure checklist is binary: one miss means below.

4. **Explain the misses.** For each indicator not on track, list the rows that pulled it down and the top return-reason categories behind them.

5. **Recommend one change**: the single habit or skill that would move the weakest indicator most, based on the misses above.

6. **Evidence summary** (only when the user asks, e.g. for a performance review): one paragraph per indicator with the rate, the count, and two concrete examples from the ledger.
