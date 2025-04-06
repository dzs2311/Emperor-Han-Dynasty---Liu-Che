-- Han Script
-- Author: dzs2311
-- DateCreated: 2023/5/20 17:58:37
--------------------------------------------------------------
include("FLuaVector.lua")
-- SP Code
include("UtilityFunctions")
--------------------------------------------------------------
local KnightID              = GameInfo.UnitPromotions["PROMOTION_KNIGHT_COMBAT"].ID
local TankID                = GameInfo.UnitPromotions["PROMOTION_TANK_COMBAT"].ID
local HelicopterUnitID      = GameInfo.UnitPromotions["PROMOTION_HELI_ATTACK"].ID
local HitAndRunUnitID       = GameInfo.UnitPromotions["PROMOTION_HITANDRUN"].ID
local HanInfantryID			= GameInfo.UnitPromotions['PROMOTION_XILIUYING'].ID
local HanNuID               = GameInfo.UnitPromotions["PROMOTION_HAN_CROSSBOWMAN"].ID
local HanRiderID            = GameInfo.UnitPromotions["PROMOTION_HUOQUBING_RIDER"].ID
local HanSakaID             = GameInfo.UnitPromotions["PROMOTION_HAN_VASSAL_MOUNTEDXBOW"].ID
local HanTraitLandID		= GameInfo.UnitPromotions["PROMOTION_SP_HAN_TRAIT_LAND"].ID
local HanEliteRiderID       = GameInfo.UnitPromotions["PROMOTION_HAN_ELITE_RIDER"].ID
local HanEliteRiderEffectID = GameInfo.UnitPromotions["PROMOTION_HAN_ELITE_RIDER_EFFECT"].ID
local HanEliteRider1ID      = GameInfo.UnitPromotions["PROMOTION_HAN_ELITE_RIDER1"].ID
local HanEliteRider2ID      = GameInfo.UnitPromotions["PROMOTION_HAN_ELITE_RIDER2"].ID
local HanXuanNvID			= GameInfo.UnitPromotions["PROMOTION_HAN_XUANNV"].ID
local HanEH1ID				= GameInfo.UnitPromotions["PROMOTION_HAN_HISTORY1"].ID
--------------------------------------------------------------
-- 文明过回合
--------------------------------------------------------------
-- function HanOnPlayerDoTurn(playerID)
-- 	local player = Players[playerID]

-- 	if player == nil or player:IsBarbarian() or player:IsMinorCiv() then
--     	return
-- 	end

-- 	local pEraType = player:GetCurrentEra()
-- 	local pEraID = GameInfo.Eras[pEraType].ID
-- 	local pCapital = player:GetCapitalCity()

