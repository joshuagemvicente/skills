---
name: plan-tonight
description: Turn an idea into a grilled spec and tracer-bullet tickets in the vault.
argument-hint: "[feature idea, Inbox note, or blank to pick from the Inbox]"
disable-model-invocation: true
hide: true
metadata:
  opencode/slash: "true"
  opencode/autoinvoke: "false"
---

# Plan tonight

Planning is where a senior engineer earns the night's output: an hour of agents running on a vague plan produces an hour of rework. Read `../gem/CONVENTIONS.md` first.

## Steps

1. **Pick one thing.**
   - Tickets already in `review` or on the frontier → tell the user, and recommend finishing those before planning more.
   - No argument → read the Inbox and the latest handoff, propose the top three candidates, one line each with why now (what it unblocks for a user or for revenue), and let the user choose.

   Done when one feature is chosen.

2. **Grill it.** Interview the user one question at a time, following Asking the user in CONVENTIONS, each question carrying your recommended answer. Walk the design tree branch by branch: data model, user flow, failure modes, permissions, money, migration of existing data. Where the codebase can answer, read the code instead of asking. Name the **riskiest assumption**: the thing that, if wrong, sinks the feature.

   Done when every branch is resolved or explicitly parked as out of scope, and the riskiest assumption is named.

3. **Write the spec** to `specs/<feature>.md`, using the glossary's words:
   - **Problem**: from the user's side.
   - **Solution**: from the user's side.
   - **Decisions**: each with the rejected alternative and one line on why it lost.
   - **Seams**: where behaviour gets tested; prefer existing seams, as few as possible.
   - **Risks**: the riskiest assumption first.
   - **Out of scope**.

   A decision that is expensive to reverse (schema, public API, auth, payments) also gets its own file in `decisions/`. New terms go into `CONTEXT.md`.

4. **Cut tracer bullets.** Break the spec into tickets in the format in CONVENTIONS:
   - Ticket 01 is the thinnest end-to-end path through the riskiest assumption, so the feature proves or kills itself first.
   - Any prefactoring is its own ticket, before the feature tickets ("make the change easy, then make the easy change").
   - Each ticket sets `touches` and `risk` honestly; these drive what can run in parallel and what can run unattended.
   - Each Done-when item is observable: a command, a test, a screen state.

   Present the list (title, blocked-by, touches, risk, what it delivers) and iterate until the user approves. Then write one file per ticket.

5. **Hand off to execution.** Print the frontier, mark which tickets can run in parallel (no shared `touches`), and which are safe for `dispatch day` (`risk: low`). Recommend the next command.
