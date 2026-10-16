# Bug-hunt output

Reference for `bug-hunt` steps 6 and 7.

## Report

~~~~markdown
## Walkthrough
<2–3 sentences: what the change does>

| File | Change |
|---|---|
| `path` | one line |

Promised but not in the diff: <items, or "none">

## Findings (<n> Critical, <n> Major, <n> Minor)

### 1. <Critical|Major|Minor> · <lens> · `path:line`
**<One-line claim.>**

**Fails when:** <concrete input and state> → <wrong result> (expected <right result>).
**Evidence:** Confirmed by `<test name or command>` | Likely: <the traced path, file:line → file:line>.

**Fix:**
```suggestion
<replacement for the commented lines>
```

**Prompt for an agent:** In `path` around line N, <imperative fix instruction including the failing case to test>.

## Questions
- `path:line`: <the intent you can't see, and what breaks under each answer>

## Negative tests written
- `<test file>::<test name>`: reproduces finding <n>. Keep? (recommended: yes, as a regression test)
~~~~

Severity:
- **Critical**: data loss or corruption, security hole, money wrong, crash on a main path.
- **Major**: wrong behaviour users will hit on a realistic path; broken caller; missing error handling that leaves bad state.
- **Minor**: wrong behaviour on a rare path, or a missing guard with low impact.

## Posting to GitHub

One review per hunt, so the PR gets a single notification:

```sh
gh api repos/{owner}/{repo}/pulls/{number}/reviews --method POST --input review.json
```

```json
{
  "commit_id": "<head SHA of the PR>",
  "event": "COMMENT",
  "body": "<walkthrough, questions, and any finding that can't be anchored to a diff line>",
  "comments": [
    { "path": "src/orders.ts", "line": 42, "side": "RIGHT", "body": "<finding block from the report>" },
    { "path": "src/orders.ts", "start_line": 40, "line": 44, "side": "RIGHT", "body": "<multi-line finding>" }
  ]
}
```

- `line` must be a line present in the PR diff; findings on unchanged lines go in `body`.
- A ` ```suggestion ` block replaces exactly the lines the comment spans, so the author can commit it in one click; keep the original indentation.
- `event` stays `COMMENT`. Approving or requesting changes is the human reviewer's call.
