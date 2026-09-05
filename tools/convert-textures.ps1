<#
.SYNOPSIS
    Wandelt PNG-Vorlagen aus assets/ in TGA-Texturen unter Media/Textures um.

.DESCRIPTION
    WoW laedt weder PNG noch JPEG. Zulaessig sind BLP (Blizzards eigenes
    Format) und TGA. TGA laesst sich ohne Zusatzwerkzeug erzeugen, deshalb
    dieser Weg.

    Zwei Regeln, die der Client erzwingt:
      * Kantenlaengen muessen Zweierpotenzen sein (32, 64, 128, 256 ...).
        Andernfalls wird die Textur gar nicht oder verzerrt geladen.
      * Unkomprimiertes 32-Bit-TGA mit Alphakanal ist das sichere Format.

    Das Bild wird unter Beibehaltung des Seitenverhaeltnisses in eine
    quadratische, transparente Flaeche eingepasst und zentriert.

    Das Logo entsteht in zwei Groessen. WoW filtert Texturen ohne Mipmaps:
    eine 128er-Grafik auf 24 Pixel herunterzurechnen erzeugt sichtbares
    Rauschen. Die Verkleinerung gehoert deshalb hierher, wo sie einmal und
    mit hochwertiger Interpolation passiert.

.EXAMPLE
    .\tools\convert-textures.ps1
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$RepoRoot  = Split-Path -Parent $PSScriptRoot
$AssetsDir = Join-Path $RepoRoot "assets"
$OutDir    = Join-Path $RepoRoot "Media\Textures"

if (-not (Test-Path $OutDir)) {
    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
}

# Quelle -> Zielname und Kantenlaenge (Zweierpotenz!)
$jobs = @(
    @{ Source = "logo.png"; Target = "logo-small"; Size = 32  }
    @{ Source = "logo.png"; Target = "logo";       Size = 128 }
)

function Write-Tga {
    param(
        [System.Drawing.Bitmap]$Bitmap,
        [string]$Path
    )

    $width  = $Bitmap.Width
    $height = $Bitmap.Height

    $rect = New-Object System.Drawing.Rectangle 0, 0, $width, $height
    $data = $Bitmap.LockBits($rect,
        [System.Drawing.Imaging.ImageLockMode]::ReadOnly,
        [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

    try {
        $byteCount = $data.Stride * $height
        $pixels = New-Object byte[] $byteCount
        [System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $pixels, 0, $byteCount)
    }
    finally {
        $Bitmap.UnlockBits($data)
    }

    $stream = [System.IO.File]::Create($Path)
    try {
        $writer = New-Object System.IO.BinaryWriter($stream)

        # --- TGA-Kopf, 18 Byte ---
        $writer.Write([byte]0)      # keine ID-Laenge
        $writer.Write([byte]0)      # keine Farbtabelle
        $writer.Write([byte]2)      # Bildtyp 2 = unkomprimiert, Echtfarbe
        $writer.Write([byte[]](0,0,0,0,0))   # Farbtabellen-Angaben
        $writer.Write([uint16]0)    # X-Ursprung
        $writer.Write([uint16]0)    # Y-Ursprung
        $writer.Write([uint16]$width)
        $writer.Write([uint16]$height)
        $writer.Write([byte]32)     # 32 Bit je Pixel
        $writer.Write([byte]0x28)   # 8 Alphabits + Ursprung oben links

        # --- Bilddaten ---
        # Format32bppArgb liegt im Speicher bereits als BGRA vor, genau wie
        # TGA es erwartet. Zeilenweise schreiben, weil die Stride groesser
        # als width*4 sein kann.
        $rowBytes = $width * 4
        for ($y = 0; $y -lt $height; $y++) {
            $writer.Write($pixels, $y * $data.Stride, $rowBytes)
        }

        $writer.Flush()
    }
    finally {
        $stream.Dispose()
    }
}

$converted = 0

foreach ($job in $jobs) {
    $sourcePath = Join-Path $AssetsDir $job.Source

    if (-not (Test-Path $sourcePath)) {
        Write-Host "uebersprungen: assets\$($job.Source) fehlt" -ForegroundColor Yellow
        continue
    }

    $source = [System.Drawing.Image]::FromFile($sourcePath)
    try {
        $size = [int]$job.Size

        $canvas = New-Object System.Drawing.Bitmap($size, $size,
            [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        $graphics = [System.Drawing.Graphics]::FromImage($canvas)
        try {
            $graphics.Clear([System.Drawing.Color]::Transparent)
            $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $graphics.PixelOffsetMode   = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
            $graphics.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

            # Seitenverhaeltnis beibehalten und mittig einpassen.
            $scale  = [Math]::Min($size / $source.Width, $size / $source.Height)
            $width  = [int][Math]::Round($source.Width  * $scale)
            $height = [int][Math]::Round($source.Height * $scale)
            $x = [int](($size - $width)  / 2)
            $y = [int](($size - $height) / 2)

            $graphics.DrawImage($source, $x, $y, $width, $height)
        }
        finally {
            $graphics.Dispose()
        }

        $target = Join-Path $OutDir "$($job.Target).tga"
        Write-Tga -Bitmap $canvas -Path $target
        $canvas.Dispose()

        Write-Host "$($job.Source) -> Media\Textures\$($job.Target).tga  ($size x $size)" -ForegroundColor Green
        $converted++
    }
    finally {
        $source.Dispose()
    }
}

if ($converted -eq 0) {
    Write-Host ""
    Write-Host "Nichts umgewandelt. Lege das Logo als assets\logo.png ab." -ForegroundColor Yellow
    Write-Host "Am besten quadratisch, mindestens 256 x 256, mit Transparenz." -ForegroundColor Yellow
}
