---
name: update-skill
description: Create or update skills by generating, editing, or refining SKILL.md files. Use when authoring a new skill, revising an existing one, or when prompted to add a skill worth generalizing from a project.
---

# update-skill

Create or update skills in `.agents/skills/`.

## Quick start

Every skill is a directory containing a `SKILL.md` with YAML frontmatter and markdown body:

```markdown
---
name: my-skill
description: What this skill does and when to use it. Start with an action verb.
---

# My Skill

## Overview
Brief context.

## Workflow
Steps...

## Best Practices
...

## Related Skills
- other-skill
```

## Requirements

### Frontmatter

Every SKILL.md must start with YAML frontmatter:

- **name**: kebab-case (lowercase letters, numbers, hyphens only)
- **description**: specific, non-empty. Start with an action verb. Include both *what* and *when*. Write in third person.

Good: `"Write a PRODUCT.md spec for a significant user-facing feature. Use when the user asks for a PRD or wants to define behavior before implementation."`

Bad: `"Helps with specs"` — too vague, no trigger.

### Structure

Standard sections:

1. **Title + brief summary** — clear title, concise overview
2. **Overview** — purpose and primary use cases (optional for simple skills)
3. **Workflow** — numbered steps or usage instructions
4. **Best Practices** — guidelines (optional)
5. **Related Skills** — links to other skills

Keep structure flexible — simple skills can omit optional sections.

### File organization

- **Simple skills** (≤200 lines): keep everything in `SKILL.md`
- **Complex skills** (>200 lines): split detailed content into `references/` subdirectory, link from `SKILL.md`

## After creating a skill

1. Add an entry to `skills-lock.json`
2. Reference the skill in `init-project/SKILL.md` if it should be part of every project setup
3. Update `AGENTS.md` / `CLAUDE.md` if the skill introduces a new convention
4. (Optional) Expose as Antigravity Workflow — see below

## Expose as Antigravity Workflow

A skill auto-discovered from context is a **Skill**. The same skill explicitly invoked via `/name` in Antigravity chat is a **Workflow**. Both can coexist without duplicating content.

To expose a skill as `/name` slash command in Antigravity:

**Create `.agents/rules/<name>.md`:**
```markdown
# <name>

@../skills/<name>/SKILL.md

Execute this workflow for the current task.
```

The `@` reference pulls the full SKILL.md content at runtime — one source of truth, two invocation modes.

**When to add a Workflow companion:**
- The skill is frequently invoked explicitly ("run the spec review now")
- The team wants a named slash command rather than relying on auto-discovery
- The skill represents a key phase in the development cycle (e.g. `/write-spec`, `/implement`, `/unity-implement`)

**When NOT to add a Workflow companion:**
- The skill is always auto-discovered correctly from context
- The skill is meta/tooling (e.g. `update-skill`, `warp-watch`) — these don't need slash commands

## When a project skill warrants globalizing

If a skill developed in a local project (e.g. DarkEdenDigital) is general enough to be useful across projects:

1. Copy it to `.agents/skills/<name>/` in `vyzygota/agent-rules`
2. Strip project-specific details (engine paths, project names, team conventions)
3. Make it language/stack agnostic where possible
4. Add to `skills-lock.json`
5. Reference from `init-project` if appropriate

Consider creating a dedicated repo (e.g. `unity-agent-rules`) when skills form a coherent domain-specific collection.

## Related Skills

- `init-project`
- `warp-watch`
- `write-product-spec`
