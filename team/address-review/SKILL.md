---
name: address-review
description: Turn returned review comments or QA defects into one complete fix cycle, so the next submission is approved.
argument-hint: "[PR number; or paste the comments/defects]"
disable-model-invocation: true
hide: true
metadata:
  opencode/slash: "true"
  opencode/autoinvoke: "false"
---

# Address review

Every return costs a cycle against the ceiling. This skill makes sure each return is the last one. Read `../dev-kpis/CONVENTIONS.md` first.

## Steps

1. **Collect everything that came back**: review comments and threads (`gh pr view <n> --comments` and the review threads, or what the user pastes) and QA defect reports. Done when every comment and defect is in one numbered list.

2. **Log the return.** In the ledger, increment `Review cycles` or `QA returns` on the PR row, set `First pass` to `no`, and add one Return reasons row per comment with its category.

3. **Ceiling check.** If cycles + returns now equals `revision-ceiling` minus one, tell the user plainly: the next submission must be approved. Recommend a short sync with the reviewer before resubmitting, to confirm the fixes match what they meant, and draft that message.

4. **Classify each item**: **must-fix**, **question** (answer it, maybe with a code comment), **suggestion** (take it unless it's wrong), **disagree** (needs a reasoned reply).

5. **Fix the class, not the instance.** For each must-fix and accepted suggestion, search the whole diff and the code it touches for the same pattern and fix every occurrence. A reviewer who finds the same issue twice sends the PR back again.

6. **Draft the replies**: one per comment saying what changed (with the commit) or the answer. Draft disagreements as a short reason plus an alternative. The user approves the replies before they're posted.

7. **Re-run preflight.** Follow `../pr-preflight/SKILL.md` in full before resubmitting; the fixes themselves are new code. Done when preflight is READY and every numbered item has a fix or an approved reply.

8. **Resubmit** on the user's yes: push, post the replies, and re-request review.
