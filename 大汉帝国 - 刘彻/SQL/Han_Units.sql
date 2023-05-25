--==========================================================================================================================	
-- 佽飞射士
--==========================================================================================================================
INSERT INTO UnitClasses
		(Type,								Description,						DefaultUnit)
VALUES	('UNITCLASS_HAN_CROSSBOWMAN',		'TXT_KEY_UNIT_HAN_CROSSBOWMAN',		'UNIT_HAN_CROSSBOWMAN');

INSERT INTO Units 	
		(Type, 					Class, 							WorkRate,	PrereqTech, RangedCombat,	Combat,	    	Range, ExtraMaintenanceCost,	Special, Cost, 	FaithCost,  HurryCostModifier, PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, Description,					Civilopedia,							Strategy,	Help,								Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech, XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass,  UnitArtInfo, 				UnitFlagIconOffset, UnitFlagAtlas,			PortraitIndex, 	IconAtlas)
SELECT	'UNIT_HAN_CROSSBOWMAN', 'UNITCLASS_HAN_CROSSBOWMAN', 	100,		PrereqTech, RangedCombat+5,	RangedCombat+5,	Range, ExtraMaintenanceCost,	Special, -1,	FaithCost,  -1,                PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, 'TXT_KEY_UNIT_HAN_CROSSBOWMAN',	'TXT_KEY_CIV5_HAN_CROSSBOWMAN_TEXT', 	Strategy, 	'TXT_KEY_UNIT_HAN_CROSSBOWMAN_HELP', Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech, XPValueAttack, XPValueDefense, 'UNITCLASS_VOLLEY_GUN',    'ART_DEF_UNIT_SP_HAN_NU',	0,					'SP_HAN_NU_FLAG_ATLAS',	4,				'SP_HAN_ATLAS'
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
		(Type, 			    Class, 	WorkRate,	PrereqTech,         RangedCombat,	Combat,	Range, ExtraMaintenanceCost,	Special, Cost, 	FaithCost,  HurryCostModifier, PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, Description,				Civilopedia,					Strategy,	Help,						    Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech,       XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass,  UnitArtInfo, 				UnitFlagIconOffset, UnitFlagAtlas,			PortraitIndex, 	IconAtlas)
SELECT	'UNIT_XILIUYING',   Class, 	100,		'TECH_ENGINEERING', RangedCombat,	Combat,	Range, ExtraMaintenanceCost,	Special, Cost,	FaithCost,  HurryCostModifier, PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, 'TXT_KEY_UNIT_XILIUYING',	'TXT_KEY_CIV5_XILIUYING_TEXT', 	Strategy, 	'TXT_KEY_UNIT_XILIUYING_HELP',  Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, 'TECH_BALLISTICS',  XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass,  'ART_DEF_UNIT_SP_HAN_JI',	0,					'SP_HAN_JI_FLAG_ATLAS',	2,				'SP_HAN_ATLAS'
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
		(Type, 			    	Class, 	WorkRate,	PrereqTech, RangedCombat,	Combat,		Range, ExtraMaintenanceCost,	Special, Cost, 	FaithCost,  HurryCostModifier, PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, Description,					Civilopedia,							Strategy,	Help,						   		 Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech,       XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass,  UnitArtInfo, 				UnitFlagIconOffset, UnitFlagAtlas,				PortraitIndex, 	IconAtlas)
SELECT	'UNIT_HUOQUBING_RIDER', Class, 	100,		PrereqTech, RangedCombat,	Combat+6,	Range, ExtraMaintenanceCost,	Special, Cost,	FaithCost,  HurryCostModifier, PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, 'TXT_KEY_UNIT_HUOQUBING_RIDER',	'TXT_KEY_CIV5_HUOQUBING_RIDER_TEXT', 	Strategy, 	'TXT_KEY_UNIT_HUOQUBING_RIDER_HELP', Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, 'TECH_METALLURGY',  XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass,  'ART_DEF_UNIT_SP_HAN_RIDER',	0,					'SP_HAN_RIDER_FLAG_ATLAS',	3,				'SP_HAN_ATLAS'
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
INSERT INTO UnitClasses
		(Type,										Description,								DefaultUnit)			
