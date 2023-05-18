--==========================================================================================================================	
-- Improvements
--==========================================================================================================================	
INSERT INTO Improvements
		(Type,							SpecificCivRequired,	CivilizationType,			AdditionalUnits,	NearbyEnemyDamage,	DefenseModifier,	PillageGold,	OutsideBorders,	IgnoreOwnership,	LuxuryCopiesSiphonedFromMinor,	Description,							Help,										Civilopedia,								ArtDefineTag,						PortraitIndex,	IconAtlas)
VALUES	('IMPROVEMENT_SP_HAN_POST',	    1,						'CIVILIZATION_SP_HAN',	    0,					0,					50,					100,			1,				1,					1,								'TXT_KEY_IMPROVEMENT_SP_HAN_POST',	    'TXT_KEY_IMPROVEMENT_SP_HAN_POST_HELP',	    'TXT_KEY_IMPROVEMENT_SP_HAN_POST_HELP',	    'ART_DEF_IMPROVEMENT_SP_HAN_POST', 	11,				'SP_HAN_ATLAS'),
		('IMPROVEMENT_SP_HAN_FORT',	    0,						null,						0,					5,					75,					150,			1,				1,					1,								'TXT_KEY_IMPROVEMENT_SP_HAN_FORT',	    'TXT_KEY_IMPROVEMENT_SP_HAN_FORT_HELP',	    'TXT_KEY_IMPROVEMENT_SP_HAN_FORT_HELP',	    'ART_DEF_IMPROVEMENT_SP_HAN_FORT', 	14,				'SP_HAN_ATLAS');
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
-- Improvement_Yields
--==========================================================================================================================	
INSERT INTO Improvement_Yields
		(ImprovementType,				YieldType,			Yield)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'YIELD_FOOD',		1),
		('IMPROVEMENT_SP_HAN_POST',		'YIELD_PRODUCTION',	1),
		('IMPROVEMENT_SP_HAN_POST',		'YIELD_GOLD',		-1),

		('IMPROVEMENT_SP_HAN_FORT',		'YIELD_FOOD',		2),
		('IMPROVEMENT_SP_HAN_FORT',		'YIELD_PRODUCTION',	2),
		('IMPROVEMENT_SP_HAN_FORT',		'YIELD_GOLD',		-2);
--==========================================================================================================================	
-- Improvement_RiverSideYields
--==========================================================================================================================	
INSERT INTO Improvement_RiverSideYields
		(ImprovementType,				YieldType,			Yield)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'YIELD_GOLD',		1),
		('IMPROVEMENT_SP_HAN_POST',		'YIELD_FOOD',		1),

		('IMPROVEMENT_SP_HAN_FORT',		'YIELD_GOLD',		2),
		('IMPROVEMENT_SP_HAN_FORT',		'YIELD_FOOD',		2);
--==========================================================================================================================	
-- Improvement_RouteYieldChanges
--==========================================================================================================================	
INSERT INTO Improvement_RouteYieldChanges
		(ImprovementType,				RouteType,			YieldType,			Yield)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'ROUTE_ROAD',		'YIELD_GOLD',		1),
		('IMPROVEMENT_SP_HAN_POST',		'ROUTE_RAILROAD',	'YIELD_GOLD',		2),

		('IMPROVEMENT_SP_HAN_FORT',		'ROUTE_ROAD',		'YIELD_GOLD',		2),
		('IMPROVEMENT_SP_HAN_FORT',		'ROUTE_RAILROAD',	'YIELD_GOLD',		4);
--==========================================================================================================================	
-- Improvement_AdjacentMountainYieldChanges
--==========================================================================================================================	
INSERT INTO Improvement_AdjacentMountainYieldChanges
		(ImprovementType,				YieldType,				Yield)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'YIELD_PRODUCTION',		1),
		('IMPROVEMENT_SP_HAN_POST',		'YIELD_SCIENCE',		1),

		('IMPROVEMENT_SP_HAN_FORT',		'YIELD_PRODUCTION',		2),
		('IMPROVEMENT_SP_HAN_FORT',		'YIELD_SCIENCE',		2);
--==========================================================================================================================	
-- Improvement_AdjacentImprovementYieldChanges
--==========================================================================================================================	
INSERT INTO Improvement_AdjacentImprovementYieldChanges 
		(ImprovementType,			OtherImprovementType,	YieldType, 		Yield)
VALUES	('IMPROVEMENT_SP_HAN_POST',	'IMPROVEMENT_FARM',		'YIELD_FOOD',	1),
		('IMPROVEMENT_SP_HAN_POST',	'IMPROVEMENT_FARM',		'YIELD_GOLD',	1),

		('IMPROVEMENT_SP_HAN_FORT',	'IMPROVEMENT_FARM',		'YIELD_FOOD',	2),
		('IMPROVEMENT_SP_HAN_FORT',	'IMPROVEMENT_FARM',		'YIELD_GOLD',	2);
