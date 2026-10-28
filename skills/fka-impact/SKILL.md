---
name: fka-impact
description: Map the legacy components, tests, and standards relevant to an understood feature and obtain a refactoring decision.
disable-model-invocation: true
---

# fka-impact

First locate the legacy components a confirmed feature touches. If the user explicitly chooses a POC, return to this skill afterward for the deeper impact and refactoring analysis.

## Establish scope

Read `.scratch/<topic>/decisions.md`, `CONTEXT.md` or `CONTEXT-MAP.md`, relevant ADRs, and the project's documented coding and architecture conventions. If the goal is not confirmed, stop and direct the user to `fka-grill`.

Completion: the feature's confirmed behavior and repository context are known.

## Discover the components

Follow relevant entry points, dependencies, and callers far enough to identify candidate components and module boundaries. Record this initial map under `## Component discovery` in `decisions.md`.

If a small vertical POC could resolve a material technical uncertainty, describe the specific question it would answer. The user must start `fka-poc` explicitly; when they do, stop this phase after recording component discovery. After the POC, the user returns to the original branch, starts `fka-impact` again, and supplies the reported findings so they can be recorded. If no POC is useful or the user declines one, continue to the deeper analysis.

Keep local codebase exploration in this phase. External/web research is a separate, user-started activity; do not launch it automatically.

Completion: candidate components are identified with repository evidence, and the POC choice is either not relevant, declined, or explicitly handed off.

## Analyze the components

For each affected component, record its role, relevant dependencies, applicable coding/architecture rules, and existing tests for the behavior in scope. Identify meaningful test gaps, including missing characterization coverage for behavior a candidate refactor could change. If resuming after a POC, incorporate its findings and do not repeat component discovery.

Completion: affected components, relevant tests, and observed rule-conformance gaps are supported by repository evidence.

## Present the refactoring gate

Record findings under `## Codebase impact` in `decisions.md`, separating observed facts, risks, and recommendations. Under `## Refactoring gate`, list candidate changes, why each is needed, and any missing characterization tests. Do not silently update the glossary or ADRs; use `fka-model` when a user-confirmed term or durable architectural decision meets its criteria.

Ask the user to approve or decline each proposed refactoring before any refactor tickets or code changes are made. If approved, record the exact scope and mark it `approved`; if declined, record `declined`; if no refactoring is needed, record `not needed`.

Completion: the user has explicitly settled the refactoring gate and the result is recorded. Tell the user to start `fka-tickets` for approved refactoring work, or `fka-plan` if feature planning can proceed.
