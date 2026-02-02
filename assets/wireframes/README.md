Wireframes folder
=================

This folder contains low-fidelity SVG wireframes used for design and prototyping.

Converting SVG to PNG (recommended)
-----------------------------------

We provide a PowerShell helper script at the project root to convert the SVGs to PNGs using Inkscape.

Requirements
- Inkscape (https://inkscape.org) installed and available on your PATH.

From project root (PowerShell):

```powershell
# Convert all SVG wireframes to PNGs (saved to assets/wireframes/png)
.
\convert_wireframes.ps1
```

Notes
- The script will create `assets/wireframes/png` if it doesn't exist.
- PNGs will be named after their SVG counterparts (e.g., `dashboard_wireframe.png`).
- If you prefer another tool (rsvg-convert, ImageMagick, or headless Chrome), adapt the script accordingly.

Python alternative (cross-platform)
----------------------------------

If you don't have Inkscape, you can use the included Python script which uses CairoSVG.

From project root:

```powershell
# Create and activate a venv (Windows)
python -m venv .venv
.\.venv\Scripts\activate
pip install cairosvg
python tools/convert_wireframes.py
```

Or on macOS/Linux:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install cairosvg
python3 tools/convert_wireframes.py
```
