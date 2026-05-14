# agent-rules — WARPEngine

Global agent development principles and reusable skills for all projects by Piotr Maziarz (vyzygota).

Spec-driven, agent-executed. Skills live once in `.agents/skills/`, discovered simultaneously by Claude Code and Antigravity IDE via `.agentskills/` junction. 
Full philosophy and conventions: [AGENTS.md](AGENTS.md) · [CLAUDE.md](CLAUDE.md).

> Adapted from [warpdotdev/warp](https://github.com/warpdotdev/warp) and [warpdotdev/common-skills](https://github.com/warpdotdev/common-skills).
> Inspired by [obra/superpowers](https://github.com/obra/superpowers) (subagents, git worktrees, strict TDD).

---

## ⚡ Quickstart: Adoption & Workflow

For any new or existing project, run these from Claude Code or Antigravity IDE:

1. **Bootstrap:** `/init-project` (creates structures, junctions, and `skills-lock.json`).
2. **Spec:** `/write-spec` (generates `PRODUCT.md` and `TECH.md`). Single-file changes? Skip specs.
3. **Build:** `/implement-specs` (agent executes specs via strict TDD and git worktrees).
4. **Review:** `/review` (agent reviews code, then human merges).

## 🛠️ Available Skills

Trigger skills by typing `/skill-name` in your IDE.

| Skill | Purpose |
|---|---|
| [`init-project`](.agents/skills/init-project/SKILL.md) | Bootstrap WARPEngine structure |
| [`self-audit`](.agents/skills/self-audit/SKILL.md) | Repo health check (run at session start) |
| [`write-spec`](.agents/skills/write-spec/SKILL.md) | Generate behavior and implementation plans |
| [`implement-specs`](.agents/skills/implement-specs/SKILL.md) | Build features from specs (TDD, Worktrees) |
| [`graphify`](.agents/skills/graphify/SKILL.md) | Build/query codebase knowledge graph |
| [`diagnose-ci-failures`](.agents/skills/diagnose-ci-failures/SKILL.md) | Fix failing CI pipelines |
| [`warp-watch`](.agents/skills/warp-watch/SKILL.md) | Sync upstream patterns (run every 2 weeks) |
| [`unity-implement`](.agents/skills/unity-implement/SKILL.md) | Implement Unity features via MCP |
| [`playwriter`](.agents/skills/playwriter/SKILL.md) | Agentic browser automation and testing |

*(See `.agents/skills/` for the full list including `unity-camera-sensor`, `update-skill`, etc.)*

## 💻 Setup on a New Machine

Clone the repo, then link the global rule file to your IDE:

**Claude Code:**
```bash
git clone https://github.com/vyzygota/agent-rules ~/agent-rules
# macOS / Linux
ln -sf ~/agent-rules/CLAUDE.md ~/.claude/CLAUDE.md
# Windows (PowerShell)
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.claude\CLAUDE.md" -Target "$env:USERPROFILE\agent-rules\CLAUDE.md"
```

**Antigravity IDE:**
```bash
# macOS / Linux
ln -sf ~/agent-rules/AGENTS.md ~/.gemini/GEMINI.md
# Windows (PowerShell)
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.gemini\GEMINI.md" -Target "$env:USERPROFILE\agent-rules\AGENTS.md"
```

## 🧠 Advanced Features

- **Knowledge Graph (`graphify`):** Stop searching files. Query relationships. Auto-triggers on `PreToolUse`. Read [`graphify` SKILL.md](.agents/skills/graphify/SKILL.md) for CLI usage and setup.
- **Unity Orchestration:** Uses `mcp-unity` to manipulate scenes and scripts. Read [`unity-implement`](.agents/skills/unity-implement/SKILL.md) and [`unity-camera-sensor`](.agents/skills/unity-camera-sensor/SKILL.md).
