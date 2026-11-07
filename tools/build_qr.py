# -*- coding: utf-8 -*-
"""生成 PChongguo v3 静态资源：自有推广码二维码 + 看全集引导页图标。

推广链接来源：用户在 PVhongguo.png 中提供的番茄达人中心官方推广码。
"""
import cv2, numpy as np, os
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PC = os.path.join(ROOT, "pc")
os.makedirs(PC, exist_ok=True)

# 用户自己的官方推广码（番茄达人中心 / fanqieopen）
PROMO_URL = ("https://kol.fanqieopen.com/landing/ground-promotion"
             "?promotion_code_id=7692035465872293950"
             "&kol_uid=1800355726519292"
             "&invite_uid=2187383794308704")


def make_qr(url, out, scale=10, quiet=4, center_logo=True):
    p = cv2.QRCodeEncoder_Params()
    p.correction_level = cv2.QRCodeEncoder_CORRECT_LEVEL_H  # 30% 纠错，中心放 logo 仍可扫
    enc = cv2.QRCodeEncoder_create(p)
    m = enc.encode(url)
    big = cv2.resize(m, None, fx=scale, fy=scale, interpolation=cv2.INTER_NEAREST)
    pad = quiet * scale
    big = cv2.copyMakeBorder(big, pad, pad, pad, pad, cv2.BORDER_CONSTANT, value=255)
    # 统一成 0=黑 255=白
    if np.mean(big > 127) < 0.5:
        big = 255 - big
    bgr = cv2.cvtColor(big, cv2.COLOR_GRAY2BGR)
    if center_logo:
        h, w = bgr.shape[:2]
        r = int(w * 0.07)
        cv2.rectangle(bgr, (w // 2 - r - 7, h // 2 - r - 7),
                      (w // 2 + r + 7, h // 2 + r + 7), (255, 255, 255), -1)
        cv2.circle(bgr, (w // 2, h // 2), r, (28, 20, 18), -1)
        cv2.circle(bgr, (w // 2, h // 2), r, (60, 130, 255), 3)
        pts = np.array([[w // 2 - 8, h // 2 - 12],
                        [w // 2 - 8, h // 2 + 12],
                        [w // 2 + 13, h // 2]], np.int32)
        cv2.fillPoly(bgr, [pts], (255, 255, 255))
    # cv2.imwrite / imread 在中文路径下会静默失败，改用 PIL 写入、内存数组验证
    Image.fromarray(cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)).save(out)
    d, _, _ = cv2.QRCodeDetector().detectAndDecode(bgr)
    print("QR:", out, bgr.shape, "saved=", os.path.exists(out), "decode_ok=", d == url)
    return d == url


ok = make_qr(PROMO_URL, os.path.join(PC, "mycode.png"))
# 同时存一份链接文本，便于以后换码
with open(os.path.join(PC, "promo-url.txt"), "w", encoding="utf-8-sig") as f:
    f.write("把下面这一行换成你自己的官方推广链接，然后运行 tools/build_qr.py 重新生成二维码。\n\n")
    f.write(PROMO_URL + "\n")
print("PROMO_URL:", PROMO_URL)
