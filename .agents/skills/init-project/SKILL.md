---
name: init-project
description: Initialize a new project with Warp-style agentic structure. Use when starting a new repository or when an existing project is missing AGENTS.md, specs/, or .agents/skills/.
---

# init-project

## Overview

Sets up the standard project structure for spec-driven agentic development. Creates the context file, specs directory, skills directory, and skills-lock.json referencing the global vyzygota/agent-rules skills.

## Prerequisites

- You are in the root directory of the project
- You know the project name, tech stack, and key commands (build, test, lint)

## Workflow

### 1. Create AGENTS.md

Create AGENTS.md at the project root with: project name, what it is, tech stack, build/test/lint commands, architecture rules, key files.

### 2. Create directory structure

Create folders: specs/ and .agents/skills/

### 3. Create skills-lock.json

Reference the three global skills: init-project, write-spec, warp-watch from vyzygota/agent-rules.

### 4. Verify and commit

Add all new files and commit with message: "init: add agentic project structure"

## Best Practices

- Fill in AGENTS.md with real commands before committing — a template with empty fields is useless.
- Ask the user for build/test/lint commands if you don't know them.
- If the project already has `.cursorrules`, keep it — Warp and Antigravity still read it as fallback.

## Related Skills

- `write-spec`
- `warp-watch`
