-- Han Script
-- Author: dzs2311
-- DateCreated: 2023/5/20 17:58:37
--------------------------------------------------------------
include("FLuaVector.lua")
--------------------------------------------------------------
local KnightID              = GameInfo.UnitPromotions["PROMOTION_KNIGHT_COMBAT"].ID
local TankID                = GameInfo.UnitPromotions["PROMOTION_TANK_COMBAT"].ID
local HelicopterUnitID      = GameInfo.UnitPromotions["PROMOTION_HELI_ATTACK"].ID
local HitAndRunUnitID       = GameInfo.UnitPromotions["PROMOTION_HITANDRUN"].ID
local HanNuID               = GameInfo.UnitPromotions["PROMOTION_HAN_CROSSBOWMAN"].ID
local HanRiderID            = GameInfo.UnitPromotions["PROMOTION_HUOQUBING_RIDER"].ID
local HanSakaID             = GameInfo.UnitPromotions["PROMOTION_HAN_VASSAL_MOUNTEDXBOW"].ID
--------------------------------------------------------------
-- 文明过回合
--------------------------------------------------------------
function HanOnPlayerDoTurn(playerID)
	local player = Players[playerID]

	if player == nil or player:IsBarbarian() or player:IsMinorCiv() then
    	return
	end

	local pEraType = player:GetCurrentEra()
	local pEraID = GameInfo.Eras[pEraType].ID
	local pCapital = player:GetCapitalCity()

	-- 黄金时代为见过面的城邦增长5影响力
	if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_SP_HAN"] then
		if player:IsGoldenAge() then
			for iCS = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_PLAYERS-2, 1 do
				local iCSplayer = Players[iCS]
				if (iCSplayer ~= nil and iCSplayer:IsAlive() and iCSplayer:IsMinorCiv() 
				and player:GetTeam():IsHasMet(iCSplayer:GetTeam())) 
				then
					iCSplayer:ChangeMinorCivFriendshipWithMajor(playerID, 200)
				end
			end
		end
	end

	-- 丝路驿站提供额外金钱和文化
	if player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_SP_HAN"] and player:IsAlive() then
		for city in player:Cities() do
			for cityPlot = 0, city:GetNumCityPlots() - 1, 1 do
				local plot = city:GetCityIndexPlot(cityPlot)
				if plot then
				if plot:GetOwner() == playerID then
				if city:IsWorkingPlot(plot) then	
				if plot:GetImprovementType() == GameInfoTypes["IMPROVEMENT_SP_HAN_POST"]
				and plot:IsTradeRoute()
				then 
					local bonus = 3
					player:ChangeGold(bonus)
					player:ChangeJONSCulture(bonus)
					if player:IsHuman() then
						local hex = ToHexFromGrid(Vector2(unit:GetX(), unit:GetY()));
						Events.AddPopupTextEvent(HexToWorld(hex),
							Locale.ConvertTextKey("[COLOR_YIELD_GOLD]+{1_Num}[ENDCOLOR][ICON_GOLD][NEWLINE][COLOR_MAGENTA]+{2_Num}[ENDCOLOR][ICON_CULTURE]", 
							bonus, bonus));
					end
				end
				end
				end
				end
			end
		end
	end

