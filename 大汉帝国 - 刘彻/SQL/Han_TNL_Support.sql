--------------------------------------------------------------------------------------------------------------------
-- TNL出生点
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS TNL_World_Civilization_StartingPlots(CivilizationType text REFERENCES Civilizations(Type), X integer default -1, Y integer default -1);
INSERT INTO TNL_World_Civilization_StartingPlots
			(CivilizationType,										X,		Y)
VALUES		('CIVILIZATION_SP_HAN',			   						76,     60);	-- 长安
--=========================================================================================================================
-- IconFontTextures
--==========================================================================================================================
INSERT OR REPLACE INTO IconFontTextures 
			(IconFontTexture,				IconFontTextureFile)
VALUES		('ICON_FONT_TEXTURE_HAN_PROMO',	'FontIcons_Han');
--=========================================================================================================================
-- IconFontMapping
--==========================================================================================================================
INSERT OR REPLACE INTO IconFontMapping
			(IconName,							IconFontTexture,				IconMapping) 
VALUES		('ICON_PROMOTION_HAN_PROMO_01',		'ICON_FONT_TEXTURE_HAN_PROMO', 	1),
			('ICON_PROMOTION_HAN_PROMO_02',		'ICON_FONT_TEXTURE_HAN_PROMO', 	2),
			('ICON_PROMOTION_HAN_PROMO_03',		'ICON_FONT_TEXTURE_HAN_PROMO', 	3),
			('ICON_PROMOTION_HAN_PROMO_04',		'ICON_FONT_TEXTURE_HAN_PROMO', 	4),
			('ICON_PROMOTION_HAN_PROMO_05',		'ICON_FONT_TEXTURE_HAN_PROMO', 	5),
			('ICON_PROMOTION_HAN_PROMO_06',		'ICON_FONT_TEXTURE_HAN_PROMO', 	6),
			('ICON_PROMOTION_HAN_PROMO_07',		'ICON_FONT_TEXTURE_HAN_PROMO', 	7),
			('ICON_PROMOTION_HAN_PROMO_08',		'ICON_FONT_TEXTURE_HAN_PROMO', 	8),
			('ICON_PROMOTION_HAN_PROMO_09',		'ICON_FONT_TEXTURE_HAN_PROMO', 	9),
			('ICON_PROMOTION_HAN_PROMO_10',		'ICON_FONT_TEXTURE_HAN_PROMO', 	10),
			('ICON_PROMOTION_HAN_PROMO_11',		'ICON_FONT_TEXTURE_HAN_PROMO', 	11),
			('ICON_PROMOTION_HAN_PROMO_12',		'ICON_FONT_TEXTURE_HAN_PROMO', 	12),
			('ICON_PROMOTION_HAN_PROMO_13',		'ICON_FONT_TEXTURE_HAN_PROMO', 	13),
			('ICON_PROMOTION_HAN_PROMO_14',		'ICON_FONT_TEXTURE_HAN_PROMO', 	14),
			('ICON_PROMOTION_HAN_PROMO_15',		'ICON_FONT_TEXTURE_HAN_PROMO', 	15),
			('ICON_PROMOTION_HAN_PROMO_16',		'ICON_FONT_TEXTURE_HAN_PROMO', 	16),
			('ICON_PROMOTION_HAN_PROMO_17',		'ICON_FONT_TEXTURE_HAN_PROMO', 	17);

UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_01]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 0;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_02]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 1;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_03]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 2;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_04]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 3;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_05]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 4;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_06]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 5;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_07]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 6;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_08]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 7;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_09]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 8;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_10]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 9;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_11]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 10;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_12]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 11;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_13]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 12;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_14]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 13;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_15]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 14;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_16]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 15;
UPDATE UnitPromotions SET IconStringSP = '[ICON_PROMOTION_HAN_PROMO_17]' WHERE IconAtlas = 'promoHan_atlas'	AND PortraitIndex = 16;
