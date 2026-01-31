from __future__ import annotations

import os
from PIL import Image

SRC = os.path.join('assets', 'Route.png')


def make_square(img: Image.Image, out_path: str, size: int, max_logo_fraction: float) -> None:
    bg = (0x29, 0x38, 0x4D, 0xFF)  # #29384D
    canvas = Image.new('RGBA', (size, size), bg)

    max_w = int(size * max_logo_fraction)
    max_h = int(size * max_logo_fraction)
    logo = img.copy()
    logo.thumbnail((max_w, max_h), Image.Resampling.LANCZOS)

    x = (size - logo.size[0]) // 2
    y = (size - logo.size[1]) // 2
    canvas.alpha_composite(logo, (x, y))
    canvas.convert('RGB').save(out_path, format='PNG')


def main() -> None:
    if not os.path.exists(SRC):
        raise SystemExit(f"Missing {SRC}")

    img = Image.open(SRC).convert('RGBA')

    make_square(img, os.path.join('assets', 'splash_logo.png'), 1024, 0.62)
    make_square(img, os.path.join('assets', 'splash_logo_android12.png'), 1152, 0.46)

    print('Generated assets/splash_logo.png and assets/splash_logo_android12.png')


if __name__ == '__main__':
    main()
