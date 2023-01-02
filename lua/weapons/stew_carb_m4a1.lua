
--
-- Necessary
--
SWEP.Base								= "stewbase"
SWEP.Spawnable							= true

--
-- Description
--
SWEP.PrintName							= "M4A1"
SWEP.Category							= "STEW - Carbines"
SWEP.Description						= [[Automatic lightweight assault carbine. Fast firing, reliable, and and fairly accurate. Used by the US military.]]
SWEP.Slot								= 2

--
-- Appearance
--
SWEP.UseHands							= true
SWEP.ViewModel							= "models/weapons/c_pistol.mdl"
SWEP.WorldModel							= "models/weapons/w_rif_m4a1.mdl"
SWEP.ViewModelFOV						= 75

SWEP.HoldTypeHip						= "ar2"
SWEP.HoldTypeSight						= "rpg"
SWEP.HoldTypeSprint						= "passive"

SWEP.Sound_Blast						= STEW.SoundBank["blast_556"]
SWEP.Sound_Mech							= {}
SWEP.Sound_Tail							= {}

--
-- Functionality
--
SWEP.Primary.Ammo						= "smg1"
SWEP.Primary.ClipSize					= 30
SWEP.Delay								= ( 60 / 800 )
