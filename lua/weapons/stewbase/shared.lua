
--
-- Necessary for the base
--
AddCSLuaFile()
SWEP.Base								= "weapon_base"
SWEP.Spawnable							= false

--
-- Description
--
SWEP.PrintName							= "STEW base"
SWEP.Category							= "Your Category Here"
SWEP.Description						= [[Where it all starts!]]
SWEP.Slot								= 2

--
-- Appearance
--
SWEP.UseHands							= true
SWEP.ViewModel							= "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel							= "models/weapons/w_rif_famas.mdl"
SWEP.ViewModelFOV						= 75

SWEP.HoldTypeHip						= "ar2"
SWEP.HoldTypeSight						= "rpg"
SWEP.HoldTypeSprint						= "passive"

SWEP.Sound_Blast						= {}
SWEP.Sound_Mech							= {}
SWEP.Sound_Tail							= {}

--
-- Functionality
--
SWEP.Primary.Ammo						= "ar2"
SWEP.Primary.ClipSize					= 20
SWEP.Delay								= ( 60 / 800 )

--
-- Useless shit that you should NEVER touch
--
SWEP.Weight								= 5
SWEP.AutoSwitchTo						= false
SWEP.AutoSwitchFrom						= false
SWEP.m_WeaponDeploySpeed				= 10
SWEP.Primary.Automatic					= true -- This should ALWAYS be true.
SWEP.Primary.DefaultClip				= 0
SWEP.Secondary.ClipSize					= -1
SWEP.Secondary.DefaultClip				= 0
SWEP.Secondary.Automatic				= true
SWEP.Secondary.Ammo						= "none"
SWEP.Secondary.ClipMax					= -1

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "BurstCount")
	self:NetworkVar("Int", 1, "Firemode")
	self:NetworkVar("Int", 2, "ShotgunReloading")
	self:NetworkVar("Int", 3, "CycleCount")

	self:NetworkVar("Float", 0, "NextFire")
end


local function quickie(en)
	if istable(en) then
		return table.Random(en)
	else
		return en
	end
end

function SWEP:PrimaryAttack()
	local p = self:GetOwner()
	if CurTime() < self:GetNextFire() then
		return false
	end
	if self:Clip1() <= 0 then
		return false
	end

	self:SetNextFire( CurTime() + self.Delay )
	self:SetClip1( self:Clip1() - 1 )

	if #self.Sound_Blast > 0 then
		self.Sound_Blast["BaseClass"] = nil
		local detail = self.Sound_Blast[math.Round(util.SharedRandom("STEW_SoundBlast", 1, #self.Sound_Blast))]
		self:EmitSound( detail, 130, 100, 0.5, 136+1 )
	end

	self:FireBullets({
		Attacker = IsValid(p) and p or self,
		Damage = 20,
		Force = 1,
		Tracer = 0,
		Dir = p:EyeAngles():Forward(),
		Src = p:EyePos(),
		Callback = function( atk, tr, dmginfo )

		end
	})

	return true
end

function SWEP:SecondaryAttack()
	return true
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:Think()
	local p = self:GetOwner()
	if IsValid(p) then
		local ht = self.HoldTypeHip
		if false then --self:GetSightDelta() > 0.2 then
			ht = self.HoldTypeSight
		end
		self:SetHoldType( ht )
		self:SetWeaponHoldType( ht )
	end
end

if CLIENT then
	CreateClientConVar("stew_camera", 1, true, false)
	local stance = 0
	local pose_stand = { 24, -64, 64 }
	local pose_duck = { 24, -48, 48 }
	function SWEP:CalcView( ply, pos, ang, fov )
		if GetConVar("stew_camera"):GetBool() then
			local tang = ang
			local tpos = Vector()

			local tmod = { 0, 0, 0 }
			tmod[1] = Lerp( stance, pose_stand[1], pose_duck[1] )
			tmod[2] = Lerp( stance, pose_stand[2], pose_duck[2] )
			tmod[3] = Lerp( stance, pose_stand[3], pose_duck[3] )

			tpos:Add( tang:Right() * tmod[1] )
			tpos:Add( tang:Forward() * tmod[2] )
			tpos:Add( tang:Up() * tmod[3] )
			tpos:Add( ply:GetPos() )
			
			stance = math.Approach( stance, ( ply:KeyDown( IN_DUCK ) ) and 1 or 0, FrameTime() / 0.2 )
			local view = {
				origin = tpos,
				angles = tang,
				fov = 75,
				drawviewer = true
			}

			return view
		end
	end
end