---
name: hexagonal-architecture-refactor
description: "Analyze legacy code and propose a hexagonal architecture refactor plan with candidate ports, adapters, and characterization tests."
disable-model-invocation: true
---

# Hexagonal Architecture Refactor

This skill extracts a single hexagonal module from legacy code by locating the core seam, tracing dependencies, and recommending the port/adaptor boundaries and tests.

See [`HEXAGONAL-ARCHITECTURE.md`](HEXAGONAL-ARCHITECTURE.md) for a reference explanation of hexagonal architecture concepts.

## Process

### 1. Clarify scope

Ask the user for:

- input files or root entry points
- whether an existing target module or refactor module is already started
- the main responsibility or domain concept of the extracted code
- any known behavior or invariants that must remain unchanged

Completion: the user has provided all scope facts and there are no remaining open questions about the entry points, target module, domain concept, or invariants.

Do not assume the listed files are exhaustive. If the code imports or references other files, follow those dependencies and include them in the analysis.

### 2. Discover the legacy seam

- Read the entry files and follow imports/uses to discover related classes, functions, and modules.
- Identify the legacy code cluster that belongs together and the boundaries between domain logic, infrastructure, and external integration.
- If an existing partial target module exists, determine how the new candidates should merge into it.

Completion: the legacy cluster and its boundary are mapped, and related dependency files are accounted for.

### 3. Propose characterization tests

- Identify observable behavior and seam surfaces for the legacy cluster.
- Propose one or more characterization tests that capture the current behavior without requiring a full redesign.
- Prefer tests that exercise public entry points, edge cases, and side effects that are likely to break during refactoring.
- If the code has no obvious test boundaries, propose small harnesses around the detected seams.

Completion: at least one concrete test candidate exists for each major behavior path or adapter boundary.

### 4. Recommend module structure and interfaces

- Describe the port/adaptor boundaries for a hexagonal design.
- Suggest specific interfaces or abstractions for the core domain logic, driven adapters, and driving adapters.
- Explain which classes or functions should move into the new module and which should remain as adapters or outside the core.
- If there is an existing target module, describe how to integrate with it and what to migrate.

Completion: the recommendation names interfaces/adapters and maps code elements to core versus adapter responsibilities.

### 5. Deliver the plan

Return a clear plan containing:

- candidate source files and why they belong in the hexagonal module
- the recommended module structure and interface names
- the suggested characterization tests with a short description of what each will verify
- the next refactoring steps in order, including safe intermediate seams or extraction points

Completion: the plan is a coherent actionable recommendation for the user to execute.

## Notes

- Do not start with code edits. First produce the plan and test suggestions.
- If the user mentions a partial target module, fold new classes into it rather than inventing a separate structure.
- Be explicit about assumptions and gaps when the code is incomplete or imports point outside the provided set.
