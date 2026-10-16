---
name: bug-hunt
description: CodeRabbit-style review of a PR or diff - walkthrough, cross-file impact, systematic edge cases, every finding proven with a failing input, inline comments with fixes.
argument-hint: "[PR number, branch, diff range, or path] [quick|standard|deep] [--post]"
disable-model-invocation: true
hide: true
metadata:
  opencode/slash: "true"
  opencode/autoinvoke: "false"
---

# Bug hunt

Hunt for the inputs and states that make changed code do the wrong thing. A reviewer that cries wolf gets ignored, so the whole skill turns on one rule: **a finding exists only when you can state the failing scenario**: this input, in this state, produces this wrong result. Everything else is dropped or asked as a question.

Defaults: target = the current branch against its base (uncommitted changes included); depth = `standard`. A path instead of a diff audits those files whole.

## Depth

| Depth | Scope | Lenses | Proof |
|---|---|---|---|
| `quick` | the diff | logic and edge cases only | traced code path; Critical/Major only |
| `standard` | diff + direct callers and callees | all four | traced path; failing test for every Critical |
| `deep` | diff + everything reachable from changed public surface | all four, one subagent each | failing test for every Critical and Major |

## Steps

1. **Map the change.** Read the diff, the PR description or linked story, and the repo's `AGENTS.md`. For each changed function, type, schema, route or job, record its **contract**: what it accepts, returns, mutates, and promises. Then find what depends on it: callers of changed signatures, consumers of changed types or response shapes, readers of changed tables. Done when every changed symbol has a contract line and a list of dependents.

2. **Write the walkthrough**: two or three sentences on what the change does, then a table of changed files with one line each. Flag anything the description promises that the diff doesn't do.

3. **Run the tools the repo already has**: typecheck, lint, tests, and any installed scanners (`semgrep`, `gitleaks`, `npm audit`, `ast-grep` rules). Fold their hits on changed lines into the findings; ignore pre-existing noise on untouched lines.

4. **Hunt through four lenses.** Walk every changed symbol through each lens using [`EDGE-CASES.md`](EDGE-CASES.md) as the catalog. In `deep`, give each lens to its own subagent in one turn, each with the contracts from step 1.
   - **Logic and inputs**: boundaries, empty and missing values, types, ordering, arithmetic.
   - **Failure and time**: errors, partial failure, retries, timeouts, concurrency, clocks.
   - **Security and data integrity**: authorization, injection, trust boundaries, invariants, migrations.
   - **Contracts and impact**: broken callers, changed shapes, behaviour changes no test or description mentions.

   Done when every changed symbol has been taken through every lens, and each catalog section is either applied or noted as not applicable to it.

5. **Prove or drop.** For each candidate, try to refute it against the real code: is the input actually reachable, is it already guarded upstream, does a test already cover it? Then grade what survives:
   - **Confirmed**: a failing test or command reproduces it. Write the test in a scratch file or the test suite and run it.
   - **Likely**: the path is traced end to end in the code, but not executed.
   - Everything else is dropped, or becomes a **question** if the answer turns on intent you can't see.

   Check the learnings file (`~/.config/gem/bug-hunt/learnings.md`) and drop any finding matching a pattern the user has rejected before.

6. **Report** in the format in [`OUTPUT.md`](OUTPUT.md): walkthrough, then findings ranked Critical → Major → Minor, each with its failing scenario, evidence grade, a fix, and a one-line prompt another agent can act on. Then list the negative tests you wrote and whether to keep them. Nitpicks only on request.

7. **Post** (only with `--post` or when the user asks): build the GitHub review per OUTPUT.md, show it, and post it on the user's yes.

8. **Learn.** When the user rejects a finding ("that's intended", "we don't care about that"), append the pattern and the reason to the learnings file so the next hunt skips it.

## Running without a human

Headless or in CI: skip step 7's confirmation only if the invocation explicitly passed `--post`; otherwise write the report to `bug-hunt-report.md` and stop. Never edit source files outside scratch tests in this mode.