-- end
-- GameEvents.PlayerDoTurn.Add(HanOnPlayerDoTurn)
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

        if attUnit:IsHasPromotion(HanTraitLandID)
        -- and attUnit:GetDomainType() == DomainTypes.DOMAIN_LAND
        and not attUnit:GetPlot():IsFriendlyTerritory(iAttackPlayerID)
        then
            -- 汉文明特性加成
            additionalDamage = additionalDamage + 5
			--冠军骠骑&期门禁军额外加成
			if attUnit:IsHasPromotion(HanRiderID) 
			or attUnit:IsHasPromotion(HanEliteRiderID)
			then
				additionalDamage = additionalDamage + 2.5
			end
        end

        if attUnit:IsHasPromotion(HanNuID) then
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
		return
	end

	local player = Players[playerID]
	local unit = Players[playerID]:GetUnitByID(unitID)
    local plot = Map.GetPlot(iPlotX, iPlotY)

    if unit:IsHasPromotion(HanNuID) then
        -- 佽飞射士彍强弩
        local plot = unit:GetPlot()
        if plot and plot:GetImprovementType() == GameInfo.Improvements["IMPROVEMENT_SP_HAN_POST"].ID then
            -- 驻扎于丝路驿站
            local unitCount = plot:GetNumUnits()
            local iGold = unit:GetMaxRangedCombatStrength() / 400
            player:ChangeGold(iGold)
            if player:IsHuman() then
                local hex = ToHexFromGrid(Vector2(unit:GetX(), unit:GetY()))
                Events.AddPopupTextEvent(HexToWorld(hex),
                    Locale.ConvertTextKey("[COLOR_YIELD_GOLD]+{1_Num}[ENDCOLOR][ICON_GOLD]", iGold))
            end
        elseif plot and plot:GetImprovementType() == GameInfo.Improvements["IMPROVEMENT_SP_HAN_FORT"].ID then
            -- 驻扎于汉塞
            unit:ChangeDamage(-5)
            local iCulture = unit:GetBaseRangedCombatStrength() / 10
            player:ChangeJONSCulture(iCulture)
            if player:IsHuman() then
                local hex = ToHexFromGrid(Vector2(unit:GetX(), unit:GetY()))
                Events.AddPopupTextEvent(HexToWorld(hex),
                    Locale.ConvertTextKey("[COLOR_MAGENTA]+{1_Num}[ENDCOLOR][ICON_CULTURE]", iCulture))
            end
        end
    end

	if unit:IsHasPromotion(HanSakaID) then
        -- 解忧
		local plot = unit:GetPlot()
        if plot and plot:GetImprovementType() == GameInfo.Improvements["IMPROVEMENT_SP_HAN_POST"].ID then
			unit:ChangeMoves(120)
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
		return
	end
	local unit = Players[ iPlayerID ]:GetUnitByID( iUnitID )
    local player = Players[iPlayerID]

	if unit:IsHasPromotion(HanRiderID) 
	and player:GetUnitClassCount(GameInfo.UnitClasses["UNITCLASS_HAN_VASSAL_MOUNTEDXBOW"].ID) > 0 
	then
		-- 解忧
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
function HanTeamMeetHook (eTeamMet, eTeamMoving)
	local pPlayerMoving
	for iPlayer = 0, GameDefines.MAX_CIV_PLAYERS - 1, 1 do
		local pPlayer = Players[iPlayer]
		if(pPlayer:GetTeam() == eTeamMoving) then
			pPlayerMoving = pPlayer
		end
	end
	
	local pPlayerMet
	for iPlayer = 0, GameDefines.MAX_CIV_PLAYERS - 1, 1 do
		local pPlayer = Players[iPlayer]
		if(pPlayer:GetTeam() == eTeamMet) then
			pPlayerMet = pPlayer
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
GameEvents.TeamMeet.Add(HanTeamMeetHook)
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
			local domainLandID = GameInfo.Domains["DOMAIN_LAND"].ID
			local LANDTotal =  capCity:GetFreeExperience() + capCity:GetDomainFreeExperience(domainLandID)
			NewUnit:ChangeExperience(LANDTotal)
		end
	end


end
GameEvents.PlayerCompletedQuest.Add(HanPlayerCompletedMinorCivQuest)
--------------------------------------------------------------
-- 乌孙弓骑兵攻击友方单位
--------------------------------------------------------------
function OnHanSakaCanRangeAttackAt(iPlayer, iUnit, iX, iY, bNeedWar)
	local pPlayer = Players[iPlayer]
	local pUnit = pPlayer:GetUnitByID(iUnit)
	local pUnitInfo = GameInfo.Units[pUnit:GetUnitType()]

	if pUnit:IsHasPromotion(HanSakaID)
	then
		local pPlot = Map.GetPlot(iX, iY)
		local ePlayer = nil
		local Range = pUnitInfo.Range

		local unitCount = pPlot:GetNumUnits()
		if Range > 0 and unitCount > 0 and pPlot ~= pUnit:GetPlot() then
			local pFoundUnit = pPlot:GetUnit(0)
			ePlayer = Players[pFoundUnit:GetOwner()]
			if ePlayer and not PlayersAtWar(ePlayer, pPlayer)
			then
				if pFoundUnit:GetOwner() ~= iPlayer then
					return true
				elseif pFoundUnit:GetOwner() == iPlayer and unitCount == 1 then
					return true
				end
			end
		end
	end

	return false
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
		local unitCount = pPlot:GetNumUnits()
		local iFaith = 0
		if unitCount > 0 then
			for i = 0, unitCount - 1, 1 do
				local pFoundUnit = pPlot:GetUnit(i)
				if pFoundUnit and pFoundUnit:GetBaseCombatStrength() > 0 then
					local iPrivateerDamage = pUnit:GetRangeCombatDamage(pFoundUnit, nil, false)
					iPrivateerDamage = math.min(pFoundUnit:GetCurrHitPoints() - 1, iPrivateerDamage)
					pFoundUnit:ChangeDamage(iPrivateerDamage)
					pUnit:ChangeExperience(pUnitInfo.XPValueAttack)
					iFaith = iFaith + math.ceil(math.log(2*iPrivateerDamage+1)) * (1 + pEraID)
				end
			end
		end
		pPlayer:ChangeFaith(iFaith)

		local hex = ToHexFromGrid(Vector2(iX, iY))
		Events.AddPopupTextEvent(HexToWorld(hex), Locale.ConvertTextKey("+{1_Num}[ICON_PEACE]",iFaith))
	end

	return 1
