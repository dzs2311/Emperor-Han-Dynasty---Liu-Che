# 大汉帝国（刘彻）模组 · 交接文档

> 写于 2026-11-24。给下一个接手 agent 的完整上下文与待办。
> 前置技能：`civ5-mpdll-sp`（SP/MPDLL 规范）、`civ5-icon`、`civ5-ui`、`civ5-locale`、`civ5-leader-map-dom`。

## 一、工程与环境

| 项 | 路径 |
|---|---|
| 模组仓库 | `D:\Civ5Projects\Civilizations\Han_Liuche` |
| 模组工程 | `...\大汉帝国 - 刘彻\大汉帝国 - 刘彻.civ5proj` |
| 素材仓库 | `E:\CIV5MOD\10_modprojects\han_assets` |
| SP 源码参考 | `D:\Civ5Projects\SP`（含 MPDLL） |
| 游戏 | `F:\SteamLibrary\steamapps\common\Sid Meier's Civilization V` |
| 用户目录 | `E:\Documents\My Games\Sid Meier's Civilization 5` |
| 打包工具 | `C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe` |
| DDS 工具 | `D:\CIV5modtools\CivNexus6_Release-1.3.3\CivNexus6_Release-1.3.3\CivNexus6\texconv.exe` |

### 部署命令（务必照抄）

```powershell
& 'C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe' `
  'D:\Civ5Projects\Civilizations\Han_Liuche\大汉帝国 - 刘彻\大汉帝国 - 刘彻.civ5proj' `
  /t:Deploy /p:Configuration=Default `
  "/p:Civ5Path=F:\SteamLibrary\steamapps\common\Sid Meier's Civilization V" `
  "/p:Civ5UserPath=E:\Documents\My Games\Sid Meier's Civilization 5" `
  "/p:SafeName=大汉帝国 - 刘彻"
