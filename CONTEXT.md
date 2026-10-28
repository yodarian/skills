# Skills repo

This repo is where I write and try out my own agent skills.

## Language

**fka workflow**:
My own project-authored workflow under `skills/`, separate from the installed Matt Pocock skills in `.agents/skills/`. Copy its skill directories into a target project's `.github/skills/` to make them discoverable; keep the sources here canonical. Its user-invoked phases clarify a goal, analyze codebase impact, gate refactoring, plan and implement small feature slices, and review on request. It also supports explicitly requested throwaway POCs and plans for existing SPIKEs. The workflow is standalone and has no runtime dependency on the installed skills.
_Avoid_: "the lean workflow", "my skills"

**Slice** (fka workflow):
The unit planned for implementation: a small, independently reviewable change with observable behavior. Prefer a vertical slice; use a separate technical-preparation slice when that makes the change safer.
_Avoid_: "tracer bullet" (that term belongs to the installed `to-tickets` workflow)

**Decisions log**:
The feature-scoped handoff at `.scratch/<topic>/decisions.md`. `fka-grill` records the confirmed goal; later feature phases append codebase impact, refactoring status, and the approved slice outline. It is not a durable glossary or architecture record; those belong in `CONTEXT.md` and `docs/adr/`.
_Avoid_: "spec" (the fka workflow uses a lightweight handoff rather than a full specification template)