end
GameEvents.PlayerDoTurn.Add(HanOnPlayerDoTurn)
--------------------------------------------------------------
-- 单位固定伤害
--------------------------------------------------------------
function HanBattleCustomDamage(iBattleUnitType, iBattleType,
	iAttackPlayerID, iAttackUnitOrCityID, bAttackIsCity, iAttackDamage,
	iDefensePlayerID, iDefenseUnitOrCityID, bDefenseIsCity, iDefenseDamage,
	iInterceptorPlayerID, iInterceptorUnitOrCityID, bInterceptorIsCity, iInterceptorDamage)

	local additionalDamage = 0

	local attPlayer = Players[iAttackPlayerID]
	local defPlayer = Players[iDefensePlayerID]
	if attPlayer == nil or defPlayer == nil then
		return 0
	end

	if iBattleUnitType == GameInfoTypes["BATTLEROLE_ATTACKER"] then
		if bAttackIsCity then
			return 0
		end

		local attUnit = attPlayer:GetUnitByID(iAttackUnitOrCityID)
		if attUnit == nil then
			return 0
		end

        if attUnit:IsHasPromotion(KnightID) or attUnit:IsHasPromotion(TankID) 
        or attUnit:IsHasPromotion(HelicopterUnitID) or attUnit:IsHasPromotion(HitAndRunUnitID) 
        then
            -- 上林苑加成
            local numShangLinYuan = math.min(10, attPlayer:CountNumBuildings(GameInfoTypes["BUILDING_HAN_GARDEN"]))
            additionalDamage = additionalDamage + numShangLinYuan
        end

        if attPlayer:GetCivilizationType() == GameInfoTypes["CIVILIZATION_SP_HAN"] 
        and attUnit:GetDomainType() == DomainTypes.DOMAIN_LAND
        and not attUnit:GetPlot():IsFriendlyTerritory(iAttackPlayerID)
        then
            -- 汉文明特性加成
            additionalDamage = additionalDamage + 5
        end

        if attUnit:IsHasPromotion(KnightID) then
            -- 佽飞射士彍强弩
            additionalDamage = additionalDamage + math.min(5, attUnit:GetFortifyTurns())
        end

	end
	return additionalDamage
end
GameEvents.BattleCustomDamage.Add(HanBattleCustomDamage)
--------------------------------------------------------------
-- 单位回合效果
--------------------------------------------------------------
function HanOnUnitDoTurn(playerID, unitID, iPlotX, iPlotY)
	if Players[playerID] == nil or not Players[playerID]:IsAlive()
	or Players[playerID]:GetUnitByID(unitID) == nil
	or Players[playerID]:GetUnitByID(unitID):IsDead()
	or Players[playerID]:GetUnitByID(unitID):IsDelayedDeath()
	then
		return;
	end

	local player = Players[playerID];
	local unit = Players[playerID]:GetUnitByID(unitID);
    local plot = Map.GetPlot(iPlotX, iPlotY);

    if unit:IsHasPromotion(HanNuID) then
        -- 佽飞射士彍强弩
        local plot = unit:GetPlot();
        if plot and plot:GetImprovementType() == GameInfo.Improvements["IMPROVEMENT_SP_HAN_POST"].ID then
            -- 驻扎于丝路驿站
            local unitCount = plot:GetNumUnits()
            local iGold = unit:GetMaxRangedCombatStrength()
            -- for i = 0, unitCount - 1, 1 do
            --     local pUnit = plot:GetUnit(i)
            --     if pUnit:IsHasPromotion(HanNuID) then
            --         iGold = iGold + pUnit:GetMaxRangedCombatStrength()
            --     end
	        -- end
            player:ChangeGold(iGold);
            if player:IsHuman() then
                local hex = ToHexFromGrid(Vector2(unit:GetX(), unit:GetY()));
                Events.AddPopupTextEvent(HexToWorld(hex),
                    Locale.ConvertTextKey("[COLOR_YIELD_GOLD]+{1_Num}[ENDCOLOR][ICON_GOLD]", iGold));
            end
        elseif plot and plot:GetImprovementType() == GameInfo.Improvements["IMPROVEMENT_SP_HAN_FORT"].ID then
            -- 驻扎于汉塞
            unit:ChangeDamage(-5);
            local iCulture = unit:GetBaseRangedCombatStrength()
            player:ChangeJONSCulture(iCulture)
            if player:IsHuman() then
                local hex = ToHexFromGrid(Vector2(unit:GetX(), unit:GetY()));
                Events.AddPopupTextEvent(HexToWorld(hex),
                    Locale.ConvertTextKey("[COLOR_MAGENTA]+{1_Num}[ENDCOLOR][ICON_CULTURE]", iCulture));
            end
        end
    end

	if unit:IsHasPromotion(HanSakaID) then
        -- 解忧
		local plot = unit:GetPlot();
        if plot and plot:GetImprovementType() == GameInfo.Improvements["IMPROVEMENT_SP_HAN_POST"].ID then
			unit:ChangeMoves(120);
		end
	end
