---
name: compress-memory
description: Compress and reorganize project MEMORY.md when it approaches the 200-line limit. Promotes cross-project patterns to ~/.claude/memory/domain/, removes stale or duplicate entries, and compacts verbose entries to the date/what/why format. Use when MEMORY.md > 150 lines or when /post-memory-check warns about line count.
---

# compress-memory

Reduce project `MEMORY.md` back under 150 lines without losing important knowledge.

## When to run

- `MEMORY.md` exceeds 150 lines (hook warns automatically)
- Session start finds the file bloated with session-specific noise
- Entries older than ~30 days that have not been referenced recently

## Workflow

### 1. Read current state

```bash
wc -l ~/.claude/projects/<key>/memory/MEMORY.md
cat ~/.claude/projects/<key>/memory/MEMORY.md
```

Also read `~/.claude/memory/domain/` to know what's already promoted.

### 2. Classify every entry into one of four buckets

| Bucket | Action |
|--------|--------|
| **Cross-project pattern** — same invariant appears (or would apply) in 2+ projects | Promote to `~/.claude/memory/domain/<project>.md`, remove from MEMORY.md |
| **Stale / resolved** — a one-off bug, a merged PR, a temporary workaround now gone | Delete |
| **Duplicate / implied** — already captured in `general.md` or another memory file | Delete |
| **Active project knowledge** — still relevant, not cross-project | Keep, compact to one line |

### 3. Compact kept entries

Rewrite multi-line entries to single-line format:

```
- YYYY-MM-DD: <what> — <why it matters>
```

Drop explanatory paragraphs. The entry should be a trigger for recall, not a full explanation.

### 4. Promote cross-project entries

Create or append to `~/.claude/memory/domain/<topic>.md`:

```markdown
# <Topic> Domain Knowledge

- YYYY-MM-DD [<source-project>]: <what> — <why>
```

Update `~/.claude/memory/memory.md` index if a new domain file was created.

### 5. Write updated MEMORY.md

Target: under 150 lines. Hard limit: 200 lines.

Keep the existing header and section structure. Do not reorder sections unless merging duplicates.

### 6. Verify

```bash
wc -l ~/.claude/projects/<key>/memory/MEMORY.md
```

Report: lines before → lines after, entries promoted, entries deleted.

## Rules

- Never delete an entry without understanding it first — when in doubt, compact instead of delete
- Never promote to `domain/` based on a single project alone — cross-project means 2+ projects or explicitly stated as a universal pattern
- Do not compress `general.md` — it is already lean by design
- If unsure whether an entry is stale, use AskUserQuestion before deleting
