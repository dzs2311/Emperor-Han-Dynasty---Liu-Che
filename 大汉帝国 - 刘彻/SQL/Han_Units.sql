--==========================================================================================================================	
-- UnitClasses
--==========================================================================================================================
INSERT INTO UnitClasses
		(Type,								Description,						DefaultUnit)
VALUES	('UNITCLASS_HAN_CROSSBOWMAN',		'TXT_KEY_UNIT_HAN_CROSSBOWMAN',		'UNIT_HAN_CROSSBOWMAN');
--==========================================================================================================================	
-- 佽飞射士
--==========================================================================================================================
INSERT INTO Units 	
		(Type, 					Class, 							PrereqTech, RangedCombat,	Combat,	    	Range, ExtraMaintenanceCost,	Special, Cost, 	FaithCost,  HurryCostModifier, PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, Description,					Civilopedia,							Strategy,	Help,								Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech, XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass,  UnitArtInfo, 				UnitFlagIconOffset, UnitFlagAtlas,			PortraitIndex, 	IconAtlas)
SELECT	'UNIT_HAN_CROSSBOWMAN', 'UNITCLASS_HAN_CROSSBOWMAN', 	PrereqTech, RangedCombat+5,	RangedCombat+5,	Range, ExtraMaintenanceCost,	Special, -1,	FaithCost,  -1,                PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, 'TXT_KEY_UNIT_HAN_CROSSBOWMAN',	'TXT_KEY_CIV5_HAN_CROSSBOWMAN_TEXT', 	Strategy, 	'TXT_KEY_UNIT_HAN_CROSSBOWMAN_HELP', Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech, XPValueAttack, XPValueDefense, 'UNITCLASS_VOLLEY_GUN',    'ART_DEF_UNIT_SP_HAN_NU',	0,					'SP_HAN_NU_FLAG_ATLAS',	4,				'SP_HAN_ATLAS'
FROM Units WHERE Type = 'UNIT_COMPOSITE_BOWMAN';

INSERT INTO Unit_ClassUpgrades 	
		(UnitType, 					UnitClassType)
VALUES	('UNIT_HAN_CROSSBOWMAN',	'UNITCLASS_VOLLEY_GUN');

INSERT INTO Unit_FreePromotions
		(UnitType, 					PromotionType)
VALUES	('UNIT_HAN_CROSSBOWMAN', 	'PROMOTION_ARCHERY_COMBAT');
		
INSERT INTO Unit_BuildingClassRequireds 	
		(UnitType, 					BuildingClassType)
SELECT	'UNIT_HAN_CROSSBOWMAN',		BuildingClassType
FROM Unit_BuildingClassRequireds WHERE UnitType = 'UNIT_COMPOSITE_BOWMAN';

INSERT INTO UnitGameplay2DScripts 	
		(UnitType, 					SelectionSound, FirstSelectionSound)
SELECT	'UNIT_HAN_CROSSBOWMAN',		SelectionSound, FirstSelectionSound
FROM UnitGameplay2DScripts WHERE UnitType = 'UNIT_COMPOSITE_BOWMAN';

INSERT INTO Unit_AITypes 	
		(UnitType, 					UnitAIType)
SELECT	'UNIT_HAN_CROSSBOWMAN',		UnitAIType
FROM Unit_AITypes WHERE UnitType = 'UNIT_COMPOSITE_BOWMAN';

INSERT INTO Unit_Flavors 	
		(UnitType, 				   FlavorType, Flavor)
SELECT	'UNIT_HAN_CROSSBOWMAN',	   FlavorType, Flavor
FROM Unit_Flavors WHERE UnitType = 'UNIT_COMPOSITE_BOWMAN';	

INSERT INTO Unit_ResourceQuantityRequirements 	
		(UnitType, 				   ResourceType, Cost)
SELECT	'UNIT_HAN_CROSSBOWMAN',	   ResourceType, Cost
FROM Unit_ResourceQuantityRequirements WHERE UnitType = 'UNIT_COMPOSITE_BOWMAN';
--==========================================================================================================================	
-- 细柳营
--==========================================================================================================================
INSERT INTO Units 	
		(Type, 			    Class, 	PrereqTech,         RangedCombat,	Combat,	Range, ExtraMaintenanceCost,	Special, Cost, 	FaithCost,  HurryCostModifier, PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, Description,				Civilopedia,					Strategy,	Help,						    Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech,       XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass,  UnitArtInfo, 				UnitFlagIconOffset, UnitFlagAtlas,			PortraitIndex, 	IconAtlas)
SELECT	'UNIT_XILIUYING',   Class, 	'TECH_ENGINEERING', RangedCombat,	Combat,	Range, ExtraMaintenanceCost,	Special, Cost,	FaithCost,  HurryCostModifier, PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, 'TXT_KEY_UNIT_XILIUYING',	'TXT_KEY_CIV5_XILIUYING_TEXT', 	Strategy, 	'TXT_KEY_UNIT_XILIUYING_HELP',  Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, 'TECH_BALLISTICS',  XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass,  'ART_DEF_UNIT_SP_HAN_JI',	0,					'SP_HAN_JI_FLAG_ATLAS',	2,				'SP_HAN_ATLAS'
FROM Units WHERE Type = 'UNIT_PIKEMAN';

INSERT INTO Unit_ClassUpgrades 	
		(UnitType, 			UnitClassType)
VALUES	('UNIT_XILIUYING',	'UNITCLASS_TERCIO');

