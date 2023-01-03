
--
-- Necessary
--
SWEP.Base								= "stewbase"
SWEP.Spawnable							= true

--
-- Description
--
SWEP.PrintName							= "USP"
SWEP.Category							= "STEW - Pistols"
SWEP.Description						= [[German full-sized precision handgun in the venerable .45 ACP round.]]
SWEP.Slot								= 2

--
-- Appearance
--
SWEP.UseHands							= true
SWEP.ViewModel							= "models/weapons/c_pistol.mdl"
SWEP.WorldModel							= "models/weapons/w_pist_usp.mdl"
SWEP.ViewModelFOV						= 75

SWEP.HoldTypeHip						= "revolver"
SWEP.HoldTypeSight						= "revolver"
SWEP.HoldTypeSprint						= "passive"

SWEP.Sound_Blast						= STEW.SoundBank["blast_45acp"]
SWEP.Sound_Mech							= {}
SWEP.Sound_Tail							= {}

--
-- Functionality
--
SWEP.Primary.Ammo						= "pistol"
SWEP.Primary.ClipSize					= 30
SWEP.Delay								= ( 60 / 400 )

SWEP.Firemodes							=
{
	{
		Mode = -1,
	},
	{
		Mode = 1,
	}
}
