
--
-- Necessary
--
SWEP.Base					= "stewbase"
SWEP.Spawnable				= true

--
-- Description
--
SWEP.PrintName				= "M4A1"
SWEP.Category				= "STEW - Carbines"
SWEP.Description			= [[Automatic lightweight assault carbine. Fast firing, reliable, and and fairly accurate. Used by the US military.]]
SWEP.Slot					= 2
SWEP.XHairMode				= "rifle"

--
-- Appearance
--
SWEP.UseHands				= true
SWEP.ViewModel				= "models/weapons/c_pistol.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_m4a1.mdl"
SWEP.ViewModelFOV			= 75

SWEP.HoldTypeHip			= "ar2"
SWEP.HoldTypeSight			= "rpg"
SWEP.HoldTypeSprint			= "passive"

SWEP.GestureFire			= { ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1, 0 }
SWEP.GestureReload			= { ACT_HL2MP_GESTURE_RELOAD_SMG1, 0 }
SWEP.GestureDraw			= { ACT_GMOD_GESTURE_ITEM_THROW, 0.75 }
SWEP.GestureHolster			= { ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND, 0.6 }

SWEP.Sound_Blast			= STEW.SoundBank["blast_556x45"]
SWEP.Sound_Mech				= {}
SWEP.Sound_Tail				= {}

--
-- Functionality
--
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.ClipSize		= 30
SWEP.Delay					= ( 60 / 800 )

SWEP.Firemodes				=
{
	{
		Mode = math.huge,
	},
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
SWEP.ReloadingTime			= 2
SWEP.ReloadingLoadTime		= 1