$ink = Get-ChildItem 'C:\Program Files' -Recurse -Filter 'inkscape.exe' -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
if ($null -ne $ink) {
  Write-Host "Found inkscape: $ink"
  $svgDir = Join-Path (Get-Location) 'assets\wireframes'
  $pngDir = Join-Path $svgDir 'png'
  if (-not (Test-Path $pngDir)) { New-Item -ItemType Directory -Path $pngDir | Out-Null }
  Get-ChildItem -Path $svgDir -Filter *.svg -File | ForEach-Object {
    $in = $_.FullName
    $out = Join-Path $pngDir ($_.BaseName + '.png')
    Write-Host "Converting $in -> $out"
    & $ink --export-type=png --export-filename="$out" "$in"
  }
} else { Write-Error 'inkscape executable not found under C:\Program Files'; exit 1 }
