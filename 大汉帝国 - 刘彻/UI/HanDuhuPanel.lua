--[[ ==========================================================================
  都护府：地图城市标记 + 单城管理面板
  - 标记：己方拥有口BUILDING_DUHU 的城市，在其格子上方显示「都护」按钮（世界坐标锚定）
  - 面板：该城覆盖的城邦（距离 ≤8）、同盟状态、人口/兵力与单城邦文化加成
  - 公式与 Han Script.lua 的 HanCityDoInstantYieldFromCityState 一致
========================================================================== ]]

include("InstanceManager")
include("FLuaVector.lua")
include("IconSupport")

print("[Han] DuhuPanel loading")

local g_DuhuID = GameInfoTypes["BUILDING_DUHU"]
local g_iMaxMajor = GameDefines.MAX_MAJOR_CIVS
local g_iMaxPlayers = GameDefines.MAX_PLAYERS
local g_bOpen = false
local g_iCityID = -1
local g_Marks = {}          -- { {anchor=control, x=gridX, y=gridY}, ... }

-- 徽记：45 档（格 45 / 内容 30 = 2/3），可见宽约 30
local g_MarkSize = 30
local g_MarkGap = 6

-- 城旗锚点比地面格点高 35 世界单位：
-- CityBannerManager.lua 里 WorldPositionOffset = { x = 0, y = 0, z = 35 }
local g_WorldOffset = { x = 0, y = 0, z = 35 }

