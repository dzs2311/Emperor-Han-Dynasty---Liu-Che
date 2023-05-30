include ("IconSupport");
include ("MenuUtils");
include ("FLuaVector.lua");
print("=========================================================Han Events Load!=========================================================")

-- Hide dialog by default.
ContextPtr:SetHide(true);


local activePlayerID    = Game.GetActivePlayer()
local activePlayer	    = Players[activePlayerID]

local g_EventsTitle     = {"TXT_KEY_EVENTS_HAN_HISTORY1_TITLE",
                           "TXT_KEY_EVENTS_HAN_HISTORY2_TITLE",
                           "TXT_KEY_EVENTS_HAN_HISTORY3_TITLE",
                           "TXT_KEY_EVENTS_HAN_HISTORY4_TITLE"}

local g_EventsMessage   = {"TXT_KEY_EVENTS_HAN_HISTORY1_MESSAGE",
                           "TXT_KEY_EVENTS_HAN_HISTORY2_MESSAGE",
                           "TXT_KEY_EVENTS_HAN_HISTORY3_MESSAGE",
                           "TXT_KEY_EVENTS_HAN_HISTORY4_MESSAGE"}

 local g_EventsButtton  = {"TXT_KEY_EVENTS_HAN_HISTORY1_BUTTON",
                           "TXT_KEY_EVENTS_HAN_HISTORY2_BUTTON",
                           "TXT_KEY_EVENTS_HAN_HISTORY3_BUTTON",
                           "TXT_KEY_EVENTS_HAN_HISTORY4_BUTTON"}

local g_Texture         = { "Han_HistEvents1.dds",
                            "Han_HistEvents2.dds",
                            "Han_HistEvents3.dds",
                            "Han_HistEvents4.dds"}

local HanEH1ID				= GameInfo.UnitPromotions["PROMOTION_HAN_HISTORY1"].ID  
local numEvent              = 0                     
--==========================================================================================
-- Main Functions
--==========================================================================================
-- Initializes All Components.
function initializeDialog()
    print("initializeDialog")

	local pPlayer   = activePlayer;	
	local leader    = GameInfo.Leaders[pPlayer:GetLeaderType()];

    IconHookup(leader.PortraitIndex, 64, leader.IconAtlas, Controls.CivIconBG)
    if numEvent > 0 then
        Controls.Image:SetTextureAndResize(g_Texture[numEvent])
        Controls.Title:SetText(Locale.ConvertTextKey(g_EventsTitle[numEvent]))
        Controls.Summary:SetText(Locale.ConvertTextKey(g_EventsMessage[numEvent]))
        Controls.SelectButton:SetToolTipString(Locale.ConvertTextKey(g_EventsButtton[numEvent]))
    end
    -- Events.AudioPlay2DSound("AS2D_EVENT_MARKET_START")

end

-- Handle the Apply Button
function onApplyButton()
    local pPlayer = activePlayer;	

    HanHistoryEvents(pPlayer)
	hideDialog()
    -- Events.AudioPlay2DSound("AS2D_EVENT_MARKET_FINISH")

end
Controls.SelectButton:RegisterCallback(Mouse.eLClick, onApplyButton)
--==========================================================================================
-- Smaller Functions
--==========================================================================================
-- Show function
function showDialog()
    -- Show panel
    ContextPtr:SetHide(false)
    -- Initialize
    initializeDialog()
end

-- Hide function
function hideDialog()
    ContextPtr:SetHide(true)
end
--==========================================================================================
-- Core Functions
--==========================================================================================
function HanHistoryEvents(player)
    local pEraType = player:GetCurrentEra()
    local pEraID = GameInfo.Eras[pEraType].ID
    -- print("numEvent2 = "..numEvent)
    if numEvent == 1 then
        -- 仕汉羽林郎：建造第一个羽林禁军时触发
        if GameInfoTypes["PROMOTION_SPUE_YULIN_CAVALRY"] == nil then return end
        for unit in player:Units() do
            if unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_SPUE_YULIN_CAVALRY"].ID) then
                unit:SetHasPromotion(HanEH1ID, true)
            end
        end
    elseif numEvent == 2 then
        -- 天马极西徕：攻占城邦或希腊文明城市后触发
        player:SetHasPolicy(GameInfo.Policies["POLICY_SP_HAN_HIST_EVENT2"].ID, true, true)
    elseif numEvent == 3 then
        -- 历史的天空：与季汉文明第一次宣布友谊后触发
        player:SetHasPolicy(GameInfo.Policies["POLICY_SP_HAN_HIST_EVENT3"].ID, true, true)
    elseif numEvent == 4 then 
        -- 失落的军团：与罗马/希腊文明相遇后随机触发，只能在中古时代之前触发一次
        local capCity = player:GetCapitalCity()
		if capCity ~= nil then
			local unitType = GameInfoTypes["UNIT_ROMAN_LEGION"]
			local plotX = capCity:GetX()
			local plotY = capCity:GetY()
			
			local NewUnit = player:InitUnit(unitType, plotX, plotY)
            NewUnit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_HAN_HISTORY4"].ID, true)
			NewUnit:JumpToNearestValidPlot()
			local domainLandID = GameInfo.Domains["DOMAIN_LAND"].ID
			local LANDTotal =  capCity:GetFreeExperience() + capCity:GetDomainFreeExperience(domainLandID)
			NewUnit:ChangeExperience(LANDTotal)
		end
    end
    numEvent = 0
