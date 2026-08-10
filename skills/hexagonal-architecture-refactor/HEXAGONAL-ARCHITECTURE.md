# Hexagonal Architecture Reference

This file explains the core concepts and vocabulary used by the `hexagonal-architecture-refactor` skill.

## What hexagonal architecture is

Hexagonal architecture (also called ports and adapters) separates the core domain logic from all external concerns.

- The **core** is the business logic and domain rules. It should depend only on abstractions, not on external frameworks or infrastructure.
- The **outside** consists of adapters that translate between the core's abstract ports and concrete technologies: databases, HTTP, queues, files, external APIs, UI, etc.
- The core exposes a small set of entry points, and those entry points are the real seam.

## Ports and adapters

### Ports

A **port** is an interface between the core and the outside world.

- A **driving port** is how the outside drives the core. Examples: a use-case interface, command handler, application service, or request boundary.
- A **driven port** is how the core depends on outside services. Examples: repository interfaces, notification senders, payment gateways, or file writers.

### Adapters

An **adapter** implements a port using a concrete technology.

- A **driving adapter** calls the core through a driving port. Examples: HTTP controllers, CLI commands, event handlers, scheduled jobs.
- A **driven adapter** implements a driven port for a specific backend. Examples: Eloquent repository, Redis cache, REST client, SMTP mailer.

## What belongs in the core module

Keep the core module small and focused on domain behavior:

- business rules
- validation that is domain-specific
- orchestration of domain operations
- port/interface definitions for external dependencies

Do not put framework-specific code, infrastructure details, or transport mechanics in the core.

## What stays outside the core

Keep infrastructure and integration code as adapters:

- persistence details (ORM, raw SQL, file system, cache)
- HTTP request/response handling
- queue/message transport
- external API clients
- user interface concerns

## Recommended extraction pattern

1. **Identify the seam**: find the public entry point(s) that implement the behavior and the dependencies they need.
2. **Separate the core from the adapters**: define interfaces for driven dependencies and move business logic into a core module.
3. **Keep adapters thin**: adapters should translate between the core's interfaces and the external technology.
4. **Preserve behavior with characterization tests**: write tests around the current observable behavior before refactoring.

## Characterization tests

Characterization tests should capture the existing behavior without prescribing a new design.

- Test public entry points or high-level workflows.
- Cover boundary cases, failures, and side effects that would be hard to reconstruct.
- Prefer tests that exercise the seam between the core and adapters.
- If the code is highly coupled, use small harnesses around the identified ports or adapter boundaries.

## Naming and folder structure guidance

This reference is intentionally generic. Apply the repository's local naming and folder conventions when you:

- name core modules and interfaces
- place driven/driving adapters
- organize tests and fixtures

If the project has a nonstandard folder layout, keep the same hexagonal separation but map the core to the local module naming and the adapters to the existing infrastructure folders.

## How to use this file

- Use this document as a baseline for the `hexagonal-architecture-refactor` skill.
- Replace or extend it later with project-specific documentation.
- Keep the skill's process separate from the concrete implementation details of the current repo.
