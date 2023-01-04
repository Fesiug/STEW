
--
-- Necessary
--
SWEP.Base					= "stewbase"
SWEP.Spawnable				= true

--
-- Description
--
SWEP.PrintName				= "USP"
SWEP.Category				= "STEW - Pistols"
SWEP.Description			= [[German full-sized precision handgun in the venerable .45 ACP round.]]
SWEP.Slot					= 1
SWEP.XHairMode				= "pistol"

--
-- Appearance
--
SWEP.UseHands				= true
SWEP.ViewModel				= "models/weapons/c_pistol.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_usp.mdl"
SWEP.ViewModelFOV			= 75

SWEP.HoldTypeHip			= "revolver"
SWEP.HoldTypeSight			= "revolver"
SWEP.HoldTypeSprint			= "passive"

SWEP.GestureFire			= { ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1, 0 }
SWEP.GestureReload			= { ACT_HL2MP_GESTURE_RELOAD_PISTOL, 0 }
SWEP.GestureDraw			= { ACT_GMOD_GESTURE_ITEM_THROW, 0.75 }
SWEP.GestureHolster			= { ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND, 0.6 }

SWEP.Sound_Blast			= STEW.SoundBank["blast_45acp"]
SWEP.Sound_Mech				= {}
SWEP.Sound_Tail				= {}

--
-- Functionality
--
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.ClipSize		= 12
SWEP.Delay					= ( 60 / 400 )

SWEP.Firemodes				= {
	{
		Mode = 1,
	}
}

--
-- Damage
--
SWEP.DamageNear				= 30
SWEP.RangeNear				= 100
SWEP.DamageFar				= 22
SWEP.RangeFar				= 300
SWEP.Force					= 2

-- misc
SWEP.ReloadingTime			= 1.5
SWEP.ReloadingLoadTime		= 0.75