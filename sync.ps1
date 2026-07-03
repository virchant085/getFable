# Mirror this library's skills into the global ~/.claude/skills/ so they take
# effect for Claude Code in every project.
$ErrorActionPreference = 'Stop'
$src = Join-Path $PSScriptRoot '.claude\skills'
$dst = Join-Path $HOME '.claude\skills'

if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Force $dst | Out-Null }

Get-ChildItem $src -Directory | ForEach-Object {
    if (Test-Path (Join-Path $_.FullName 'SKILL.md')) {
        # /MIR mirror: keep the global copy identical to the library (including deletions)
        robocopy $_.FullName (Join-Path $dst $_.Name) /MIR /NJH /NJS /NDL /NC /NS /NP | Out-Null
        if ($LASTEXITCODE -ge 8) { throw "robocopy failed for $($_.Name) (code $LASTEXITCODE)" }
        Write-Host "synced: $($_.Name)"
    }
}
Write-Host "done -> $dst"
exit 0
