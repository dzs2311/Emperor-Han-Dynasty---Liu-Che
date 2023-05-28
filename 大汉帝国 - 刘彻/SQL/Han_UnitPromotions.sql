--==========================================================================================================================	
-- UnitPromotions_PromotionModifiers
--==========================================================================================================================	
-- 幕府将军
INSERT INTO UnitPromotions_PromotionModifiers(PromotionType, OtherPromotionType, Modifier)
SELECT t1.PromotionType, 'PROMOTION_HAN_ELITE_RIDER_EFFECT', -0.5 * t1.Modifier
FROM UnitPromotions_UnitCombatMods t1
WHERE t1.Modifier > 0 AND (t1.UnitCombatType = 'UNITCOMBAT_ARMOR' OR t1.UnitCombatType = 'UNITCOMBAT_MOUNTED' );
-- 天子剑 - 不受克制
INSERT INTO UnitPromotions_PromotionModifiers(PromotionType, OtherPromotionType, Modifier)
SELECT t1.PromotionType, 'PROMOTION_HAN_ELITE_MECH', -t1.Modifier
FROM UnitPromotions_UnitCombatMods t1
WHERE t1.Modifier > 0 AND (t1.UnitCombatType = 'UNITCOMBAT_ARMOR' OR t1.UnitCombatType = 'UNITCOMBAT_MOUNTED' );
