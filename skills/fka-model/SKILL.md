---
name: fka-model
description: Keeper of this project's domain glossary (CONTEXT.md) and architectural decisions (docs/adr/). Call whenever a term needs sharpening or a decision meets the ADR bar.
---

# fka-model

Actively build and sharpen the project's domain model as the fka workflow runs. `fka-grill`, `fka-impact`, `fka-plan`, `fka-tickets`, `fka-implement`, and `fka-setup` may call this skill when terminology or a durable architectural decision needs attention. It is a shared utility, not a workflow phase.

## File structure

Most repos have a single context:

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-slug.md
│       └── 0002-slug.md
```

If a `CONTEXT-MAP.md` exists at the root, the repo has multiple contexts, each with its own `CONTEXT.md` and `docs/adr/`. The map points to where each one lives.

Create files lazily — only when there's something to write. If no `CONTEXT.md` exists, create one when the first term is resolved. If no `docs/adr/` exists, create it when the first ADR is needed.

## Sharpening vocabulary

- **Challenge against the glossary.** When a term conflicts with `CONTEXT.md`, say so: "Your glossary defines X as A, but you mean B here — which is it?"
- **Sharpen fuzzy language.** Propose a precise canonical term for vague or overloaded words.
- **Cross-reference with code.** If stated behavior contradicts what the code does, surface the contradiction.
- **Update inline, immediately.** Don't batch resolved terms — write them to `CONTEXT.md` as soon as they're settled.

`CONTEXT.md` is a glossary only — never a spec, scratch pad, or place for implementation decisions. Use this format:

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Language

**{Term}**:
{One or two sentence definition — what it IS, not what it does.}
_Avoid_: {other words people use for the same thing}
```

## Recording ADRs

Offer an ADR only when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — genuine alternatives existed and one was picked for specific reasons

Skip it if any of the three is missing. Use sequential numbering (`0001-slug.md`, `0002-slug.md`, ...) under `docs/adr/`. Keep it short:

```md
# {Short title of the decision}

{1-3 sentences: the context, what was decided, and why.}
```

Only add a Status line, Considered Options, or Consequences when they add genuine value — most ADRs are a single paragraph.
