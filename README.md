# agent-rules — WARPEngine

Global agent development principles for all projects by Piotr Maziarz (vyzygota).

Inspired by Warp's agentic development model.

> **Origin:** The spec-driven workflow, SKILL.md format, and skills-lock.json convention are adapted from [warpdotdev/warp](https://github.com/warpdotdev/warp) and [warpdotdev/common-skills](https://github.com/warpdotdev/common-skills). WARPEngine extends these patterns to support multiple agent environments (Claude Code, Google Antigravity) and domain-specific tooling (Unity via mcp-unity).

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
| [`unity-camera-sensor`](.agents/skills/unity-camera-sensor/SKILL.md) | Give the agent eyes — visual observation of the Unity scene via CameraSensorComponent |
| [`diagnose-ci-failures`](.agents/skills/diagnose-ci-failures/SKILL.md) | Investigate and fix failing CI checks |
| [`update-skill`](.agents/skills/update-skill/SKILL.md) | Create or update a SKILL.md file |
| [`warp-watch`](.agents/skills/warp-watch/SKILL.md) | Sync with upstream Warp patterns; detect drift |
| [`self-audit`](.agents/skills/self-audit/SKILL.md) | Audit and self-correct repo structure; run at session start and as step 0 of warp-watch |
| [`graphify`](.agents/skills/graphify/SKILL.md) | Build a knowledge graph from the codebase; query it instead of searching raw files to cut token usage |

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

### The Agent Has Eyes — `unity-camera-sensor`

> **Stop describing. Start showing.**

Logs catch bugs that happen in code. But some bugs only exist in pixels — a misaligned prefab, a broken material, a camera framing that makes no sense, a UI element half off-screen. These errors are invisible to every tool that reads text. They require vision.

**`CameraSensorComponent` is the visual bridge between Unity and the agent.** It is not a training utility — it is a real-time observation channel. The agent sees what the camera sees, exactly as the player would.

This changes everything about how AI-assisted Unity development works:

| Without camera sensor | With camera sensor |
|---|---|
| Human takes a screenshot | Agent sees the scene directly |
| Human describes "the object is slightly off-center" | Agent detects the offset by observation |
| Graphical bugs survive code review | Visual errors caught in the same pass as logic errors |
| Human is the bottleneck for visual feedback | Agent closes the visual feedback loop autonomously |

Logs remain essential — they catch what the eye cannot (null refs, wrong values, timing errors). But logs alone leave an entire category of bugs invisible. **The camera sensor closes that gap.**

Set up once per project. Position a camera to frame what matters. From that point on, the agent does not need to be told what the scene looks like — it can look.

See [`unity-camera-sensor`](.agents/skills/unity-camera-sensor/SKILL.md) for full setup, API reference, and camera positioning strategies.

---

## Knowledge Graph — `graphify`

> **Stop searching files. Start querying relationships.**

Without a knowledge graph, the agent searches linearly: Glob → Grep → Read, consuming tokens proportional to codebase size. On a large project this is slow and expensive. With a graph, the agent answers "what connects `AuthService` to the database?" in a single query against a pre-built index.

**Graphify builds this graph from the entire project** — source code, docs, PDFs, images, and video — without sending code anywhere. Pass 1 (AST extraction via Tree-sitter) is offline and deterministic. Passes 2–3 use local whisper and your own Claude API key for media and docs.

After installation, a `PreToolUse` hook fires before every `Glob` and `Grep` call, telling Claude to check `GRAPH_REPORT.md` first. This changes the agent's default behavior from file search to graph query — no prompt engineering required.

### Setup

```bash
# 1. Install
uv tool install graphifyy    # or: pipx install graphifyy

# 2. Wire Claude Code hook + CLAUDE.md directive
graphify install --platform claude-code

# 3. Build the graph (run once per session; --update for incremental)
graphify .

# 4. Add to .gitignore
echo "graphify-out/" >> .gitignore
```

### Using the graph as an agent

| Goal | Command |
|---|---|
| Understand the codebase before implementing | Read `graphify-out/GRAPH_REPORT.md` — lists "god nodes" and community clusters |
| Cross-file relationship question | `graphify query "what connects auth to the database?"` |
| Trace connection between two components | `graphify path "UserService" "DatabasePool"` |
| Understand an unfamiliar class/function | `graphify explain "RateLimiter"` |
| Generate architecture docs | `graphify export callflow-html` |
| Keep graph current in CI / on commit | `graphify hook install` |

### What it produces

| File | Content |
|---|---|
| `graphify-out/GRAPH_REPORT.md` | God nodes, surprising connections, suggested queries — read this first |
| `graphify-out/graph.html` | Interactive visualization — click, filter, zoom/pan |
| `graphify-out/graph.json` | Full queryable graph for programmatic use |

### Automatic initialization via PostToolUse hook

Add this to `.claude/settings.json` to auto-run `graphify install` whenever `skills-lock.json` is written and contains `graphify`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "node -e \"const fs=require('fs');const f='skills-lock.json';if(fs.existsSync(f)&&JSON.stringify(JSON.parse(fs.readFileSync(f))).includes('graphify')){require('child_process').execSync('graphify install --platform claude-code',{stdio:'inherit'})}\""
          }
        ]
      }
    ]
  }
}
```

This hook fires after every `Write` tool call, checks whether `skills-lock.json` now contains `graphify`, and runs the install if so. First-time setup only — subsequent calls are idempotent (Graphify skips reinstall if the hook already exists).

See [`graphify`](.agents/skills/graphify/SKILL.md) for full CLI reference, three-pass architecture details, and monorepo patterns.

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

Run the `warp-watch` skill every 2 weeks (or before starting a major feature) to check warpdotdev/warp and warpdotdev/common-skills for new patterns worth adopting.

Last synced: **2026-05-10**
