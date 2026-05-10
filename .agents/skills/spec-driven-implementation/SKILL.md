---
name: spec-driven-implementation
description: Drive a spec-first workflow for substantial features — write PRODUCT.md before implementation, write TECH.md when warranted, then implement and keep both specs current. Use when starting a significant feature or when the user wants specs checked into source control before building.
---

# spec-driven-implementation

Drive a spec-first workflow for substantial features.

## Overview

Use for significant features where written specs will improve implementation quality, reduce ambiguity, or make review easier. Be pragmatic: not every change needs specs.

## When specs are needed

**Strongly prefer specs when:**
- There is product or architectural ambiguity
- Implementation is 500+ LOC or spans multiple modules
- The change is risky (regressions would be expensive)
- Agent quality will improve materially from clearer inputs

**Specs are often unnecessary for:**
- Small, local bug fixes
- Straightforward refactors
- Narrow UI tweaks with little ambiguity

For pure UI changes, `PRODUCT.md` is often useful while `TECH.md` may be unnecessary.

## Workflow

### 1. Decide whether the feature needs specs

Evaluate size, ambiguity, and risk. If specs won't meaningfully improve execution or review, skip and focus on verification instead.

### 2. Write the product spec first

Use `write-product-spec` to create `PRODUCT.md`. This defines what the feature does from the user's perspective — invariants, edge cases, success criteria.

If the feature has UI, ask for a design mockup before drafting Behavior.

### 3. Write the tech spec when warranted

Use `write-tech-spec` to create `TECH.md`. Acceptable to write after a prototype if the implementation details are too uncertain upfront.

### 4. Get specs reviewed

Specs should be reviewed before implementation begins. Commit them to source control in the feature branch so review is anchored to what will actually ship.

### 5. Implement from approved specs

Use `implement-specs` to build from approved `PRODUCT.md` and `TECH.md`. Keep specs and code in the same PR.

### 6. Keep specs current during implementation

If implementation diverges from the spec, update the spec immediately — not at the end.

- Update `PRODUCT.md` when: user-facing behavior, UX, edge cases, or success criteria change
- Update `TECH.md` when: architecture, module boundaries, risks, or validation strategy change

### 7. Verify behavior against the spec

Before marking work complete, confirm that tests and verification map to `PRODUCT.md` Behavior invariants by number.

## Best Practices

- Write specs to improve input quality for agents, not as ceremony
- Keep product specs behavior-oriented and implementation-light
- Keep tech specs grounded in current codebase patterns
- The checked-in spec describes the feature that ships, not the initial intent

## Related Skills

- `write-product-spec`
- `write-tech-spec`
- `implement-specs`
