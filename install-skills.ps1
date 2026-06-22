# install-skills.ps1
# Installs all skills listed in skills-lock.json that exist locally in .agents/skills/
# to ~/.claude/skills/ so they are available via Skill() in Claude Code.
#
# Run from the repo root: .\install-skills.ps1
# Optional: .\install-skills.ps1 -Verbose

param(
    [switch]$Verbose,
    [switch]$DryRun
)

$repoRoot = $PSScriptRoot
$lockFile  = Join-Path $repoRoot "skills-lock.json"
$claudeSkillsDir = Join-Path $env:USERPROFILE ".claude\skills"

if (-not (Test-Path $lockFile)) {
    Write-Error "skills-lock.json not found in $repoRoot"
    exit 1
}

$lock = Get-Content $lockFile -Raw | ConvertFrom-Json
$skills = $lock.skills

$installed = 0
$skipped   = 0
$errors    = 0

foreach ($name in $skills.PSObject.Properties.Name) {
    $entry    = $skills.$name
    $skillMd  = Join-Path $repoRoot $entry.skillPath

    if (-not (Test-Path $skillMd)) {
        if ($Verbose) { Write-Host "  SKIP (not local): $name" -ForegroundColor DarkGray }
        $skipped++
        continue
    }

    $destDir = Join-Path $claudeSkillsDir $name
    $destMd  = Join-Path $destDir "SKILL.md"

    if ($DryRun) {
        Write-Host "  [dry-run] would install: $name -> $destDir"
        continue
    }

    try {
        # Copy SKILL.md
        New-Item -ItemType Directory -Force -Path $destDir | Out-Null
        Copy-Item $skillMd $destMd -Force

        # Copy any subdirectories (references/, scripts/, assets/)
        $skillDir = Split-Path $skillMd -Parent
        $subDirs = Get-ChildItem $skillDir -Directory -ErrorAction SilentlyContinue
        foreach ($sub in $subDirs) {
            $destSub = Join-Path $destDir $sub.Name
            Copy-Item $sub.FullName $destSub -Recurse -Force
        }

        Write-Host "  installed: $name" -ForegroundColor Green
        $installed++
    } catch {
        Write-Host "  ERROR: $name — $_" -ForegroundColor Red
        $errors++
    }
}

Write-Host ""
Write-Host "Done. installed=$installed  skipped=$skipped  errors=$errors"
Write-Host "Restart Claude Code to pick up newly installed skills."