end
GameEvents.UnitDoTurn.Add(HanOnUnitDoTurn)
--------------------------------------------------------------
-- 单位产生
--------------------------------------------------------------
function HanUnitCreated( iPlayerID, iUnitID )
	if Players[ iPlayerID ] == nil or not Players[ iPlayerID ]:IsAlive()
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ) == nil
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ):IsDead()
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ):IsDelayedDeath()
	then
		return;
	end
	local unit = Players[ iPlayerID ]:GetUnitByID( iUnitID )
    local player = Players[iPlayerID]

	if unit:IsHasPromotion(HanRiderID) 
	and player:GetUnitClassCount(GameInfo.UnitClasses["UNITCLASS_HAN_VASSAL_MOUNTEDXBOW"].ID) > 0 
	then
        for pUnit in player:Units() do
            if pUnit:IsHasPromotion(HanSakaID) then
                pUnit:SetBaseCombatStrength(pUnit:GetBaseCombatStrength() + 1)
                pUnit:SetBaseRangedCombatStrength(pUnit:GetBaseRangedCombatStrength() + 1)
            end
        end
	end	
end
GameEvents.UnitCreated.Add(HanUnitCreated)
--------------------------------------------------------------
-- 发现城邦
--------------------------------------------------------------
function HanOnPopup( popupInfo )
    local m_PopupInfo = nil;
	
	local bGreeting = popupInfo.Type == ButtonPopupTypes.BUTTONPOPUP_CITY_STATE_GREETING;
	
	if (not bGreeting) then
		return;
	end
	
	m_PopupInfo = popupInfo;	
	
    local iPlayer = popupInfo.Data1;
    local pPlayer = Players[iPlayer];
	
	
	local civType = pPlayer:GetCivilizationType();
	local civInfo = GameInfo.Civilizations[civType];
	
	local iActivePlayer = Game.GetActivePlayer();
    local player = Players[iActivePlayer];
	
	-- Gifts
	local bFirstMajorCiv = popupInfo.Option1;
	
	if (bFirstMajorCiv) and player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_SP_HAN"] then
        pPlayer:ChangeMinorCivFriendshipWithMajor(iActivePlayer, 200)		----增加200点关系
        local citystateCapital = pPlayer:GetCapitalCity()	---获取城邦的首都
        player:AddNotification(NotificationTypes.NOTIFICATION_MINOR_QUEST, 
		Locale.ConvertTextKey("TXT_KEY_TRAIT_AUS_NOTI_2") , 
		Locale.ConvertTextKey("TXT_KEY_TRAIT_AUS_NOTI_1"), 
		citystateCapital:GetX(), citystateCapital:GetY())
	end
	
