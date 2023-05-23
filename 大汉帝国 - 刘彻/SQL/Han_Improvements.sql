--==========================================================================================================================	
-- Improvements
--==========================================================================================================================	
INSERT INTO Improvements
		(Type,							SpecificCivRequired,	CivilizationType,			NoTwoAdjacent,	NearbyFriendHeal,	InAdjacentFriendly,	AdditionalUnits,	NearbyEnemyDamage,	DefenseModifier,	PillageGold,	Description,							Help,										Civilopedia,								ArtDefineTag,						PortraitIndex,	IconAtlas)
VALUES	('IMPROVEMENT_SP_HAN_POST',	    1,						'CIVILIZATION_SP_HAN',	    1,				1,					0,					0,					0,					25,					200,			'TXT_KEY_IMPROVEMENT_SP_HAN_POST',	    'TXT_KEY_IMPROVEMENT_SP_HAN_POST_HELP',	    'TXT_KEY_IMPROVEMENT_SP_HAN_POST_HELP',	    'ART_DEF_IMPROVEMENT_SP_HAN_POST', 	11,				'SP_HAN_ATLAS'),
		('IMPROVEMENT_SP_HAN_FORT',	    0,						null,						1,				0,					1,					1,					10,					50,					50,				'TXT_KEY_IMPROVEMENT_SP_HAN_FORT',	    'TXT_KEY_IMPROVEMENT_SP_HAN_FORT_HELP',	    'TXT_KEY_IMPROVEMENT_SP_HAN_FORT_HELP',	    'ART_DEF_IMPROVEMENT_SP_HAN_FORT', 	14,				'SP_HAN_ATLAS');
--==========================================================================================================================	
-- Improvement_ValidTerrains
--==========================================================================================================================	
INSERT INTO Improvement_ValidTerrains
		(ImprovementType,				TerrainType)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'TERRAIN_GRASS'),
		('IMPROVEMENT_SP_HAN_POST',		'TERRAIN_TUNDRA'),
		('IMPROVEMENT_SP_HAN_POST',		'TERRAIN_DESERT'),
		('IMPROVEMENT_SP_HAN_POST',		'TERRAIN_SNOW'),
		('IMPROVEMENT_SP_HAN_POST',		'TERRAIN_PLAINS'),

		('IMPROVEMENT_SP_HAN_FORT',		'TERRAIN_GRASS'),
		('IMPROVEMENT_SP_HAN_FORT',		'TERRAIN_TUNDRA'),
		('IMPROVEMENT_SP_HAN_FORT',		'TERRAIN_DESERT'),
		('IMPROVEMENT_SP_HAN_FORT',		'TERRAIN_SNOW'),
		('IMPROVEMENT_SP_HAN_FORT',		'TERRAIN_PLAINS');		
--==========================================================================================================================	
-- Improvement_ValidFeatures
--==========================================================================================================================	
INSERT INTO Improvement_ValidFeatures
		(ImprovementType,				FeatureType)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'FEATURE_JUNGLE'),
		('IMPROVEMENT_SP_HAN_POST',		'FEATURE_OASIS');
--==========================================================================================================================	
-- Improvement_Yields
--==========================================================================================================================	
INSERT INTO Improvement_Yields
		(ImprovementType,				YieldType,			Yield)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'YIELD_CULTURE',	1),
		('IMPROVEMENT_SP_HAN_POST',		'YIELD_PRODUCTION',	1);
--==========================================================================================================================	
-- Improvement_RiverSideYields
--==========================================================================================================================	
INSERT INTO Improvement_RiverSideYields
		(ImprovementType,				YieldType,			Yield)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'YIELD_GOLD',		1),
		('IMPROVEMENT_SP_HAN_POST',		'YIELD_FOOD',		1);
--==========================================================================================================================	
-- Improvement_RouteYieldChanges
--==========================================================================================================================	
INSERT INTO Improvement_RouteYieldChanges
		(ImprovementType,				RouteType,			YieldType,			Yield)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'ROUTE_ROAD',		'YIELD_CULTURE',	1),
		('IMPROVEMENT_SP_HAN_POST',		'ROUTE_RAILROAD',	'YIELD_CULTURE',	2),

		('IMPROVEMENT_SP_HAN_FORT',		'ROUTE_ROAD',		'YIELD_PRODUCTION',	1),
		('IMPROVEMENT_SP_HAN_FORT',		'ROUTE_RAILROAD',	'YIELD_PRODUCTION',	2);
--==========================================================================================================================	
-- Improvement_TradeRouteYieldChanges
--==========================================================================================================================	
INSERT INTO Improvement_TradeRouteYieldChanges
		(ImprovementType,				DomainType,			YieldType,			Yield)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'DOMAIN_LAND',		'YIELD_CULTURE',	1),
		('IMPROVEMENT_SP_HAN_POST',		'DOMAIN_LAND',		'YIELD_GOLD',		1);
--==========================================================================================================================	
-- Improvement_TechYieldChanges
--==========================================================================================================================
INSERT INTO Improvement_TechYieldChanges
		(ImprovementType,				TechType,				YieldType,				Yield)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'TECH_CIVIL_SERVICE',	'YIELD_FOOD',			1),
		('IMPROVEMENT_SP_HAN_POST',		'TECH_ARCHAEOLOGY',		'YIELD_CULTURE',		1),

		('IMPROVEMENT_SP_HAN_FORT',		'TECH_CHIVALRY',		'YIELD_PRODUCTION',		1),
		('IMPROVEMENT_SP_HAN_FORT',		'TECH_THEOLOGY',		'YIELD_FAITH',			1);

