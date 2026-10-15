---
name: estimate-story
description: Estimate a story you can deliver on, re-forecast halfway, and log the actual when it's done.
argument-hint: "<story> [estimate | checkpoint | close]"
disable-model-invocation: true
hide: true
metadata:
  opencode/slash: "true"
  opencode/autoinvoke: "false"
---

# Estimate story

On-time delivery measures calibration: how often the work fits your own estimate. A calibrated estimate is an honest breakdown corrected by your track record, and you hit it at least 85% of the time. Read `../dev-kpis/CONVENTIONS.md` first. Mode is `estimate` unless the argument says `checkpoint` or `close`.

## estimate

1. **Read the story** and its acceptance criteria. Explore the code it touches so the breakdown names real modules, not guesses.

2. **Break it down** into tasks of half a day or less, each estimated in `estimate-unit`. Include the work that isn't coding: tests, `pr-preflight`, waiting on review, one round of review fixes, QA fixes, deployment steps.

3. **Name the unknowns.** One that could double a task → propose a time-boxed spike before committing, or commit to the top of a range.

4. **Calibrate.** From the ledger's Stories table, take the median of `Actual ÷ Estimate` over your last ten closed stories (fewer if that's all there is; 1.3 when there are none). Multiply the breakdown total by it. Show both numbers so the correction is visible, not hidden padding.

5. **Commit.** Present the estimate, the breakdown, the assumptions and the unknowns. On the user's yes, add the Stories row to the ledger.

## checkpoint

Run around the halfway point. Compare time spent and tasks done against the breakdown, then re-forecast the finish.

- Still inside the estimate → say so in one line.
- Projected to overrun → tell the user now, while it can still be managed. Draft a short message to the lead with the new forecast, the cause, and options (cut scope, split the story, move the date). The user sends it.

## close

Record `Actual`, set `Within estimate`, and give a one-phrase `Variance cause` when it missed (`unknown codebase area`, `scope grew`, `review cycles`, `blocked by dependency`, ...). These causes calibrate the next estimate.