--==========================================================================================================================	
-- Improvement_ResourceTypes
--==========================================================================================================================	
INSERT INTO Improvement_ResourceTypes
		(ImprovementType,				ResourceType)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'RESOURCE_IRON'),
		('IMPROVEMENT_SP_HAN_POST',		'RESOURCE_HORSE'),
		('IMPROVEMENT_SP_HAN_POST',		'RESOURCE_TEA'),
		('IMPROVEMENT_SP_HAN_POST',		'RESOURCE_GOLD'),
		('IMPROVEMENT_SP_HAN_POST',		'RESOURCE_SALT'),
		
		('IMPROVEMENT_SP_HAN_FORT',		'RESOURCE_IRON'),
		('IMPROVEMENT_SP_HAN_FORT',		'RESOURCE_HORSE'),
		('IMPROVEMENT_SP_HAN_FORT',		'RESOURCE_TEA'),
		('IMPROVEMENT_SP_HAN_FORT',		'RESOURCE_GOLD'),
		('IMPROVEMENT_SP_HAN_FORT',		'RESOURCE_SALT');
--==========================================================================================================================	
-- Improvement_TechYieldChanges
--==========================================================================================================================
INSERT INTO Improvement_TechYieldChanges
		(ImprovementType,				TechType,				YieldType,				Yield)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'TECH_CIVIL_SERVICE',	'YIELD_FOOD',			1),
		('IMPROVEMENT_SP_HAN_POST',		'TECH_CHIVALRY',		'YIELD_PRODUCTION',		1),
		('IMPROVEMENT_SP_HAN_POST',		'TECH_ADMINISTRATION',	'YIELD_GOLD',			1),
		('IMPROVEMENT_SP_HAN_POST',		'TECH_THEOLOGY',		'YIELD_FAITH',			1),
		('IMPROVEMENT_SP_HAN_POST',		'TECH_ARCHAEOLOGY',		'YIELD_CULTURE',		1),

		('IMPROVEMENT_SP_HAN_FORT',		'TECH_CIVIL_SERVICE',	'YIELD_FOOD',			2),
		('IMPROVEMENT_SP_HAN_FORT',		'TECH_CHIVALRY',		'YIELD_PRODUCTION',		2),
		('IMPROVEMENT_SP_HAN_FORT',		'TECH_ADMINISTRATION',	'YIELD_GOLD',			2),
		('IMPROVEMENT_SP_HAN_FORT',		'TECH_THEOLOGY',		'YIELD_FAITH',			2),
		('IMPROVEMENT_SP_HAN_FORT',		'TECH_ARCHAEOLOGY',		'YIELD_CULTURE',		2);
--==========================================================================================================================	
-- Improvement_TechYieldChanges
--==========================================================================================================================
INSERT INTO Policy_ImprovementYieldChanges
		(ImprovementType,				PolicyType,						YieldType,			Yield)
VALUES	('IMPROVEMENT_SP_HAN_POST',		'POLICY_TRADITION_FINISHER',	'YIELD_FOOD',		1),
		('IMPROVEMENT_SP_HAN_POST',		'POLICY_COMMERCE_FINISHER',		'YIELD_GOLD',		1),
		('IMPROVEMENT_SP_HAN_POST',		'POLICY_PIETY_FINISHER',		'YIELD_FAITH',		1),

		('IMPROVEMENT_SP_HAN_FORT',		'POLICY_TRADITION_FINISHER',	'YIELD_FOOD',		2),
		('IMPROVEMENT_SP_HAN_FORT',		'POLICY_COMMERCE_FINISHER',		'YIELD_GOLD',		2),
		('IMPROVEMENT_SP_HAN_FORT',		'POLICY_PIETY_FINISHER',		'YIELD_FAITH',		2);
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
		(Type,					PrereqTech,				ImprovementType, 			Time, Recommendation,					Description,					Help,									OrderPriority,	IconIndex,	IconAtlas,			EntityEvent)
VALUES	('BUILD_SP_HAN_POST',	'TECH_CONSTRUCTION',	'IMPROVEMENT_SP_HAN_POST',	500,  'TXT_KEY_BUILD_SP_HAN_POST_REC', 	'TXT_KEY_BUILD_SP_HAN_POST',	'TXT_KEY_IMPROVEMENT_SP_HAN_POST_HELP',	96,				0,			'SP_HAN_UI_ATLAS',	'ENTITY_EVENT_BUILD'),
        ('BUILD_SP_HAN_FORT',	'TECH_CONSTRUCTION',	'IMPROVEMENT_SP_HAN_FORT',	500,  'TXT_KEY_BUILD_SP_HAN_FORT_REC', 	'TXT_KEY_BUILD_SP_HAN_FORT',	'TXT_KEY_IMPROVEMENT_SP_HAN_FORT_HELP',	96,				1,			'SP_HAN_UI_ATLAS',	'ENTITY_EVENT_BUILD');
--==========================================================================================================================	
-- BuildFeatures
--==========================================================================================================================	
INSERT INTO BuildFeatures
		(BuildType,					FeatureType,		PrereqTech,				Time,	Remove)
VALUES	('BUILD_SP_HAN_POST',		'FEATURE_JUNGLE',	'TECH_BRONZE_WORKING',	400,	1),
		('BUILD_SP_HAN_POST',		'FEATURE_FOREST',	'TECH_BRONZE_WORKING',	100,	1);
--==========================================================================================================================	
-- Unit_Builds
--==========================================================================================================================	
INSERT INTO Unit_Builds
		(UnitType,			BuildType)
VALUES	('UNIT_WORKER',		'BUILD_SP_HAN_POST');