end
GameEvents.UnitRangeAttackAt.Add(OnHanSakaRangeAttackAt)
--------------------------------------------------------------
-- 单位作战效果
--------------------------------------------------------------
local g_DoNewAttackEffect = nil
function NewAttackEffectStarted(iType, iPlotX, iPlotY)
	if (PreGame.GetGameOption("GAMEOPTION_SP_NEWATTACK_OFF") == 1) then
		print("SP Attack Effect - OFF!")
		return
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
		}
	end
end

GameEvents.BattleStarted.Add(NewAttackEffectStarted)
-- local tCaptureSPUnits = {}
function NewAttackEffectJoined(iPlayer, iUnitOrCity, iRole, bIsCity)
	if g_DoNewAttackEffect == nil
		or Players[iPlayer] == nil or not Players[iPlayer]:IsAlive()
		or (not bIsCity and Players[iPlayer]:GetUnitByID(iUnitOrCity) == nil)
		or (bIsCity and (Players[iPlayer]:GetCityByID(iUnitOrCity) == nil or iRole == GameInfoTypes["BATTLEROLE_ATTACKER"]))
		or iRole == GameInfoTypes["BATTLEROLE_BYSTANDER"]
	then
		return
	end
	if bIsCity then
		g_DoNewAttackEffect.defPlayerID = iPlayer
		g_DoNewAttackEffect.defCityID = iUnitOrCity
		g_DoNewAttackEffect.bIsCity = bIsCity
	elseif iRole == GameInfoTypes["BATTLEROLE_ATTACKER"] then
		g_DoNewAttackEffect.attPlayerID = iPlayer
		g_DoNewAttackEffect.attUnitID = iUnitOrCity
		g_DoNewAttackEffect.attODamage = Players[iPlayer]:GetUnitByID(iUnitOrCity):GetDamage()
	elseif iRole == GameInfoTypes["BATTLEROLE_DEFENDER"] or iRole == GameInfoTypes["BATTLEROLE_INTERCEPTOR"] then
		g_DoNewAttackEffect.defPlayerID = iPlayer
		g_DoNewAttackEffect.defUnitID = iUnitOrCity
		g_DoNewAttackEffect.defODamage = Players[iPlayer]:GetUnitByID(iUnitOrCity):GetDamage()
	end
end

