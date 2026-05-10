# Global Agent Development Principles

Inspired by Warp's agentic development model (warpdotdev/warp, warpdotdev/common-skills).
Source of truth: https://github.com/vyzygota/agent-rules
Last synced with Warp: 2026-05-10

---

## Philosophy: Spec-Driven Agentic Development

Before writing code, write specs. Before writing specs, understand the problem.
Agent work is most effective when:
1. Anchored to precise specifications (PRODUCT.md + TECH.md)
2. Decomposed into reusable, named skills (.agents/skills/)
3. Reviewed before merging — agent review first, then human
4. Parallelized when subtasks are genuinely independent

Human role: decide what matters, define behavior, review tradeoffs.
Agent role: execute mechanical work, keep specs current, flag ambiguity.

---

## Project Initialization Checklist

When starting work on any project, verify these exist:

- [ ] `AGENTS.md` or `CLAUDE.md` at repo root — project context, build commands, architecture rules
- [ ] `specs/<id>/` — specs for any non-trivial feature in progress
- [ ] `.agents/skills/` — directory for project-specific reusable skills
- [ ] `skills-lock.json` — references to shared skills from vyzygota/agent-rules

If missing, offer to create them before starting feature work. Use the `init-project` skill.

---

## When to Write Specs

| Situation | Action |
|---|---|
| Single-file, obvious approach | No spec needed — just implement |
| Multi-file, architectural decisions | Write `TECH.md` (~80–150 lines) |
| New user-facing feature | Write `PRODUCT.md` + `TECH.md` |
| Large cross-cutting change | Full spec, longer is fine if every section earns its place |

Write specs to `specs/<ticket-or-feature-name>/` before implementation.
Keep specs updated as implementation evolves — in the same PR as code.

---

## PRODUCT.md Structure

1. **Overview** — what the user sees and why it matters
2. **Behavior** — numbered, concrete, testable invariants (these map to tests)
3. **Edge cases** — what happens at boundaries
4. **Out of scope** — explicitly excluded to prevent scope creep

No Validation section — that belongs in TECH.md.

---

## TECH.md Structure

Required sections:

1. **Context** — current system state, relevant files with line references
2. **Proposed changes** — which modules change, new types/APIs, data flow, ownership
3. **Testing and validation** — tests mapped to PRODUCT.md invariants by number
4. **Parallelization** — evaluate sub-agents; if yes: name, mode, worktree, branch, ownership

Optional (omit heading if empty):
- **End-to-end flow**, **Diagram** (Mermaid), **Risks and mitigations**, **Follow-ups**

---

## Skill Format

Create a skill when the same workflow will be executed more than once or by multiple agents.

File: `.agents/skills/<name>/SKILL.md` with YAML frontmatter:
