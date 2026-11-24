"""从 Han_Atlas_Layout_4096.psd 生成 Civ5 图标图集（Han_IconAtlas*.dds）。

流程要点（踩坑记录见同目录上级 SKILL.md）：
1. 8x8 网格、每格 512px；索引 i -> (i//8, i%8)
2. 合成时排除 00_guide* 参考线与「图层 2 拷贝」整图快照
3. 颜色只从 alpha>=250 的像素向外扩散（蒙版边缘的半透明像素含着垃圾色）
4. alpha 用面积平均(BOX)缩放，RGB（预乘后）用 LANCZOS
5. DDS 存 **预乘 alpha** 的未压缩 BGRA + 完整 mip 链（与 promoHan_*.dds 一致）

用法：
    python gen_icon_atlas.py                    # 生成全部尺寸
    python gen_icon_atlas.py --sizes 256,128    # 只生成部分尺寸
    python gen_icon_atlas.py --check            # 只校验现有文件
    python gen_icon_atlas.py --check --sizes 256
"""
from __future__ import annotations

import argparse
import os
import struct
from pathlib import Path

import numpy as np
from PIL import Image
from psd_tools import PSDImage

REPO_ROOT = Path(__file__).resolve().parents[4]
DEFAULT_PSD = REPO_ROOT / "assets" / "图标" / "Han_Atlas_Layout_4096.psd"
DEFAULT_OUT = REPO_ROOT / "大汉帝国 - 刘彻" / "Art" / "Icons"
DEFAULT_SIZES = "256,128,80,64,45,32"
GRID = 8

DDS_FLAGS = 0xA1007
DDS_PF_FLAGS = 0x41
DDS_PF_BITS = 32
DDS_MASK_R, DDS_MASK_G, DDS_MASK_B, DDS_MASK_A = 0xFF0000, 0x00FF00, 0x0000FF, 0xFF000000
DDS_CAPS = 0x401008


# ---------------------------------------------------------------- PSD 合成
def build_canvas(psd_path: Path) -> Image.Image:
    psd = PSDImage.open(str(psd_path))
    canvas = Image.new("RGBA", (psd.width, psd.height), (0, 0, 0, 0))
    for layer in reversed(list(psd)):
        if not layer.visible:
            continue
        name = layer.name.replace("\n", " ").strip()
        if "guide" in name.lower():
            continue
        if name.startswith("图层") and name.endswith("拷贝"):
            continue  # 整张图的重复快照
        img = layer.composite()
        if img is None:
            continue
        canvas.alpha_composite(img.convert("RGBA"), (layer.left, layer.top))
    return canvas


def _shift(a: np.ndarray, dy: int, dx: int) -> np.ndarray:
    """不环绕的整数平移，空位补 0（避免 np.roll 跨边界串色）。"""
    out = np.zeros_like(a)
    h, w = a.shape[:2]
    out[max(0, dy):min(h, h + dy), max(0, dx):min(w, w + dx)] = \
        a[max(0, -dy):min(h, h - dy), max(0, -dx):min(w, w - dx)]
    return out


def straight_rgb_from_solid(rgba: np.ndarray, iterations: int = 200):
    """只用 alpha>=250 的像素扩散出可信的直通 RGB 与 alpha。"""
    arr = rgba.astype(np.float32)
    alpha = arr[..., 3]
    solid = alpha >= 250
    rgb = arr[..., :3] * solid[..., None]
    known = solid.copy()
    if known.any():
        for _ in range(iterations):
            if known.all():
                break
            acc = np.zeros_like(rgb)
            cnt = np.zeros(known.shape, dtype=np.float32)
            kf = known.astype(np.float32)
            for dy in (-1, 0, 1):
                for dx in (-1, 0, 1):
                    if dy == 0 and dx == 0:
                        continue
                    acc += _shift(rgb * kf[..., None], dy, dx)
                    cnt += _shift(kf, dy, dx)
            new = (~known) & (cnt > 0)
            rgb[new] = acc[new] / cnt[new][..., None]
            known = known | new
        rgb[solid] = arr[..., :3][solid]
    return rgb, alpha


# ---------------------------------------------------------------- 缩放与编码
def resize_premult(premult_rgb: np.ndarray, alpha: np.ndarray, size: int):
    pr = Image.fromarray(np.clip(premult_rgb, 0, 255).astype(np.uint8)).resize((size, size), Image.LANCZOS)
    al = Image.fromarray(np.clip(alpha, 0, 255).astype(np.uint8)).resize((size, size), Image.BOX)
    pr_a = np.array(pr).astype(np.float32)
    a = np.array(al).astype(np.float32)
    pr_a = np.minimum(pr_a, a[..., None])  # 预乘不变量 rgb <= alpha
    return pr_a, a


def to_bgra(premult_rgb: np.ndarray, alpha: np.ndarray) -> np.ndarray:
    f = np.dstack([premult_rgb, alpha]).clip(0, 255).round().astype(np.uint8)
    out = np.empty(f.shape, dtype=np.uint8)
    out[..., 0] = f[..., 2]
    out[..., 1] = f[..., 1]
    out[..., 2] = f[..., 0]
    out[..., 3] = f[..., 3]
    return out