GameEvents.BattleJoined.Add(NewAttackEffectJoined)
function NewAttackEffect()
	--Defines and status checks
	if g_DoNewAttackEffect == nil or Players[g_DoNewAttackEffect.defPlayerID] == nil
		or Players[g_DoNewAttackEffect.attPlayerID] == nil or not Players[g_DoNewAttackEffect.attPlayerID]:IsAlive()
		or Players[g_DoNewAttackEffect.attPlayerID]:GetUnitByID(g_DoNewAttackEffect.attUnitID) == nil
		-- or Players[ g_DoNewAttackEffect.attPlayerID ]:GetUnitByID(g_DoNewAttackEffect.attUnitID):IsDead()
		or Map.GetPlot(g_DoNewAttackEffect.PlotX, g_DoNewAttackEffect.PlotY) == nil
	then
		return
	end

	local attPlayerID = g_DoNewAttackEffect.attPlayerID
	local attPlayer = Players[attPlayerID]
	local defPlayerID = g_DoNewAttackEffect.defPlayerID
	local defPlayer = Players[defPlayerID]

	local attUnit = attPlayer:GetUnitByID(g_DoNewAttackEffect.attUnitID)
	local attPlot = attUnit:GetPlot()

	local plotX = g_DoNewAttackEffect.PlotX
	local plotY = g_DoNewAttackEffect.PlotY
	local batPlot = Map.GetPlot(plotX, plotY)
	local batType = g_DoNewAttackEffect.battleType

	local bIsCity = g_DoNewAttackEffect.bIsCity
	local defUnit = nil
	local defPlot = nil
	local defCity = nil

	local attFinalUnitDamage = attUnit:GetDamage()
	local defFinalUnitDamage = 0
	local attUnitDamage = attFinalUnitDamage - g_DoNewAttackEffect.attODamage
	local defUnitDamage = 0

	if not bIsCity and defPlayer:GetUnitByID(g_DoNewAttackEffect.defUnitID) then
		defUnit = defPlayer:GetUnitByID(g_DoNewAttackEffect.defUnitID)
		defPlot = defUnit:GetPlot()
		defFinalUnitDamage = defUnit:GetDamage()
		defUnitDamage = defFinalUnitDamage - g_DoNewAttackEffect.defODamage
	elseif bIsCity and defPlayer:GetCityByID(g_DoNewAttackEffect.defCityID) then
		defCity = defPlayer:GetCityByID(g_DoNewAttackEffect.defCityID)
	end

	g_DoNewAttackEffect = nil

	--Complex Effects Only for Human VS AI(reduce time and enhance stability)
	-- if not attPlayer:IsHuman() and not defPlayer:IsHuman() then
	-- 	return
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
			HanSakaDamageBonus = math.ceil(math.log(2*defUnitDamage+1)) * (1 + pEraID)
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
			local hex = ToHexFromGrid(Vector2(attPlot:GetX(), attPlot:GetY()))
            Events.AddPopupTextEvent(HexToWorld(hex), Locale.ConvertTextKey("+{1_Num}[ICON_MOVES]", 2))
		end
 	end

	-- 六郡良家子
	if defUnit and attUnit then
		if defUnit:IsHasPromotion(HanEH1ID) and not defUnit:IsDead()
		and not attUnit:IsDead()
		and batType == GameInfoTypes["BATTLETYPE_MELEE"] 
		then
			attUnit:SetMoves(0)
		end
	end

end --function END

GameEvents.BattleFinished.Add(NewAttackEffect)
--------------------------------------------------------------
-- 单位升级
--------------------------------------------------------------
function HanUnitUpgraded(iPlayer, iOldUnit, iNewUnit)
	if Players[iPlayer] == nil or not Players[iPlayer]:IsAlive()
		or Players[iPlayer]:GetUnitByID(iOldUnit) == nil
		or Players[iPlayer]:GetUnitByID(iOldUnit):IsDead()
		or Players[iPlayer]:GetUnitByID(iOldUnit):IsDelayedDeath()
	then
		return
	end

	-- 解忧：乌孙弓骑兵保额外战斗力
	
	local pOldUnit 					= Players[iPlayer]:GetUnitByID(iOldUnit)
	local pNewUnit 					= Players[iPlayer]:GetUnitByID(iNewUnit)
	if pOldUnit:IsHasPromotion(HanSakaID) then
		local dCombatStrenghth 			= pOldUnit:GetBaseCombatStrength() - GameInfo.Units[pOldUnit:GetUnitType()].Combat
		local dRangedCombatStrenghth 	= pOldUnit:GetBaseRangedCombatStrength() - GameInfo.Units[pOldUnit:GetUnitType()].RangedCombat
		pNewUnit:SetBaseCombatStrength(pNewUnit:GetBaseCombatStrength() + dCombatStrenghth)
		pNewUnit:SetBaseRangedCombatStrength(pNewUnit:GetBaseRangedCombatStrength() + dRangedCombatStrenghth)
	end

