# Global Agent Rules (Minimal Core)

Source of truth: https://github.com/vyzygota/agent-rules
Last synced with Warp: 2026-05-10

## 1. Philosophy: Spec-Driven Development
- **Human role:** Decide what matters, define behavior, review tradeoffs.
- **Agent role:** Execute mechanical work, keep specs current, flag ambiguity.
- **Rule:** Before writing code, understand the problem. Before writing complex code, write specs.

## 2. When to Write Specs
| Situation | Action |
|---|---|
| Single-file, obvious approach | No spec needed — just implement. |
| Multi-file, architectural decisions | Write `TECH.md` (~80–150 lines). |
| New user-facing feature | Write `PRODUCT.md` + `TECH.md`. |
| Large cross-cutting change | Full spec (PRODUCT + TECH). |

*Note: Specs live in `specs/<ticket-or-feature-name>/`. Keep them updated in the same PR as the code.*

## 3. Workflow & Constraints
- **Branching:** Use feature branches. **NEVER push directly to main.**
- **Code & Specs:** Keep specs and code aligned in the same PR as implementation evolves.
- **Progressive Disclosure (CRITICAL):** Do NOT guess structures or formats. Use the predefined skills to guide you.
  - To initialize a project: use `init-project` skill.
  - To write a spec: use `write-spec`, `write-product-spec` or `write-tech-spec` skills.
  - To implement specs: use `implement-specs` skill.
- **Advanced Tools:** If a project uses specialized tech (Unity, Graphify), do NOT assume their usage globally. Wait for instructions or trigger their specific skills (`unity-implement`, `graphify`).

## 4. Skills Usage
Skills are located in `.agents/skills/` (or `.agentskills/`). They contain step-by-step instructions for specific tasks. **Always read the `SKILL.md` before executing a complex workflow.**