INSERT INTO Unit_FreePromotions
		(UnitType, 			PromotionType)
VALUES	('UNIT_XILIUYING', 	'PROMOTION_ANTI_MOUNTED'),
        ('UNIT_XILIUYING', 	'PROMOTION_HALF_CASUALTIES'),
        ('UNIT_XILIUYING', 	'PROMOTION_XILIUYING');
		
INSERT INTO Unit_BuildingClassRequireds 	
		(UnitType, 				BuildingClassType)
SELECT	'UNIT_XILIUYING',		BuildingClassType
FROM Unit_BuildingClassRequireds WHERE UnitType = 'UNIT_PIKEMAN';

INSERT INTO UnitGameplay2DScripts 	
		(UnitType, 				SelectionSound, FirstSelectionSound)
SELECT	'UNIT_XILIUYING',		SelectionSound, FirstSelectionSound
FROM UnitGameplay2DScripts WHERE UnitType = 'UNIT_PIKEMAN';

INSERT INTO Unit_AITypes 	
		(UnitType, 				UnitAIType)
SELECT	'UNIT_XILIUYING',		UnitAIType
FROM Unit_AITypes WHERE UnitType = 'UNIT_PIKEMAN';

INSERT INTO Unit_Flavors 	
		(UnitType, 			    FlavorType, Flavor)
SELECT	'UNIT_XILIUYING',	    FlavorType, Flavor
FROM Unit_Flavors WHERE UnitType = 'UNIT_PIKEMAN';	

INSERT INTO Unit_ResourceQuantityRequirements 	
		(UnitType, 			    ResourceType, Cost)
SELECT	'UNIT_XILIUYING',	    ResourceType, Cost
FROM Unit_ResourceQuantityRequirements WHERE UnitType = 'UNIT_PIKEMAN';
--==========================================================================================================================	
-- 冠军骠骑
--==========================================================================================================================
INSERT INTO Units 	
		(Type, 			    	Class, 	PrereqTech, RangedCombat,	Combat,		Range, ExtraMaintenanceCost,	Special, Cost, 	FaithCost,  HurryCostModifier, PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, Description,					Civilopedia,					Strategy,	Help,						   		 Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech,       XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass,  UnitArtInfo, 				UnitFlagIconOffset, UnitFlagAtlas,				PortraitIndex, 	IconAtlas)
SELECT	'UNIT_HUOQUBING_RIDER', Class, 	PrereqTech, RangedCombat,	Combat+6,	Range, ExtraMaintenanceCost,	Special, Cost,	FaithCost,  HurryCostModifier, PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, 'TXT_KEY_UNIT_HUOQUBING_RIDER',	'TXT_KEY_CIV5_XILIUYING_TEXT', 	Strategy, 	'TXT_KEY_UNIT_HUOQUBING_RIDER_HELP', Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, 'TECH_METALLURGY',  XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass,  'ART_DEF_UNIT_SP_HAN_RIDER',	0,					'SP_HAN_RIDER_FLAG_ATLAS',	3,				'SP_HAN_ATLAS'
FROM Units WHERE Type = 'UNIT_HORSEMAN';

INSERT INTO Unit_ClassUpgrades 	
		(UnitType, 					UnitClassType)
VALUES	('UNIT_HUOQUBING_RIDER',	'UNITCLASS_KNIGHT');

INSERT INTO Unit_FreePromotions
		(UnitType, 					PromotionType)
VALUES	('UNIT_HUOQUBING_RIDER', 	'PROMOTION_KNIGHT_COMBAT'),
        ('UNIT_HUOQUBING_RIDER', 	'PROMOTION_HUOQUBING_RIDER');
		
INSERT INTO Unit_BuildingClassRequireds 	
		(UnitType, 					BuildingClassType)
SELECT	'UNIT_HUOQUBING_RIDER',		BuildingClassType
FROM Unit_BuildingClassRequireds WHERE UnitType = 'UNIT_HORSEMAN';

INSERT INTO UnitGameplay2DScripts 	
		(UnitType, 					SelectionSound, FirstSelectionSound)
SELECT	'UNIT_HUOQUBING_RIDER',		SelectionSound, FirstSelectionSound
FROM UnitGameplay2DScripts WHERE UnitType = 'UNIT_HORSEMAN';

INSERT INTO Unit_AITypes 	
		(UnitType, 					UnitAIType)
SELECT	'UNIT_HUOQUBING_RIDER',		UnitAIType
FROM Unit_AITypes WHERE UnitType = 'UNIT_HORSEMAN';

INSERT INTO Unit_Flavors 	
		(UnitType, 			    	FlavorType, Flavor)
SELECT	'UNIT_HUOQUBING_RIDER',	    FlavorType, Flavor
FROM Unit_Flavors WHERE UnitType = 'UNIT_HORSEMAN';	

INSERT INTO Unit_ResourceQuantityRequirements 	
		(UnitType, 			    	ResourceType, Cost)
SELECT	'UNIT_HUOQUBING_RIDER',	    ResourceType, Cost
FROM Unit_ResourceQuantityRequirements WHERE UnitType = 'UNIT_HORSEMAN';
--==========================================================================================================================	
-- 乌孙弓骑兵
--==========================================================================================================================
--==========================================================================================================================	
-- 期门禁军
--==========================================================================================================================
--==========================================================================================================================	
-- 绝域轻骑
--==========================================================================================================================
--==========================================================================================================================	
-- 承影机甲
--==========================================================================================================================
--==========================================================================================================================	
-- 玄女战机
--==========================================================================================================================
