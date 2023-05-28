include ("IconSupport");
include ("MenuUtils");
include ("FLuaVector.lua");
print("=========================================================MarketEvents Load!=========================================================")

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

local numEvent          = math.random(1, 4)
--==========================================================================================
-- Main Functions
--==========================================================================================
-- Initializes All Components.
function initializeDialog(numEvent)
    print("initializeDialog")

	local pPlayer = activePlayer;	
	local building = GameInfo.Buildings["BUILDING_SONG_MARKET"];

    IconHookup(building.PortraitIndex, 64, building.IconAtlas, Controls.CivIconBG)
    Controls.Image:SetTextureAndResize(g_Texture[numEvent])
    Controls.Title:SetText(Locale.ConvertTextKey(g_EventsTitle[numEvent]))
    Controls.Summary:SetText(Locale.ConvertTextKey(g_EventsMessage[numEvent]))
    Controls.SelectButton:SetText(Locale.ConvertTextKey(g_EventsButtton[numEvent]))

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


-- function OnPlayerDoTurn(playerID)
--     local player = Players[playerID]	
--     if player == nil or player:IsBarbarian() then return end

--     print("do turn prepare")
--     if player:CountNumBuildings(GameInfoTypes["BUILDING_SONG_MARKET"]) > 0 then
--         --25%概率发生事件
--         print("bEvent")
--         local bEvent = math.random(0, 100)
--         if bEvent > 25 then return end

--         local bCargo = false
--         local bGeneral = false

--         for unit in player:Units() do
--             if unit:GetUnitType() == GameInfoTypes["UNIT_SONG_CARGOSHIP"] then
--                 bCargo= true
--             elseif unit:GetUnitType() == GameInfoTypes["UNIT_JIEDUSHI"] then
--                 bGeneral = true
--             end
--         end

--         numEvent = math.random(1, 4)
--         if bCargo and bGeneral then
--             numEvent = math.random(1, 6)
--         elseif bCargo and not bGeneral then
--             numEvent = math.random(1, 5)
--         elseif not bCargo and bGeneral then
--             numEvent = math.random(1, 5)
--             if numEvent == 5 then numEvent = 6 end
--         end

--         print("numEvent = "..numEvent)

--         if player:IsHuman() then
--             showDialog()
--         else
--             SongMarketEvents(player)
--         end

--     end


-- end
-- GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn)
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
        -- print("pEraID = "..pEraID)
        for city in player:Cities() do
            if city:GetNumBuilding(GameInfo.Buildings['BUILDING_SONG_MARKET'].ID) > 0 then
                local cultureBonus = 15 * (1 + pEraID)
                player:ChangeJONSCulture(cultureBonus)
                if player:IsHuman() then
                    local hex = ToHexFromGrid(Vector2(city:GetX(), city:GetY()));
                    Events.AddPopupTextEvent(HexToWorld(hex), Locale.ConvertTextKey("[COLOR_MAGENTA]+{1_Num}[ENDCOLOR][ICON_CULTURE]", cultureBonus));
                end
            end
        end
    elseif numEvent == 2 then
        for city in player:Cities() do
            if city:GetNumBuilding(GameInfo.Buildings['BUILDING_SONG_MARKET'].ID) > 0 then
                local scienceBonus = 15 * (1 + pEraID)
                player:ChangeOverflowResearch(scienceBonus)
                if player:IsHuman() then
                    local hex = ToHexFromGrid(Vector2(city:GetX(), city:GetY()));
                    Events.AddPopupTextEvent(HexToWorld(hex), 
                        Locale.ConvertTextKey("[COLOR_RESEARCH_STORED]+{1_Num}[ENDCOLOR][ICON_RESEARCH]", scienceBonus));
                end
            end
        end
    elseif numEvent == 3 then
        for city in player:Cities() do
            if city:GetNumBuilding(GameInfo.Buildings['BUILDING_SONG_MARKET'].ID) > 0 then
                local productionBonus = 15 * (1 + pEraID)
                city:SetOverflowProduction(city:GetOverflowProduction() + productionBonus)
                if player:IsHuman() then
                    local hex = ToHexFromGrid(Vector2(city:GetX(), city:GetY()));
                    Events.AddPopupTextEvent(HexToWorld(hex), 
                        Locale.ConvertTextKey("[COLOR_CITY_BROWN]+{1_Num}[ENDCOLOR][ICON_PRODUCTION]", productionBonus));
                end
            end
        end
    elseif numEvent == 4 then 
        for city in player:Cities() do
            if city:GetNumBuilding(GameInfo.Buildings['BUILDING_SONG_MARKET'].ID) > 0 then
                local productionBonus = 15 * (1 + pEraID)
                city:SetWeLoveTheKingDayCounter(city:GetWeLoveTheKingDayCounter() + 5)

                local goldRow = GameInfo.Resources["RESOURCE_GOLD"];

                if player:IsHuman() then
                    player:AddNotification(
                        NotificationTypes.NOTIFICATION_DISCOVERED_LUXURY_RESOURCE, 
                        Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_CITY_WLTKD", goldRow.Description, city:GetNameKey()),
                        Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_SUMMARY_CITY_WLTKD", city:GetNameKey()), 
                        city:GetX(), city:GetY(), 
                        goldRow.ID);
                end

            end
        end
    end
end
