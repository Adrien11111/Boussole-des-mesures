#!/usr/bin/env python3
"""Génère le logo de l'app (assets/icon/*.png) : boussole, aiguille orange → bleu sur fond encre.

Usage : python3 tool/make_icon.py   (nécessite Pillow)
"""
import math
from PIL import Image, ImageDraw

INK, PAPER = (0x14, 0x20, 0x2E), (0xED, 0xF0, 0xF4)
ORANGE, BLUE = (0xE0, 0x83, 0x4A), (0x4F, 0x86, 0xD9)
SS = 4          # sur-échantillonnage pour des bords lisses
SIZE = 1024


def compass(scale: float, background: bool) -> Image.Image:
    n = SIZE * SS
    img = Image.new("RGBA", (n, n), INK + (255,) if background else (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    c = n / 2
    r = 330 * SS * scale

    # anneau
    w = 52 * SS * scale
    d.ellipse([c - r, c - r, c + r, c + r], outline=PAPER, width=int(w))
    # graduations N / E / S / O
    for k in range(4):
        a = k * math.pi / 2
        for rr, ww in ((r - w - 14 * SS * scale, 18 * SS * scale), ):
            x0, y0 = c + math.sin(a) * rr, c - math.cos(a) * rr
            x1, y1 = c + math.sin(a) * (rr - 46 * SS * scale), c - math.cos(a) * (rr - 46 * SS * scale)
            d.line([x0, y0, x1, y1], fill=PAPER, width=int(ww))

    # aiguille vers le nord-est : pointe orange, queue bleue
    ang = math.radians(45)
    ux, uy = math.sin(ang), -math.cos(ang)          # direction de la pointe
    px, py = -uy, ux                                # perpendiculaire
    half, tip, tail = 62 * SS * scale, 236 * SS * scale, 236 * SS * scale
    tipP = (c + ux * tip, c + uy * tip)
    tailP = (c - ux * tail, c - uy * tail)
    left = (c + px * half, c + py * half)
    right = (c - px * half, c - py * half)
    d.polygon([tipP, left, right], fill=ORANGE)
    d.polygon([tailP, left, right], fill=BLUE)
    # pivot
    pr = 26 * SS * scale
    d.ellipse([c - pr, c - pr, c + pr, c + pr], fill=PAPER)
    return img.resize((SIZE, SIZE), Image.LANCZOS)


if __name__ == "__main__":
    compass(1.0, True).convert("RGB").save("assets/icon/icon.png")
    # Android adaptive : le dessin reste dans les 66 % centraux (zone sûre)
    compass(0.62, False).save("assets/icon/icon_foreground.png")
    # Linux : icône de fenêtre GTK (installée dans le bundle) + icône pour le fichier .desktop
    import os
    os.makedirs("linux/runner/resources", exist_ok=True)
    os.makedirs("linux/packaging", exist_ok=True)
    full = compass(1.0, True).convert("RGB").resize((512, 512), Image.LANCZOS)
    full.save("linux/runner/resources/app_icon.png")
    full.save("linux/packaging/fr.boussole.boussole.png")
    print("assets/icon/*.png + icônes Linux générés")