VALUES	('UNITCLASS_HAN_VASSAL_MOUNTEDXBOW',		'TXT_KEY_UNIT_HAN_VASSAL_MOUNTEDXBOW',		'UNIT_HAN_VASSAL_MOUNTEDXBOW');

INSERT INTO Units 	
		(Type, 							Class, 									WorkRate,	PrereqTech, 	RangedCombat,	Combat,		Range, ExtraMaintenanceCost,	Special, Cost,	FaithCost,  HurryCostModifier, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, Description,							Civilopedia,									Strategy,	Help,											Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech, XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass, 	UnitArtInfo, 				UnitFlagIconOffset, UnitFlagAtlas,				PortraitIndex, 	IconAtlas,			NoMinorGifts)
SELECT	'UNIT_HAN_VASSAL_MOUNTEDXBOW', 	'UNITCLASS_HAN_VASSAL_MOUNTEDXBOW', 	100,		PrereqTech, 	RangedCombat,	Combat,	 	Range, ExtraMaintenanceCost,	Special, Cost, 	FaithCost, 	HurryCostModifier, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, 'TXT_KEY_UNIT_HAN_VASSAL_MOUNTEDXBOW',	'TXT_KEY_CIV5_HAN_VASSAL_MOUNTEDXBOW_TEXT', 	Strategy, 	'TXT_KEY_UNIT_HAN_VASSAL_MOUNTEDXBOW_HELP', 	Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech, XPValueAttack, XPValueDefense, 'UNITCLASS_BOMBARD', 		'ART_DEF_UNIT_SP_HAN_SAKA',	0,					'SP_HAN_WUSUN_FLAG_ATLAS',	7,				'SP_HAN_ATLAS',		1
FROM Units WHERE Type = 'UNIT_MEDIEVAL_CHARIOT';

INSERT INTO Unit_ClassUpgrades 	
		(UnitType, 							UnitClassType)
VALUES	('UNIT_HAN_VASSAL_MOUNTEDXBOW',		'UNITCLASS_BOMBARD');
		
INSERT INTO Unit_FreePromotions
		(UnitType, 							PromotionType)
VALUES	('UNIT_HAN_VASSAL_MOUNTEDXBOW', 	'PROMOTION_HITANDRUN'),
		('UNIT_HAN_VASSAL_MOUNTEDXBOW', 	'PROMOTION_HAN_VASSAL_MOUNTEDXBOW'),
		('UNIT_HAN_VASSAL_MOUNTEDXBOW', 	'PROMOTION_NO_CASUALTIES');
		
INSERT INTO Unit_BuildingClassRequireds 	
		(UnitType, 				 	 		BuildingClassType)
SELECT	'UNIT_HAN_VASSAL_MOUNTEDXBOW',	 	BuildingClassType
FROM Unit_BuildingClassRequireds WHERE UnitType = 'UNIT_MEDIEVAL_CHARIOT';

INSERT INTO UnitGameplay2DScripts 	
		(UnitType, 				    	SelectionSound, FirstSelectionSound)
SELECT	'UNIT_HAN_VASSAL_MOUNTEDXBOW', 	SelectionSound, FirstSelectionSound
FROM UnitGameplay2DScripts WHERE UnitType = 'UNIT_HAN_MOUNTEDXBOW';

INSERT INTO Unit_AITypes 	
		(UnitType, 				 	  		UnitAIType)
SELECT	'UNIT_HAN_VASSAL_MOUNTEDXBOW',   	UnitAIType
FROM Unit_AITypes WHERE UnitType = 'UNIT_HAN_MOUNTEDXBOW';

INSERT INTO Unit_Flavors 	
		(UnitType, 						   	FlavorType, Flavor)
SELECT	'UNIT_HAN_VASSAL_MOUNTEDXBOW',  	FlavorType, Flavor
FROM Unit_Flavors WHERE UnitType = 'UNIT_HAN_MOUNTEDXBOW';	

INSERT INTO Unit_ResourceQuantityRequirements 	
		(UnitType, 				 	 		ResourceType, Cost)
