---
name: check-impl-against-spec
description: Compare a pull request's implementation against the spec in specs/<feature>/TECH.md or PRODUCT.md and report any material mismatches. Use during PR review when a spec exists for the feature being reviewed.
---

# Check implementation against spec

Use this skill when `specs/<feature>/TECH.md` or `specs/<feature>/PRODUCT.md` exists for the PR being reviewed.

## Goal

Determine whether the implementation materially matches the approved spec. This supplements a normal code review — it does not replace it.

## Inputs

- `specs/<feature>/PRODUCT.md` — intended behavior and acceptance criteria.
- `specs/<feature>/TECH.md` — implementation details, file changes, constraints.
- `gh pr diff` or the checked-out diff — the actual implementation.
- PR description and changed files — additional scope or rationale.

## Process

1. Read the spec(s) and extract concrete commitments:
   - required behaviors (from PRODUCT.md)
   - required files or subsystems to change (from TECH.md)
   - stated constraints
   - required follow-up steps, validations, or migrations
2. Compare those commitments against the actual implementation in the diff and checked-out files.
3. Treat small implementation-level adjustments as acceptable when they preserve the spec's intent. Do not flag harmless differences in naming, structure, or low-level technique.
4. Flag a mismatch only when it is material:
   - required behavior in the product spec is missing
   - the implementation contradicts a spec decision
   - the change introduces significant unplanned scope
   - a required validation, migration, or compatibility step from the tech spec is absent

## Output

Write findings directly to the user as a structured report:

```markdown
## Spec Alignment Report

**Spec:** specs/<feature>/TECH.md + PRODUCT.md
**PR:** <title>

### Matches
- [list what aligns with spec]

### Mismatches (material)
- [describe mismatch, cite spec section and diff location]

### Not covered by spec
- [changes in the PR that the spec doesn't address]

**Verdict:** Aligned / Partially aligned / Significant drift
```

If everything aligns closely, say so briefly without listing every match.

## Boundaries

- Do not require literal one-to-one implementation of the spec when the PR achieves the same outcome safely.
- Do not speculate about spec details that are not actually present in the spec files.
- Do not post to GitHub directly.
