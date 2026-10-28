---
name: fka-tickets
description: Turn an approved refactoring or feature-slice plan into small, tests-first agent tickets as local markdown files.
disable-model-invocation: true
---

# fka-tickets

Turn an approved plan into small, human-reviewable agent tickets. Run this phase separately for approved refactoring work and for feature work; never combine the two in the same ticket set.

## Process

### 1. Check the handoff

Read `.scratch/<topic>/decisions.md` and identify which stage the user wants ticketed: approved refactoring or feature slices.

- Refactoring tickets require an explicit `approved` decision in `## Refactoring gate`.
- Feature tickets require an approved `## Feature slices` plan and a refactoring status of `not needed` or `declined`, or evidence that all approved refactoring tickets are complete.
- If a gate is missing or unresolved, stop and name the required decision or phase.

Completion: the chosen stage is eligible for ticketing and its source plan is explicit.

### 2. Explore and draft

Use project vocabulary and inspect the affected code enough to make each ticket actionable. Break work into small, independently reviewable units:

- Prefer a small vertical slice with observable behavior. Keep necessary technical preparation as separate tickets when that makes review safer.
- Put behavior tests before implementation steps in each checklist. Tests-first is the default; record a specific reason for any exception.
- For approved refactoring, missing agreed characterization tests are the first ticket(s), before behavior-changing refactor tickets.
- Record dependencies so blockers are explicit. Do not place feature implementation in the refactoring ticket set.

Completion: every ticket has an observable outcome, tests, scope, and dependency information.

### 3. Make tickets executable

Describe implementation steps precisely enough to execute without guessing, but avoid literal diffs or line-numbered patches. Use paths as hints when they may move.

Completion: each checklist step is concrete, scoped, and ordered.

### 4. Confirm and write

Present the proposed tickets with their stage, title, blockers, outcome, and test intent. Ask whether scope, granularity, and dependencies are correct. Iterate until the user approves the set.

Write one file per ticket in a stage-specific folder, numbered from `01` in dependency order:

- approved refactoring work: `.scratch/<topic>/tickets/refactoring/`
- feature work: `.scratch/<topic>/tickets/feature/`

```md
# <NN> — <Ticket title>

**Blocked by:** <ticket numbers/titles, or "None — can start immediately">

**What it delivers:** <the behavior this ticket makes true, in one or two sentences>

## Checklist

- [ ] Write test: <test name/description> — <what it must assert>
- [ ] Write test: <...>
- [ ] Implement: <pointed description / pseudocode of the change>
- [ ] Implement: <...>
```

Do not change the confirmed decisions while ticketing. Tell the user to start `fka-implement` separately for an unblocked ticket.

Completion: the approved stage's ticket files exist, blockers are explicit, and the next executable ticket is identified.
