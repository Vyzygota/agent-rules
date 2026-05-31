---
name: agent-workflow
description: Maintain the 3-layer agent communication system (WORKFLOW.md, AGENT_WORKFLOW.md, COMMUNICATION.md) in any project using .agents/. Use at session start (read context) and session end (update logs before git push). Trigger when user says "agent workflow", "zaktualizuj COMMUNICATION", "agent-workflow", or before any git push in a multi-agent project.
---

# Skill: agent-workflow

## Purpose

Maintain the 3-layer agent communication system in any project that uses `.agents/`.
Read this before starting a session, run the end-of-session checklist before `git push`.

---

## Layer Architecture

```
.agents/
  WORKFLOW.md          ← Human-facing: milestones, decisions, sprint goal, blockers
  AGENT_WORKFLOW.md    ← Agent-facing: session logs, tasks, technical context
  COMMUNICATION.md     ← Slim sync board: who owns what RIGHT NOW

~/.claude/projects/.../memory/
  *.md                 ← Keyword index pointing into COMMUNICATION + AGENT_WORKFLOW
```

---

## WORKFLOW.md — Human layer

**Who reads it:** Human architect. Scannable in 60 seconds.  
**What goes here:** Milestones, architectural decisions (+ rationale), sprint goal, active blockers.  
**What does NOT go here:** Session logs, file lists, cross-agent Q&A, implementation details.

Entry format:
```markdown
## YYYY-MM-DD — <Milestone title>
- Decision: ...
- Rationale: ...
- Blockers: ...
```

---

## AGENT_WORKFLOW.md — Agent layer

**Who reads it:** Agent at session start (for context) and session end (to append).  
**What goes here:** Session logs with timestamp, changed files, open tasks, cross-agent answers, references to WORKFLOW.md decisions.  
**Rule:** Always append — never overwrite. Newest entries at top.

Entry format:
```markdown
## YYYY-MM-DD HH:MM — <Agent name> — <task summary>
Tags: #keyword1 #keyword2 #keyword3
→ WORKFLOW.md#YYYY-MM-DD-milestone (if relevant)

**Done:**
- ...

**Open / next:**
- ...
```

---

## COMMUNICATION.md — Sync board

**Who reads it:** Every agent at session start. Max ~30 lines.  
**What goes here:** Current task owner per agent, status, date, link to detail in AGENT_WORKFLOW.md.  
**If it grows past 30 lines:** Move content to AGENT_WORKFLOW.md.

Table format:
```markdown
| Agent | Task | Status | Date | Detail |
|---|---|---|---|---|
| Antigravity | ForgeTagPicker grouped headers | active | 2026-05-30 | AGENT_WORKFLOW.md#2026-05-28-forge |
| Gemini | Build env / emulator | idle | — | — |
```

---

## Keywords ("hasła")

Both COMMUNICATION.md and AGENT_WORKFLOW.md entries must include `Tags:` with `#keyword` tokens.  
Memory files index these keywords so agents can locate context without parsing full files:

```markdown
## Keywords
#ForgeTagPicker, #MetaComparator → AGENT_WORKFLOW.md#2026-05-28-pathmodifiers
#OnboardingScreen → WORKFLOW.md#2026-05-25-forge-redesign
```

---

## Session Start Checklist

1. Read `COMMUNICATION.md` — understand who owns what
2. Read relevant section(s) in `AGENT_WORKFLOW.md` via keywords from memory
3. Read `WORKFLOW.md` for current sprint goal and blockers

## Session End Checklist (before `git push`)

1. **AGENT_WORKFLOW.md** — append entry with date/time, tags, done, open
2. **COMMUNICATION.md** — update your row (task, status, date, link to new entry)
3. **WORKFLOW.md** — update only if a milestone was reached or a decision was made
4. **Memory** — add/update keywords if new topics were introduced
5. `git add .agents/COMMUNICATION.md .agents/AGENT_WORKFLOW.md`
6. Include both in the commit before `git push`

---

## Templates

### New project setup

```bash
touch .agents/WORKFLOW.md .agents/AGENT_WORKFLOW.md
# COMMUNICATION.md should already exist
```

**WORKFLOW.md starter:**
```markdown
# Workflow — <Project Name>

## YYYY-MM-DD — Project start
- Goal: ...
- Stack: ...
- Blockers: none
```

**AGENT_WORKFLOW.md starter:**
```markdown
# Agent Workflow — <Project Name>

> Session log. Newest entries at top. Tags: #keyword for memory index.

---
```

**COMMUNICATION.md starter:**
```markdown
# .agents/COMMUNICATION.md

> Slim sync board. Max 30 lines. Detail → AGENT_WORKFLOW.md.

| Agent | Task | Status | Date | Detail |
|---|---|---|---|---|
| — | — | — | — | — |
```
