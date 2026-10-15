---
name: secure-review
description: Apply the secure coding checklist to a diff, item by item, and produce the completed checklist as evidence.
argument-hint: "[PR number, branch, or diff range; blank = current branch]"
disable-model-invocation: true
hide: true
metadata:
  opencode/slash: "true"
  opencode/autoinvoke: "false"
---

# Secure review

The secure-checklist rate is binary: a review without the completed checklist is a miss, however clean the code is. Read `../dev-kpis/CONVENTIONS.md` first.

## Steps

1. **Load the checklist**: the file at `secure-checklist` in the config, or [`CHECKLIST.md`](CHECKLIST.md) when that's blank. The team's own checklist always wins; use its items and wording exactly.

2. **Read the diff** against the target branch, plus enough of the surrounding code to judge each item (the route's middleware, the query builder, where the input comes from).

3. **Mark every item** with one of:
   - **Pass**, with evidence: `file:line` or the mechanism that covers it ("validated by the zod schema at `api/orders.ts:14`").
   - **N/A**, with the reason the diff can't affect it ("no new endpoints").
   - **Fail**, with `file:line` and what's wrong.

   Done when every item has a mark with evidence. A blank item is an incomplete checklist.

4. **Fix the Fails**, or list them for the user when the fix is outside the story, then re-mark those items.

5. **Output** the completed checklist as a markdown block ready to paste into the PR or review record, titled with `checklist-name` from config. Save a copy to `~/.config/gem/team/checklists/<PR or branch>.md` and set `Secure checklist` on the PR's ledger row.