end
-- Events.SerialEventGameMessagePopup.Add( HanOnPopup );
-------------------------------------------------
function HanTeamMeetHook (eTeamMet, eTeamMoving)
	local pPlayerMoving;
	for iPlayer = 0, GameDefines.MAX_CIV_PLAYERS - 1, 1 do
		local pPlayer = Players[iPlayer];
		if(pPlayer:GetTeam() == eTeamMoving) then
			pPlayerMoving = pPlayer;
		end
	end
	
	local pPlayerMet;
	for iPlayer = 0, GameDefines.MAX_CIV_PLAYERS - 1, 1 do
		local pPlayer = Players[iPlayer];
		if(pPlayer:GetTeam() == eTeamMet) then
			pPlayerMet = pPlayer;
		end
	end

    -- 文明被城邦发现
    if(pPlayerMet ~= nil and (pPlayerMet:GetCivilizationType() == GameInfo.Civilizations["CIVILIZATION_SP_HAN"].ID)) then
        if (Teams[eTeamMoving] ~= nil and Teams[eTeamMoving]:IsMinorCiv()) then
			-- 乌孙弓骑兵加战斗力
			if pPlayerMet:GetUnitClassCount(GameInfo.UnitClasses["UNITCLASS_HAN_VASSAL_MOUNTEDXBOW"].ID) > 0 then
				for pUnit in pPlayerMet:Units() do
					if pUnit:IsHasPromotion(HanSakaID) then
						pUnit:SetBaseCombatStrength(pUnit:GetBaseCombatStrength() + 1)
						pUnit:SetBaseRangedCombatStrength(pUnit:GetBaseRangedCombatStrength() + 1)
					end
				end
			end
			-- 城邦没有见过其他主要文明
			local bFirstMajorCiv = true
			for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS - 1, 1 do
				local pPlayer = Players[iPlayer]
				if (iPlayer ~= pPlayerMet:GetID() and pPlayer:IsAlive() and not pPlayer:IsMinorCiv() 
				and Teams[eTeamMoving]:IsHasMet(pPlayer:GetTeam())) 
				then
					bFirstMajorCiv = false
					break
				end
			end
			-- 汉文明加关系
			if (bFirstMajorCiv) then
				pPlayerMoving:ChangeMinorCivFriendshipWithMajor(pPlayerMet:GetID(), 200)		----增加200点关系
				if pPlayerMet:IsHuman() then
					local citystateCapital = pPlayerMoving:GetCapitalCity()	---获取城邦的首都
					if citystateCapital ~= nil then
						pPlayerMet:AddNotification(NotificationTypes.NOTIFICATION_MINOR_QUEST, 
						Locale.ConvertTextKey("TXT_KEY_TRAIT_HAN_NOTI_2") , 
						Locale.ConvertTextKey("TXT_KEY_TRAIT_HAN_NOTI_1"), 
						citystateCapital:GetX(), citystateCapital:GetY())
					else
						pPlayerMet:AddNotification(NotificationTypes.NOTIFICATION_MINOR_QUEST, 
						Locale.ConvertTextKey("TXT_KEY_TRAIT_HAN_NOTI_2") , 
						Locale.ConvertTextKey("TXT_KEY_TRAIT_HAN_NOTI_1"), -1,-1)
					end
				end
			end
        end
    end

    -- 文明发现城邦
    if (pPlayerMoving ~= nil and (pPlayerMoving:GetCivilizationType() == GameInfo.Civilizations["CIVILIZATION_SP_HAN"].ID )) then
	    if (Teams[eTeamMet] ~= nil and Teams[eTeamMet]:IsMinorCiv()) then
			-- 乌孙弓骑兵加战斗力
			if pPlayerMoving:GetUnitClassCount(GameInfo.UnitClasses["UNITCLASS_HAN_VASSAL_MOUNTEDXBOW"].ID) > 0 then
				for pUnit in pPlayerMoving:Units() do
					if pUnit:IsHasPromotion(HanSakaID) then
						pUnit:SetBaseCombatStrength(pUnit:GetBaseCombatStrength() + 1)
						pUnit:SetBaseRangedCombatStrength(pUnit:GetBaseRangedCombatStrength() + 1)
					end
				end
			end
			-- 城邦没有见过其他主要文明
			local bFirstMajorCiv = true
			for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS - 1, 1 do
				local pPlayer = Players[iPlayer]
				if (iPlayer ~= pPlayerMoving:GetID() and pPlayer:IsAlive() and not pPlayer:IsMinorCiv() 
				and Teams[eTeamMet]:IsHasMet(pPlayer:GetTeam())) 
				then
					bFirstMajorCiv = false
					break
				end
			end
			-- 汉文明加关系
			if (bFirstMajorCiv) then
				pPlayerMet:ChangeMinorCivFriendshipWithMajor(pPlayerMoving:GetID(), 200)		----增加200点关系
				if pPlayerMoving:IsHuman() then
					local citystateCapital = pPlayerMet:GetCapitalCity()	---获取城邦的首都
					if citystateCapital ~= nil then
						pPlayerMoving:AddNotification(NotificationTypes.NOTIFICATION_MINOR_QUEST, 
						Locale.ConvertTextKey("TXT_KEY_TRAIT_HAN_NOTI_2") , 
						Locale.ConvertTextKey("TXT_KEY_TRAIT_HAN_NOTI_1"), 
						citystateCapital:GetX(), citystateCapital:GetY())
					else
						pPlayerMoving:AddNotification(NotificationTypes.NOTIFICATION_MINOR_QUEST, 
						Locale.ConvertTextKey("TXT_KEY_TRAIT_HAN_NOTI_2") , 
						Locale.ConvertTextKey("TXT_KEY_TRAIT_HAN_NOTI_1"), -1,-1)
					end
				end
			end
	    end
	end