end
GameEvents.UnitUpgraded.Add(HanUnitUpgraded)
--------------------------------------------------------------
-- 单位登陆
--------------------------------------------------------------
function HanUnitEmbark(iPlayerID, iUnitID)
	if Players[iPlayerID] == nil or Players[iPlayerID]:GetUnitByID(iUnitID) == nil
		or Players[iPlayerID]:GetUnitByID(iUnitID):IsEmbarked()
		or Players[iPlayerID]:GetUnitByID(iUnitID):IsDead()
		or Players[iPlayerID]:GetUnitByID(iUnitID):IsDelayedDeath()
	then
		return;
	end
	local pUnit = Players[iPlayerID]:GetUnitByID(iUnitID);
	if pUnit:IsHasPromotion(HanSakaID) then
		local dRangedCombatStrenghth = pUnit:GetBaseRangedCombatStrength() - GameInfo.Units[pUnit:GetUnitType()].RangedCombat
		pUnit:SetBaseCombatStrength(GameInfo.Units[pUnit:GetUnitType()].Combat + dRangedCombatStrenghth)
	end
end
Events.UnitEmbark.Add(HanUnitEmbark);
--------------------------------------------------------------
-- 战机转场
--------------------------------------------------------------
function HanCanRebaseInCity( iPlayerID, iUnitID, iPlotX, iPlotY)
	if Players[ iPlayerID ] == nil or not Players[ iPlayerID ]:IsAlive()
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ) == nil
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ):IsDead()
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ):IsDelayedDeath()
	then
		return
	end
	local cityPlot = Map.GetPlot(cityX, cityY)
	local pCity = cityPlot:GetPlotCity()
	if pCity == nil then return end

	local unit = Players[ iPlayerID ]:GetUnitByID( iUnitID )
    local player = Players[iPlayerID]

	if unit:IsHasPromotion(HanXuanNvID) 
	and pCity:GetOwner() == unit:GetOwner()
	then
		-- 九天玄女无限制转场
		return true;
	end
end
GameEvents.CanRebaseInCity.Add(HanCanRebaseInCity)

function HanRebaseTo( iPlayerID, iUnitID, iPlotX, iPlotY)
	if Players[ iPlayerID ] == nil or not Players[ iPlayerID ]:IsAlive()
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ) == nil
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ):IsDead()
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ):IsDelayedDeath()
	then
		return
	end

	local unit = Players[ iPlayerID ]:GetUnitByID( iUnitID )
    local player = Players[iPlayerID]

	if unit:IsHasPromotion(HanXuanNvID) 
	then
		-- 九天玄女转场回复全部移动力
		local move_denominator = GameDefines["MOVE_DENOMINATOR"]
		local max_moves = unit:MaxMoves() / move_denominator
		unit:SetMoves(max_moves * move_denominator)
	end
end
GameEvents.RebaseTo.Add(HanRebaseTo)
--==========================================================================================================================
-- CanHavePromotion EVENTS
--==========================================================================================================================
function HanCanHavePromotion(iPlayer, iUnit, iPromotionType)
	local player = Players[iPlayer]; -----获取player
	if player == nil then return end
	if (not player:IsAlive()) then return end
	if player:IsBarbarian() or player:IsMinorCiv() then return end

	local pUnit = Players[iPlayer]:GetUnitByID(iUnit);

	-- 期门禁军互斥晋升
	if iPromotionType == GameInfoTypes.PROMOTION_HAN_ELITE_RIDER1 
	and pUnit:IsHasPromotion(HanEliteRider2ID)
	then
		return false;
	end

	if iPromotionType == GameInfoTypes.PROMOTION_HAN_ELITE_RIDER2
	and pUnit:IsHasPromotion(HanEliteRider1ID)
	then
		return false;
	end

	return true;
end

GameEvents.CanHavePromotion.Add(HanCanHavePromotion)
--------------------------------------------------------------
-- 光环效果
--------------------------------------------------------------
-- 遍历某单位(pUnit)附近单位，判断其是否拥有晋升A，若有则给与当前单位晋升B，没有则去掉当前单位晋升B
--------------------------------------------------------------
function plotDistancePromotion(pPlayer, pUnit, unitPromotionAID, unitPromotionBID, radius, pFlag)
	local Patronage = 0;
	if pFlag then 
		for sUnit in pPlayer:Units() do
			if sUnit:IsHasPromotion(unitPromotionAID) then
				if Map.PlotDistance(pUnit:GetX(), pUnit:GetY(), sUnit:GetX(), sUnit:GetY()) < radius + 1 then -- 人类2格
					Patronage = 1;
					break;
				end
			end
		end			
		if Patronage == 1 then
			if not pUnit:IsHasPromotion(unitPromotionBID) then
				pUnit:SetHasPromotion(unitPromotionBID, true)
			end
		else
			if pUnit:IsHasPromotion(unitPromotionBID) and not pUnit:IsHasPromotion(unitPromotionAID) then
				pUnit:SetHasPromotion(unitPromotionBID, false)
			end
		end		
	else
		if pUnit:IsHasPromotion(unitPromotionBID) and not pUnit:IsHasPromotion(unitPromotionAID) then
			pUnit:SetHasPromotion(unitPromotionBID, false)
		end
	end