-- 城市库 TXT_KEY → 郡国 TXT_KEY（数据来源 MERIT_MIL12.html 第六表；郡国名在 Text XML 里）
local g_JunByCity = {
	["TXT_KEY_CITY_NAME_SP_HAN_00"] = "TXT_KEY_HAN_JUN_00",  ["TXT_KEY_CITY_NAME_SP_HAN_01"] = "TXT_KEY_HAN_JUN_01",
	["TXT_KEY_CITY_NAME_SP_HAN_02"] = "TXT_KEY_HAN_JUN_02",  ["TXT_KEY_CITY_NAME_SP_HAN_03"] = "TXT_KEY_HAN_JUN_03",
	["TXT_KEY_CITY_NAME_SP_HAN_04"] = "TXT_KEY_HAN_JUN_04",  ["TXT_KEY_CITY_NAME_SP_HAN_05"] = "TXT_KEY_HAN_JUN_05",
	["TXT_KEY_CITY_NAME_SP_HAN_06"] = "TXT_KEY_HAN_JUN_06",  ["TXT_KEY_CITY_NAME_SP_HAN_07"] = "TXT_KEY_HAN_JUN_07",
	["TXT_KEY_CITY_NAME_SP_HAN_08"] = "TXT_KEY_HAN_JUN_08",  ["TXT_KEY_CITY_NAME_SP_HAN_09"] = "TXT_KEY_HAN_JUN_09",
	["TXT_KEY_CITY_NAME_SP_HAN_10"] = "TXT_KEY_HAN_JUN_10",  ["TXT_KEY_CITY_NAME_SP_HAN_11"] = "TXT_KEY_HAN_JUN_11",
	["TXT_KEY_CITY_NAME_SP_HAN_12"] = "TXT_KEY_HAN_JUN_12",  ["TXT_KEY_CITY_NAME_SP_HAN_13"] = "TXT_KEY_HAN_JUN_13",
	["TXT_KEY_CITY_NAME_SP_HAN_14"] = "TXT_KEY_HAN_JUN_14",  ["TXT_KEY_CITY_NAME_SP_HAN_15"] = "TXT_KEY_HAN_JUN_15",
	["TXT_KEY_CITY_NAME_SP_HAN_16"] = "TXT_KEY_HAN_JUN_16",  ["TXT_KEY_CITY_NAME_SP_HAN_17"] = "TXT_KEY_HAN_JUN_17",
	["TXT_KEY_CITY_NAME_SP_HAN_18"] = "TXT_KEY_HAN_JUN_18",  ["TXT_KEY_CITY_NAME_SP_HAN_19"] = "TXT_KEY_HAN_JUN_19",
	["TXT_KEY_CITY_NAME_SP_HAN_20"] = "TXT_KEY_HAN_JUN_20",  ["TXT_KEY_CITY_NAME_SP_HAN_21"] = "TXT_KEY_HAN_JUN_21",
	["TXT_KEY_CITY_NAME_SP_HAN_22"] = "TXT_KEY_HAN_JUN_22",  ["TXT_KEY_CITY_NAME_SP_HAN_23"] = "TXT_KEY_HAN_JUN_23",
	["TXT_KEY_CITY_NAME_SP_HAN_24"] = "TXT_KEY_HAN_JUN_24",  ["TXT_KEY_CITY_NAME_SP_HAN_25"] = "TXT_KEY_HAN_JUN_25",
	["TXT_KEY_CITY_NAME_SP_HAN_26"] = "TXT_KEY_HAN_JUN_26",  ["TXT_KEY_CITY_NAME_SP_HAN_27"] = "TXT_KEY_HAN_JUN_27",
	["TXT_KEY_CITY_NAME_SP_HAN_28"] = "TXT_KEY_HAN_JUN_28",  ["TXT_KEY_CITY_NAME_SP_HAN_29"] = "TXT_KEY_HAN_JUN_29",
	["TXT_KEY_CITY_NAME_SP_HAN_30"] = "TXT_KEY_HAN_JUN_30",  ["TXT_KEY_CITY_NAME_SP_HAN_31"] = "TXT_KEY_HAN_JUN_31",
	["TXT_KEY_CITY_NAME_SP_HAN_32"] = "TXT_KEY_HAN_JUN_32",  ["TXT_KEY_CITY_NAME_SP_HAN_33"] = "TXT_KEY_HAN_JUN_33",
	["TXT_KEY_CITY_NAME_SP_HAN_34"] = "TXT_KEY_HAN_JUN_34",  ["TXT_KEY_CITY_NAME_SP_HAN_35"] = "TXT_KEY_HAN_JUN_35",
	["TXT_KEY_CITY_NAME_SP_HAN_36"] = "TXT_KEY_HAN_JUN_36",  ["TXT_KEY_CITY_NAME_SP_HAN_37"] = "TXT_KEY_HAN_JUN_37",
	["TXT_KEY_CITY_NAME_SP_HAN_38"] = "TXT_KEY_HAN_JUN_38",  ["TXT_KEY_CITY_NAME_SP_HAN_39"] = "TXT_KEY_HAN_JUN_39",
	["TXT_KEY_CITY_NAME_SP_HAN_40"] = "TXT_KEY_HAN_JUN_40",  ["TXT_KEY_CITY_NAME_SP_HAN_41"] = "TXT_KEY_HAN_JUN_41",
	["TXT_KEY_CITY_NAME_SP_HAN_42"] = "TXT_KEY_HAN_JUN_42",  ["TXT_KEY_CITY_NAME_SP_HAN_43"] = "TXT_KEY_HAN_JUN_43",
	["TXT_KEY_CITY_NAME_SP_HAN_44"] = "TXT_KEY_HAN_JUN_44",  ["TXT_KEY_CITY_NAME_SP_HAN_45"] = "TXT_KEY_HAN_JUN_45",
	["TXT_KEY_CITY_NAME_SP_HAN_46"] = "TXT_KEY_HAN_JUN_46",  ["TXT_KEY_CITY_NAME_SP_HAN_47"] = "TXT_KEY_HAN_JUN_47",
	["TXT_KEY_CITY_NAME_SP_HAN_48"] = "TXT_KEY_HAN_JUN_45",  ["TXT_KEY_CITY_NAME_SP_HAN_49"] = "TXT_KEY_HAN_JUN_48",
	["TXT_KEY_CITY_NAME_SP_HAN_50"] = "TXT_KEY_HAN_JUN_49",  ["TXT_KEY_CITY_NAME_SP_HAN_51"] = "TXT_KEY_HAN_JUN_50",
	["TXT_KEY_CITY_NAME_SP_HAN_52"] = "TXT_KEY_HAN_JUN_51",  ["TXT_KEY_CITY_NAME_SP_HAN_53"] = "TXT_KEY_HAN_JUN_52",
	["TXT_KEY_CITY_NAME_SP_HAN_54"] = "TXT_KEY_HAN_JUN_53",  ["TXT_KEY_CITY_NAME_SP_HAN_55"] = "TXT_KEY_HAN_JUN_54",
	["TXT_KEY_CITY_NAME_SP_HAN_56"] = "TXT_KEY_HAN_JUN_55",  ["TXT_KEY_CITY_NAME_SP_HAN_57"] = "TXT_KEY_HAN_JUN_56",
	["TXT_KEY_CITY_NAME_SP_HAN_58"] = "TXT_KEY_HAN_JUN_57",  ["TXT_KEY_CITY_NAME_SP_HAN_59"] = "TXT_KEY_HAN_JUN_58",
	["TXT_KEY_CITY_NAME_SP_HAN_60"] = "TXT_KEY_HAN_JUN_59",  ["TXT_KEY_CITY_NAME_SP_HAN_61"] = "TXT_KEY_HAN_JUN_60",
	["TXT_KEY_CITY_NAME_SP_HAN_62"] = "TXT_KEY_HAN_JUN_61",  ["TXT_KEY_CITY_NAME_SP_HAN_63"] = "TXT_KEY_HAN_JUN_62",
	["TXT_KEY_CITY_NAME_SP_HAN_64"] = "TXT_KEY_HAN_JUN_63",  ["TXT_KEY_CITY_NAME_SP_HAN_65"] = "TXT_KEY_HAN_JUN_64",
	["TXT_KEY_CITY_NAME_SP_HAN_66"] = "TXT_KEY_HAN_JUN_65",  ["TXT_KEY_CITY_NAME_SP_HAN_67"] = "TXT_KEY_HAN_JUN_66",
	["TXT_KEY_CITY_NAME_SP_HAN_68"] = "TXT_KEY_HAN_JUN_67",  ["TXT_KEY_CITY_NAME_SP_HAN_69"] = "TXT_KEY_HAN_JUN_68",
	["TXT_KEY_CITY_NAME_SP_HAN_70"] = "TXT_KEY_HAN_JUN_69",  ["TXT_KEY_CITY_NAME_SP_HAN_71"] = "TXT_KEY_HAN_JUN_03",
	["TXT_KEY_CITY_NAME_SP_HAN_72"] = "TXT_KEY_HAN_JUN_69",  ["TXT_KEY_CITY_NAME_SP_HAN_73"] = "TXT_KEY_HAN_JUN_70",
	["TXT_KEY_CITY_NAME_SP_HAN_74"] = "TXT_KEY_HAN_JUN_71",  ["TXT_KEY_CITY_NAME_SP_HAN_75"] = "TXT_KEY_HAN_JUN_72",
	["TXT_KEY_CITY_NAME_SP_HAN_76"] = "TXT_KEY_HAN_JUN_73",  ["TXT_KEY_CITY_NAME_SP_HAN_77"] = "TXT_KEY_HAN_JUN_74",
	["TXT_KEY_CITY_NAME_SP_HAN_78"] = "TXT_KEY_HAN_JUN_75",  ["TXT_KEY_CITY_NAME_SP_HAN_79"] = "TXT_KEY_HAN_JUN_76",
	["TXT_KEY_CITY_NAME_SP_HAN_80"] = "TXT_KEY_HAN_JUN_77",  ["TXT_KEY_CITY_NAME_SP_HAN_81"] = "TXT_KEY_HAN_JUN_78",
	["TXT_KEY_CITY_NAME_SP_HAN_82"] = "TXT_KEY_HAN_JUN_79",
}
-- 有些版本 GetName() 直接返回显示名而不是 TXT_KEY：两种键都建索引
local tJunAdd = {}
for k, v in pairs(g_JunByCity) do
	local disp = Locale.ConvertTextKey(k)
	if disp and disp ~= k and tJunAdd[disp] == nil then tJunAdd[disp] = v end
