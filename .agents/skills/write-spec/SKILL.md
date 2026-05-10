---
name: write-spec
description: Write PRODUCT.md and/or TECH.md for a feature before implementation. Use when the feature spans multiple files, involves architectural decisions, or when a reviewer would benefit from seeing the plan before the code.
---

# write-spec

## Overview

Translates a feature idea into precise specifications that an agent can implement correctly and a human can review meaningfully. PRODUCT.md defines user-facing behavior; TECH.md defines the implementation plan.

Skip this skill for single-file, obvious changes. Use it for anything multi-module or architecturally significant.

## Prerequisites

- You understand what the feature should do (ask the user if unclear)
- You have read the relevant existing code — do not guess about architecture
- You have a ticket ID, GitHub issue number, or feature name to use as the directory name

## Workflow

### 1. Choose the spec directory name

Use one of:
- Feature name: specs/card-visualization/
- GitHub issue: specs/gh-42/

### 2. Research before writing

Read the relevant source files. Identify entry points, data flow, types that will change, existing patterns to follow.

### 3. Write PRODUCT.md (user-facing features only)

Sections: Overview, Behavior (numbered testable invariants), Edge cases, Out of scope.

### 4. Write TECH.md

Required sections: Context (with file:line references), Proposed changes, Testing and validation, Parallelization.

### 5. Get approval before implementing

Present specs to user. Wait for approval before writing implementation code.

### 6. Keep specs current during implementation

Update TECH.md and PRODUCT.md in the same commit as code changes when the design evolves.

## Best Practices

- Ground the plan in actual code — read files before writing specs.
- Each PRODUCT.md behavior invariant should map to exactly one test in TECH.md.
- Omit optional sections entirely rather than writing "N/A" or "None".

## Related Skills

- `init-project`
- `warp-watch`
