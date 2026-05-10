---
name: init-project
description: Initialize a new project with WARPEngine agentic structure for Claude Code and Antigravity IDE. Use when starting a new repository or when an existing project is missing AGENTS.md, specs/, .agents/skills/, or .agentskills/.
---

# init-project

## Overview

Sets up the standard project structure for spec-driven agentic development. Creates the context file, specs directory, skills and rules directories (for both Claude Code and Antigravity), and skills-lock.json referencing global vyzygota/agent-rules skills.

## Supported environments

| Environment | Skills | Rules / Workflows | Global context |
|---|---|---|---|
| Claude Code | `.agents/skills/<name>/SKILL.md` | — | `CLAUDE.md` / `~/.claude/CLAUDE.md` |
| Antigravity IDE | `.agentskills/<name>/SKILL.md` (junction) | `.agents/rules/*.md` → `/name` slash cmds | `~/.gemini/GEMINI.md` |

Both use the same `SKILL.md` YAML frontmatter format and same MCP JSON config.

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

```bash
mkdir -p specs .agents/skills .agents/rules
```

Then link `.agentskills/` → `.agents/skills/` so Antigravity discovers skills:

**Windows (junction — no admin required):**
```bash
cmd /c mklink /J .agentskills .agents\skills
```

**Linux / macOS (symlink):**
```bash
ln -s .agents/skills .agentskills
```

If junction/symlink fails: create `.agentskills/` as a real directory and note in AGENTS.md it must stay in sync.

Add `.agentskills` to `.gitignore` when it's a junction. Commit it if it's a real directory.

### 3. Create `.agents/rules/WORKSPACE.md`

This file is the Antigravity Rules context — loaded automatically in every Antigravity session for this workspace.

```markdown
# Workspace Rules

@../../AGENTS.md

## Agent Mode
Use Planning mode for feature implementation (specs → task groups → artifacts → verify).
Use Fast mode for quick fixes and single-file changes.

## Artifact Review
Always request review before implementing from specs.
Run tests after implementation and verify against PRODUCT.md invariants by number.

## Skills
This project uses WARPEngine skills. See .agentskills/ for available skills.
```

The `@../../AGENTS.md` reference pulls in the full project context automatically — no duplication.

### 4. Create skills-lock.json

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

For Unity projects, also add:
```json
"unity-implement": { "source": "vyzygota/agent-rules", "sourceType": "github", "skillPath": ".agents/skills/unity-implement/SKILL.md" }
```

### 5. Configure MCP (if applicable)

**Claude Code** — `.claude/settings.json`:
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

**Antigravity** — `antigravity://settings` → Editor Settings → MCP Servers. Same JSON format.

### 6. (Optional) Expose key skills as Antigravity Workflows

For skills the team will invoke explicitly (not just auto-discovered), create a companion workflow file in `.agents/rules/`. This makes the skill callable as `/skill-name` in Antigravity chat:

```bash
# Example: expose unity-implement as /unity-implement
cat > .agents/rules/unity-implement.md << 'EOF'
# unity-implement

@../skills/unity-implement/SKILL.md

Execute the unity-implement workflow for the current feature.
EOF
```

See `update-skill` for the full workflow exposure pattern.

### 7. Verify and commit

```bash
git add AGENTS.md specs/ .agents/ skills-lock.json .claude/
git commit -m "init: add agentic project structure (Claude Code + Antigravity)"
```

## Best Practices

- Fill AGENTS.md with real commands — empty fields give agents no useful context.
- Ask the user for build/test/lint commands if you don't know them.
- The junction/symlink means skills are written once and discovered by both environments — never copy SKILL.md manually.
- `.agents/rules/WORKSPACE.md` uses `@` to reference AGENTS.md — one source of truth for project context.
- If the project already has `.cursorrules`, keep it — some environments read it as fallback.

## Related Skills

- `write-spec`
- `write-product-spec`
- `write-tech-spec`
- `spec-driven-implementation`
- `implement-specs`
- `update-skill`
- `warp-watch`
- `unity-implement` (Unity projects only)