end
for k, v in pairs(tJunAdd) do g_JunByCity[k] = v end



local g_MarkIM = InstanceManager:new("DuhuMark", "Anchor", Controls.DuhuMarkers)

-- ---------------- 旗宽：直接问 CityBannerManager ----------------
-- 自己量名字宽度不可靠（长名、宗教图标、名字重复都会让旗比“名宽+60”更宽）。
-- CityBannerManager.lua 里的 DoResizeBanner 是**全局函数**，钩住它就能拿到每面旗的真实宽度。
local g_BannerW = {}          -- [旗上显示的城市名] = 旗宽
local g_BannerInst = {}       -- [旗上显示的城市名] = BannerInstance
local g_BannerHooked = false
local placeMark                -- 前置声明：钩子里要回调

local function hookBannerResize()
	if g_BannerHooked then return end
	-- Civ5 的 Lua 沙箱没有 rawget/rawset，直接读全局名即可
	local orig = DoResizeBanner
	if type(orig) ~= "function" then return end
	DoResizeBanner = function(inst)
		orig(inst)
		pcall(function()
			local w = inst.BannerButton and inst.BannerButton:GetSizeX()
			-- 用 playerID:cityID 做键，和城市名/显示名无关（长名、改名都不影响）
			local key = tostring(inst.playerID or -1) .. ":" .. tostring(inst.cityID or -1)
			if w and w > 0 then
				local nm = inst.CityName and inst.CityName:GetText() or nil
				local keys = { key }
				if nm and nm ~= "" then keys[2] = nm end   -- 双键：cityID 键 + 显示名键
				for _, k in ipairs(keys) do
					g_BannerInst[k] = inst
					local old = g_BannerW[k]
					g_BannerW[k] = w
					if old ~= w then placeMark(k) end
				end
			end
		end)
	end
	g_BannerHooked = true
	print("[Han] DoResizeBanner hooked")
