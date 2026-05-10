---
name: write-tech-spec
description: Write a TECH.md implementation plan for a significant feature, grounded in the current codebase. Use when the user asks for a technical spec, architecture doc, or implementation plan, or after PRODUCT.md is agreed on and the feature spans multiple modules.
---

# write-tech-spec

Write a `TECH.md` for a significant feature.

## Overview

The tech spec translates product intent into an implementation plan that fits the existing codebase, documents architectural choices, and makes work easier for agents to execute and reviewers to evaluate.

Have `PRODUCT.md` agreed on first so the plan is anchored to accepted behavior. If implementation details are still uncertain, build a prototype and then write the tech spec from what was learned.

## Before writing

Read `PRODUCT.md`, inspect relevant code, identify key files, types, data flow, and ownership boundaries. Do not guess about current architecture when the code can be inspected directly.

## Output location

`specs/<id>/TECH.md` matching the sibling `PRODUCT.md` directory.

## Structure

**Required:**

1. **Context** — What's being built, how the current system works in the relevant area, and the most relevant files with line references. Reference `PRODUCT.md` for user-visible behavior rather than restating it.

2. **Proposed changes** — Implementation plan: which modules change, new types/APIs/state, data flow, ownership boundaries, how the design follows existing patterns. Call out tradeoffs when there is more than one reasonable path.

3. **Testing and validation** — How the implementation will be verified. Reference numbered Behavior invariants from `PRODUCT.md` directly. Owns: unit tests, integration tests, manual verification steps, and any other proof the feature works.

4. **Parallelization** — Actively evaluate whether parallel sub-agents would reduce wall-clock time. If yes, specify for each agent: name/role, subtask, execution mode (local/remote), worktree path, branch, and coordination boundaries. If no, briefly note why.

**Optional** (omit heading if empty):

- **End-to-end flow** — Only when tracing system path adds signal beyond Proposed changes.
- **Diagram** — Mermaid diagram when visual explains design faster than prose (data flow, state transitions, sequence).
- **Risks and mitigations** — When there are real failure modes, regressions, or migration hazards.
- **Follow-ups** — Deferred cleanup or future work worth naming.

## Length heuristic

- Single-file, clear approach: skip or under ~40 lines
- Multi-module, some ambiguity: ~80–150 lines
- Large cross-cutting change: as long as each section earns its place

## Writing guidance

- Ground the plan in actual codebase structure and patterns
- Prefer concrete implementation guidance over generic architecture language
- Reference `PRODUCT.md` for behavior instead of restating it
- Each section earns its place — omit sections that only repeat others

## Keep the spec current

Update TECH.md in the same PR as code when module boundaries, architecture, or validation strategy changes. The checked-in spec describes the implementation that actually ships.

## Related Skills

- `write-product-spec`
- `spec-driven-implementation`
- `implement-specs`
