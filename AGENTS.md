# Global Agent Rules (Minimal Core)

Source of truth: https://github.com/vyzygota/agent-rules
Last synced with Warp: 2026-06-08

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

## 5. Audit Pipeline — Skill Order

**Order is not optional. Running skills out of sequence silently degrades audit quality.**

```
1. graphify        ← INFRASTRUCTURE: installs PreToolUse hook; all later Grep/Glob
                     queries auto-consult the graph. Run once per session, not per task.
2. self-audit      ← checks structural integrity before analysis runs on broken state
3. agent-workflow  ← (session start) establishes context: who owns what, current blockers
4. warp-watch      ← (if >14 days) rules must be current before auditing with them
─────────────────────────────────────────────────────────────────────────────────────
5. code-review     ← correctness first
6. security-review ← after code-review; security audit on already-correct code
7. check-impl-against-spec     ← lightweight read-only gate (use before validate)
8. validate-changes-match-specs ← interactive resolution; only when step 7 found drift
9. council         ← synthesis; only useful after findings from steps 5–8 exist
─────────────────────────────────────────────────────────────────────────────────────
10. agent-workflow ← (session end) log session before git push
```

Skills referenced above:
- [graphify](.agents/skills/graphify/SKILL.md)
- [self-audit](.agents/skills/self-audit/SKILL.md)
- [agent-workflow](.agents/skills/agent-workflow/SKILL.md)
- [warp-watch](.agents/skills/warp-watch/SKILL.md)
- [check-impl-against-spec](.agents/skills/check-impl-against-spec/SKILL.md)
- [validate-changes-match-specs](.agents/skills/validate-changes-match-specs/SKILL.md)
- [council](.agents/skills/council/SKILL.md)

**Critical violations to avoid:**
- `code-review` before `graphify` → misses cross-file dependencies
- `council` before analysis → opinions without evidence
- `validate-changes-match-specs` before `check-impl-against-spec` → heavy process without knowing if mismatches exist
