--=========================================================================================================================
-- IconTextureAtlases
--==========================================================================================================================
INSERT OR REPLACE INTO IconTextureAtlases 
			(Atlas, 							IconSize, 	Filename, 							IconsPerRow, 	IconsPerColumn)
VALUES		('SP_HAN_ATLAS', 					256, 		'Han_IconAtlas256.dds',				8,				8),
			('SP_HAN_ATLAS', 					128, 		'Han_IconAtlas128.dds',				8,				8),
			('SP_HAN_ATLAS', 					80, 		'Han_IconAtlas080.dds',				8,				8),
			('SP_HAN_ATLAS', 					64, 		'Han_IconAtlas064.dds',				8,				8),
			('SP_HAN_ATLAS', 					45, 		'Han_IconAtlas045.dds',				8,				8),
			('SP_HAN_ATLAS', 					32, 		'Han_IconAtlas032.dds',				8,				8),
			('SP_HAN_ALPHA_ATLAS',				128, 		'Han_AlphaAtlas_128.dds',			1,				1),
			('SP_HAN_ALPHA_ATLAS',				80, 		'Han_AlphaAtlas_080.dds',			1, 				1),
			('SP_HAN_ALPHA_ATLAS',				64, 		'Han_AlphaAtlas_064.dds',			1, 				1),
			('SP_HAN_ALPHA_ATLAS',				48, 		'Han_AlphaAtlas_048.dds',			1, 				1),
			('SP_HAN_ALPHA_ATLAS',				32, 		'Han_AlphaAtlas_032.dds',			1, 				1),
			('SP_HAN_ALPHA_ATLAS',				24, 		'Han_AlphaAtlas_024.dds',			1, 				1),
			('SP_HAN_ALPHA_ATLAS',		 		16, 		'Han_AlphaAtlas_016.dds',			1, 				1),
            ('SP_HAN_UI_ATLAS', 				64, 		'HanImprovementIcons64.dds',		2, 				1),
			('SP_HAN_UI_ATLAS', 				45, 		'HanImprovementIcons45.dds',		2, 				1),
			('SP_HAN_NU_FLAG_ATLAS',			32,			'HanNuFlag.dds',			        1, 				1),
			('SP_HAN_ERIDER_FLAG_ATLAS',		32,			'HanQiMenFlag.dds',			        1, 				1),
			('SP_HAN_RIDER_FLAG_ATLAS',			32,			'HanRiderFlag.dds',			        1, 				1),
			('SP_HAN_WUSUN_FLAG_ATLAS',			32,			'HanScythianUnitFlag.dds',			1, 				1),
			('SP_HAN_NTM_FLAG_ATLAS',			32,			'NanTianMenFlag.dds',			    1, 				1),
			('SP_HAN_JI_FLAG_ATLAS',			32,			'RelicHanJiFlag.dds',			    1, 				1);

INSERT OR REPLACE INTO IconTextureAtlases	(Atlas, IconSize, Filename, IconsPerRow, IconsPerColumn) VALUES
			('promoHan_atlas', 					256, 		'promoHan_256.dds', 				'8', 			'4'),
			('promoHan_atlas', 					064, 		'promoHan_064.dds', 				'8', 			'4'),
			('promoHan_atlas', 					045, 		'promoHan_045.dds', 				'8', 			'4'),
			('promoHan_atlas', 					032, 		'promoHan_032.dds', 				'8', 			'4'),
			('promoHan_atlas', 					016, 		'promoHan_016.dds', 				'8', 			'4');

