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

.PARAMETER Mock
    Baut das Datenaddon aus den Testdaten in intern/mock - direkt in den
    WoW-Ordner, nicht ins Repository.

    Der Ordner ist nicht Teil des Repositorys - er steht in .gitignore und
    liegt nur lokal. Testdaten gehoeren nicht in ein oeffentliches Addon-Repo.

    Ohne das spiegelt der Sync den Repo-Stand, und der ist absichtlich leer:
    ausgeliefert werden nur echte Routen. Wer im Spiel etwas sehen will,
    braucht diesen Schalter.

.EXAMPLE
    .\tools\sync.ps1
    .\tools\sync.ps1 -Mock
    .\tools\sync.ps1 -Watch
#>

[CmdletBinding()]
param(
    [string]$WowPath = "C:\Spiele\World of Warcraft\_retail_",
    [switch]$Watch,
    [switch]$Mock
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$AddOns   = Join-Path $WowPath "Interface\AddOns"

if ($Mock) {
    $mdt = Join-Path $AddOns "MythicDungeonTools"
    if (-not (Test-Path $mdt)) {
        Write-Error "MDT nicht gefunden: $mdt"
        exit 1
    }

    # Die Testdaten liegen in intern\, nicht in data\ - sie sind beim
    # Oeffentlichmachen des Repositorys dorthin gewandert.
    # Nicht $mock nennen: PowerShell unterscheidet bei Variablen keine Gross-
    # und Kleinschreibung. Das ueberschriebe den Schalter $Mock, und weil der
    # als [switch] typisiert ist, scheitert schon die Zuweisung.
    $mockDir = Join-Path $RepoRoot "intern\mock"
    if (-not (Test-Path $mockDir)) {
        Write-Error "Testdaten nicht gefunden: $mockDir"
        exit 1
    }

    $cache = Join-Path $RepoRoot "data\cache"
    if (-not (Test-Path $cache)) { New-Item -ItemType Directory -Force $cache | Out-Null }
    Copy-Item (Join-Path $mockDir "ks-*.json") $cache -Force

    # Direkt in den WoW-Ordner, nicht ins Repository. Die erzeugten
    # Routendateien sehen genauso aus wie echte; lagen sie im Repo, landeten
    # sie irgendwann in einem Commit - und im Release waeren dann Testrouten.
    $dataTarget = Join-Path $AddOns "MDTRouteLibrary_Data"
    & node (Join-Path $RepoRoot "tools\build.mjs") `
        --mdt $mdt --season "Midnight Season 2" --force --out $dataTarget | Out-Null
    Remove-Item (Join-Path $RepoRoot "data\cache\ks-*.json") -Force -ErrorAction SilentlyContinue

    Write-Host "Testdaten gebaut - nur im Spiel, das Repository bleibt sauber." -ForegroundColor Yellow
}

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

    # Eine Zeichenkette ueber ein Zeilenende hinaus macht die ganze Datei
    # unlesbar, und im Spiel fehlt dann wortlos die Sektion. Lieber hier
    # abbrechen als das ins Spiel kopieren.
    $lua = Get-ChildItem -Path (Join-Path $RepoRoot "Core"), (Join-Path $RepoRoot "Locales") -Filter *.lua |
        ForEach-Object { $_.FullName }
    & node (Join-Path $RepoRoot "tools\check-lua-strings.mjs") @lua | Out-Null
    if ($LASTEXITCODE -ne 0) {
        & node (Join-Path $RepoRoot "tools\check-lua-strings.mjs") @lua
        throw "Kaputte Zeichenkette - nicht synchronisiert."
    }

    Sync-Addon -Source $RepoRoot `
               -Target (Join-Path $AddOns "MDTRouteLibrary") `
               -ExcludeDirs  @(".git", ".github", ".release", ".vscode", "docs", "tools", "data", "assets", "branding", "node_modules", "MDTRouteLibrary_Data") `
               -ExcludeFiles @("*.md", "*.ps1", "*.mjs", ".gitignore", ".gitattributes", ".pkgmeta", ".luacheckrc", ".editorconfig")

    # Mit -Mock stehen die Testdaten schon im Zielordner. Sie von hier aus
    # zu spiegeln wuerde sie sofort wieder durch den Repo-Stand ersetzen.
    if (-not $Mock) {
        $mdtPath = Join-Path $AddOns "MythicDungeonTools"

        if (Test-Path $mdtPath) {
            # Frisch bauen statt den eingecheckten Ordner zu spiegeln.
            #
            # Der im Repository liegende Datenordner stammt vom letzten
            # Release der CI und kennt weder neu eingereichte Routen noch die
            # Laeufe in data/raiderio. Ihn hierher zu kopieren hat mehrfach
            # ein frisch gebautes Paket im Spiel durch ein altes ersetzt -
            # sichtbar nur daran, dass die Routenzahl im Kopf ploetzlich
            # wieder klein war.
            # ErrorActionPreference steht oben auf "Stop". Damit macht
            # PowerShell aus jeder Zeile, die ein fremdes Programm nach stderr
            # schreibt, einen abbrechenden Fehler - und build.mjs meldet dort
            # ganz normale Hinweise ("Protokoll der Quelle unvollstaendig").
            # Also hier lockern und den Exitcode selbst pruefen.
            $previous = $ErrorActionPreference
            $ErrorActionPreference = "Continue"
            & node (Join-Path $RepoRoot "tools\build.mjs") `
                --mdt $mdtPath --season "Midnight Season 2" --force `
                --out (Join-Path $AddOns "MDTRouteLibrary_Data") 2>&1 | Out-Null
            $code = $LASTEXITCODE
            $ErrorActionPreference = $previous

            # 0 heisst "Inhalt geaendert", 9 "unveraendert" - beides in Ordnung.
            if ($code -ne 0 -and $code -ne 9) {
                throw "Datenaddon liess sich nicht bauen (Exitcode $code)."
            }
        }
        else {
            # Ohne MDT laesst sich nicht bauen - dann bleibt der Repo-Stand.
            $dataSource = Join-Path $RepoRoot "MDTRouteLibrary_Data"
            if (Test-Path $dataSource) {
                Sync-Addon -Source $dataSource `
                           -Target (Join-Path $AddOns "MDTRouteLibrary_Data") `
                           -ExcludeFiles @("*.md")
            }
        }
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