SELECT	'UNIT_HAN_VASSAL_MOUNTEDXBOW',	 	ResourceType, Cost
FROM Unit_ResourceQuantityRequirements WHERE UnitType = 'UNIT_MEDIEVAL_CHARIOT';
--==========================================================================================================================	
-- 期门禁军
--==========================================================================================================================
INSERT INTO UnitClasses
		(Type,								Description,						DefaultUnit,				MaxPlayerInstances)
VALUES	('UNITCLASS_HAN_ELITE_RIDER',		'TXT_KEY_UNIT_HAN_ELITE_RIDER',		'UNIT_HAN_ELITE_RIDER',		1);

INSERT INTO Units 	
		(Type, 			    	Class, 							ProjectPrereq,						PrereqTech, RangedCombat,	Combat,	Range, ExtraMaintenanceCost,	Special, Cost, 	FaithCost,  HurryCostModifier, PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, Description,					Civilopedia,							Strategy,	Help,						   		 Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech,       XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass,  UnitArtInfo, 						UnitFlagIconOffset, UnitFlagAtlas,				PortraitIndex, 	IconAtlas)
SELECT	'UNIT_HAN_ELITE_RIDER', 'UNITCLASS_HAN_ELITE_RIDER', 	'PROJECT_HAN_ELITE_RIDER_TRAINING',	PrereqTech, RangedCombat,	Combat,	Range, ExtraMaintenanceCost,	Special, Cost,	FaithCost,  HurryCostModifier, PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, 'TXT_KEY_UNIT_HAN_ELITE_RIDER',	'TXT_KEY_CIV5_HAN_ELITE_RIDER_TEXT', 	Strategy, 	'TXT_KEY_UNIT_HAN_ELITE_RIDER_HELP', Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, 'TECH_METALLURGY',  XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass,  'ART_DEF_UNIT_SP_HAN_ELITE_RIDER',	0,					'SP_HAN_ERIDER_FLAG_ATLAS',	5,				'SP_HAN_ATLAS'
FROM Units WHERE Type = 'UNIT_ELITE_RIDER';

INSERT INTO Unit_ClassUpgrades 	
		(UnitType, 					UnitClassType)
VALUES	('UNIT_HAN_ELITE_RIDER',	'UNITCLASS_LANCER');

INSERT INTO Unit_FreePromotions
		(UnitType, 					PromotionType)
VALUES	('UNIT_HAN_ELITE_RIDER', 	'PROMOTION_KNIGHT_COMBAT'),
        ('UNIT_HAN_ELITE_RIDER', 	'PROMOTION_HUOQUBING_RIDER'),
		('UNIT_HAN_ELITE_RIDER', 	'PROMOTION_HAN_ELITE_RIDER');
		
INSERT INTO Unit_BuildingClassRequireds 	
		(UnitType, 					BuildingClassType)
SELECT	'UNIT_HAN_ELITE_RIDER',		BuildingClassType
FROM Unit_BuildingClassRequireds WHERE UnitType = 'UNIT_ELITE_RIDER';

INSERT INTO UnitGameplay2DScripts 	
		(UnitType, 					SelectionSound, FirstSelectionSound)
SELECT	'UNIT_HAN_ELITE_RIDER',		SelectionSound, FirstSelectionSound
FROM UnitGameplay2DScripts WHERE UnitType = 'UNIT_ELITE_RIDER';

INSERT INTO Unit_AITypes 	
		(UnitType, 					UnitAIType)
SELECT	'UNIT_HAN_ELITE_RIDER',		UnitAIType
FROM Unit_AITypes WHERE UnitType = 'UNIT_ELITE_RIDER';

INSERT INTO Unit_Flavors 	
		(UnitType, 			    	FlavorType, Flavor)
SELECT	'UNIT_HAN_ELITE_RIDER',	    FlavorType, Flavor
FROM Unit_Flavors WHERE UnitType = 'UNIT_ELITE_RIDER';	

INSERT INTO Unit_ResourceQuantityRequirements 	
		(UnitType, 			    	ResourceType, Cost)
