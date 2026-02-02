"""optimize_pngs.py
Losslessly optimize PNGs using Pillow's save(..., optimize=True).
Usage:
  .venv\Scripts\python.exe tools\optimize_pngs.py
"""
from PIL import Image
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
PNG_DIR = ROOT / 'assets' / 'wireframes' / 'png'
if not PNG_DIR.exists():
    print('PNG directory not found:', PNG_DIR)
    sys.exit(1)

files = list(PNG_DIR.glob('*.png'))
if not files:
    print('No PNG files to optimize in', PNG_DIR)
    sys.exit(0)

for f in files:
    try:
        im = Image.open(f)
        # Convert to P mode if possible to reduce size but keep lossless
        if im.mode not in ("P", "L"):
            im = im.convert("RGBA")
        out_path = f
        orig_size = f.stat().st_size
        im.save(out_path, optimize=True)
        new_size = f.stat().st_size
        saved = orig_size - new_size
        print(f"Optimized {f.name}: {orig_size} -> {new_size} bytes (saved {saved} bytes)")
    except Exception as e:
        print('Failed to optimize', f.name, e)

print('Optimization complete.')
