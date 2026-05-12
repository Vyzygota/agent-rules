# agent-rules — WARPEngine

Global agent development principles and reusable skills for all projects by Piotr Maziarz (vyzygota).

Spec-driven, agent-executed. Skills live once in `.agents/skills/`, discovered simultaneously by Claude Code and Antigravity IDE via `.agentskills/` junction. Full philosophy and conventions: [AGENTS.md](AGENTS.md) · [CLAUDE.md](CLAUDE.md).

> Adapted from [warpdotdev/warp](https://github.com/warpdotdev/warp) and [warpdotdev/common-skills](https://github.com/warpdotdev/common-skills).

---

## Session Rituals

Run these at the start of every session — in this order:

```
1. /self-audit    → checks repo structure, fixes drift, flags warp-watch due date
2. /warp-watch    → (every 14 days) syncs upstream Warp patterns into skills
```

`self-audit` is the entry point. It tells you whether the graph is stale, whether the junction survived a fresh clone, and whether any skill file has gone missing.

---

## Available Skills

| Skill | Description |
|---|---|
| [`init-project`](.agents/skills/init-project/SKILL.md) | Bootstrap WARPEngine structure in a new or existing project |
| [`self-audit`](.agents/skills/self-audit/SKILL.md) | Audit and self-correct repo structure; step 0 of every session |
| [`write-spec`](.agents/skills/write-spec/SKILL.md) | Write PRODUCT.md and/or TECH.md for a feature |
| [`write-product-spec`](.agents/skills/write-product-spec/SKILL.md) | Write a PRODUCT.md — user-facing behavior spec |
| [`write-tech-spec`](.agents/skills/write-tech-spec/SKILL.md) | Write a TECH.md — implementation plan mapped to PRODUCT.md invariants |
| [`spec-driven-implementation`](.agents/skills/spec-driven-implementation/SKILL.md) | Implement a feature from approved specs |
| [`implement-specs`](.agents/skills/implement-specs/SKILL.md) | Language-agnostic spec implementation workflow |
| [`graphify`](.agents/skills/graphify/SKILL.md) | Build a knowledge graph; query relationships instead of searching raw files |
| [`diagnose-ci-failures`](.agents/skills/diagnose-ci-failures/SKILL.md) | Investigate and fix failing CI checks |
| [`update-skill`](.agents/skills/update-skill/SKILL.md) | Create or update a SKILL.md file |
| [`warp-watch`](.agents/skills/warp-watch/SKILL.md) | Sync with upstream Warp patterns every 2 weeks |
| [`unity-implement`](.agents/skills/unity-implement/SKILL.md) | Implement Unity features via mcp-unity MCP tools |
| [`unity-camera-sensor`](.agents/skills/unity-camera-sensor/SKILL.md) | Give the agent eyes — visual observation of the Unity scene |

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

Run `init-project` in Claude Code or Antigravity — see [init-project SKILL.md](.agents/skills/init-project/SKILL.md) for full steps including graphify setup.

---

## Knowledge Graph — `graphify`

> **Stop searching files. Start querying relationships.**

Without a graph the agent searches linearly: Glob → Grep → Read, burning tokens proportional to codebase size. With a graph it answers "what connects `AuthService` to the database?" in one query.

Graphify builds the graph from code, docs, PDFs, images, and video. AST extraction (Pass 1) is offline and free. Semantic extraction (Pass 3) uses your own Claude API key for docs and media.

After `graphify claude install`, a `PreToolUse` hook fires before every Glob and Grep call — Claude checks `GRAPH_REPORT.md` first automatically.

### Quick start

```bash
uv tool install graphifyy          # or: pipx install graphifyy
graphify claude install            # wire Claude Code hook + CLAUDE.md directive
graphify extract . --backend claude  # full semantic graph (needs ANTHROPIC_API_KEY)
graphify update .                  # fast AST-only rebuild (no API cost)
echo "graphify-out/" >> .gitignore
```

### Query the graph

| Goal | Command |
|---|---|
| Understand codebase before implementing | Read `graphify-out/GRAPH_REPORT.md` — god nodes + community map |
| Cross-file relationship question | `graphify query "what connects auth to the database?"` |
| Trace connection between two nodes | `graphify path "UserService" "DatabasePool"` |
| Explain an unfamiliar component | `graphify explain "RateLimiter"` |
| Architecture docs | `graphify export callflow-html` |
| Keep graph current on every commit | `graphify hook install` |

### Auto-install hook

Add to `.claude/settings.json` — auto-runs `graphify claude install` whenever `skills-lock.json` is written with a `graphify` entry:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "node -e \"const chunks=[]; process.stdin.on('data',d=>chunks.push(d)); process.stdin.on('end',()=>{ try{ const d=JSON.parse(Buffer.concat(chunks)); const fp=(d.tool_input||{}).file_path||''; if(fp.endsWith('skills-lock.json')){ const fs=require('fs'); const c=fs.readFileSync(fp,'utf8'); if(c.includes('graphify')){ require('child_process').execSync('graphify claude install',{stdio:'inherit'}); } } }catch(e){} });\""
          }
        ]
      }
    ]
  }
}
```

See [`graphify`](.agents/skills/graphify/SKILL.md) for full CLI reference, three-pass architecture, and monorepo patterns.

---

## Unity Projects

Unity projects use [`unity-implement`](.agents/skills/unity-implement/SKILL.md), which orchestrates [CoderGamester/mcp-unity](https://github.com/CoderGamester/mcp-unity) MCP tools in spec-driven order:

1. Scripts first — compile before scene setup
2. Scene / hierarchy setup via `batch_execute`
3. Tests via `run_tests`, mapped to PRODUCT.md invariants by number

Requires: Unity Editor open + mcp-unity server running (**Tools > MCP Unity > Server Window** → green).

### The Agent Has Eyes — `unity-camera-sensor`

> **Stop describing. Start showing.**

Logs catch code bugs. But misaligned prefabs, broken materials, and UI elements half off-screen are invisible to every text-based tool. [`unity-camera-sensor`](.agents/skills/unity-camera-sensor/SKILL.md) gives the agent a direct camera feed into the Unity scene — visual errors caught in the same pass as logic errors, no screenshots or human description needed.

---

## Sync with Upstream

Run [`warp-watch`](.agents/skills/warp-watch/SKILL.md) every 2 weeks to check warpdotdev/warp and warpdotdev/common-skills for new patterns. `self-audit` flags when it's due.

Last synced: **2026-05-10**