end
--==========================================================================================
-- 触发事件
--==========================================================================================
--------------------------------------------------------------
-- 单位产生
--------------------------------------------------------------
function HanEventUnitCreated( iPlayerID, iUnitID )
	if Players[ iPlayerID ] == nil or not Players[ iPlayerID ]:IsAlive()
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ) == nil
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ):IsDead()
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ):IsDelayedDeath()
	then
		return
	end
	local unit = Players[ iPlayerID ]:GetUnitByID( iUnitID )
    local player = Players[iPlayerID]
    if player:GetCivilizationType() ~= GameInfoTypes["CIVILIZATION_SP_HAN"] then return end
    if GameInfoTypes["PROMOTION_SPUE_YULIN_CAVALRY"] == nil then return end

    if unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_SPUE_YULIN_CAVALRY"].ID)
    and player:GetUnitCountFromHasPromotion(HanEH1ID == 0)
    then
        -- 仕汉羽林郎：建造第一个羽林禁军时触发
        numEvent = 1
        showDialog()
    end
end
GameEvents.UnitCreated.Add(HanEventUnitCreated)
--------------------------------------------------------------
-- 攻陷城市
--------------------------------------------------------------
function HanEventCaptureCity(hexPos, iPlayer, cityID, newiPlayer)

    local pOldPlayer = Players[iPlayer]
	local pCityPlot = Map.GetPlot( ToGridFromHex( hexPos.x, hexPos.y ) )------获取城市所在地块
	local player = Players[newiPlayer]         -------获取玩家
	local pCity = pCityPlot:GetPlotCity()                       -----获取城市
	local citySize = pCity:GetPopulation()	-------获取城市人口规模

    if pOldPlayer == nil or pOldPlayer:IsBarbarian() then return end
	if player == nil or player:IsBarbarian() or player:IsMinorCiv()
    or player:GetCivilizationType() ~= GameInfoTypes["CIVILIZATION_SP_HAN"]
    then
    	return
	end

    if (pOldPlayer:IsMinorCiv() or pOldPlayer:GetCivilizationType() == GameInfoTypes["CIVILIZATION_GREECE"])
    and not player:HasPolicy(GameInfo.Policies["POLICY_SP_HAN_HIST_EVENT2"].ID)
    then
        -- 天马极西徕：攻占城邦或希腊文明城市后触发
        numEvent = 2
        showDialog()
    end
end
Events.SerialEventCityCaptured.Add(HanEventCaptureCity)
--------------------------------------------------------------
-- 过回合
--------------------------------------------------------------
function OnPlayerDoTurn(playerID)
    local player = Players[playerID]	
	if player == nil or player:IsBarbarian() or player:IsMinorCiv()
    or player:GetCivilizationType() ~= GameInfoTypes["CIVILIZATION_SP_HAN"]
    then
    	return
	end

    local pEraType = player:GetCurrentEra()
	local pEraID = GameInfo.Eras[pEraType].ID

    if not player:HasPolicy(GameInfo.Policies["POLICY_SP_HAN_HIST_EVENT3"].ID)
    and GameInfoTypes["CIVILIZATION_JIHAN"] ~= nil
    then
        -- 历史的天空
        if Game.IsCivEverActive(GameInfoTypes.CIVILIZATION_JIHAN) then
            local iJiHaPlayer
            for iPlayer = 0, GameDefines.MAX_CIV_PLAYERS - 1, 1 do
                local pPlayer = Players[iPlayer]
                if pPlayer:IsEverAlive() then
                    if(player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_JIHAN"]) then
                        iJiHaPlayer = iPlayer
                    end
                end
            end
            if iJiHaPlayer then
                if player:IsDoF(iJiHaPlayer) then
                    -- 友谊声明
                    numEvent = 3
                    showDialog()
                end
            end
            
        end
    end

    if player:GetUnitCountFromHasPromotion(GameInfo.UnitPromotions["PROMOTION_HAN_HISTORY4"].ID) < 3
    and pEraID <= GameInfo.Eras["ERA_MEDIEVAL"].ID
    then
        -- 失落的军团
        local bHasMetMed = false
        for iPlayer = 0, GameDefines.MAX_CIV_PLAYERS - 1, 1 do
            local pPlayer = Players[iPlayer]
            if pPlayer:IsEverAlive() then
                local activeCivID = pPlayer:GetCivilizationType()
                local activeCiv = GameInfo.Civilizations[activeCivID]
                local activeCivSuffix = GameInfo.Civilizations[activeCivID].ArtStyleSuffix
                if activeCivSuffix == '_MED' and Teams[player:GetTeam()]:IsHasMet(pPlayer:GetTeam()) then
                    bHasMetMed = true
                    break
                end
            end
        end

        if bHasMetMed and math.random(1, 4) < 2 then
            numEvent = 4
            showDialog()
        end
    end
end
GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn)