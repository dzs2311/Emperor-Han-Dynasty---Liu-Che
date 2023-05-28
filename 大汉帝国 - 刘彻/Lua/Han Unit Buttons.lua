include("FLuaVector.lua")
--------------------------------------------------------------
local HanChengYingID = GameInfo.UnitPromotions["PROMOTION_HAN_ELITE_MECH"].ID
--------------------------------------------------------------
local unitPromotionEmperorFlag = 0
--------------------------------------------------------------
-- 天子剑：轨道空投
--------------------------------------------------------------
local Han_Emperor_Button = {
	Name = "Han Transport",
	Title = "TXT_KEY_TITLE_HAN_EMPEROR",
	OrderPriority = 200,
	IconAtlas = "PROMOTION_ATLAS",
	PortraitIndex = 23,
	ToolTip = "TXT_KEY_COND_HAN_EMPEROR", -- or a TXT_KEY_ or a function

	Condition = function(action, unit)
		if unit:CanMove() and unit:IsHasPromotion(HanChengYingID)
		then
			return true
		end
	end, -- or nil or a boolean, default is true
	Disabled = function(action, unit)
        local player = Players[unit:GetOwner()];
		local plot = unit:GetPlot();
        if plot == nil 
        or not plot:IsCity()
        or unit:GetMoves() < unit:MaxMoves()
        then
            return true
        end
		return false
	end, -- or nil or a boolean, default is false
	Action = function(action, unit, eClick)
		if eClick == Mouse.eRClick then
			return
		end
		local player = Players[unit:GetOwner()];
		local plot = unit:GetPlot();
		local radius = 40;

		local unitCount = plot:GetNumUnits();
		local uniqueRange = radius;

		for dx = -uniqueRange, uniqueRange, 1 do
			for dy = -uniqueRange, uniqueRange, 1 do
				local adjPlot = Map.PlotXYWithRangeCheck(plot:GetX(), plot:GetY(), dx, dy, uniqueRange);
				if (adjPlot ~= nil) 
                and  adjPlot:GetNumUnits() == 0 
                and (not adjPlot:IsCity())
                then
					Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(adjPlot:GetX(), adjPlot:GetY())), true,
						Vector4(1, 0, 0, 1))
				end
			end
		end
		unitPromotionEmperorFlag = 1;
	end
}
LuaEvents.UnitPanelActionAddin(Han_Emperor_Button)

function Han_SetInputHandler(uiMsg, wParam, lParam)
	if unitPromotionEmperorFlag == 1 then
		if uiMsg == MouseEvents.LButtonDown then
			lButtonDown = true
			local pPlot = Map.GetPlot(UI.GetMouseOverHex());
			local pPlayer = Players[Game:GetActivePlayer()];
			local pSelUnit = UI.GetHeadSelectedUnit();
            local uniqueRange = 40
			if pSelUnit == nil then return end

			local selUnitPlot = pSelUnit:GetPlot();
            local distance = Map.PlotDistance(selUnitPlot:GetX(), selUnitPlot:GetY(), pPlot:GetX(), pPlot:GetY())

			if pSelUnit:IsHasPromotion(HanChengYingID)
			and distance <= uniqueRange and distance > 0 and pSelUnit:GetMoves() ~= 0 
			and  pPlot:GetNumUnits() == 0 
			and (not pPlot:IsCity())
			then
				pSelUnit:SetXY(pPlot:GetX(), pPlot:GetY());
                local hex = ToHexFromGrid(Vector2(pPlot:GetX(), pPlot:GetY()));
				Events.GameplayFX(hex.x, hex.y, -1);
				pSelUnit:SetMoves(0);
			end
			Events.ClearHexHighlights();
			unitPromotionEmperorFlag = 0
		elseif uiMsg == MouseEvents.LButtonUp then
			if lButtonDown then
				lButtonDown = false;
			end
		elseif uiMsg == MouseEvents.RButtonDown then
			rButtonDown = true;
		elseif uiMsg == MouseEvents.RButtonUp then
			if rButtonDown and unitPromotionEmperorFlag == 1 then
				rButtonDown = false;
				unitPromotionEmperorFlag = 0;
				Events.ClearHexHighlights();
			end
		end
	end
	return false;
end

ContextPtr:SetInputHandler(Han_SetInputHandler)