INSERT INTO Improvement_TechYieldChanges
		(ImprovementType,				TechType, 				YieldType, 				Yield)
SELECT 	 'IMPROVEMENT_SP_HAN_POST',		TechType, 				YieldType, 				Yield
FROM Improvement_TechYieldChanges WHERE ImprovementType = 'IMPROVEMENT_TRADING_POST' AND Yield > 0;
--==========================================================================================================================	
-- Policy_ImprovementYieldChanges
--==========================================================================================================================
INSERT INTO Policy_ImprovementYieldChanges
		(ImprovementType,				PolicyType,				YieldType,				Yield)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'POLICY_TRADITION',		'YIELD_FOOD',			1),
		('IMPROVEMENT_SP_HAN_POST',		'POLICY_COMMERCE',		'YIELD_GOLD',			1),
		('IMPROVEMENT_SP_HAN_POST',		'POLICY_HONOR',			'YIELD_PRODUCTION',		1),

		('IMPROVEMENT_SP_HAN_FORT',		'POLICY_TRADITION',		'YIELD_CULTURE',		1),
		('IMPROVEMENT_SP_HAN_FORT',		'POLICY_HONOR',			'YIELD_PRODUCTION',		1);

INSERT INTO Policy_ImprovementYieldChanges
		(ImprovementType,				PolicyType,				YieldType,				Yield)
SELECT 	 'IMPROVEMENT_SP_HAN_POST',		PolicyType, 			YieldType, 				Yield
FROM Policy_ImprovementYieldChanges WHERE ImprovementType = 'IMPROVEMENT_TRADING_POST' AND Yield > 0;
--==========================================================================================================================	
-- Improvement_Flavors
--==========================================================================================================================	
INSERT INTO Improvement_Flavors
		(ImprovementType,				FlavorType,					Flavor)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'FLAVOR_TILE_IMPROVEMENT',	40),
		('IMPROVEMENT_SP_HAN_POST',		'FLAVOR_DEFENSE',			40),
		('IMPROVEMENT_SP_HAN_POST',		'FLAVOR_GROWTH',			20),
		('IMPROVEMENT_SP_HAN_POST',		'FLAVOR_GOLD',				20),
		('IMPROVEMENT_SP_HAN_POST',		'FLAVOR_PRODUCTION',		20),

		('IMPROVEMENT_SP_HAN_FORT',		'FLAVOR_TILE_IMPROVEMENT',	40),
		('IMPROVEMENT_SP_HAN_FORT',		'FLAVOR_DEFENSE',			40),
		('IMPROVEMENT_SP_HAN_FORT',		'FLAVOR_GROWTH',			20),
		('IMPROVEMENT_SP_HAN_FORT',		'FLAVOR_GOLD',				20),
		('IMPROVEMENT_SP_HAN_FORT',		'FLAVOR_PRODUCTION',		20);
--==========================================================================================================================	
-- Builds
--==========================================================================================================================	
INSERT INTO Builds
		(Type,					PrereqTech,					ImprovementType, 			Time, Recommendation,					Description,					Help,									OrderPriority,	IconIndex,	IconAtlas,			EntityEvent)
VALUES	('BUILD_SP_HAN_POST',	'TECH_ANIMAL_HUSBANDRY',	'IMPROVEMENT_SP_HAN_POST',	500,  'TXT_KEY_BUILD_SP_HAN_POST_REC', 	'TXT_KEY_BUILD_SP_HAN_POST',	'TXT_KEY_IMPROVEMENT_SP_HAN_POST_HELP',	96,				0,			'SP_HAN_UI_ATLAS',	'ENTITY_EVENT_BUILD'),
        ('BUILD_SP_HAN_FORT',	'TECH_CONSTRUCTION',		'IMPROVEMENT_SP_HAN_FORT',	400,  'TXT_KEY_BUILD_SP_HAN_FORT_REC', 	'TXT_KEY_BUILD_SP_HAN_FORT',	'TXT_KEY_IMPROVEMENT_SP_HAN_FORT_HELP',	96,				1,			'SP_HAN_UI_ATLAS',	'ENTITY_EVENT_BUILD');
--==========================================================================================================================	
-- BuildFeatures
-- --==========================================================================================================================	
INSERT INTO BuildFeatures
		(BuildType,					FeatureType,		PrereqTech,				Time,	Remove)
VALUES	('BUILD_SP_HAN_FORT',		'FEATURE_JUNGLE',	'TECH_BRONZE_WORKING',	200,	1),
		('BUILD_SP_HAN_FORT',		'FEATURE_FOREST',	'TECH_BRONZE_WORKING',	200,	1);
--==========================================================================================================================	
-- Unit_Builds
--==========================================================================================================================	
INSERT INTO Unit_Builds
		(UnitType,						BuildType)
VALUES	('UNIT_WORKER',					'BUILD_SP_HAN_POST'),
		('UNIT_HAN_CROSSBOWMAN',		'BUILD_SP_HAN_FORT'),
		('UNIT_XILIUYING',				'BUILD_SP_HAN_FORT'),
		('UNIT_HUOQUBING_RIDER',		'BUILD_SP_HAN_FORT'),
		('UNIT_HAN_VASSAL_MOUNTEDXBOW',	'BUILD_SP_HAN_FORT');