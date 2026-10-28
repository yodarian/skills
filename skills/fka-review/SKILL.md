---
name: fka-review
description: Review a user-selected change against its originating ticket and the project's documented standards.
disable-model-invocation: true
---

# fka-review

Review only when the user starts this skill. Do not edit code or create tickets while reviewing.

## Pin the review scope

Ask for a fixed point if the user did not provide one. Identify the changed files and diff from that point. Find the originating ticket or `.scratch/<topic>/decisions.md`; if no source of expected behavior is available, ask whether to proceed with a standards-only review.

Completion: the comparison point, changed scope, and available behavior source are explicit.

## Review both axes

Read the relevant project standards, `CONTEXT.md` or `CONTEXT-MAP.md`, and ADRs. Review:

- **Standards:** compliance with documented coding and architecture rules.
- **Behavior:** whether the change meets the ticket's acceptance criteria and confirmed decisions.

Report only actionable findings with file and line references, the violated rule or expected behavior, and confidence. Distinguish confirmed defects from questions or risks. If an axis has no findings, say so. Do not duplicate issues already enforced by the project's checks.

Completion: both applicable axes have been checked across the requested diff, and every finding is traceable to evidence.

## Report

List findings first, ordered by severity and confidence, then note any review limitations. Do not fix findings unless the user separately asks.

Completion: applicable review findings and limitations are reported without changing the worktree.