end


local function bannerWidthFor(key)
	-- 直接问实例要实时宽度
	local inst = g_BannerInst[key]
	if inst and inst.BannerButton then
		local ok, w = pcall(function() return inst.BannerButton:GetSizeX() end)
		if ok and w and w >= 100 then
			g_BannerW[key] = w
			return w
		end
	end
	local w = g_BannerW[key]
	if w and w >= 100 then return w end
	return 168
end

local function markOffsetX(key)
	local iBannerW = bannerWidthFor(key)
	if iBannerW < 100 or iBannerW > 900 then iBannerW = 168 end
	return math.floor(iBannerW / 2 + g_MarkGap + g_MarkSize / 2)
end

-- ---------------- 数据 ----------------
local function getNearbyCityStates(pCity)
	local iPlayer = pCity:GetOwner()
	local t = {}
	for i = g_iMaxMajor, g_iMaxPlayers - 2 do
		local pMinor = Players[i]
		if pMinor and pMinor:IsAlive() and pMinor:IsMinorCiv() then
			local pCap = pMinor:GetCapitalCity()
			if pCap then
				local d = Map.PlotDistance(pCity:GetX(), pCity:GetY(), pCap:GetX(), pCap:GetY())
				if d <= 8 then
					table.insert(t, {
						name = Locale.ConvertTextKey(pMinor:GetName()),
						dist = d,
						ally = (pMinor:GetAlly() == iPlayer),
						pop = pCap:GetPopulation(),
						units = pMinor:GetNumMilitaryUnits(),
						-- 城邦图标：用 CivInfo 的 AlphaIconAtlas（与 CityBannerManager 一致）
						civ = GameInfo.Civilizations[pMinor:GetCivilizationType()],
						player = pMinor,
					})
				end
			end
		end
	end
	table.sort(t, function(a, b) return a.dist < b.dist end)
	return t
end

local function getRewards(iPlayer)
	local pPlayer = Players[iPlayer]
	local iNum, iPops, iUnits = 0, 0, 0
	for i = g_iMaxMajor, g_iMaxPlayers - 2 do
		local pMinor = Players[i]
		if pMinor and pMinor:IsAlive() and pMinor:IsMinorCiv() and pMinor:GetAlly() == iPlayer then
			iNum = iNum + 1
			local pCap = pMinor:GetCapitalCity()
			if pCap then iPops = iPops + pCap:GetPopulation() end
			iUnits = iUnits + pMinor:GetNumMilitaryUnits()
		end
	end
	local iEra = pPlayer:GetCurrentEra() + 1
	if iNum <= 0 then return 0, 0, 0, 0 end
	return iNum, iNum * iEra, math.ceil(math.log(iPops + 1) * iEra), math.ceil(math.log(iUnits + 1) * iEra)
end

