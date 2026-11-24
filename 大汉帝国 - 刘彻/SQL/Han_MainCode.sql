UPDATE SPTriggerControler SET Enabled = 1 WHERE TriggerType = 'SPNDeleteALLUnitStrategicFlag';
UPDATE SPNewEffectControler SET Enabled = 1 WHERE Type = 'SP_DELETE_ALL_STRATEGIC_UNIT_FLAG';

UPDATE CustomModOptions SET Value = 1 WHERE Name = 'EVENTS_UNIT_UPGRADES';				-- 开启单位升级事件
UPDATE CustomModOptions SET Value = 1 WHERE Name = 'EVENTS_BATTLES_CUSTOM_DAMAGE';		-- 开启单位减伤事件
UPDATE CustomModOptions SET Value = 1 WHERE Name = 'EVENTS_UNIT_CREATED';				-- 开启单位产生事件
UPDATE CustomModOptions SET Value = 1 WHERE Name = 'IMPROVEMENTS_UPGRADE';				-- 开启设施升级事件
UPDATE CustomModOptions SET Value = 1 WHERE Name = 'PROMOTION_SPLASH_DAMAGE';			-- 开启单位溅射
UPDATE CustomModOptions SET Value = 1 WHERE Name = 'PROMOTION_COLLATERAL_DAMAGE';		-- 开启单位穿透
UPDATE CustomModOptions SET Value = 1 WHERE Name = 'ROG_CORE';							-- 开启单位强权效果
UPDATE CustomModOptions SET Value = 1 WHERE Name = 'EVENTS_UNIT_DO_TURN';				-- 开启单位过回合事件
UPDATE CustomModOptions SET Value = 1 WHERE Name = 'GLOBAL_EXCLUDE_FROM_GIFTS';			-- 开启城邦赠送豁免
UPDATE CustomModOptions SET Value = 1 WHERE Name = 'EVENTS_UNIT_RANGEATTACK';			-- 开启单位远程攻击事件
UPDATE CustomModOptions SET Value = 1 WHERE Name = 'IMPROVEMENT_TRADE_ROUTE_BONUSES';	-- 开启设施商路加成
UPDATE CustomModOptions SET Value = 1 WHERE Name = 'DEFENSE_MOVES_BONUS';				-- 开启移动力防御加成
UPDATE CustomModOptions SET Value = 1 WHERE Name = 'PROMOTIONS_EXTRARES_BONUS';			-- 开启资源/笑脸加成
UPDATE CustomModOptions SET Value = 1 WHERE Name = 'EVENTS_REBASE';						-- 开启飞机转场事件
UPDATE CustomModOptions SET Value = 1 WHERE Name = 'PROMOTION_AURA_PROMOTION';			-- 开启光环
--==========================================================================================================================
-- Civilizations
--==========================================================================================================================
INSERT INTO Civilizations 	
			(Type, 						Description, 					ShortDescription, 				    Adjective, 							CivilopediaTag, 			DefaultPlayerColor,		ArtDefineTag, ArtStyleType, ArtStyleSuffix, ArtStylePrefix, IconAtlas,		    AlphaIconAtlas, 		 PortraitIndex,	SoundtrackTag, 	MapImage, 			DawnOfManQuote, 					DawnOfManImage)
SELECT		('CIVILIZATION_SP_HAN'), 	('TXT_KEY_CIV_SP_HAN_DESC'), 	('TXT_KEY_CIV_SP_HAN_SHORT_DESC'),  ('TXT_KEY_CIV_SP_HAN_ADJECTIVE'), 	('TXT_KEY_CIV5_SP_HAN'), 	('PLAYERCOLOR_SP_HAN'), ArtDefineTag, ArtStyleType, ArtStyleSuffix, ArtStylePrefix, ('SP_HAN_ATLAS'),   ('SP_HAN_ALPHA_ATLAS'),  0, 			('CHINA'),	 	('MapHan512.dds'), 	('TXT_KEY_CIV5_DOM_SP_HAN_TEXT'),   ('Dom_Han.dds')
FROM Civilizations WHERE Type = 'CIVILIZATION_CHINA';
--==========================================================================================================================	
-- Civilization_BuildingClassOverrides
--==========================================================================================================================	
INSERT INTO	Civilization_BuildingClassOverrides
			(CivilizationType,			BuildingClassType,						BuildingType)
