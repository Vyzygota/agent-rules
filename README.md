# agent-rules — WARPEngine

Global agent development principles for all projects by Piotr Maziarz (vyzygota).

Inspired by Warp's agentic development model ([warpdotdev/warp](https://github.com/warpdotdev/warp), [warpdotdev/common-skills](https://github.com/warpdotdev/common-skills)).

---

## What is WARPEngine

WARPEngine is an agent-first development pipeline — not a game engine, but a structured workflow for working on software projects with AI agents. It bridges two agent environments simultaneously using a single set of skills:

| Environment | Skills | Rules / Workflows | Global context |
|---|---|---|---|
| Claude Code | `.agents/skills/<name>/SKILL.md` | — | `~/.claude/CLAUDE.md` |
| Antigravity IDE (Google) | `.agentskills/<name>/SKILL.md` (junction) | `.agents/rules/*.md` → `/name` slash cmds | `~/.gemini/GEMINI.md` |

`.agentskills/` is a junction/symlink to `.agents/skills/` — skills are authored once and discovered by both environments.

---

## Philosophy

**Spec-driven, agent-executed.**

1. Understand the problem
2. Write specs (`PRODUCT.md` + `TECH.md`) before writing code
3. Implement using reusable named skills
4. Review before merging (agent review first, then human)
5. Parallelize when subtasks are genuinely independent

Human role: decide what matters, define behavior, review tradeoffs.  
Agent role: execute mechanical work, keep specs current, flag ambiguity.

---

## Available Skills

| Skill | Description |
|---|---|
| [`init-project`](.agents/skills/init-project/SKILL.md) | Set up WARPEngine structure in a new or existing project |
| [`write-spec`](.agents/skills/write-spec/SKILL.md) | Write PRODUCT.md and/or TECH.md for a feature |
| [`write-product-spec`](.agents/skills/write-product-spec/SKILL.md) | Write a PRODUCT.md (user-facing behavior spec) |
| [`write-tech-spec`](.agents/skills/write-tech-spec/SKILL.md) | Write a TECH.md (implementation spec) |
| [`spec-driven-implementation`](.agents/skills/spec-driven-implementation/SKILL.md) | Implement a feature from approved specs |
| [`implement-specs`](.agents/skills/implement-specs/SKILL.md) | Language-agnostic spec implementation workflow |
| [`unity-implement`](.agents/skills/unity-implement/SKILL.md) | Implement Unity features using mcp-unity MCP tools |
| [`diagnose-ci-failures`](.agents/skills/diagnose-ci-failures/SKILL.md) | Investigate and fix failing CI checks |
| [`update-skill`](.agents/skills/update-skill/SKILL.md) | Create or update a SKILL.md file |
| [`warp-watch`](.agents/skills/warp-watch/SKILL.md) | Sync with upstream Warp patterns; detect drift |

---

## Per-Project Structure

After running `init-project`, a project contains:

```
AGENTS.md                    # project context, build commands, architecture rules
specs/
  <feature>/
    PRODUCT.md               # what the user sees; numbered Behavior invariants
    TECH.md                  # implementation plan; maps tests to invariants

.agents/
  skills/                    # project-specific skills (if any)
  rules/
    WORKSPACE.md             # Antigravity session context — @references AGENTS.md
    <name>.md                # Workflow companions for explicit /name invocation

.agentskills/                # junction/symlink → .agents/skills/ (Antigravity)
skills-lock.json             # pinned references to vyzygota/agent-rules skills

.claude/
  settings.json              # MCP server config (Claude Code)
```

---

## Setup on a New Machine

### Claude Code

```bash
git clone https://github.com/vyzygota/agent-rules ~/agent-rules

# Windows (PowerShell)
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.claude\CLAUDE.md" -Target "$env:USERPROFILE\agent-rules\CLAUDE.md"

# macOS / Linux
ln -sf ~/agent-rules/CLAUDE.md ~/.claude/CLAUDE.md
```

### Antigravity IDE (Google)

```bash
# Windows (PowerShell)
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.gemini\GEMINI.md" -Target "$env:USERPROFILE\agent-rules\AGENTS.md"

# macOS / Linux
ln -sf ~/agent-rules/AGENTS.md ~/.gemini/GEMINI.md
```

### New Project

Run `init-project` skill in Claude Code or Antigravity — or follow the steps in [.agents/skills/init-project/SKILL.md](.agents/skills/init-project/SKILL.md).

---

## Unity Projects

Unity projects use the additional `unity-implement` skill, which orchestrates [CoderGamester/mcp-unity](https://github.com/CoderGamester/mcp-unity) MCP tools in spec-driven order:

1. Scripts first (compile before scene setup)
2. Scene / hierarchy setup via `batch_execute`
3. Tests via `run_tests`, mapped to PRODUCT.md invariants by number

Requires: Unity Editor open + mcp-unity server running (**Tools > MCP Unity > Server Window** → green).

---

## Skill Format

Every skill is a directory with a `SKILL.md`:

```markdown
---
name: my-skill
description: What this skill does and when to use it. Start with an action verb.
---

# My Skill

## Overview
## Workflow
## Best Practices
## Related Skills
```

Same YAML frontmatter format across Claude Code and Antigravity.

---

## Antigravity Workflows

A skill can also be invoked as a `/name` slash command in Antigravity by adding a companion file in `.agents/rules/`:

```markdown
# skill-name

@../skills/skill-name/SKILL.md

Execute this workflow for the current task.
```

The `@` reference pulls the full SKILL.md content at runtime — one source of truth, two invocation modes.

---

## Sync with Upstream

Run the `warp-watch` skill monthly (or before starting a major feature) to check warpdotdev/warp and warpdotdev/common-skills for new patterns worth adopting.

Last synced: **2026-05-10**