SELECT	'UNIT_HAN_ELITE_RIDER',	    ResourceType, Cost
FROM Unit_ResourceQuantityRequirements WHERE UnitType = 'UNIT_ELITE_RIDER';
--==========================================================================================================================	
-- 承影机甲
--==========================================================================================================================
INSERT INTO UnitClasses
		(Type,								Description,						DefaultUnit,				MaxPlayerInstances)
VALUES	('UNITCLASS_HAN_ELITE_MECH',		'TXT_KEY_UNIT_HAN_ELITE_MECH',		'UNIT_HAN_ELITE_MECH',		1);

INSERT INTO Units 	
		(Type, 			    	Class, 							ProjectPrereq,						PrereqTech, RangedCombat,	Combat,	Range, ExtraMaintenanceCost,	Special, Cost, 	FaithCost,  HurryCostModifier, PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, Description,					Civilopedia,							Strategy,	Help,						   		Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech,  XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass,  UnitArtInfo, 						UnitFlagIconOffset, UnitFlagAtlas,				PortraitIndex, 	IconAtlas)
SELECT	'UNIT_HAN_ELITE_MECH', 	'UNITCLASS_HAN_ELITE_MECH', 	'PROJECT_HAN_ELITE_MECH_TRAINING',	PrereqTech, RangedCombat,	Combat,	Range, ExtraMaintenanceCost,	Special, Cost,	FaithCost,  HurryCostModifier, PurchaseOnly, RequiresFaithPurchaseEnabled, Moves,   MoveAfterPurchase,	CombatClass, Domain, DefaultUnitAI, 'TXT_KEY_UNIT_HAN_ELITE_MECH',	'TXT_KEY_CIV5_HAN_ELITE_MECH_TEXT', 	Strategy, 	'TXT_KEY_UNIT_HAN_ELITE_MECH_HELP', Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech,  XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass,  'ART_DEF_UNIT_SP_HAN_CHENGYING',	0,					'SP_HAN_NTM_FLAG_ATLAS',	12,				'SP_HAN_ATLAS'
FROM Units WHERE Type = 'UNIT_MECH';


INSERT INTO Unit_FreePromotions	
		(UnitType, 				PromotionType)
SELECT	'UNIT_HAN_ELITE_MECH',  PromotionType
FROM Unit_FreePromotions WHERE UnitType = 'UNIT_MECH';

INSERT INTO Unit_FreePromotions
		(UnitType, 					PromotionType)
VALUES	('UNIT_HAN_ELITE_MECH', 	'PROMOTION_HAN_ELITE_MECH');
		
INSERT INTO Unit_BuildingClassRequireds 	
		(UnitType, 					BuildingClassType)
SELECT	'UNIT_HAN_ELITE_MECH',		BuildingClassType
FROM Unit_BuildingClassRequireds WHERE UnitType = 'UNIT_MECH';

INSERT INTO UnitGameplay2DScripts 	
		(UnitType, 					SelectionSound, FirstSelectionSound)
SELECT	'UNIT_HAN_ELITE_MECH',		SelectionSound, FirstSelectionSound
FROM UnitGameplay2DScripts WHERE UnitType = 'UNIT_MECH';

INSERT INTO Unit_AITypes 	
		(UnitType, 					UnitAIType)
SELECT	'UNIT_HAN_ELITE_MECH',		UnitAIType
FROM Unit_AITypes WHERE UnitType = 'UNIT_MECH';

INSERT INTO Unit_Flavors 	
		(UnitType, 			    	FlavorType, Flavor)
SELECT	'UNIT_HAN_ELITE_MECH',	    FlavorType, Flavor
FROM Unit_Flavors WHERE UnitType = 'UNIT_MECH';	

INSERT INTO Unit_ResourceQuantityRequirements 	
		(UnitType, 			    	ResourceType, Cost)
SELECT	'UNIT_HAN_ELITE_MECH',	    ResourceType, Cost
FROM Unit_ResourceQuantityRequirements WHERE UnitType = 'UNIT_MECH';
--==========================================================================================================================	
-- 玄女战机
--==========================================================================================================================
INSERT INTO UnitClasses
		(Type,							Description,					DefaultUnit,			MaxPlayerInstances)
