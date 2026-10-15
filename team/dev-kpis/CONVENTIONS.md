# Team conventions

Shared reference for the team skills (`dev-kpis`, `pr-preflight`, `address-review`, `secure-review`, `estimate-story`). Every team skill reads this file first. Sibling skills sit side by side, so `../<skill>/` reaches another one.

## Local config

Team specifics live on this machine only, in `~/.config/gem/team/config.md`, never in the skills repo. If the file is missing, ask the user for each field, write it, and continue:

```markdown
reviewer: <who approves PRs, e.g. "Tech Lead">
revision-ceiling: <max review cycles per work item, code review and QA returns combined>
secure-checklist: <absolute path to the team's secure coding checklist; blank = ../secure-review/CHECKLIST.md>
checklist-name: <what the team calls that checklist, used in PR text>
estimate-unit: <hours | days | points>
tracker: <where stories live and how they're referenced, e.g. "Jira, PROJ-123">
period: <reporting period, e.g. "monthly">
targets:
  first-pass-approval: 80
  ceiling-compliance: 90
  secure-checklist: 100
  on-time-delivery: 85
```

## The four indicators

| Indicator | Target (default) | Calculation | Moved by |
|---|---|---|---|
| **First-pass approval** | ≥ 80% | PRs approved with no revision ÷ PRs submitted | `pr-preflight` |
| **Ceiling compliance** | ≥ 90% | Work items whose review cycles (code review + QA defect returns) stayed within `revision-ceiling` ÷ work items reviewed | `pr-preflight`, `address-review` |
| **Secure-checklist rate** | 100%, binary | Review submissions with the secure checklist fully applied ÷ review submissions | `secure-review` |
| **On-time delivery** | ≥ 85% | Stories completed within your own estimate ÷ stories committed | `estimate-story` |

Ceiling compliance is counted per work item. If the team counts it differently, the user's correction goes in the config file under `notes:`, and that wins.

## Ledger

The ledger is the evidence behind every number: `~/.config/gem/team/ledger.md`, appended to by the skills, never rewritten. Create it with these three tables when missing:

```markdown
## Pull requests
| PR | Story | Submitted | Review cycles | QA returns | First pass | Within ceiling | Secure checklist |
|---|---|---|---|---|---|---|---|

## Stories
| Story | Committed | Estimate | Actual | Within estimate | Variance cause |
|---|---|---|---|---|---|

## Return reasons
| Date | PR | Source | Category | What was asked |
|---|---|---|---|---|
```

Row rules:
- A PR row is added at first submission with `Review cycles 0`, `QA returns 0`, `First pass` blank.
- `First pass` becomes `yes` on an approval with zero cycles, `no` on the first return; it never flips back.
- `Within ceiling` is set when the item is approved: `Review cycles + QA returns ≤ revision-ceiling`.
- `Secure checklist` is `yes` only when every checklist item carries Pass or N/A with evidence on the submission.
- Return reasons use a short category (`naming`, `missing test`, `error handling`, `scope`, `security`, `UI defect`, `validation`, ...) so `pr-preflight` can check the recurring ones.

Record what happened, including misses. The ledger is only useful if it's honest.

## Asking the user

Ask through the agent's structured question tool when it has one (Claude Code `AskUserQuestion`, OpenCode `question`, omp `ask`, Codex `request_user_input`); otherwise as plain text, then wait. One decision per question, 2–4 options, recommended option first and marked "(Recommended)". Anything posted where the reviewer or the team can see it (PR comments, replies, messages to the lead) is drafted first and sent only after the user approves it.