-- ---------------- 面板 ----------------
-- 行：名称 / 距离·兵力 / 人口 / 同盟状态 + 城邦图标 + 左侧状态条
local function addRow(cs, bPlain)
	local t = {}
	ContextPtr:BuildInstanceForControl("DuhuRow", t, Controls.DuhuList)
	if not cs then return end
	if t.Name then t.Name:SetText(cs.name or "") end
	if bPlain then
		if t.Dist then t.Dist:SetText("") end
		if t.Pop then t.Pop:SetText("") end
		if t.State then t.State:SetText("") end
		return
	end
	if t.Dist then
		t.Dist:SetText(Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_ROW_DIST", cs.dist or 0, cs.units or 0))
	end
	if t.Pop then
		t.Pop:SetText(Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_ROW_POP", cs.pop or 0))
	end
	if t.State then
		t.State:SetText(cs.ally and Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_CS_ALLY")
		                        or Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_CS_NONE"))
	end
	if t.Accent then
		if cs.ally then t.Accent:SetColor(Vector4(0.56, 0.83, 0.29, 1))
		else t.Accent:SetColor(Vector4(0.49, 0.53, 0.58, 1)) end
	end
	if t.Icon and cs.civ then
		IconHookup(cs.civ.PortraitIndex, 32, cs.civ.AlphaIconAtlas, t.Icon)
		-- 城邦图标按城邦本国颜色着色（与 CityBannerManager 同一套取色规则）
		if cs.player then
			local c1, c2 = cs.player:GetPlayerColors()
			if cs.player:IsMinorCiv() then c1, c2 = c2, c1 end
			local vCol = Vector4(c1.x, c1.y, c1.z, 1)
			pcall(function() t.Icon:SetColor(vCol) end)
			if t.Name then pcall(function() t.Name:SetColor(vCol, 0) end) end
		end
	end
end

local function rebuild()
	local iPlayer = Game.GetActivePlayer()
	local pCity = Players[iPlayer]:GetCityByID(g_iCityID)
	Controls.DuhuList:DestroyAllChildren()
	if not pCity then return end

	local tCS = getNearbyCityStates(pCity)

	-- 库内城市显示所属郡国；自定义名/征服城市仍显示城名
	local sRawName = pCity:GetName()
	local sCityName = Locale.ConvertTextKey(sRawName)
	-- 库内城市（TXT_KEY_CITY_NAME_SP_HAN_NN）→ 显示郡国；自定义/征服城市 → 显示城名
	local sJunKey = g_JunByCity[sRawName]
	local sHead = sJunKey and Locale.ConvertTextKey(sJunKey) or sCityName
	Controls.DuhuTitle:SetText(Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_CITY_TITLE", sHead))

	if #tCS == 0 then
		addRow({ name = Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_NO_CS_NEAR") }, true)
	else
		for _, cs in ipairs(tCS) do
			addRow(cs)
		end
	end

	local iNum, iCulture, iFood, iProd = getRewards(iPlayer)
	Controls.DuhuSummary:SetText(Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_CITY_SUMMARY",
		sCityName, pCity:GetPopulation(), #tCS, iNum))

	-- 右栏收益
	-- 右栏收益：数值 + 图标（与 TXT_KEY_HAN_DUHU_REWARD 同一套 ICON 写法）
	if Controls.CulV then
		Controls.CulV:SetText(Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_LINE_CULTURE", iCulture))
	end
	if Controls.FoodV then
		Controls.FoodV:SetText(Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_LINE_FOOD", iFood))
	end
	if Controls.ProdV then
		Controls.ProdV:SetText(Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_LINE_PRODUCTION", iProd))
	end

	if Controls.DuhuHint then
		if iNum > 0 then
			Controls.DuhuHint:SetText(Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_HINT2"))
		else
			Controls.DuhuHint:SetText(Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_NO_ALLY"))
		end
	end
end

local function show(iCityID)
	g_iCityID = iCityID
	g_bOpen = true
	rebuild()
	Controls.DuhuFrame:SetHide(false)
end

function hide()
	g_bOpen = false
	Controls.DuhuFrame:SetHide(true)
end

-- ---------------- 地图标记 ----------------
local function onMarkClick()
	local iCityID = UI.GetHeadSelectedCity() and UI.GetHeadSelectedCity():GetID() or -1
	if iCityID >= 0 and not g_bOpen then show(iCityID) end
end

-- 徽章 tooltip：城名/郡国 + 覆盖城邦 + 同盟 + 收益 + 操作提示
local function markTooltip(pCity)
	local iPlayer = pCity:GetOwner()
	local sRaw = pCity:GetName()
	local sCity = Locale.ConvertTextKey(sRaw)
	local sJunKey = g_JunByCity[sRaw] or g_JunByCity[sCity]
	local sJun = sJunKey and Locale.ConvertTextKey(sJunKey) or sCity
	local tCS = getNearbyCityStates(pCity)
	local iAlly = 0
	for _, cs in ipairs(tCS) do
		if cs.ally then iAlly = iAlly + 1 end
	end
	local iNum, iCulture, iFood, iProd = getRewards(iPlayer)
	local t = {}
	t[#t + 1] = Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_TT_HEAD", sJun, sCity)
	t[#t + 1] = Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_TT_CS", #tCS, iAlly)
	t[#t + 1] = Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_TT_REWARD", iCulture, iFood, iProd)
	t[#t + 1] = Locale.ConvertTextKey("TXT_KEY_HAN_DUHU_TT_HINT")
	return table.concat(t, "[NEWLINE]")
end

-- 标记中心 = 旗心 + 旗宽/2 + 缝隙 + 徽记半宽
function RefreshMarks()
	hookBannerResize()
	g_MarkIM:ResetInstances()
	g_Marks = {}

	local iPlayer = Game.GetActivePlayer()
	for pCity in Players[iPlayer]:Cities() do
		if pCity:IsHasBuilding(g_DuhuID) then
			local m = g_MarkIM:GetInstance()
			local iCid = pCity:GetID()
			local sName = Locale.ConvertTextKey(pCity:GetName())
			local sKey = iPlayer .. ":" .. iCid
			-- cityID 键没采到时退回显示名键（兼容钩子晚挂的情况）
			if not g_BannerW[sKey] then sKey = sName end
			-- 按该城旗的真实宽度贴到右侧（宽旗不会压旗）
			if m.MarkButton and m.MarkButton.SetOffsetVal then
				m.MarkButton:SetOffsetVal(markOffsetX(sKey), 0)
			end
			if m.MarkButton.SetToolTipString then
				m.MarkButton:SetToolTipString(markTooltip(pCity))
			end
			m.MarkButton:RegisterCallback(Mouse.eLClick, function()
				if g_bOpen then hide() else show(iCid) end
			end)
			table.insert(g_Marks, { anchor = m.Anchor, x = pCity:GetX(), y = pCity:GetY(),
			                        key = sKey, button = m.MarkButton })
		end
	end
	UpdateMarkPositions()
end

-- 旗宽变化时（DoResizeBanner 钩子回调）只挪对应城市的徽记，不重建整层
placeMark = function(sKey)
	for _, mk in ipairs(g_Marks) do
		if mk.key == sKey and mk.button and mk.button.SetOffsetVal then
			mk.button:SetOffsetVal(markOffsetX(sKey), 0)
		end
	end
end

-- 教程 6 的写法：世界坐标只设一次，WorldAnchor 自己跟随镜头
-- 注意：要和城旗同高，必须带上 z=35（否则标记掉在城砖上，不会贴着旗）
function UpdateMarkPositions()
	for _, mk in ipairs(g_Marks) do
		if mk.anchor and mk.anchor.SetWorldPosition then
			mk.anchor:SetWorldPosition(VecAdd(HexToWorld(ToHexFromGrid({ x = mk.x, y = mk.y })), g_WorldOffset))
		end
	end
end

-- ---------------- 生命周期 ----------------
Controls.DuhuFrame:SetHide(true)
ContextPtr:SetInputHandler(function(uiMsg, wParam)
	if uiMsg == KeyEvents.KeyDown and wParam == Keys.VK_ESCAPE and g_bOpen then
		hide()
		return true
	end
	return false
end)

Controls.DuhuClose:RegisterCallback(Mouse.eLClick, hide)

-- 立刻尝试挂钩（CityBannerManager 通常先于本 Addin 加载；若没挂上，RefreshMarks 里还会再试）
hookBannerResize()
-- 不再每帧刷新：WorldAnchor 自带跟随

-- 教程 6：进城市界面时隐藏世界层控件
Events.SerialEventEnterCityScreen.Add(function() Controls.DuhuMarkers:SetHide(true) end)
Events.SerialEventExitCityScreen.Add(function() Controls.DuhuMarkers:SetHide(false); RefreshMarks() end)
Events.LoadScreenClose.Add(RefreshMarks)
Events.ActivePlayerTurnStart.Add(RefreshMarks)
Events.SerialEventCityInfoDirty.Add(RefreshMarks)
GameEvents.CityConstructed.Add(RefreshMarks)
GameEvents.CityCaptureComplete.Add(RefreshMarks)

LuaEvents.HanDuhuPanel_Show.Add(function()
	local pCity = UI.GetHeadSelectedCity()
	if pCity then show(pCity:GetID()) end
end)

if Game.GetGameTurn and Game.GetGameTurn() > 0 then RefreshMarks() end

print("[Han] DuhuPanel loaded")