end
GameEvents.TeamMeet.Add(HanTeamMeetHook);
--------------------------------------------------------------
-- 完成城邦任务
--------------------------------------------------------------
function HanPlayerCompletedMinorCivQuest(iMajor, iMinor, iQuestType, iStartTurn, iOldInfluence, iNewInfluence) 
	local pPlayer = Players[iMajor]
	local civPlayer = Players[iMinor]
	if pPlayer == nil or civPlayer == nil or pPlayer:IsMinorCiv() or pPlayer:IsBarbarian() then
	 	return
	end

	if pPlayer:GetCivilizationType() == GameInfoTypes["CIVILIZATION_SP_HAN"] then
		-- 完成城邦任务送乌孙弓骑兵
		local capCity = pPlayer:GetCapitalCity()
		if capCity ~= nil then
			local unitType = GameInfoTypes["UNIT_HAN_VASSAL_MOUNTEDXBOW"]
			local plotX = capCity:GetX()
			local plotY = capCity:GetY()
			
			local NewUnit = pPlayer:InitUnit(unitType, plotX, plotY, UNITAI_ATTACK)
			NewUnit:JumpToNearestValidPlot()
			local domainLandID = GameInfo.Domains["DOMAIN_LAND"].ID;
			local LANDTotal =  capCity:GetFreeExperience() + capCity:GetDomainFreeExperience(domainLandID);
			NewUnit:ChangeExperience(LANDTotal);
		end
	end


end
GameEvents.PlayerCompletedQuest.Add(HanPlayerCompletedMinorCivQuest);
--------------------------------------------------------------
-- 乌孙弓骑兵攻击友方单位
--------------------------------------------------------------
function OnHanSakaCanRangeAttackAt(iPlayer, iUnit, iX, iY, bNeedWar)
	local pPlayer = Players[iPlayer]
	local pUnit = pPlayer:GetUnitByID(iUnit)
	local pUnitInfo = GameInfo.Units[pUnit:GetUnitType()]

	if pUnit:IsHasPromotion(HanSakaID)
	then
		local pPlot = Map.GetPlot(iX, iY);
		local ePlayer = nil;
		local Range = pUnitInfo.Range;

		local unitCount = pPlot:GetNumUnits();
		if Range > 0 and unitCount > 0 and pPlot ~= pUnit:GetPlot() then
			local pFoundUnit = pPlot:GetUnit(0);
			ePlayer = Players[pFoundUnit:GetOwner()];
			if ePlayer and not PlayersAtWar(ePlayer, pPlayer)
			then
				if pFoundUnit:GetOwner() ~= iPlayer then
					return true;
				elseif pFoundUnit:GetOwner() == iPlayer and unitCount == 1 then
					return true;
				end
			end
		end
	end

	return false;
end
GameEvents.UnitCanRangeAttackAt.Add(OnHanSakaCanRangeAttackAt)
function OnHanSakaRangeAttackAt(iPlayer, iUnit, iX, iY)
	local pPlayer = Players[iPlayer]
	local pUnit = Players[iPlayer]:GetUnitByID(iUnit)
	local pPlot = Map.GetPlot(iX, iY)
	local pUnitInfo = GameInfo.Units[pUnit:GetUnitType()]
	local pEraType = pPlayer:GetCurrentEra()
	local pEraID = GameInfo.Eras[pEraType].ID

	-- 乌孙弓骑兵
	if pUnit:IsHasPromotion(HanSakaID) then
		local unitCount = pPlot:GetNumUnits();
		local iFaith = 0;
		if unitCount > 0 then
			for i = 0, unitCount - 1, 1 do
				local pFoundUnit = pPlot:GetUnit(i);
				if pFoundUnit and pFoundUnit:GetBaseCombatStrength() > 0 then
					local iPrivateerDamage = pUnit:GetRangeCombatDamage(pFoundUnit, nil, false);
					iPrivateerDamage = math.min(pFoundUnit:GetCurrHitPoints() - 1, iPrivateerDamage);
					pFoundUnit:ChangeDamage(iPrivateerDamage);
					pUnit:ChangeExperience(pUnitInfo.XPValueAttack);
					iFaith = iFaith + iPrivateerDamage * (1 + pEraID);
				end
			end
		end
		pPlayer:ChangeFaith(iFaith);

		local hex = ToHexFromGrid(Vector2(iX, iY));
		Events.AddPopupTextEvent(HexToWorld(hex), Locale.ConvertTextKey("+{1_Num}[ICON_PEACE]",iFaith));
	end

	return 1;
