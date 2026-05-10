---
name: write-spec
description: Write specs for a significant feature — PRODUCT.md (behavior) and optionally TECH.md (implementation plan). Use when the user asks for a spec, PRD, or implementation plan, or when the feature is substantial enough that written specs will improve execution or review.
---

# write-spec

Write specs for a significant feature. This skill orchestrates `write-product-spec` and `write-tech-spec`.

## Overview

Translates a feature idea into precise specifications that an agent can implement correctly and a human can review meaningfully. `PRODUCT.md` defines user-facing behavior; `TECH.md` defines the implementation plan.

Skip this skill for single-file, obvious changes. Use it for anything multi-module or architecturally significant.

## When to use

| Situation | Action |
|---|---|
| Single-file, obvious approach | No spec needed — just implement |
| Multi-file, architectural decisions | Write `TECH.md` only |
| New user-facing feature | Write `PRODUCT.md` + `TECH.md` |
| Large cross-cutting change | Full spec, both files |

## Prerequisites

- You understand what the feature should do (ask the user if unclear)
- You have read the relevant existing code — do not guess about architecture
- You have a ticket ID, GitHub issue number, or feature name to use as the directory name

## Workflow

### 1. Write the product spec first

Use `write-product-spec` to create `specs/<id>/PRODUCT.md` for user-facing features. Defines behavior as numbered, testable invariants.

### 2. Write the tech spec when warranted

Use `write-tech-spec` to create `specs/<id>/TECH.md`. Required sections: Context (with file:line references), Proposed changes, Testing and validation, Parallelization.

### 3. Get approval before implementing

Present specs to the user. Wait for approval before writing implementation code.

### 4. Keep specs current during implementation

Update specs in the same commit as code changes. Use `implement-specs` skill to drive implementation from approved specs.

## Output location

`specs/<id>/` where `<id>` is:
- A ticket number (e.g. `specs/APP-1234/`)
- A GitHub issue id (e.g. `specs/gh-42/`)
- A short kebab-case feature name (e.g. `specs/dark-mode-toggle/`)

## Best Practices

- Ground the plan in actual code — read files before writing specs
- Each PRODUCT.md behavior invariant maps to a test in TECH.md
- Omit optional sections entirely rather than writing "N/A" or "None"
- The checked-in spec describes the feature that ships, not the initial intent

## Related Skills

- `write-product-spec`
- `write-tech-spec`
- `spec-driven-implementation`
- `implement-specs`