end

function SPUE_Unit_Effect_UnitSetXY(playerID)
	local pPlayer                = Players[playerID]

	-- 期门禁军
	if pPlayer:GetUnitCountFromHasPromotion() > 0 then
		for pUnit in pPlayer:Units() do
			-- local Patronage = 0;
			local pFlag = false;
			if (pUnit:IsHasPromotion(KnightID) or pUnit:IsHasPromotion(TankID))
			and not pUnit:IsHasPromotion(HanEliteRiderID)
			then
				pFlag = true
			end
			plotDistancePromotion(pPlayer, pUnit, HanEliteRiderID, HanEliteRiderEffectID, 3, pFlag)
		end
	end
end
GameEvents.UnitSetXY.Add(SPUE_Unit_Effect_UnitSetXY)
GameEvents.UnitCreated.Add(SPUE_Unit_Effect_UnitSetXY)
--------------------------------------------------------------
-- 单位命名
--------------------------------------------------------------
function SetEliteUnitName( iPlayerID, iUnitID )
	if Players[ iPlayerID ] == nil or not Players[ iPlayerID ]:IsAlive()
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ) == nil
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ):IsDead()
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ):IsDelayedDeath()
	or Players[ iPlayerID ]:GetUnitByID( iUnitID ):HasName()
	then
		return;
	end

	local pUnit = Players[ iPlayerID ]:GetUnitByID( iUnitID );

	-- 期门禁军特殊命名
	if pUnit:IsHasPromotion(HanEliteRider1ID) and pUnit:GetUnitType() ~= GameInfoTypes.UNIT_HAN_ELITE_RIDER
	then
		pUnit:SetName("TXT_KEY_UNIT_HAN_ELITE_RIDER1_NAME");
	elseif pUnit:IsHasPromotion(HanEliteRider2ID) and pUnit:GetUnitType() ~= GameInfoTypes.UNIT_HAN_ELITE_RIDER
	then
		pUnit:SetName("TXT_KEY_UNIT_HAN_ELITE_RIDER2_NAME");
	elseif pUnit:IsHasPromotion(HanEliteRiderID) and pUnit:GetUnitType() ~= GameInfoTypes.UNIT_HAN_ELITE_RIDER
	then
		pUnit:SetName("TXT_KEY_UNIT_HAN_ELITE_RIDER");
	end

end
Events.SerialEventUnitCreated.Add(SetEliteUnitName)
--==========================================================================================================================
-- UB：都护府
--==========================================================================================================================
--------------------------------------------------------------
-- 统计文明的城邦盟友及各城邦盟友的人口数量\关系\单位数\单元格数
--------------------------------------------------------------
function Han_AllyCityStateData(playerID)
	local g_MinorCivsAndPopWithMajor = {};

	local player = Players[playerID];

	if (not player:IsAlive()) then return end;
	if player:IsMinorCiv() or player:GetMinorAllyCount() < 1 then return false end
	local index = 1;
	if not (player:IsMinorCiv() or player:IsBarbarian()) then
		for iCS = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_PLAYERS-2, 1 do
			if  Players[iCS]:IsAlive() and Players[iCS]:IsMinorCiv()
			and Players[iCS]:GetAlly() ~= -1 and Players[Players[iCS]:GetAlly()]:IsAlive()
			and Players[iCS]:GetAlly() == playerID
			then
				local CityPop = Players[iCS]:GetTotalPopulation()
				local iFriendShip = Players[iCS]:GetMinorCivFriendshipWithMajor(playerID)
				local numUnits = Players[iCS]:GetNumUnits()
				local numPlots = Players[iCS]:GetNumPlots()
				g_MinorCivsAndPopWithMajor[index] = {iCS, CityPop, iFriendShip, numUnits, numPlots}
				index = index + 1
			end
		end
		if index == 1 then
			return false
		end
	end

	return g_MinorCivsAndPopWithMajor;