VALUES	('UNITCLASS_HAN_XUANNV',		'TXT_KEY_UNIT_HAN_XUANNV',		'UNIT_HAN_XUANNV',		3);
 
INSERT INTO Units 	
		(Type, 						Class,						ProjectPrereq,						PrereqTech, RangedCombat,	Combat,		Range,	AirInterceptRange, Immobile,	AirUnitCap,	ExtraMaintenanceCost,	Special, Cost, 		FaithCost, HurryCostModifier, 	RequiresFaithPurchaseEnabled, Moves,	CombatClass, Domain, DefaultUnitAI, Description,					Civilopedia,							Strategy, Help,									Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech, XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass, UnitArtInfo,						UnitFlagIconOffset, UnitFlagAtlas,				PortraitIndex, 	IconAtlas)
SELECT	'UNIT_HAN_XUANNV', 			'UNITCLASS_HAN_XUANNV', 	'PROJECT_HAN_ELITE_MECH_TRAINING',	PrereqTech, RangedCombat,	Combat,	    Range,	AirInterceptRange, Immobile,	AirUnitCap,	ExtraMaintenanceCost,	Special, Cost, 		FaithCost, -1,					RequiresFaithPurchaseEnabled, Moves,   	CombatClass, Domain, DefaultUnitAI, 'TXT_KEY_UNIT_HAN_XUANNV',		'TXT_KEY_CIV5_HAN_XUANNV_TEXT', 		Strategy, 'TXT_KEY_UNIT_HAN_XUANNV_HELP', 		Pillage, MilitarySupport, MilitaryProduction, IgnoreBuildingDefense, Mechanized, AdvancedStartCost, RangedCombatLimit, CombatLimit, ObsoleteTech, XPValueAttack, XPValueDefense, GoodyHutUpgradeUnitClass, 'ART_DEF_UNIT_SP_HAN_XUANNV',	0,					'SP_HAN_NTM_FLAG_ATLAS',	13,				'SP_HAN_ATLAS'
FROM Units WHERE Type = 'UNIT_INTERCEPTER';

INSERT INTO Unit_FreePromotions	
		(UnitType, 				PromotionType)
SELECT	'UNIT_HAN_XUANNV',  	PromotionType
FROM Unit_FreePromotions WHERE UnitType = 'UNIT_INTERCEPTER';

INSERT INTO Unit_FreePromotions
		(UnitType, 					PromotionType)
VALUES	('UNIT_HAN_XUANNV', 		'PROMOTION_HAN_XUANNV');

INSERT INTO Unit_BuildingClassRequireds 	
		(UnitType, 				BuildingClassType)
SELECT	'UNIT_HAN_XUANNV',  	BuildingClassType
FROM Unit_BuildingClassRequireds WHERE UnitType = 'UNIT_INTERCEPTER';

INSERT INTO UnitGameplay2DScripts 	
		(UnitType, 			SelectionSound, FirstSelectionSound)
SELECT	'UNIT_HAN_XUANNV',  SelectionSound, FirstSelectionSound
FROM UnitGameplay2DScripts WHERE UnitType = 'UNIT_INTERCEPTER';

INSERT INTO Unit_AITypes 	
		(UnitType, 			UnitAIType)
SELECT	'UNIT_HAN_XUANNV',  UnitAIType
FROM Unit_AITypes WHERE UnitType = 'UNIT_INTERCEPTER';

INSERT INTO Unit_Flavors 	
		(UnitType, 			FlavorType, Flavor)
SELECT	'UNIT_HAN_XUANNV',  FlavorType, Flavor
FROM Unit_Flavors WHERE UnitType = 'UNIT_INTERCEPTER';	

INSERT INTO Unit_ResourceQuantityRequirements 	
		(UnitType, 			ResourceType, Cost)
SELECT	'UNIT_HAN_XUANNV',  ResourceType, Cost
FROM Unit_ResourceQuantityRequirements WHERE UnitType = 'UNIT_INTERCEPTER';