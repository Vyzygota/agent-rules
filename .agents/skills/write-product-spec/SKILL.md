---
name: write-product-spec
description: Write a PRODUCT.md spec for a significant user-facing feature, focused on detailed behavior invariants. Use when the user asks for a product spec, PRD, or behavior doc, or when the feature is substantial enough that written behavior will improve implementation or review.
---

# write-product-spec

Write a `PRODUCT.md` for a significant feature.

## Overview

The product spec makes the desired behavior unambiguous enough that an agent can implement it correctly. Describe the feature from the user's perspective — what they see, do, and experience. No implementation details.

"User" means whoever consumes the surface:
- **UI/UX feature**: the human using the product
- **Data model**: code that reads and writes it
- **API or library**: callers of that API
- **CLI tool**: the developer invoking it

The companion `TECH.md` (produced by `write-tech-spec`) owns validation, testing, and architecture. Do not include those in PRODUCT.md.

## Before writing

Gather: spec directory id, feature summary, target users, key behaviors, edge cases. Use `ask_user_question` for missing context.

For features with any UI or visual design, ask whether a design mockup exists before drafting Behavior. If one exists, link it in the spec. If none exists, note that explicitly.

## Output location

`specs/<id>/PRODUCT.md` where `<id>` is:
- A ticket number (e.g. `specs/APP-1234/`)
- A GitHub/Linear issue id (e.g. `specs/gh-42/`)
- A short kebab-case name (e.g. `specs/dark-mode-toggle/`)

## Structure

**Required:**

1. **Summary** — 1–3 sentences: the feature and desired outcome.
2. **Behavior** — Exhaustive numbered invariants. See below — this is the spec.

**Optional** (include only if they add signal; omit heading if empty):

- **Problem** — Only when motivation isn't obvious from Summary.
- **Goals / Non-goals** — When scope has been contested or is ambiguous.
- **Figma / Design** — Link when one exists; note `none provided` for visual features with no mock. Omit for non-visual features.
- **Open questions** — Prefer inline `**Open question:** …` near relevant behavior.

Do not include Validation, Testing, or Success criteria — those live in TECH.md.

## The Behavior section

Behavior is the spec. Everything else is framing.

Describe at minimum:
- Default behavior and the happy-path flow
- Every user-visible state and transitions between them
- All inputs and how the feature responds
- Empty states, error states, loading/pending states, cancellation
- Edge cases: permissions denied, offline, timeouts, stale data, concurrent instances
- Keyboard, accessibility, and focus where relevant
- Invariants that must hold at all times and must not regress

Err toward enumerating one more edge case rather than one fewer.

## Length heuristic

- Trivial fix or narrow tweak: no spec
- Small feature (single module, few edge cases): ~30–60 lines total
- Medium feature (cross-module, multiple states): ~80–150 lines total
- Large or behaviorally rich feature: as long as needed — most length in Behavior

## Writing guidance

- Prefer concrete, observable behavior over aspirational wording
- Write Behavior as numbered invariants, not prose
- Avoid implementation details unless required for UX
- Each section earns its place — omit sections that only repeat others

## Keep the spec current

Update PRODUCT.md in the same PR as code when user-facing behavior changes. The checked-in spec describes the feature that actually ships.

## Related Skills

- `write-tech-spec`
- `spec-driven-implementation`
- `implement-specs`
