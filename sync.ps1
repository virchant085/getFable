# 将本库技能同步到全局 ~/.claude/skills/，使其在所有项目中对 Claude Code 生效
$ErrorActionPreference = 'Stop'
$src = Join-Path $PSScriptRoot '.claude\skills'
$dst = Join-Path $HOME '.claude\skills'

if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Force $dst | Out-Null }

Get-ChildItem $src -Directory | ForEach-Object {
    if (Test-Path (Join-Path $_.FullName 'SKILL.md')) {
        # /MIR 镜像：全局副本与库内保持完全一致（含删除）
        robocopy $_.FullName (Join-Path $dst $_.Name) /MIR /NJH /NJS /NDL /NC /NS /NP | Out-Null
        if ($LASTEXITCODE -ge 8) { throw "robocopy failed for $($_.Name) (code $LASTEXITCODE)" }
        Write-Host "synced: $($_.Name)"
    }
}
Write-Host "done -> $dst"
exit 0
