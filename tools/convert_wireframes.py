"""convert_wireframes.py
Cross-platform SVG -> PNG converter using CairoSVG.
Usage:
  python -m venv .venv
  .\.venv\Scripts\activate
  pip install cairosvg
  python tools/convert_wireframes.py

Outputs PNGs to assets/wireframes/png/
"""
import os
import sys
from pathlib import Path

try:
    import cairosvg
except Exception as e:
    print("CairoSVG not installed. Install with: pip install cairosvg")
    sys.exit(1)

ROOT = Path(__file__).resolve().parents[1]
SVG_DIR = ROOT / 'assets' / 'wireframes'
PNG_DIR = SVG_DIR / 'png'

SVG_DIR.mkdir(parents=True, exist_ok=True)
PNG_DIR.mkdir(parents=True, exist_ok=True)

svg_files = list(SVG_DIR.glob('*.svg'))
if not svg_files:
    print(f'No SVG files found in {SVG_DIR}')
    sys.exit(0)

for svg in svg_files:
    out = PNG_DIR / (svg.stem + '.png')
    print(f'Converting {svg.name} -> {out.name} ...')
    try:
        cairosvg.svg2png(url=str(svg), write_to=str(out))
    except Exception as ex:
        print(f'Failed to convert {svg.name}: {ex}')

print('Conversion complete. PNGs in:', PNG_DIR)
