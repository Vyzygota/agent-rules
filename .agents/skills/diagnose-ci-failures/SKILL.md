---
name: diagnose-ci-failures
description: Diagnose CI failures for a PR using the GitHub CLI, extract error logs, and generate a fix plan. Use when the user asks to check CI status, triage test failures, or investigate PR build failures.
---

# diagnose-ci-failures

Programmatically diagnose CI failures for a PR and generate a plan to fix them.

## Overview

Deterministic workflow: check CI status, extract failure logs, analyze errors, create a plan. Output is always a plan for review — not immediate code changes.

## Workflow

### 1. Verify PR exists for current branch

```bash
git branch --show-current
gh --no-pager pr view <branch-name> --json number,title,url,state
```

If no PR exists, offer to create one.

### 2. Check CI status

```bash
gh pr view <branch-name> --json statusCheckRollup
```

Identify: completed vs in-progress checks, successful checks, failed checks with run IDs. If CI is still running, report what has already passed/failed and suggest waiting.

### 3. Extract failure logs

For each failed check:

```bash
gh run view <run-id> --log-failed
```

Extract: error messages with locations, compilation/lint errors, test failure messages and stack traces.

### 4. Categorize errors

Group by type:
- **Formatting**: code style failures
- **Linting**: static analysis warnings/errors
- **Compilation**: type errors, missing imports, signature mismatches
- **Test failures**: failing tests with names and reasons
- **Platform-specific**: OS or environment-specific failures

### 5. Generate a fix plan

Produce a plan document with:
- **Problem statement**: summary of failing checks
- **Current state**: errors found and where
- **Proposed changes**: specific fix for each error category
- **Validation steps**: commands to verify fixes

## Important notes

- Always create a plan first — never make code changes directly
- Fix one category at a time (e.g., all lint errors before tests)
- Distinguish environment-specific flakiness from real failures

## Example commands

```bash
# Get PR status with check details
gh --no-pager pr view --json number,title,state,statusCheckRollup

# Get logs from a specific failed run
gh run view 12345678 --log-failed

# Search for specific errors in logs
gh run view 12345678 --log-failed 2>&1 | grep -A 5 "error:"
```

## Related Skills

- `init-project`
- `warp-watch`
