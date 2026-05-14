---
name: implement-specs
description: Implement an approved feature from PRODUCT.md and TECH.md. Enforces Git worktree isolation, micro-tasking, and strict TDD (Red-Green-Refactor). Use after specs are approved.
---

# implement-specs

Implement an approved feature from `PRODUCT.md` and `TECH.md`.

## Prerequisites

- `PRODUCT.md` exists and has been reviewed
- `TECH.md` exists when the feature warranted one
- Specs are approved enough to start implementation

## Workflow

### 1. Read the approved specs first

Understand expected behavior, constraints, risks, and validation plan before writing code.

### 2. Isolate Environment (Git Worktree)

Before writing code, create an isolated Git Worktree to prevent breaking the main branch or current workspace.
- Run `git worktree add ../<branch-name> <branch-name>` (or `git checkout -b <branch-name>` if worktrees aren't supported)
- Do all implementation work in this isolated directory.

### 3. Plan Micro-Tasks (Subagent Approach)

Break work into concrete micro-tasks (2-5 minutes of work each). 
Each task must have exact file paths, the required code logic, and verification steps.
Approach each task as if dispatching an independent "sub-agent" focused purely on that one step.

### 4. Strict TDD Implementation (Red-Green-Refactor)

Implement tasks using strict Test-Driven Development:
1. Write a failing test for the current micro-task.
2. Watch the test fail (**RED**).
3. Write the minimal code required to pass the test (**GREEN**).
4. Refactor if necessary.
5. Commit the micro-task.
*Note: Any code written before a failing test is considered a violation.*

### 5. Update specs as implementation evolves

If implementation reveals that behavior or design should change, update the specs immediately rather than letting them go stale.
Keep spec updates in the same PR as the code changes.

### 6. Verify against the specs and Review

Before marking work complete, verify that code matches current specs. Reference `PRODUCT.md` Behavior invariants by number in your tests or verification steps.
Once verified, present merge options and clean up the worktree.

## Best Practices

- Keep specs and code synchronized throughout — not just at the end
- Update the spec immediately when decisions change

## Related Skills

- `write-product-spec`
- `write-tech-spec`
- `spec-driven-implementation`
