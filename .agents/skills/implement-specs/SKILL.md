---
name: implement-specs
description: Implement an approved feature from PRODUCT.md and TECH.md, keeping specs and code aligned in the same PR as implementation evolves. Use after product and tech specs are approved and the next step is building the feature.
---

# implement-specs

Implement an approved feature from `PRODUCT.md` and `TECH.md`.

## Prerequisites

- `PRODUCT.md` exists and has been reviewed
- `TECH.md` exists when the feature warranted one
- Specs are approved enough to start implementation

## Workflow

### 1. Read the approved specs first

- `PRODUCT.md` is the source of truth for user-facing behavior
- `TECH.md` is the source of truth for architecture and sequencing

Understand expected behavior, constraints, risks, and validation plan before writing code.

### 2. Offer optional tracking aids for large features

For large or long-running features, optionally offer before implementation begins:

- `PROJECT_LOG.md` — tracks checkpoints, explored paths, and current implementation state
- `DECISIONS.md` — captures concrete product and technical decisions made during design

These are optional, not required deliverables. Offer them when they would reduce confusion.

### 3. Plan and implement against the specs

Break work into concrete steps, then implement against approved specs:
- Keep behavior aligned with `PRODUCT.md`
- Keep architecture aligned with `TECH.md`
- Add or update tests as work lands

Use the same PR for specs and implementation when practical.

### 4. Update specs as implementation evolves

If implementation reveals that behavior or design should change, update the specs immediately rather than letting them go stale.

Update `PRODUCT.md` when user-facing behavior, UX, or edge cases change.
Update `TECH.md` when architecture, module boundaries, or validation strategy change.

Keep spec updates in the same PR as the code changes.

### 5. Verify against the specs

Before marking work complete, verify that code matches current specs. Reference `PRODUCT.md` Behavior invariants by number in your tests or verification steps.

## Best Practices

- Keep specs and code synchronized throughout — not just at the end
- Update the spec immediately when decisions change
- The PR should describe the feature that actually ships, not the initial draft

## Related Skills

- `write-product-spec`
- `write-tech-spec`
- `spec-driven-implementation`
