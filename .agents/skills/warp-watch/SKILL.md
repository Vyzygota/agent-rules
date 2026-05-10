---
name: warp-watch
description: Check Warp's GitHub repositories and changelog for new patterns, conventions, or skills worth adopting into the global methodology. Use monthly or when asked to update the agent development principles.
---

# warp-watch

## Overview

Keeps the global methodology in vyzygota/agent-rules current with Warp's evolving approach to agentic development. When Warp changes their conventions, we evaluate whether to adopt them.

## Prerequisites

- Network access to GitHub API
- Write access to vyzygota/agent-rules

## Workflow

### 1. Fetch recent Warp commits

Check: https://api.github.com/repos/warpdotdev/warp/commits?per_page=20

Look for commits touching: WARP.md, .agents/, specs/, skills-lock.json

### 2. Fetch current skills list from common-skills

Check: https://api.github.com/repos/warpdotdev/common-skills/contents/.agents/skills

For each new skill, read its SKILL.md and evaluate if the pattern is worth adopting.

### 3. Check changelog

Check: https://docs.warp.dev/changelog/2026/

### 4. Evaluate findings

Adopt if it changes: PRODUCT.md or TECH.md format, SKILL.md structure, AGENTS.md conventions, PR workflow or parallelization guidelines.

Skip if it's Warp-specific: Rust codebase, desktop UI, enterprise billing.

### 5. Update and commit

Edit CLAUDE.md and AGENTS.md with new patterns. Update "Last synced with Warp" date. Commit and push to vyzygota/agent-rules.

## Best Practices

- Only adopt patterns that improve clarity or correctness — don't change conventions for novelty.
- Always update the "Last synced" date even if nothing changed.

## Related Skills

- `init-project`
- `write-spec`
