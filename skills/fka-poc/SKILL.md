---
name: fka-poc
description: Build an explicitly requested throwaway vertical-slice POC in a separate branch to answer a technical question.
disable-model-invocation: true
---

# fka-poc

Build a POC only when the user explicitly starts this skill or asks for it by name. A POC validates an approach; it is not production implementation.

## Agree the question

Read `.scratch/<topic>/decisions.md` and the relevant project context. Clarify the single uncertainty, the smallest vertical slice that can answer it, and what observation will count as an answer.

Completion: the user agrees on the question and a bounded validation target.

## Isolate the experiment

Check the current branch and worktree before changing files. If unrelated or uncommitted work could be affected, stop and ask how to proceed. Agree a separate POC branch name before creating or switching branches. Keep the experiment isolated from the production branch. Do not edit the shared `decisions.md` while working on the POC branch.

Implement only the smallest runnable slice needed to test the hypothesis. Use the lightest validation that answers the question; avoid production hardening, broad abstractions, and unrelated changes.

Completion: the agreed experiment runs and produces evidence for or against the hypothesis.

## Capture the result

Report the question, experiment, evidence, and conclusion to the user. Keep the code on the separate POC branch; do not commit, merge, or port it into production. If returning to the original branch would discard uncommitted POC work, stop and ask the user how to preserve or discard it. After the user returns to the original branch, they start `fka-impact` again; that phase records the findings under `## POC findings` in `decisions.md`.

Completion: the POC branch is isolated, findings are reported, and the user knows how to return to the original branch without losing work.
