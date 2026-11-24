---
name: civ5-icon-atlas
description: 'Use when generating or fixing Civ5/Han mod icon atlases (Han_IconAtlas*.dds) from the PSD layout: slicing the 8x8 Han_Atlas_Layout_4096.psd, fixing white rim / fringing / rainbow stripe artifacts, matching promoHan DDS format, or reproducing the icon regeneration pipeline.'
---

# Civ5 图标图集生成（大汉 v8.x）

从 `assets/图标/Han_Atlas_Layout_4096.psd` 生成 `大汉帝国 - 刘彻/Art/Icons/Han_IconAtlas*.dds`。
本技能记录了 2026-11 调试中踩过的全部坑，**照做即可避免白边/毛边/彩色条纹**。

## 何时使用

- 用户说「把 PSD 生成图标 / 更新 icons / 图标有毛边 / 图标有白边 / 图标出现彩色条纹」
- 需要新增或重排 `Han_Atlas_Layout_4096.psd` 中的图标槽位
- 需要对照 `promoHan_*.dds` 的格式排查 DDS 问题

## 关键事实（必读）

### 1. PSD 排版 = 8×8 网格，格 512px，索引 i → (行 i//8, 列 i%8)

| idx | 内容 | 使用方 |
|---|---|---|
| 0 | 汉徽 | `CIVILIZATION_SP_HAN`（另需 `SP_HAN_ALPHA_ATLAS` 白色剪影） |
| 1 | 刘彻立绘 | `LEADER_SP_LIUCHE` |
| 2 | 西凉营 | `UNIT_XILIUYING` |
| 3 | 冠军骠骑 | `UNIT_HUOQUBING_RIDER` |
| 4 | 佽飞射士 | `UNIT_HAN_CROSSBOWMAN` |
| 5 | 期门禁军 | `UNIT_HAN_ELITE_RIDER` |
| 6 | 斥候 | 未被 SQL 引用 |
| 7 | 乌孙弓骑兵 | `UNIT_HAN_VASSAL_MOUNTEDXBOW` |
| 8 | 太学 | 建筑 |
| 9 | 都护府 | 建筑 |
| 10 | 上林苑 | 建筑 |
| 11 | 驿传 | `IMPROVEMENT_SP_HAN_POST` |
| 12 | 承影机甲 | `UNIT_HAN_ELITE_MECH` |
| 13 | 玄女 | `UNIT_HAN_XUANNV` |
| 14 | 汉塞 | `IMPROVEMENT_SP_HAN_FORT` |
| 15 | 空 | — |
| 16 | 私学 | 建筑 |
| 17 | 郡国学 | 建筑 |
| 18/19 | 两座 3D 建筑 | 主图集冗余位（建造图标在 `HanImprovementIcons*`） |

改排版时**必须**同步检查 SQL/XML 里的 `PortraitIndex`。

### 2. 合成时要排除的图层

- `00_guide`、`00_guide 拷贝`：参考线（alpha=1 覆盖整张）
- `图层 2 拷贝`：整张图的重复快照（与各独立图层逐像素相同）；不排除会让图标重影、内容溢出到相邻格子
- 隐藏层（`01_leader`、`18_post_old3d`、`19_fort_old3d`）`layer.composite()` 自动为空，无需特殊处理

### 3. Alpha 必须是**预乘**存储（最容易踩的坑）

Civ5 图标图集按预乘 alpha 处理（对照 `promoHan_256.dds`：透明区 RGB 全 0，半透明处 RGB 随 alpha 变暗）。因此：

- 写入的 RGB 必须是 `rgb × alpha / 255`，且保证 `RGB ≤ alpha`
- alpha=0 的像素 RGB **必须为 0**，否则会被原样画出（症状：图标四周出现彩色斜条纹）
- 边缘 RGB 若为 255 而 alpha 很小，也会被全强度画出（症状：白色毛边/颗粒）

### 4. 颜色来源只能用 alpha==255 的像素

PSD 图层蒙版（硬边）边缘的半透明像素里存在**垃圾颜色**（实测有纯青 `0,255,255`、纯白等）。若把它们向外扩散做 RGB 外溢，会形成放射状彩色条纹。正确做法：只从 `alpha >= 250` 的像素做邻域扩散填充，半透明像素的 RGB 一律重建。

