---
name: session-memory
description: "Use when: resuming an interrupted session (`pickup`), ending a coding session (`checkpoint`), or logging an important architectural decision (`remember`). If the project contains Assets/ or .unity files, apply the Unity Extension section."
---

# session-memory

## Purpose

Persist coding context across sessions via `.agents/memory/session.jsonl`. Prevents cold-start problem where each session re-derives decisions that were already made.

Inspired by cross-session memory patterns from BugHunter (multi-agent bug bounty toolkit).

---

## `pickup` — Session Start

1. Check if `.agents/memory/session.jsonl` exists in the project root.
2. If yes → read the last 20 entries, summarize to human: open tasks, recent decisions, blockers.
3. Resume from the last checkpoint state.
4. If missing → start fresh, no action needed.

---

## `remember` — Log a Decision

Append one entry to `.agents/memory/session.jsonl`:

```json
{ "ts": "<ISO-8601>", "type": "decision|finding|blocker|todo", "summary": "...", "files": [] }
```

Use after every significant architectural or implementation decision.

---

## `checkpoint` — Session End

1. Append a checkpoint entry:
```json
{ "ts": "<ISO-8601>", "type": "checkpoint", "summary": "...", "open_todos": [] }
```
2. `git add .agents/memory/session.jsonl`
3. Commit: `chore: session checkpoint [<branch>]`

---

## Unity Extension

*Apply when the project contains `Assets/` or `.unity` files.*

Additional entry types:

```json
{ "ts": "<ISO-8601>", "type": "scene_change", "scene": "...", "summary": "..." }
{ "ts": "<ISO-8601>", "type": "prefab_decision", "prefab": "...", "summary": "..." }
{ "ts": "<ISO-8601>", "type": "build_error", "error": "...", "resolution": "..." }
```

On `pickup` — also check `Logs/Editor.log` for the most recent build errors before summarizing context.

---

## .gitignore note

`.agents/memory/` should be committed by default for solo projects (shares context across machines and sessions). Add it to `.gitignore` only if the memory log is personal or contains sensitive path data.

---

## Related Skills

- `agent-workflow` — multi-agent coordination (COMMUNICATION.md); separate concern from session memory
- `init-project` — add `.agents/memory/` to the project structure during bootstrap
- `graphify` — complement: session.jsonl tracks decisions, graphify tracks code structure
