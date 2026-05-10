---
name: init-project
description: Initialize a new project with WARPEngine agentic structure for Claude Code and Antigravity IDE. Use when starting a new repository or when an existing project is missing AGENTS.md, specs/, .agents/skills/, or .agentskills/.
---

# init-project

## Overview

Sets up the standard project structure for spec-driven agentic development. Creates the context file, specs directory, skills directories (for both Claude Code and Antigravity), and skills-lock.json referencing global vyzygota/agent-rules skills.

## Supported environments

This structure works across two AI agent environments simultaneously:

| Environment | Skills path | MCP config |
|---|---|---|
| Claude Code | `.agents/skills/<name>/SKILL.md` | `.claude/settings.json` |
| Antigravity IDE | `.agentskills/<name>/SKILL.md` | `antigravity://settings` → MCP Servers |

Both use the same `SKILL.md` format (YAML frontmatter + markdown). `.agentskills/` is a junction/symlink to `.agents/skills/` so skills only live in one place.

## Prerequisites

- You are in the root directory of the project
- You know the project name, tech stack, and key commands (build, test, lint)

## Workflow

### 1. Create AGENTS.md

Create `AGENTS.md` at the project root with:
- Project name and one-paragraph description
- Tech stack (language, framework, engine)
- Build / test / lint commands
- Architecture rules (2–5 invariants)
- Key files with one-line descriptions

Fill in real values — a template with empty fields is useless. Ask the user for build/test/lint commands if unknown.

### 2. Create directory structure

Create `specs/` and `.agents/skills/`.

Then link `.agentskills/` → `.agents/skills/` so Antigravity discovers the same skills:

**Windows (junction — no admin required):**
```bash
cmd /c mklink /J .agentskills .agents\skills
```

**Linux / macOS (symlink):**
```bash
ln -s .agents/skills .agentskills
```

If the junction/symlink fails, create `.agentskills/` as a real directory and note in AGENTS.md that it must be kept in sync with `.agents/skills/`.

Add `.agentskills` to `.gitignore` if it's a junction (junctions are not tracked by git meaningfully). If it's a real directory, commit it normally.

### 3. Create skills-lock.json

```json
{
  "version": 1,
  "skills": {
    "init-project":               { "source": "vyzygota/agent-rules", "sourceType": "github", "skillPath": ".agents/skills/init-project/SKILL.md" },
    "write-spec":                 { "source": "vyzygota/agent-rules", "sourceType": "github", "skillPath": ".agents/skills/write-spec/SKILL.md" },
    "write-product-spec":         { "source": "vyzygota/agent-rules", "sourceType": "github", "skillPath": ".agents/skills/write-product-spec/SKILL.md" },
    "write-tech-spec":            { "source": "vyzygota/agent-rules", "sourceType": "github", "skillPath": ".agents/skills/write-tech-spec/SKILL.md" },
    "spec-driven-implementation": { "source": "vyzygota/agent-rules", "sourceType": "github", "skillPath": ".agents/skills/spec-driven-implementation/SKILL.md" },
    "implement-specs":            { "source": "vyzygota/agent-rules", "sourceType": "github", "skillPath": ".agents/skills/implement-specs/SKILL.md" },
    "diagnose-ci-failures":       { "source": "vyzygota/agent-rules", "sourceType": "github", "skillPath": ".agents/skills/diagnose-ci-failures/SKILL.md" },
    "update-skill":               { "source": "vyzygota/agent-rules", "sourceType": "github", "skillPath": ".agents/skills/update-skill/SKILL.md" },
    "warp-watch":                 { "source": "vyzygota/agent-rules", "sourceType": "github", "skillPath": ".agents/skills/warp-watch/SKILL.md" }
  }
}
```

If the project uses Unity, add `unity-implement` to the skills list:
```json
"unity-implement": { "source": "vyzygota/agent-rules", "sourceType": "github", "skillPath": ".agents/skills/unity-implement/SKILL.md" }
```

### 4. Configure MCP (if applicable)

**Claude Code** — add to `.claude/settings.json`:
```json
{
  "mcpServers": {
    "mcp-unity": {
      "command": "node",
      "args": ["ABSOLUTE/PATH/TO/mcp-unity/Server~/build/index.js"]
    }
  }
}
```

**Antigravity** — open `antigravity://settings` → Editor Settings → MCP Servers and add the same server entry. Antigravity uses identical MCP config format.

Both agents will then have access to the same MCP tools.

### 5. Verify and commit

```bash
git add AGENTS.md specs/ .agents/ skills-lock.json .claude/settings.json
git commit -m "init: add agentic project structure (Claude Code + Antigravity)"
```

## Best Practices

- Fill AGENTS.md with real commands — a template with empty fields gives agents no useful context.
- Ask the user for build/test/lint commands if you don't know them.
- If the project already has `.cursorrules`, keep it — some environments read it as a fallback.
- The junction/symlink approach means skills are written once and discovered by both environments automatically — never copy SKILL.md files manually between the two directories.

## Related Skills

- `write-spec`
- `write-product-spec`
- `write-tech-spec`
- `spec-driven-implementation`
- `implement-specs`
- `update-skill`
- `warp-watch`
- `unity-implement` (Unity projects only)