### 5. 缩放滤镜

- **alpha**：用 `Image.BOX`（面积平均）。`LANCZOS` 对硬边会产生振铃，剖面出现 `5 → 0 → 127 → 255` 这类带空洞的跳变，游戏中表现为断续的毛边。
- **RGB（预乘后）**：`LANCZOS` 可用，结果需 clamp 到 `[0, alpha]`。

### 6. DDS 格式对齐 `promoHan_*.dds`（未压缩，不要 DXT5）

| 字段 | 值 |
|---|---|
| flags | `0xA1007` |
| 像素格式 | `pfFlags=0x41`（RGB\|ALPHAPIXELS）、`bits=32`、无 FourCC |
| 掩码 | R `0xFF0000`、G `0xFF00`、B `0xFF`、A `0xFF000000`（即 BGRA 字节序） |
| pitch/linear | `width * height * 4`（沿用 promoHan 的写法） |
| caps | `0x401008`（TEXTURE\|COMPLEX\|MIPMAP） |
| mip | 完整链，直到 1×1（2048 → 12 级） |
| 尺寸 | `IconSize × 8`：256→2048、128→1024、80→640、64→512、45→360、32→256 |

**不要用 DXT5**：块压缩的 alpha 只有 8 级插值，硬边会出锯齿；无 mip 时游戏缩放也会出锯齿。
体积参考：6 档合计约 31 MB（`promoHan_256.dds` 本身 10.7 MB）。

## 步骤

1. 运行 [生成脚本](./scripts/gen_icon_atlas.py)：

   ```powershell
   python .github/skills/civ5-icon-atlas/scripts/gen_icon_atlas.py
   ```

   可选参数：`--psd`、`--out`、`--sizes 256,128,64`、`--check`（只做校验不写文件）。

   依赖：`psd-tools`、`pillow`、`numpy`（`pip install psd-tools pillow numpy -i https://repo.huaweicloud.com/repository/pypi/zh/simple`）。

2. 校验（脚本 `--check` 或手工）：

   - 每个 mip 层：`alpha==0` 的像素 RGB 最大值必须为 **0**
   - `RGB > alpha + 2` 的像素数必须为 **0**
   - 透明区相邻像素差分应接近 0（无噪声条纹）

3. 视觉复核：把 level 0 按「忽略 alpha 的 RGB」渲染，应看到图标 + 纯黑背景；按预乘合成（黑底/浅灰底）应看到干净的圆边。

4. 如改动了槽位，同步更新 SQL/XML 的 `PortraitIndex`，再进游戏验证（需重新打包 Mod，游戏不会热重载 DDS）。

## 排查对照表

| 现象 | 原因 | 处理 |
|---|---|---|
| 圆圈外彩色斜条纹 | 透明区 RGB 非 0（被外溢/未预乘） | 预乘存储，透明区置 0 |
| 白色颗粒/白边 | 低 alpha 处 RGB=255（反除 alpha 的量化噪声） | 不做「预乘→缩放→反除」，直接用已重建的 RGB 缩放 |
| 边缘断续、局部透明空洞 | LANCZOS 缩放硬边振铃 | alpha 改用 BOX |
| 放射状彩色条纹 | 从蒙版边缘半透明像素扩散颜色 | 只从 alpha≥250 的像素扩散 |
| 边缘锯齿、缩放后闪烁 | DXT5 / 无 mip | 未压缩 BGRA + 完整 mip 链 |
| 图标重影、内容串格 | 未排除 `图层 2 拷贝` | 合成时跳过该层 |

## 相关文件

- PSD：`assets/图标/Han_Atlas_Layout_4096.psd`（另有 PS 导出的 `Han_Atlas_Layout_4096.dds`，仅作参照）
- 产物：`大汉帝国 - 刘彻/Art/Icons/Han_IconAtlas{256,128,080,064,045,032}.dds`
- 图集声明：`大汉帝国 - 刘彻/SQL/Han_IconAtlases.sql`
- 参考格式：`大汉帝国 - 刘彻/Art/Icons/promoHan_256.dds`
