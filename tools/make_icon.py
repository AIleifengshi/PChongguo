# -*- coding: utf-8 -*-
"""生成 PChongguo 原创图标（不复用任何第三方 logo）。"""
from PIL import Image, ImageDraw
import os

OUT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "pc", "PChongguo.ico")
BASE = 512
img = Image.new("RGBA", (BASE, BASE), (0, 0, 0, 0))
d = ImageDraw.Draw(img)

# 深色圆角底
d.rounded_rectangle([8, 8, BASE - 8, BASE - 8], radius=112, fill=(26, 20, 24, 255))
# 暖橙渐变圆环（用多层描边模拟）
for i, col in enumerate([(255, 122, 40, 255), (255, 96, 46, 255), (240, 72, 52, 255)]):
    pad = 44 + i * 6
    d.rounded_rectangle([pad, pad, BASE - pad, BASE - pad], radius=96 - i * 6,
                        outline=col, width=7)
# 播放三角
tri = [(214, 158), (214, 354), (376, 256)]
d.polygon(tri, fill=(255, 255, 255, 255))
# 小圆点（PC 端标识）
d.ellipse([228, 388, 252, 412], fill=(255, 150, 60, 255))
d.ellipse([260, 388, 284, 412], fill=(255, 150, 60, 150))
d.ellipse([292, 388, 316, 412], fill=(255, 150, 60, 80))

img.save(OUT, format="ICO", sizes=[(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)])
print("ICON:", OUT, os.path.getsize(OUT))
