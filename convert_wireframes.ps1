# convert_wireframes.ps1
# Usage: Run this PowerShell script from the project root to convert SVG wireframes to PNGs.
# Requires: Inkscape installed and available on PATH (https://inkscape.org)

$svgDir = "assets/wireframes"
$pngDir = "assets/wireframes/png"

if (-not (Test-Path $svgDir)) {
  Write-Error "SVG directory not found: $svgDir"
  exit 1
}
if (-not (Test-Path $pngDir)) {
  New-Item -ItemType Directory -Path $pngDir | Out-Null
}

$svgFiles = Get-ChildItem -Path $svgDir -Filter *.svg -File
if ($svgFiles.Count -eq 0) {
  Write-Host "No SVG files found in $svgDir"
  exit 0
}

# Try to find inkscape
$inkscape = "inkscape"
try {
  $ver = & $inkscape --version 2>$null
} catch {
  Write-Error "Inkscape not found on PATH. Please install Inkscape and ensure 'inkscape' is available in PATH.";
  exit 1
}

foreach ($f in $svgFiles) {
  $in = $f.FullName
  $out = Join-Path $pngDir ($f.BaseName + ".png")
  Write-Host "Converting $($f.Name) -> $(Split-Path $out -Leaf) ..."
  # Modern Inkscape CLI (1.0+)
  & $inkscape $in --export-type=png --export-filename=$out
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "Conversion failed for $($f.Name)"
  }
}

Write-Host "Conversion finished. PNGs are in: $pngDir"