VALUES		('CIVILIZATION_SP_HAN',		'BUILDINGCLASS_DUHU_DUMMY',				'BUILDING_DUHU'),			-- 驿传
			('CIVILIZATION_SP_HAN',		'BUILDINGCLASS_NATIONAL_LIBRARY',		'BUILDING_TAIXUE'),			-- 太学
			('CIVILIZATION_SP_HAN',		'BUILDINGCLASS_GARDEN',					'BUILDING_HAN_GARDEN');		-- 上林苑
--==========================================================================================================================
-- Civilization_CityNames
--==========================================================================================================================		
INSERT INTO Civilization_CityNames 
			(CivilizationType, 				CityName)
VALUES		('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_00'),
            ('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_01'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_02'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_03'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_04'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_05'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_06'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_07'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_08'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_09'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_10'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_11'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_12'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_13'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_14'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_15'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_16'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_17'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_18'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_19'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_20'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_21'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_22'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_23'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_24'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_25'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_26'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_27'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_28'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_29'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_30'),
            ('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_31'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_32'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_33'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_34'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_35'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_36'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_37'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_38'),
			('CIVILIZATION_SP_HAN', 		'TXT_KEY_CITY_NAME_SP_HAN_39');
--==========================================================================================================================
-- Civilization_FreeBuildingClasses
--==========================================================================================================================		
INSERT INTO Civilization_FreeBuildingClasses 
			(CivilizationType, 				BuildingClassType)
VALUES		('CIVILIZATION_SP_HAN', 		'BUILDINGCLASS_PALACE');
--==========================================================================================================================
-- Civilization_FreeTechs
--==========================================================================================================================	
INSERT INTO Civilization_FreeTechs 
			(CivilizationType, 			TechType)
VALUES		('CIVILIZATION_SP_HAN',	    'TECH_AGRICULTURE'),
			('CIVILIZATION_SP_HAN',	    'TECH_BRONZE_WORKING');
--==========================================================================================================================
-- Civilization_FreeUnits
--==========================================================================================================================	
INSERT INTO Civilization_FreeUnits 
			(CivilizationType, 			UnitClassType, Count, UnitAIType)
SELECT		('CIVILIZATION_SP_HAN'), 	UnitClassType, Count, UnitAIType
FROM Civilization_FreeUnits WHERE CivilizationType = 'CIVILIZATION_CHINA';
--==========================================================================================================================
-- Civilization_Leaders
--==========================================================================================================================		
INSERT INTO Civilization_Leaders 
			(CivilizationType, 			LeaderheadType)
VALUES		('CIVILIZATION_SP_HAN', 	'LEADER_SP_LIUCHE');
--==========================================================================================================================
-- Civilization_UnitClassOverrides 
--==========================================================================================================================	
INSERT INTO Civilization_UnitClassOverrides 
			(CivilizationType, 			UnitClassType, 				UnitType)
VALUES		('CIVILIZATION_SP_HAN', 	'UNITCLASS_PIKEMAN',		'UNIT_XILIUYING'),
			('CIVILIZATION_SP_HAN', 	'UNITCLASS_HORSEMAN',		'UNIT_HUOQUBING_RIDER');
--==========================================================================================================================
-- Civilization_Religions
--==========================================================================================================================	
INSERT INTO Civilization_Religions 
			(CivilizationType, 			ReligionType)
VALUES		('CIVILIZATION_SP_HAN', 	'RELIGION_CONFUCIANISM');
--==========================================================================================================================
-- Civilization_SpyNames
--==========================================================================================================================	
INSERT INTO Civilization_SpyNames 
			(CivilizationType, 			SpyName)
VALUES		('CIVILIZATION_SP_HAN', 	'TXT_KEY_SPY_NAME_SP_HAN_0'),	
			('CIVILIZATION_SP_HAN', 	'TXT_KEY_SPY_NAME_SP_HAN_1'),
			('CIVILIZATION_SP_HAN', 	'TXT_KEY_SPY_NAME_SP_HAN_2'),
			('CIVILIZATION_SP_HAN', 	'TXT_KEY_SPY_NAME_SP_HAN_3'),
			('CIVILIZATION_SP_HAN', 	'TXT_KEY_SPY_NAME_SP_HAN_4'),
			('CIVILIZATION_SP_HAN', 	'TXT_KEY_SPY_NAME_SP_HAN_5'),
			('CIVILIZATION_SP_HAN', 	'TXT_KEY_SPY_NAME_SP_HAN_6'),
			('CIVILIZATION_SP_HAN', 	'TXT_KEY_SPY_NAME_SP_HAN_7'),
			('CIVILIZATION_SP_HAN', 	'TXT_KEY_SPY_NAME_SP_HAN_8'),
			('CIVILIZATION_SP_HAN', 	'TXT_KEY_SPY_NAME_SP_HAN_9'),
            ('CIVILIZATION_SP_HAN', 	'TXT_KEY_SPY_NAME_SP_HAN_9'),
            ('CIVILIZATION_SP_HAN', 	'TXT_KEY_SPY_NAME_SP_HAN_10'),
            ('CIVILIZATION_SP_HAN', 	'TXT_KEY_SPY_NAME_SP_HAN_11');
--==========================================================================================================================
-- Civilization_Start_Region_Priority
--==========================================================================================================================	
INSERT INTO Civilization_Start_Along_River 
			(CivilizationType, 			StartAlongRiver)
VALUES		('CIVILIZATION_SP_HAN', 	1);	
INSERT INTO Civilization_Start_Along_Ocean
			(CivilizationType, 			StartAlongOcean)
VALUES		('CIVILIZATION_SP_HAN', 	1);
--==========================================================================================================================	
-- Colors
--==========================================================================================================================		
INSERT INTO Colors 
			(Type, 										Red, 	Green, 	Blue, 	Alpha)
VALUES		('COLOR_PLAYER_SP_HAN_ICON',				0.839,	0.651,	0.208,	1),
			('COLOR_PLAYER_SP_HAN_BACKGROUND',		    0.467,	0.100,	0.100,	1);
--==========================================================================================================================	
-- PlayerColors
--==========================================================================================================================				
INSERT INTO PlayerColors 
			(Type, 							PrimaryColor, 						SecondaryColor, 							TextColor)
VALUES		('PLAYERCOLOR_SP_HAN',			'COLOR_PLAYER_SP_HAN_ICON', 		'COLOR_PLAYER_SP_HAN_BACKGROUND', 			'COLOR_PLAYER_WHITE_TEXT'); 
--==========================================================================================================================	
-- Leaders
--==========================================================================================================================			
INSERT INTO Leaders 
			(Type, 						Description, 						Civilopedia, 							 CivilopediaTag, 					ArtDefineTag, 			VictoryCompetitiveness, WonderCompetitiveness, 	MinorCivCompetitiveness, 	Boldness, 	DiploBalance, 	WarmongerHate, 	DenounceWillingness, 	DoFWillingness, Loyalty, 	Neediness, 	Forgiveness, 	Chattiness, Meanness, 	IconAtlas, 			PortraitIndex)
VALUES		('LEADER_SP_LIUCHE', 		'TXT_KEY_LEADER_SP_LIUCHE', 		'TXT_KEY_LEADER_SP_LIUCHE_PEDIA_TEXT',  'TXT_KEY_LEADER_SP_LIUCHE_PEDIA',	'Han_Scene.xml',	    10, 					4, 						4, 							9, 			5, 				4, 				2, 						6, 				10, 		2, 			4, 				1, 			1, 			'SP_HAN_ATLAS', 	1);
--==========================================================================================================================	
-- Leader_MajorCivApproachBiases
--==========================================================================================================================						
INSERT INTO Leader_MajorCivApproachBiases 
			(LeaderType, 			MajorCivApproachType, 				Bias)
			--对文明倾向
VALUES		('LEADER_SP_LIUCHE', 	'MAJOR_CIV_APPROACH_WAR', 			10),--战争
			('LEADER_SP_LIUCHE', 	'MAJOR_CIV_APPROACH_HOSTILE', 		6),--敌对
			('LEADER_SP_LIUCHE', 	'MAJOR_CIV_APPROACH_DECEPTIVE', 	4),--虚伪
			('LEADER_SP_LIUCHE', 	'MAJOR_CIV_APPROACH_GUARDED', 		10),--谨慎
			('LEADER_SP_LIUCHE', 	'MAJOR_CIV_APPROACH_AFRAID', 		1),--畏惧
			('LEADER_SP_LIUCHE', 	'MAJOR_CIV_APPROACH_FRIENDLY', 		7),--友好
			('LEADER_SP_LIUCHE', 	'MAJOR_CIV_APPROACH_NEUTRAL', 		6);--中立
--==========================================================================================================================	
-- Leader_MajorCivApproachBiases
--==========================================================================================================================						
INSERT INTO Leader_MinorCivApproachBiases 
			(LeaderType, 			MinorCivApproachType, 				Bias)
			--对城邦倾向
VALUES		('LEADER_SP_LIUCHE', 	'MINOR_CIV_APPROACH_IGNORE', 		5),--忽视
			('LEADER_SP_LIUCHE', 	'MINOR_CIV_APPROACH_FRIENDLY', 		10),--友好
			('LEADER_SP_LIUCHE', 	'MINOR_CIV_APPROACH_PROTECTIVE', 	10),--保护
			('LEADER_SP_LIUCHE', 	'MINOR_CIV_APPROACH_CONQUEST', 		3),--征服
			('LEADER_SP_LIUCHE', 	'MINOR_CIV_APPROACH_BULLY', 		1);--欺凌
--==========================================================================================================================	
-- Leader_Flavors--领袖性格
--==========================================================================================================================						
INSERT INTO Leader_Flavors 
			(LeaderType, 			FlavorType, 						Flavor)
			--城市建设
VALUES		('LEADER_SP_LIUCHE', 	'FLAVOR_PRODUCTION', 				10),--注重产能
			('LEADER_SP_LIUCHE', 	'FLAVOR_GOLD', 						5),--注重金钱
			('LEADER_SP_LIUCHE', 	'FLAVOR_SCIENCE', 					8),--注重科研
			('LEADER_SP_LIUCHE', 	'FLAVOR_CULTURE', 					5),--注重文化
			--军事倾向
			('LEADER_SP_LIUCHE', 	'FLAVOR_OFFENSE', 					12),--进攻倾向
			('LEADER_SP_LIUCHE', 	'FLAVOR_DEFENSE', 					10),--防御倾向
			('LEADER_SP_LIUCHE', 	'FLAVOR_CITY_DEFENSE', 				7),--城防倾向
			('LEADER_SP_LIUCHE', 	'FLAVOR_MILITARY_TRAINING', 		12),--组建军队
			--军队建设
			('LEADER_SP_LIUCHE', 	'FLAVOR_RECON', 					5),--侦查部队
			('LEADER_SP_LIUCHE', 	'FLAVOR_RANGED', 					6),--远程部队
			('LEADER_SP_LIUCHE', 	'FLAVOR_MOBILE', 					12),--机动部队
			('LEADER_SP_LIUCHE', 	'FLAVOR_NAVAL', 					12),--海军部队
			('LEADER_SP_LIUCHE', 	'FLAVOR_NAVAL_RECON', 				8),--海军游猎部队
			('LEADER_SP_LIUCHE', 	'FLAVOR_AIR', 						8),--空军部队
			('LEADER_SP_LIUCHE', 	'FLAVOR_ANTIAIR', 					5),--防空部队
			('LEADER_SP_LIUCHE', 	'FLAVOR_AIR_CARRIER', 				8),--航空母舰
			('LEADER_SP_LIUCHE', 	'FLAVOR_AIRLIFT', 					2),--空运部队
			--国家建设
			('LEADER_SP_LIUCHE', 	'FLAVOR_GROWTH', 					10),--发展人口
			('LEADER_SP_LIUCHE', 	'FLAVOR_EXPANSION', 				12),--扩张领土
			('LEADER_SP_LIUCHE', 	'FLAVOR_INFRASTRUCTURE', 			8),--基础设施
			('LEADER_SP_LIUCHE', 	'FLAVOR_TILE_IMPROVEMENT', 			8),--地格开发
			('LEADER_SP_LIUCHE', 	'FLAVOR_NAVAL_TILE_IMPROVEMENT', 	6),--海洋开发
			('LEADER_SP_LIUCHE', 	'FLAVOR_NAVAL_GROWTH', 				8),--海军建设
			('LEADER_SP_LIUCHE', 	'FLAVOR_HAPPINESS', 				9),--国家快乐
			('LEADER_SP_LIUCHE', 	'FLAVOR_GREAT_PEOPLE', 				6),--诞生伟人
			('LEADER_SP_LIUCHE', 	'FLAVOR_WONDER', 					7),--建造奇观
			('LEADER_SP_LIUCHE', 	'FLAVOR_RELIGION', 					5),--发展宗教
			('LEADER_SP_LIUCHE', 	'FLAVOR_WATER_CONNECTION', 			10),--水路连接
			('LEADER_SP_LIUCHE', 	'FLAVOR_ARCHAEOLOGY', 				4),--发展考古
			('LEADER_SP_LIUCHE', 	'FLAVOR_SPACESHIP', 				2),--发展航天
			--外交倾向
			('LEADER_SP_LIUCHE', 	'FLAVOR_DIPLOMACY', 				6),--发展外交
			('LEADER_SP_LIUCHE', 	'FLAVOR_ESPIONAGE', 				7),--间谍机构
			('LEADER_SP_LIUCHE', 	'FLAVOR_NUKE', 						7),--发展核威慑
			('LEADER_SP_LIUCHE', 	'FLAVOR_USE_NUKE', 					2),--使用核武库
			--贸易倾向
			('LEADER_SP_LIUCHE', 	'FLAVOR_I_LAND_TRADE_ROUTE', 		12),--陆地商路
			('LEADER_SP_LIUCHE', 	'FLAVOR_I_SEA_TRADE_ROUTE', 		1),--海洋商路
			('LEADER_SP_LIUCHE', 	'FLAVOR_I_TRADE_ORIGIN', 			12),--发起商路
			('LEADER_SP_LIUCHE', 	'FLAVOR_I_TRADE_DESTINATION', 		12);--接收商路
--==========================================================================================================================	
-- Leader_Traits
--==========================================================================================================================	
INSERT INTO Leader_Traits 
			(LeaderType, 			TraitType)
VALUES		('LEADER_SP_LIUCHE', 	'TRAIT_SP_HAN');
--==========================================================================================================================	
-- Traits
--==========================================================================================================================	
INSERT INTO Traits 
			(Type, 				Description, 				ShortDescription,				GoldenAgeMinorPerTurnInfluence)
VALUES		('TRAIT_SP_HAN', 	'TXT_KEY_TRAIT_SP_HAN', 	'TXT_KEY_TRAIT_SP_HAN_SHORT',	300);
--==========================================================================================================================	
-- Trait_BuildingClassYieldChanges
--==========================================================================================================================	
INSERT INTO Trait_BuildingClassYieldChanges(TraitType, BuildingClassType, YieldType, YieldChange)
SELECT 'TRAIT_SP_HAN', t1.Type, 'YIELD_CULTURE' , t2.Yield
FROM BuildingClasses t1 LEFT JOIN Building_YieldChanges t2 
ON t1.DefaultBuilding = t2.BuildingType
WHERE t2.Yield > 0 AND t2.YieldType = 'YIELD_FAITH';

INSERT INTO Trait_BuildingClassYieldChanges(TraitType, BuildingClassType, YieldType, YieldChange)
SELECT 'TRAIT_SP_HAN', t1.Type, 'YIELD_FAITH' , t2.Yield
FROM BuildingClasses t1 LEFT JOIN Building_YieldChanges t2 
ON t1.DefaultBuilding = t2.BuildingType
WHERE t2.Yield > 0 AND t2.YieldType = 'YIELD_CULTURE';
--==========================================================================================================================	
-- Trait_Promotions
--==========================================================================================================================	
INSERT INTO Trait_FreePromotionUnitCombats
			(TraitType,			UnitCombatType,				PromotionType) 	
VALUES		('TRAIT_SP_HAN',	'UNITCOMBAT_MELEE',			'PROMOTION_SP_HAN_TRAIT_LAND'),
			('TRAIT_SP_HAN',	'UNITCOMBAT_MOUNTED',		'PROMOTION_SP_HAN_TRAIT_LAND'),	
			('TRAIT_SP_HAN',	'UNITCOMBAT_ARMOR',			'PROMOTION_SP_HAN_TRAIT_LAND'),
			('TRAIT_SP_HAN',	'UNITCOMBAT_HELICOPTER',	'PROMOTION_SP_HAN_TRAIT_LAND'),
			('TRAIT_SP_HAN',	'UNITCOMBAT_SIEGE',			'PROMOTION_SP_HAN_TRAIT_LAND'),
			('TRAIT_SP_HAN',	'UNITCOMBAT_BOMBER',		'PROMOTION_SP_HAN_TRAIT_LAND'),
			('TRAIT_SP_HAN',	'UNITCOMBAT_RECON',			'PROMOTION_SP_HAN_TRAIT_LAND');
--==========================================================================================================================	
-- Plocies--显示用，无任何实际用途
--==========================================================================================================================	
INSERT INTO Policies 
			(Type, 				Description)
VALUES		('POLICY_SP_HAN', 	'TXT_KEY_POLICY_SP_HAN');
--==========================================================================================================================	
-- Policy_BuildingClassYieldChanges
--==========================================================================================================================	
INSERT INTO Policy_BuildingClassYieldChanges
		(PolicyType, 	BuildingClassType, YieldType, YieldChange)
SELECT 'POLICY_SP_HAN', BuildingClassType, YieldType, YieldChange
FROM Trait_BuildingClassYieldChanges WHERE TraitType = 'TRAIT_SP_HAN';
--==========================================================================================================================	
-- Plocies--事件假政策
--==========================================================================================================================	
INSERT INTO Policies 
			(Type, 							Description)
VALUES		('POLICY_SP_HAN_HIST_EVENT2', 	'TXT_KEY_EVENTS_HAN_HISTORY2_TITLE'),
			('POLICY_SP_HAN_HIST_EVENT3', 	'TXT_KEY_EVENTS_HAN_HISTORY3_TITLE');

INSERT INTO Policy_FreePromotions 
			(PolicyType, 					PromotionType)
VALUES		('POLICY_SP_HAN_HIST_EVENT2', 	'PROMOTION_HAN_HISTORY2');		
--==========================================================================================================================
-- AUDIO
--==========================================================================================================================	
-- Audio_Sounds
------------------------------	
INSERT INTO Audio_Sounds 
			(SoundID, 								Filename, 		LoadType)
VALUES		('SND_LEADER_MUSIC_SP_LIUCHE_PEACE', 	'Han_Peace', 	'DynamicResident'),
			('SND_LEADER_MUSIC_SP_LIUCHE_WAR',		'Han_War', 		'DynamicResident');		
------------------------------
-- Audio_2DSounds
------------------------------	
INSERT INTO Audio_2DSounds 
			(ScriptID, 										SoundID, 								SoundType, 		MinVolume, 	MaxVolume,	IsMusic,	Looping)
VALUES		('AS2D_LEADER_MUSIC_SP_LIUCHE_PEACE', 			'SND_LEADER_MUSIC_SP_LIUCHE_PEACE', 	'GAME_MUSIC', 	50, 		65, 		1, 			0),
			('AS2D_LEADER_MUSIC_SP_LIUCHE_WAR', 			'SND_LEADER_MUSIC_SP_LIUCHE_WAR', 		'GAME_MUSIC',	50, 		65, 		1,			0);
--==========================================================================================================================
-- World Power
--==========================================================================================================================
CREATE TABLE IF NOT EXISTS ROG_GlobalUserSettings (Type text default null, Value integer default 0);
--强权初始科技兼容
DELETE FROM Civilization_FreeTechs WHERE CivilizationType='CIVILIZATION_SP_HAN' AND EXISTS (SELECT * FROM ROG_GlobalUserSettings WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1); 
INSERT  INTO Civilization_FreeTechs(CivilizationType,TechType )
SELECT 'CIVILIZATION_SP_HAN',	    'TECH_AGRICULTURE' 
WHERE EXISTS (SELECT * FROM ROG_GlobalUserSettings WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1);
INSERT  INTO Civilization_FreeTechs(CivilizationType,TechType )
SELECT 'CIVILIZATION_SP_HAN',	    'TECH_STONE_TOOLS' 
WHERE EXISTS (SELECT * FROM ROG_GlobalUserSettings WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1);

CREATE TRIGGER HAN_WP
AFTER INSERT ON ROG_GlobalUserSettings
WHEN NEW.Type ='WORLD_POWER_PATCH' AND NEW.Value = 1
BEGIN
	DELETE FROM Civilization_FreeTechs WHERE CivilizationType='CIVILIZATION_SP_HAN';
	INSERT INTO Civilization_FreeTechs
				(CivilizationType,			TechType )
	VALUES 		('CIVILIZATION_SP_HAN',	    'TECH_AGRICULTURE'),
				('CIVILIZATION_SP_HAN',	    'TECH_STONE_TOOLS');
END;