end
--------------------------------------------------------------
-- 都护府建造城市限制
--------------------------------------------------------------
function HanUB(iPlayer, iCity, iBuilding)
	if (iBuilding == GameInfoTypes.BUILDING_DUHU) then
		-- 都护府不能在首都建造，且附近需要有城邦
		local pPlayer = Players[iPlayer]
		local pCity = pPlayer:GetCityByID(iCity)
		local bNearCityState = false
		if not pCity:IsCapital() then
			for iCS = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_PLAYERS-2, 1 do
				if  Players[iCS]:IsAlive() and Players[iCS]:IsMinorCiv()
				then
					local csPlot = Map.GetPlot(Players[iCS]:GetCapitalCity():GetX(),Players[iCS]:GetCapitalCity():GetY())
					local distanceToCity = Map.PlotDistance(pCity:GetX(), pCity:GetY(), csPlot:GetX(), csPlot:GetY())
					if distanceToCity <= 8 then
						-- 城邦首都处于该城市8格内
						bNearCityState = true
						break
					end
				end
			end
		end
		return bNearCityState
	end
	return true
end
GameEvents.CityCanConstruct.Add(HanUB)
--------------------------------------------------------------
-- 统计盟友城邦数量、总人口、总单位数
--------------------------------------------------------------
function HanCountCityStatesData(iPlayer)
	local player = Players[iPlayer]
	local g_Allies = {}

	if player:GetMinorAllyCount() > 0 then
		local g_MinorCivsAndPopWithMajor = Han_AllyCityStateData(iPlayer);
		local numAllies = player:GetMinorAllyCount()
		local pops = 0
		local numUnits = 0
		
		for i = 1, #g_MinorCivsAndPopWithMajor, 1 do
			pops = pops + g_MinorCivsAndPopWithMajor[i][2]
			numUnits = numUnits + g_MinorCivsAndPopWithMajor[i][4]
		end
		g_Allies = {numAllies, pops, numUnits}
	else
		return false
	end

	return g_Allies
end
function HanCityDoInstantYieldFromCityState(iPlayer, iCity)
	local player = Players[iPlayer]
	local city = player:GetCityByID(iCity)
	local g_Allies = HanCountCityStatesData(iPlayer)
	local pEraType = player:GetCurrentEra()
	local pEraID = GameInfo.Eras[pEraType].ID
	-- local totalCultureBonus = 0

	local cultureBonus = g_Allies[1] * (1 + pEraID)
	local foodBonus = math.ceil(math.log(g_Allies[2]+1)) * (1 + pEraID)
	local productionBonus = math.ceil(math.log(g_Allies[3]+1)) * (1 + pEraID)

	player:ChangeJONSCulture(cultureBonus)
	city:ChangeFood(foodBonus)
	city:SetOverflowProduction(city:GetOverflowProduction() + productionBonus)
	if player:IsHuman() then
        local hex = ToHexFromGrid(Vector2(city:GetX(), city:GetY()));
        Events.AddPopupTextEvent(HexToWorld(hex), 
            Locale.ConvertTextKey(
				"[COLOR_MAGENTA]+{1_Num}[ENDCOLOR][ICON_CULTURE][NEWLINE][COLOR_YIELD_FOOD]+{2_Num}[ENDCOLOR][ICON_FOOD][NEWLINE][COLOR_CITY_BROWN]+{3_Num}[ENDCOLOR][ICON_PRODUCTION]", 
				cultureBonus, foodBonus, productionBonus))
	end
end

function HanCityProcessCompleted(iPlayer, iCity)
	local player = Players[iPlayer]
	if player == nil or not player:IsMajorCiv() then
	 	return
	end
	local city = player:GetCityByID(iCity)

	if city:IsHasBuilding(GameInfoTypes["BUILDING_DUHU"]) and player:GetMinorAllyCount() > 0 then
		HanCityDoInstantYieldFromCityState(iPlayer, iCity)
	end
end
-- GameEvents.CityTrained.Add(HanCityProcessCompleted)
GameEvents.CityConstructed.Add(HanCityProcessCompleted)
GameEvents.CityBoughtPlot.Add(HanCityProcessCompleted)
