---
name: gem
description: Show where you are in the build loop and which skill to run next.
disable-model-invocation: true
hide: true
metadata:
  opencode/slash: "true"
  opencode/autoinvoke: "false"
---

# Gem

Router for the build loop. Read the state, then recommend one next skill.

## The loop

| Skill | When | Does |
|---|---|---|
| `agent-ready` | Once per repo, and when agents keep failing the same way | One verify command, guardrail hooks, a lean `AGENTS.md` |
| `plan-tonight` | After work, frontier empty | Idea → grilled spec → tracer-bullet tickets in the vault |
| `dispatch` | Frontier has tickets | `night`: up to 3 parallel agents in worktrees. `day`: unattended runs on low-risk tickets |
| `ship-ticket` | One ticket, you at the keyboard | Claim → red → green → verify → PR |
| `fresh-review` | Tickets in `review` | Spec, risk and design review in fresh context; you merge |
| `wrap` | End of a session | Lessons → guardrails, handoff note, tomorrow's day-dispatch pick |

Other installed skills that fit the loop: `grilling` (stress-test a plan), `research` (primary-source digging), `prototype` (throwaway spike before a spec), `diagnosing-bugs` (a red you can't explain), `domain-modeling` (CONTEXT.md and decisions).

## Steps

1. Read [`CONVENTIONS.md`](CONVENTIONS.md) and resolve the vault and `<product>` for the current repo.
2. Gather the state, one line each:
   - repo has a `Verify:` line in `AGENTS.md` (yes/no)
   - Inbox note count
   - specs with no tickets folder
   - frontier tickets (number and title)
   - tickets in `in-progress` and `review`, with PR links
   - the latest handoff's "Next" section
   - local time (`date`)
3. Recommend one skill, from the first rule that matches:
   1. No `Verify:` line → `agent-ready`.
   2. Tickets in `review` → `fresh-review` (finish before starting).
   3. Weekday 08:00–17:00 and a low-risk frontier ticket exists → `dispatch day`.
   4. Frontier has tickets → `dispatch` (or `ship-ticket` if only one).
   5. Otherwise → `plan-tonight`.

   Give the rule that fired in one line, then the exact command to type in the user's current agent: `/<skill>` in Claude Code and OpenCode, `/skill:<skill>` in omp and pi, `$<skill>` in Codex.