```

- **SafeName 必须显式传中文**，否则包名变 `" (v 9)"`、目录变 `MODS\ (v 9)`
- **部署前先关游戏**：游戏占用 MODS 目录会导致 `RemoveEmptyDirectories` 失败，并把工程里的 DDS 删掉
- 当前版本号 **9.0**（`ModVersion=9`，Teaser 与更新记录已同步）

## 二、已完成（P0，提交 `43323e8`）

| 项 | 文件 | 改动 |
|---|---|---|
| 玄女转场判定 | `Lua/Han Script.lua:586` | `cityX/cityY` → `iPlotX/iPlotY` |
| 西极天马说明 | `XML/Units/Han_UnitPromotions.xml:38` | Help 指向 `HISTORY2_HELP` |
| 特性单位类型 | `SQL/Han_MainCode.sql:268-274` | 已 revert 回 V8.3 的 7 类（含 BOMBER，无 GUNPOWDER_INFANTRY），遗留问题见第三节 1 |
| 承影文本 | `XML/Text/Han_Text_zh_CN.xml:763` | 3 队 → 1 队 |
| 都护府文本 | 同上 `:379` | 改为“城邦首都 8 格内” |
| 特性文本 | 同上 `:238` | 补“开局拥有农业与青铜器” |
| 描述拼写 | `.civ5proj:11` | `[NEWLINW]` → `[NEWLINE]` |
| 图标图集 | `Art/Icons/Han_IconAtlas*.dds` | 8×8、DXT5、按 PSD 的 Alpha 1 通道重建 |

## 三、待修（优先级从高到低）

### 1. 特性单位类型清单缺 ARCHER（已核实，待定方案）

`SQL/Han_MainCode.sql:268-274` 当前为 7 类（与 V8.3 一致）：

```
MELEE · MOUNTED · ARMOR · HELICOPTER · SIEGE · BOMBER · RECON
```

- `UNITCOMBAT_BOMBER` 必须保留（SP 里 BOMBER = 地面炮兵/AOE 武器）
- `UNITCOMBAT_GUNPOWDER_INFANTRY` **不存在**，火器应为 `UNITCOMBAT_GUN`
- **缺 `UNITCOMBAT_ARCHER`**：佽飞射士继承 `UNIT_COMPOSITE_BOWMAN`，CombatClass = ARCHER，因此始终拿不到「维天有汉」晋升（减伤 + 境外加伤都吃不到）
- **但不能直接挂 ARCHER**：SP 的攻击机/轰炸机同样使用 ARCHER（见 `SP\SuperPower\...\Gameplay\XML\Units\Units_Air.xml` 顶部注释），直接加会让汉文明拥有的 SP 空军也吃到「陆军」晋升

两个方案：
- **A（推荐，影响面最小）**：在 `SQL/Han_Units.sql` 的 `Unit_FreePromotions` 里给 `UNIT_HAN_CROSSBOWMAN` 单独加 `PROMOTION_SP_HAN_TRAIT_LAND`
- **B**：在 `Lua/Han Script.lua` 的 `HanUnitCreated` 里按 `CombatClass == ARCHER` 且 `Domain == DOMAIN_LAND` 补发，可覆盖缴获/赠予场景

`UNITCOMBAT_GUN` 目前无对应汉单位，可等加入火器单位时再补（只影响本文明）。

### 2. 特性「减伤 5 / 境外 +5」——现状正确，不要改

> 本条原结论（改成 `OutsideFriendlyLandsInflictDamageChange`）**已被源码推翻**。

`XML/Units/Han_UnitPromotions.xml:13-14` 保持现状：

```xml
<!-- <AttackInflictDamageChange>5</AttackInflictDamageChange> -->
<ChangeDamageValue>-5</ChangeDamageValue>
```

依据：
- `ChangeDamageValue` 在 MPDLL 中是**该单位受到的最终伤害增减**（`CvUnitCombat.cpp` → `UnitDamageChangeIntervene`，攻击者/防御者两个方向都适用）；SP 的 `PROMOTION_HEAVY_ARMOR` 也是同写法，文本明确写「受到的最终伤害-5」
- 「境外 +5」已在 `Lua/Han Script.lua` 的 `HanBattleCustomDamage` 中实现（有晋升 + 所在地块非友方领土 → `additionalDamage + 5`）
- `OutsideFriendlyLandsInflictDamageChange` 是**造成伤害**列；若同时挂上会与 Lua 的 +5 重复叠加

剩余动作：仅需游戏内实测确认数值，不改代码。

### 3. 部署与元数据

- `.civ5proj` 版本号已统一为 `ModVersion=9` / Teaser `(9.0)`，与 `更新记录.txt` 顶部 9.0 条目一致
- `MODS` 目录下曾同时存在 `大汉帝国 - 刘彻 (v 8)` 与 `(v 9)` 两份，且 v9 为 revert 前的旧代码，**必须删除后重新部署**

### 4. 其它

- 英文文本 `Han_Text_en_US.xml` 是中文逐字复制，未做英化
- 斥候（图集槽 6）有图无单位定义

## 四、单位战斗类型（已核实）

| 汉单位 | 继承 | CombatClass |
|---|---|---|
| 细柳营 | `UNIT_PIKEMAN` | `MELEE` |
| 冠军骠骑 | `UNIT_HORSEMAN` | `MOUNTED` |
| 佽飞射士 | `UNIT_COMPOSITE_BOWMAN` | `ARCHER` |
| 期门禁军 | `UNIT_ELITE_RIDER`（SP） | `MOUNTED` |
| 乌孙弓骑兵 | `UNIT_MEDIEVAL_CHARIOT` | `MOUNTED` |
| 承影机甲 | `UNIT_MECH` | `ARMOR` |
| 玄女战机 | `UNIT_INTERCEPTER` | `FIGHTER` |

## 五、重大设计决策（已定稿，见素材区文档）

### 文明定位

> **以战养爵，以爵养战；以都护通西域，以丝路养军马。**

### 军功 / 武功 / 首功（`MERIT_SYSTEM.md`）

| 层 | 名字 | 来源 | 上限 | 给什么 |
|---|---|---|---|---|
| 单位 | 军功爵 | 该单位斩首数 | 普通 8 阶公乘 / 精英 12 阶列侯 | 攻/防/视野/治疗/移动 |
| 单位（精英专属） | 武功爵 | 金币购买 | 普通 7 级千夫 / 精英 11 级军卫 | 防/治疗/减维护 |
| 玩家 | 首功 | 全文明斩首累计 | 无 | 只做事件门槛、HUD、编年 |

- 精英（期门/冠军/佽飞/承影/玄女）**出生即 3 阶簪袅**
- 普通单位单轨：买到千夫后可折算入军功爵大夫，之后只能斩首
- 精英双轨可叠加；**不能有一个人同时两爵的史实依据，故普通单位互斥**
- 武功爵 8–11 级为荣誉级，只进编年

### 事件（`EVENTS_100_FULL.md`、`M_EVENTS_20.md`、`EVENTS_TITLES_v3.md`、`WAR_POETRY_POOL.md`）

- 目标 100 条，9 类：军功 20 / 宝物 10 / 都护府 15 / 丝路 10 / 上林苑 10 / 天灾 10 / 朝堂 15 / 科技文化 10 / 联动 10
- 标题一律用**唐前诗文原句**（诗经、楚辞、汉乐府、木兰诗、史记、汉书、后汉书）；**最短 3 字，减少四字**；不用两字名词；后世鲜明名句不用
- 标题可大量采用《汉书》赞文四字评语（长平桓桓、票骑冠军、饮马翰海、封狼居胥…）
- 正文两行诗，同源出处
- M 组 20 条已按**汉代历史节点**锚定（白登→马台→河南→朔方→冠军侯→大将军→骠骑→收河南地→漠北→上谷→屯田→李陵→大宛→李广利→连年征伐→巫蛊→破楼兰→李广→轮台→封狼居胥）
- 状态存储：**SaveUtils**（`E:\...\YueFei\...\Lua\SaveUtils.lua` 可复用），键 `EV_<ID>`、`EV_<ID>_C`

### 界面（未动工）

规划 4 件，全部走独立 Addin，**不改 SP 覆盖的 5 个文件**（TopPanel/UnitPanel/CityView/NotificationPanel/InfoTooltipInclude）：

1. 汉节 HUD 条（爵位 · 首功 · 盟友数）
2. 大汉编年面板（章节 + 模态 `incTurnTimerSemaphore`）
3. 事件弹窗 2.0（双选项 + 印玺）
4. 都护府地图标记（WorldAnchor，注意层级可能被 UnitFlagManager 盖住）

## 六、SP / MPDLL 关键结论（详见技能 `civ5-mpdll-sp`）

- **不能新增 UnitCombatType**（SP 注释：Civ5 无法为新的 UnitCombatInfos 计算动画）
- 类型复用：炮兵/BOMBER、攻击机/ARCHER、特种部队/GUN、民兵/RECON、防空/SIEGE、陆战突击/HELICOPTER
- 自定义列 635 条、自定义表 294 个；伤害列见 `MPDLL\(1) CIV5MPDLL\DB\PROMOTIONS\InflictDamageChange.sql`
- 汉模组自定义表统一 `HAN_` 前缀，`CREATE TABLE IF NOT EXISTS`
- 给单位批量套晋升用 `insert ... select ... from Units where Class = ...`

## 七、素材区文档索引（`E:\CIV5MOD\10_modprojects\han_assets`）

| 文件 | 内容 |
|---|---|
| `MERIT_SYSTEM.md` | 军功爵/武功爵/首功系统定稿 |
| `EVENTS_100_FULL.md` | 100 条事件全表（v4） |
| `EVENTS_TITLES_v3.md` | 标题修订表（唐前、≥3 字） |
| `M_EVENTS_20.md` | 军功爵 20 条（历史锚定 + Civ5 原生效果） |
| `WAR_POETRY_POOL.md` | 战争诗文库（诗经→南北朝） |
| `SP_UNIT_CONVENTIONS.md` | SP/MPDLL 写法备忘 |
| `DECISIONS.md` | 图标与打包决策 |
| `EVENTS_DESIGN_100.md` | 100 条旧版（参考） |

## 八、接手第一步建议

1. 按第三节 1 的方案 A 补 ARCHER（佽飞射士），打包部署验证「减伤 5 / 境外 +5」数值
2. 清理 `MODS` 下重复安装的旧版本目录，用第九节部署命令重新部署
3. 接 SaveUtils + 事件框架（数据表驱动 + 队列 + 双选项），把现有 4 条事件迁入
4. 按 M → T → D → S → G → K → C → N → L 顺序导入事件
5. 界面 4 件按 HUD → 标记 → 编年 → 弹窗 2.0 顺序做

## 九、协作约定

- 改工程前先给用户看方案或 diff，**不要直接动手**（用户明确要求）
- 文本改动后必须校验 XML 合法 与 **无 BOM**
- DDS 必须 DXT5/BC3，UI 图集按 `Han_IconAtlas*` 命名
- 每次部署后核对六档 DDS 哈希与游戏目录一致
