---
name: self-audit
description: Audit and self-correct a WARPEngine project structure. Checks the init-project checklist against the current repo state, fixes any drift automatically, verifies the knowledge graph is current, and flags whether warp-watch is due. Run at the start of every session — warp-watch calls it as step 0. Works for any WARPEngine project, including agent-rules itself.
---

# self-audit

## Purpose

A WARPEngine project should always satisfy its own init-project checklist. Over time, structure drifts: junctions disappear after clones, WORKSPACE.md gets stale, graphify-out/ goes stale, warp-watch falls overdue.

`self-audit` detects and fixes this drift automatically. Run it at the start of every session before any feature work.

---

## Workflow

For each check: verify → fix if missing → record result → report at the end.

### 1. AGENTS.md / CLAUDE.md

```bash
# Check both exist at repo root
ls AGENTS.md CLAUDE.md 2>/dev/null || echo "MISSING"
```

If either is missing: recreate from the init-project template, filling in real values from git history and existing files.

### 2. specs/ directory

```bash
# Windows
powershell -Command "if(-not(Test-Path 'specs')){New-Item -ItemType Directory -Path 'specs' -Force; New-Item -ItemType File -Path 'specs/.gitkeep' -Force; Write-Host 'FIXED'} else {'OK'}"
```

### 3. .agents/rules/WORKSPACE.md

Check `.agents/rules/WORKSPACE.md` exists. If missing, create it using this template:

```markdown
# <ProjectName> Workspace

@../../AGENTS.md

## Agent Mode
Use Planning mode for feature implementation. Use Fast mode for quick fixes.

## First Action Each Session
Run `/self-audit` before any other work.

## Key Invariants
(fill from AGENTS.md)
```

### 4. .agentskills/ junction

```bash
# Windows — check junction exists and points correctly
powershell -Command "
  $j = '.agentskills'
  if(-not(Test-Path $j)){
    cmd /c mklink /J $j '.agents\skills' | Out-Null
    Write-Host 'FIXED: junction created'
  } elseif((Get-Item $j).LinkType -ne 'Junction'){
    Write-Host 'ERROR: .agentskills exists but is not a junction — investigate'
  } else {
    Write-Host 'OK'
  }
"
```

```bash
# Linux / macOS
[ -L .agentskills ] || ln -s .agents/skills .agentskills && echo "FIXED" || echo "OK"
```

### 5. skills-lock.json integrity

Read `skills-lock.json`. For each entry, verify the `skillPath` file exists locally:

```bash
powershell -Command "
  \$lock = Get-Content skills-lock.json | ConvertFrom-Json
  \$lock.skills.PSObject.Properties | ForEach-Object {
    \$path = \$_.Value.skillPath
    if(-not(Test-Path \$path)){ Write-Host \"MISSING: \$path\" }
    else { Write-Host \"OK: \$path\" }
  }
"
```

If any skill file is missing: flag for human review — do not auto-create (skill content requires intent).

### 6. .claude/settings.json (project-level)

Check `.claude/settings.json` exists. If missing, create with graphify PostToolUse hook:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "node -e \"const chunks=[]; process.stdin.on('data',d=>chunks.push(d)); process.stdin.on('end',()=>{ try{ const d=JSON.parse(Buffer.concat(chunks)); const fp=(d.tool_input||{}).file_path||''; if(fp.endsWith('skills-lock.json')){ const fs=require('fs'); const c=fs.readFileSync(fp,'utf8'); if(c.includes('graphify')){ require('child_process').execSync('graphify install --platform claude-code',{stdio:'inherit'}); } } }catch(e){} });}\""
          }
        ]
      }
    ]
  }
}
```

### 7. Knowledge graph currency

```bash
powershell -Command "
  \$report = 'graphify-out/GRAPH_REPORT.md'
  if(-not(Test-Path \$report)){
    Write-Host 'MISSING — run: graphify .'
  } else {
    \$age = (Get-Date) - (Get-Item \$report).LastWriteTime
    if(\$age.TotalDays -gt 7){
      Write-Host \"STALE (\$([int]\$age.TotalDays) days) — run: graphify . --update\"
    } else {
      Write-Host \"OK (\$([int]\$age.TotalDays) days old)\"
    }
  }
"
```

If missing or stale: run `graphify .` (full rebuild) or `graphify . --update` (incremental).

**Note:** graphify rebuild is optional in this step — flag it and let the agent decide based on session scope. For a quick fix session, skip; for deep feature work, rebuild.

### 8. warp-watch due date

Read `warp-watch.md` — find the most recent date in the `## Ostatnie sprawdzenia` table.

```bash
powershell -Command "
  \$lines = Get-Content warp-watch.md
  \$dates = \$lines | Where-Object { \$_ -match '\d{4}-\d{2}-\d{2}' } | ForEach-Object {
    [regex]::Match(\$_, '\d{4}-\d{2}-\d{2}').Value
  }
  \$last = (\$dates | Sort-Object -Descending | Select-Object -First 1)
  \$age = (Get-Date) - [datetime]\$last
  if(\$age.TotalDays -gt 14){
    Write-Host \"DUE: last sync \$last (\$([int]\$age.TotalDays) days ago) — run /warp-watch\"
  } else {
    Write-Host \"OK: last sync \$last\"
  }
"
```

---

## Report Format

After all checks, output a status table and a one-line action summary:

```
| Check                        | Status   | Action taken / needed       |
|------------------------------|----------|-----------------------------|
| AGENTS.md / CLAUDE.md        | ✅        | —                           |
| specs/                       | ✅ fixed  | Created directory           |
| .agents/rules/WORKSPACE.md   | ✅        | —                           |
| .agentskills/ junction        | ✅ fixed  | Junction recreated          |
| skills-lock.json integrity   | ✅        | —                           |
| .claude/settings.json        | ✅        | —                           |
| Knowledge graph              | ⚠️ stale  | Run: graphify . --update    |
| warp-watch                   | ⚠️ due    | Run: /warp-watch            |

Self-audit complete. 2 items need attention (see ⚠️ above).
```

If all checks pass: `Self-audit complete. No drift detected — ready to work.`

---

## When to Run

- **Always:** start of every session before feature work
- **Automatically:** called as step 0 of `warp-watch`
- **After clone:** first thing after cloning the repo on a new machine (junctions don't survive git clone)
- **After dependency changes:** after updating `skills-lock.json`

---

## Related Skills

- `init-project` — the canonical setup this skill audits against
- `warp-watch` — calls self-audit as step 0; handles upstream sync
- `graphify` — knowledge graph that self-audit checks for currency
- `update-skill` — use when self-audit flags a missing or outdated skill file
