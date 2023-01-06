
--
-- Necessary
--
SWEP.Base					= "stewbase"
SWEP.Spawnable				= true

--
-- Description
--
SWEP.PrintName				= "AKS-74u"
SWEP.Category				= "STEW - Carbines"
SWEP.Description			= [[Automatic carbine with folding stock and reduced length handguard, based off of the AK-74 assault rifle.]]
SWEP.Slot					= 2
SWEP.XHairMode				= "rifle"

--
-- Appearance
--
SWEP.UseHands				= true
SWEP.ViewModel				= "models/weapons/c_pistol.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_aks74u.mdl"
SWEP.ViewModelFOV			= 75

SWEP.HoldTypeHip			= "ar2"
SWEP.HoldTypeSight			= "rpg"
SWEP.HoldTypeSprint			= "passive"

SWEP.GestureFire			= { ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1, 0 }
SWEP.GestureReload			= { ACT_HL2MP_GESTURE_RELOAD_SMG1, 0 }
SWEP.GestureDraw			= { ACT_GMOD_GESTURE_ITEM_THROW, 0.75 }
SWEP.GestureHolster			= { ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND, 0.6 }

SWEP.Sound_Blast			= STEW.SoundBank["blast_545x39"]
SWEP.Sound_Mech				= STEW.SoundBank["action_ak"]
SWEP.Sound_Tail				= STEW.SoundBank["tail_545x39"]

--
-- Functionality
--
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.ClipSize		= 30
SWEP.Delay					= ( 60 / 720 )

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
SWEP.DamageNear				= STEW.Profile["545x39"].near
SWEP.RangeNear				= 100
SWEP.DamageFar				= STEW.Profile["545x39"].far
SWEP.RangeFar				= 300
SWEP.Force					= STEW.Profile["545x39"].force

-- misc
SWEP.ReloadingTime			= 2
SWEP.ReloadingLoadTime		= 1