def write_dds_bgra(path: Path, premult_rgb: np.ndarray, alpha: np.ndarray) -> tuple[int, int]:
    levels = [(premult_rgb, alpha)]
    cur_p, cur_a = premult_rgb, alpha
    while min(cur_p.shape[0], cur_p.shape[1]) > 1:
        cur_p, cur_a = resize_premult(cur_p, cur_a, max(1, cur_p.shape[1] // 2))
        levels.append((cur_p, cur_a))

    width, height = premult_rgb.shape[1], premult_rgb.shape[0]
    header = bytearray(128)
    header[0:4] = b"DDS "
    struct.pack_into("<I", header, 4, 124)
    struct.pack_into("<I", header, 8, DDS_FLAGS)
    struct.pack_into("<I", header, 12, height)
    struct.pack_into("<I", header, 16, width)
    struct.pack_into("<I", header, 20, width * height * 4)
    struct.pack_into("<I", header, 24, 1)
    struct.pack_into("<I", header, 28, len(levels))
    struct.pack_into("<I", header, 76, 32)
    struct.pack_into("<I", header, 80, DDS_PF_FLAGS)
    struct.pack_into("<I", header, 88, DDS_PF_BITS)
    struct.pack_into("<I", header, 92, DDS_MASK_R)
    struct.pack_into("<I", header, 96, DDS_MASK_G)
    struct.pack_into("<I", header, 100, DDS_MASK_B)
    struct.pack_into("<I", header, 104, DDS_MASK_A)
    struct.pack_into("<I", header, 108, DDS_CAPS)
    with open(path, "wb") as fh:
        fh.write(bytes(header))
        for p, a in levels:
            fh.write(to_bgra(p, a).tobytes())
    return os.path.getsize(path), len(levels)


def generate(psd_path: Path, out_dir: Path, sizes: list[int]) -> None:
    canvas = build_canvas(psd_path)
    cell = canvas.width // GRID
    cells = []
    for i in range(GRID * GRID):
        r, c = divmod(i, GRID)
        tile = np.array(canvas.crop((c * cell, r * cell, (c + 1) * cell, (r + 1) * cell)))
        cells.append(straight_rgb_from_solid(tile))
    print(f"合成完成 {canvas.width}x{canvas.height}，格子 {cell}px")

    for size in sizes:
        atlas_rgb = np.zeros((size * GRID, size * GRID, 3), dtype=np.float32)
        atlas_a = np.zeros((size * GRID, size * GRID), dtype=np.float32)
        for i, (rgb, alpha) in enumerate(cells):
            premult = rgb * (alpha[..., None] / 255.0)
            p, a = resize_premult(premult, alpha, size)
            if a.any():
                r, c = divmod(i, GRID)
                atlas_rgb[r * size:(r + 1) * size, c * size:(c + 1) * size] = p
                atlas_a[r * size:(r + 1) * size, c * size:(c + 1) * size] = a
        path = out_dir / f"Han_IconAtlas{size:03d}.dds"
        n, mips = write_dds_bgra(path, atlas_rgb, atlas_a)
        print(f"{path.name:<26} {size * GRID}x{size * GRID} mips={mips} {n} bytes")


# ---------------------------------------------------------------- 校验
def check(out_dir: Path, sizes: list[int]) -> bool:
    ok = True
    for size in sizes:
        path = out_dir / f"Han_IconAtlas{size:03d}.dds"
        raw = path.read_bytes()
        w = struct.unpack("<I", raw[16:20])[0]
        h = struct.unpack("<I", raw[12:16])[0]
        mips = struct.unpack("<I", raw[28:32])[0]
        pf_flags = struct.unpack("<I", raw[80:84])[0]
        fourcc = raw[84:88]
        off, cw, ch = 128, w, h
        bad_premult = 0
        transparent_max = 0
        for _ in range(mips):
            n = cw * ch * 4
            lvl = np.frombuffer(raw[off:off + n], dtype=np.uint8).reshape(ch, cw, 4)
            rgb = lvl[..., :3].astype(int)
            a = lvl[..., 3].astype(int)
            bad_premult += int((rgb.max(axis=2) > a + 2).sum())
            m = a == 0
            if m.any():
                transparent_max = max(transparent_max, int(rgb[m].max()))
            off += n
            cw = max(1, cw // 2)
            ch = max(1, ch // 2)
        good = pf_flags == DDS_PF_FLAGS and fourcc == b"\x00\x00\x00\x00" and bad_premult == 0 and transparent_max == 0
        ok = ok and good
        print(f"{path.name:<26} {w}x{h} mips={mips:2d} pf=0x{pf_flags:X} "
              f"透明区RGB最大={transparent_max:3d} 预乘违例={bad_premult} {'OK' if good else 'FAIL'}")
    return ok


def main() -> None:
    ap = argparse.ArgumentParser(description="从 PSD 生成 Civ5 图标图集（预乘 alpha + 完整 mip）")
    ap.add_argument("--psd", type=Path, default=DEFAULT_PSD, help="排版 PSD 路径")
    ap.add_argument("--out", type=Path, default=DEFAULT_OUT, help="输出目录（Art/Icons）")
    ap.add_argument("--sizes", default=DEFAULT_SIZES, help="逗号分隔的图集档位，默认 256,128,80,64,45,32")
    ap.add_argument("--check", action="store_true", help="只校验现有 DDS，不重新生成")
    args = ap.parse_args()

    sizes = [int(s) for s in str(args.sizes).split(",") if s.strip()]
    if args.check:
        raise SystemExit(0 if check(args.out, sizes) else 1)
    generate(args.psd, args.out, sizes)
    check(args.out, sizes)


if __name__ == "__main__":
    main()