end
GameEvents.UnitRangeAttackAt.Add(OnHanSakaRangeAttackAt)
--------------------------------------------------------------
-- 单位作战效果
--------------------------------------------------------------
local g_DoNewAttackEffect = nil;
function NewAttackEffectStarted(iType, iPlotX, iPlotY)
	if (PreGame.GetGameOption("GAMEOPTION_SP_NEWATTACK_OFF") == 1) then
		print("SP Attack Effect - OFF!");
		return;
	end

	if iType == GameInfoTypes["BATTLETYPE_MELEE"]
		or iType == GameInfoTypes["BATTLETYPE_RANGED"]
		or iType == GameInfoTypes["BATTLETYPE_AIR"]
		or iType == GameInfoTypes["BATTLETYPE_SWEEP"]
	then
		g_DoNewAttackEffect = {
			attPlayerID = -1,
			attUnitID   = -1,
			defPlayerID = -1,
			defUnitID   = -1,
			attODamage  = 0,
			defODamage  = 0,
			PlotX       = iPlotX,
			PlotY       = iPlotY,
			bIsCity     = false,
			defCityID   = -1,
			battleType  = iType,
		};
	end
end

GameEvents.BattleStarted.Add(NewAttackEffectStarted);
-- local tCaptureSPUnits = {};
function NewAttackEffectJoined(iPlayer, iUnitOrCity, iRole, bIsCity)
	if g_DoNewAttackEffect == nil
		or Players[iPlayer] == nil or not Players[iPlayer]:IsAlive()
		or (not bIsCity and Players[iPlayer]:GetUnitByID(iUnitOrCity) == nil)
		or (bIsCity and (Players[iPlayer]:GetCityByID(iUnitOrCity) == nil or iRole == GameInfoTypes["BATTLEROLE_ATTACKER"]))
		or iRole == GameInfoTypes["BATTLEROLE_BYSTANDER"]
	then
		return;
	end
	if bIsCity then
		g_DoNewAttackEffect.defPlayerID = iPlayer;
		g_DoNewAttackEffect.defCityID = iUnitOrCity;
		g_DoNewAttackEffect.bIsCity = bIsCity;
	elseif iRole == GameInfoTypes["BATTLEROLE_ATTACKER"] then
		g_DoNewAttackEffect.attPlayerID = iPlayer;
		g_DoNewAttackEffect.attUnitID = iUnitOrCity;
		g_DoNewAttackEffect.attODamage = Players[iPlayer]:GetUnitByID(iUnitOrCity):GetDamage();
	elseif iRole == GameInfoTypes["BATTLEROLE_DEFENDER"] or iRole == GameInfoTypes["BATTLEROLE_INTERCEPTOR"] then
		g_DoNewAttackEffect.defPlayerID = iPlayer;
		g_DoNewAttackEffect.defUnitID = iUnitOrCity;
		g_DoNewAttackEffect.defODamage = Players[iPlayer]:GetUnitByID(iUnitOrCity):GetDamage();
	end
end

