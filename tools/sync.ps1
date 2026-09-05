<#
.SYNOPSIS
    Kopiert MDTRouteLibrary aus dem Repo in den WoW-AddOns-Ordner.

.DESCRIPTION
    Spiegelt zwei Addons:
        Repo-Wurzel          -> AddOns\MDTRouteLibrary
        Repo\MDTRouteLibrary_Data  -> AddOns\MDTRouteLibrary_Data

    Entwicklungsdateien (docs, tools, data, .git, Markdown) bleiben draussen.

.PARAMETER WowPath
    Pfad zum _retail_-Ordner. Standard: C:\Spiele\World of Warcraft\_retail_

.PARAMETER Watch
    Beobachtet das Repo und synchronisiert bei jeder Aenderung automatisch.

.EXAMPLE
    .\tools\sync.ps1
    .\tools\sync.ps1 -Watch
#>

[CmdletBinding()]
param(
    [string]$WowPath = "C:\Spiele\World of Warcraft\_retail_",
    [switch]$Watch
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$AddOns   = Join-Path $WowPath "Interface\AddOns"

if (-not (Test-Path $AddOns)) {
    Write-Error "AddOns-Ordner nicht gefunden: $AddOns"
    exit 1
}

# Sicherheitsnetz: /MIR loescht im Ziel. Nur eigene MDTRouteLibrary-Ordner zulassen.
function Assert-SafeTarget {
    param([string]$Target)
    $leaf = Split-Path -Leaf $Target
    if ($leaf -notlike "MDTRouteLibrary*") {
        throw "Unerwarteter Zielordner: $Target"
    }
}

function Sync-Addon {
    param(
        [string]$Source,
        [string]$Target,
        [string[]]$ExcludeDirs  = @(),
        [string[]]$ExcludeFiles = @()
    )

    Assert-SafeTarget $Target

    $roboArgs = @($Source, $Target, "/MIR", "/NJH", "/NJS", "/NP", "/NDL", "/NFL", "/R:2", "/W:1")
    if ($ExcludeDirs.Count)  { $roboArgs += "/XD"; $roboArgs += $ExcludeDirs }
    if ($ExcludeFiles.Count) { $roboArgs += "/XF"; $roboArgs += $ExcludeFiles }

    robocopy @roboArgs | Out-Null

    # Robocopy: Exit-Codes 0-7 sind Erfolg, ab 8 liegt ein Fehler vor.
    if ($LASTEXITCODE -ge 8) {
        throw "robocopy fehlgeschlagen ($LASTEXITCODE): $Source -> $Target"
    }

    # Sonst erbt das Skript den Robocopy-Code (1 = "Dateien kopiert") als Fehler.
    $global:LASTEXITCODE = 0
}

function Invoke-Sync {
    $stamp = Get-Date -Format "HH:mm:ss"

    Sync-Addon -Source $RepoRoot `
               -Target (Join-Path $AddOns "MDTRouteLibrary") `
               -ExcludeDirs  @(".git", ".github", ".release", ".vscode", "docs", "tools", "data", "node_modules", "MDTRouteLibrary_Data") `
               -ExcludeFiles @("*.md", "*.ps1", "*.mjs", ".gitignore", ".gitattributes", ".pkgmeta", ".luacheckrc", ".editorconfig")

    $dataSource = Join-Path $RepoRoot "MDTRouteLibrary_Data"
    if (Test-Path $dataSource) {
        Sync-Addon -Source $dataSource `
                   -Target (Join-Path $AddOns "MDTRouteLibrary_Data") `
                   -ExcludeFiles @("*.md")
    }

    Write-Host "[$stamp] MDTRouteLibrary + MDTRouteLibrary_Data synchronisiert" -ForegroundColor Green
}

Invoke-Sync

if (-not $Watch) {
    Write-Host "Fertig. Im Spiel: /reload" -ForegroundColor Cyan
    return
}

Write-Host "Beobachte $RepoRoot - Beenden mit Strg+C" -ForegroundColor Cyan

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path                  = $RepoRoot
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents   = $true

$lastRun = [datetime]::MinValue

while ($true) {
    $change = $watcher.WaitForChanged([System.IO.WatcherChangeTypes]::All, 1000)
    if ($change.TimedOut) { continue }

    # Eigene Ausgabe- und Metaordner ignorieren
    if ($change.Name -match '^(\.git|\.release|docs|tools|data|node_modules)') { continue }

    # Editoren feuern mehrere Ereignisse pro Speichervorgang - entprellen.
    if (([datetime]::Now - $lastRun).TotalMilliseconds -lt 400) { continue }
    $lastRun = [datetime]::Now

    Start-Sleep -Milliseconds 150
    try   { Invoke-Sync }
    catch { Write-Host $_.Exception.Message -ForegroundColor Red }
}
