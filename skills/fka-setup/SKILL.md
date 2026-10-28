---
name: fka-setup
description: Set up a repo's context and module-map sources for the fka workflow.
disable-model-invocation: true
---

# fka-setup

Identify the repository's domain context and module-map sources. Process and ticket conventions are shared workflow rules, not per-repo setup inputs.

## Process

### 1. Discover existing sources

Read applicable `AGENTS.md`, `CONTEXT.md` or `CONTEXT-MAP.md`, ADRs, and existing architecture/module documentation. Use the project's established layout. Treat existing documents as the source of truth; do not create a parallel copy.

Completion: the domain context and module information relevant to this workflow are located, or their absence is clear.

### 2. Resolve gaps

Summarize missing or conflicting context/module information and ask the user only for what cannot be established from the repo. Confirm the right existing document to update. Keep domain vocabulary in its context glossary and durable architectural choices in ADRs; put module maps in the project's architecture documentation.

Completion: the user has confirmed what information should be added and where.

### 3. Persist the project context

Update only the relevant source documents, preserving existing conventions and unrelated content. If no suitable home for a needed module map exists, propose a small location and get agreement before creating it. Do not record quality commands, ticket conventions, or workflow rules here.

Completion: confirmed context and module information is recorded once in its source of truth. Tell the user the later phases will read those documents.