GameEvents.BattleJoined.Add(NewAttackEffectJoined);
function NewAttackEffect()
	--Defines and status checks
	if g_DoNewAttackEffect == nil or Players[g_DoNewAttackEffect.defPlayerID] == nil
		or Players[g_DoNewAttackEffect.attPlayerID] == nil or not Players[g_DoNewAttackEffect.attPlayerID]:IsAlive()
		or Players[g_DoNewAttackEffect.attPlayerID]:GetUnitByID(g_DoNewAttackEffect.attUnitID) == nil
		-- or Players[ g_DoNewAttackEffect.attPlayerID ]:GetUnitByID(g_DoNewAttackEffect.attUnitID):IsDead()
		or Map.GetPlot(g_DoNewAttackEffect.PlotX, g_DoNewAttackEffect.PlotY) == nil
	then
		return;
	end

	local attPlayerID = g_DoNewAttackEffect.attPlayerID;
	local attPlayer = Players[attPlayerID];
	local defPlayerID = g_DoNewAttackEffect.defPlayerID;
	local defPlayer = Players[defPlayerID];

	local attUnit = attPlayer:GetUnitByID(g_DoNewAttackEffect.attUnitID);
	local attPlot = attUnit:GetPlot();

	local plotX = g_DoNewAttackEffect.PlotX;
	local plotY = g_DoNewAttackEffect.PlotY;
	local batPlot = Map.GetPlot(plotX, plotY);
	local batType = g_DoNewAttackEffect.battleType;

	local bIsCity = g_DoNewAttackEffect.bIsCity;
	local defUnit = nil;
	local defPlot = nil;
	local defCity = nil;

	local attFinalUnitDamage = attUnit:GetDamage();
	local defFinalUnitDamage = 0;
	local attUnitDamage = attFinalUnitDamage - g_DoNewAttackEffect.attODamage;
	local defUnitDamage = 0;

	if not bIsCity and defPlayer:GetUnitByID(g_DoNewAttackEffect.defUnitID) then
		defUnit = defPlayer:GetUnitByID(g_DoNewAttackEffect.defUnitID);
		defPlot = defUnit:GetPlot();
		defFinalUnitDamage = defUnit:GetDamage();
		defUnitDamage = defFinalUnitDamage - g_DoNewAttackEffect.defODamage;
	elseif bIsCity and defPlayer:GetCityByID(g_DoNewAttackEffect.defCityID) then
		defCity = defPlayer:GetCityByID(g_DoNewAttackEffect.defCityID);
	end

	g_DoNewAttackEffect = nil;

	--Complex Effects Only for Human VS AI(reduce time and enhance stability)
	-- if not attPlayer:IsHuman() and not defPlayer:IsHuman() then
	-- 	return;
	-- end

	if attUnit and attUnit:IsHasPromotion(HanNuID)
    and defUnit 
	then
        --佽飞射士彍强弩
        if not defUnit:IsDead() then
            defUnit:SetMoves(0)
        end
	end

	if not defCity and attUnit:IsHasPromotion(HanSakaID) then
		-- 解忧
		local HanSakaDamageBonus = 0
		if defUnit then
			local pEraType = attPlayer:GetCurrentEra()
			local pEraID = GameInfo.Eras[pEraType].ID
			HanSakaDamageBonus = defUnitDamage * (1 + pEraID)
		end
		attPlayer:ChangeOverflowResearch(HanSakaDamageBonus)
		if attPlayer:IsHuman() and HanSakaDamageBonus > 0 then
			local hex = ToHexFromGrid(Vector2(plotX,plotY))
			Events.AddPopupTextEvent(HexToWorld(hex), Locale.ConvertTextKey("[COLOR_RESEARCH_STORED]+{1_Num}[ENDCOLOR][ICON_RESEARCH]", HanSakaDamageBonus))
		end
	end

	-- 解忧
	if attUnit and attUnit:IsHasPromotion(HanSakaID) then
		if batType == GameInfoTypes["BATTLETYPE_MELEE"] then
			attUnit:ChangeDamage(-10)
		elseif batType == GameInfoTypes["BATTLETYPE_RANGED"] then
			attUnit:SetMoves(attUnit:MovesLeft() + GameDefines["MOVE_DENOMINATOR"] * 2)
			local hex = ToHexFromGrid(Vector2(attPlot:GetX(), attPlot:GetY()));
            Events.AddPopupTextEvent(HexToWorld(hex), Locale.ConvertTextKey("+{1_Num}[ICON_MOVES]", 2));
		end
 	end

end --function END

GameEvents.BattleFinished.Add(NewAttackEffect);