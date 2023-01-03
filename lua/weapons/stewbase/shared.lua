
--
-- Necessary for the base
--
AddCSLuaFile()
SWEP.Base								= "weapon_base"
SWEP.Spawnable							= false
SWEP.STEW								= true

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

AddCSLuaFile("sh_holdtypes.lua")
include("sh_holdtypes.lua")

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "UserSight")

	self:NetworkVar("Int", 0, "BurstCount")
	self:NetworkVar("Int", 1, "Firemode")
	self:NetworkVar("Int", 2, "ShotgunReloading")
	self:NetworkVar("Int", 3, "CycleCount")

	self:NetworkVar("Float", 0, "NextFire")
	self:NetworkVar("Float", 1, "Aim")
	self:NetworkVar("Float", 2, "ReloadingTime")
	self:NetworkVar("Float", 3, "LoadingTime")
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

function SWEP:Reload()
	self:CallOnClient("TPReload")

	self:SetLoadingTime(CurTime() + 2)
	self:SetReloadingTime(CurTime() + 2)
end

function SWEP:TPReload()
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, self:GetOwner():SelectWeightedSequence(ACT_HL2MP_GESTURE_RELOAD_SMG1), 0, true )
end

function SWEP:TPDraw()
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_GRENADE, self:GetOwner():SelectWeightedSequence(ACT_GMOD_GESTURE_ITEM_THROW), 0.75, true )
end

function SWEP:TPHolster()
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_GRENADE, self:GetOwner():SelectWeightedSequence(ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND), 0.6, true )
end

local doit = 1
local doit2 = 1
function SWEP:Think()
	local p = self:GetOwner()
	if IsValid(p) then
		local ht = self.HoldTypeHip
		if self:GetAim() > 0.2 then
			ht = self.HoldTypeSight
		end
		if !self:GetUserSight() and self:GetReloadingTime() <= CurTime() then
			ht = "normal"
			doit = 1
		else
			doit = 2
		end
		if doit != doit2 then
			if doit == 1 then
				self:CallOnClient("TPHolster")
			elseif doit == 2 then
				self:CallOnClient("TPDraw")
				self:SetReloadingTime(CurTime() + 0.3)
			end
			doit2 = doit
		end
		self:SetHoldType( ht )
		self:SetWeaponHoldType( ht )

		self:SetUserSight( p:KeyDown( IN_ATTACK2 ) )
		self:SetAim( math.Approach( self:GetAim(), self:GetUserSight() and 1 or 0, FrameTime() / 0.4 ) )

		if self:GetLoadingTime() != 0 and self:GetLoadingTime() <= CurTime() then
			self:SetClip1(self.Primary.ClipSize)
			self:SetLoadingTime( 0 )
		end
	end
end

function SWEP:DrawWorldModel( flags )
	if !self:GetUserSight() and self:GetReloadingTime() <= CurTime() then
		return false
	else
		self:DrawModel( flags )
	end
end

CreateClientConVar("stew_camera", 0, true, false)

local stance = 0
local pose_stand = Vector( 14, -80, 0 )
local pose_duck = Vector( 10, -64, 0 )
local pose_prone = Vector( 8, -54, 0 )
local pose_stand_aim = Vector( 18, -64, 0 )
local pose_duck_aim = Vector( 14, -48, 0 )
local pose_prone_aim = Vector( 20, -12, 0 )

local fov_stand = 76
local fov_duck = 72
local fov_prone = 70
local fov_aim = 65
local eye_stand = 60
local eye_duck = 44
local eye_prone = 24
local globhit = Vector()
local globang = Angle()

waga = waga or Angle()

local ptimei = 0
hook.Add("CalcView", "STEW_TP", function( ply, pos, angles, fov )
	if GetConVar("stew_camera"):GetBool() then
		local tang = waga
		local tpos = Vector()
		local tfov = fov_stand
		local w = ply:GetActiveWeapon()
		local smoothed = math.ease.InOutSine( stance )
		local sighted = 0
		local ptime = 0
		if w then
			sighted = math.ease.InOutSine( w.GetSightDelta and (1-w:GetSightDelta()) or w.GetAim and (w:GetAim()) or (w:GetNWBool( "insights", false ) == true and 1) or 0 )
		end
		if ply.IsProne then
			ptimei = math.Approach( ptimei, ( ply:GetProneAnimationState() == PRONE_GETTINGDOWN or ply:GetProneAnimationState() == PRONE_INPRONE ) and 1 or 0, FrameTime() / 0.8 )
			ptime = math.ease.InOutSine( ptimei )
		end

		local tmod = Vector()
		tmod:Set( pose_stand )
		tmod:Set( LerpVector( smoothed, tmod, pose_duck ) )
		tmod:Set( LerpVector( ptime, tmod, pose_prone ) )
		tmod:Set( LerpVector( sighted, tmod, Lerp( ptime, LerpVector( smoothed, pose_stand_aim, pose_duck_aim ), pose_prone_aim ) ) )
		tfov = Lerp( smoothed, fov_stand, fov_duck )
		tfov = Lerp( ptime, tfov, fov_prone )
		tfov = Lerp( sighted, tfov, fov_aim )

		tpos:Add( tang:Right() * tmod[1] )
		tpos:Add( tang:Forward() * tmod[2] )
		tpos:Add( tang:Up() * tmod[3] )

		local starter = ply:GetPos()
		starter = Vector( starter.x, starter.y, starter.z + Lerp( ptime, Lerp( smoothed, eye_stand, eye_duck ), eye_prone ) )
		tpos:Add( starter )

		local trace = util.TraceLine({
			start = starter,
			endpos = tpos,
			filter = ply
		})

		local hitter = trace.HitPos
		if trace.Fraction then
			hitter:Add( trace.HitNormal*4 )
		end

		local view = {
			origin = hitter,
			angles = tang,
			fov = tfov,
			drawviewer = true
		}

		globhit:Set( hitter )
		globang:Set( tang )

		stance = math.Approach( stance, ( ply:KeyDown( IN_DUCK ) ) and 1 or 0, FrameTime() / 0.3 )

		return view
	end
end)

tr1f = Vector()
tr2f = Vector()
local gunmode = 0 -- 0 is mgsv free mode
local dong = Angle( 0, 000, 0 )
hook.Add( "StartCommand", "STEW_StartCommand", function( ply, cmd )
	if CLIENT then
		if !GetConVar("stew_camera"):GetBool() then
			waga:Set( cmd:GetViewAngles() )
		else
			local time = 0
			--debugoverlay.Cross(ply:EyePos(), 16, time)
			--debugoverlay.Cross(globhit, 16, time)
			local tr1 = util.TraceLine({
				start = ply:EyePos(),
				endpos = ply:EyePos() + (ply:EyeAngles():Forward()*10000),
				filter = ply
			})
			debugoverlay.Cross(tr1.HitPos, 2, time, Color(255, 0, 0, 127))

			local tr2 = util.TraceLine({
				start = globhit,
				endpos = globhit + (globang:Forward()*10000),
				filter = ply
			})
			debugoverlay.Cross(tr2.HitPos, 2, time, Color(0, 0, 255, 127))

			--tr1f:Set(tr1.HitPos)
			--tr2f:Set(tr2.HitPos)

			waga:Add( Angle( cmd:GetMouseY() * 0.022, cmd:GetMouseX() * -0.022, 0 ) )
			waga.x = math.Clamp( waga.x, -89, 89 )
			waga:Normalize()

			local w = ply:GetActiveWeapon()
			local compatiblyaimed = false
			if IsValid(w) then
				if w.GetUserSight and w:GetUserSight() == false then
					compatiblyaimed = true
				elseif (w:GetNWBool( "insights", "shaa" ) == false) then
					compatiblyaimed = true
				elseif w.GetState and w:GetState() != 1 then
					compatiblyaimed = true
				end
			end
			if ply:GetMoveType() == MOVETYPE_NOCLIP then
				cmd:SetViewAngles( waga )
			elseif compatiblyaimed then
				local m1 = cmd:KeyDown( IN_FORWARD ) and 1 or cmd:KeyDown( IN_BACK ) and -1 or 0
				local m2 = cmd:KeyDown( IN_MOVERIGHT ) and 1 or cmd:KeyDown( IN_MOVELEFT ) and -1 or 0
				local m3 = cmd:KeyDown( IN_FORWARD+IN_BACK+IN_MOVELEFT+IN_MOVERIGHT ) and 1 or 0

				local honk = Vector( 100 * m1, 100 * -m2, 0 )
				honk = honk:Angle()
				honk.y = honk.y + waga.y
				if honk.x != 90 then
					cmd:SetViewAngles( honk )
					dong:Set(honk)
				else
					cmd:SetViewAngles( dong )
				end

				local thing = Matrix()
				--thing:Rotate( Angle( 0, waga.y, 0 ) )
				thing:Translate( Vector( 1000 * m3, 0, 0 ) )
				
				local forwar = thing:GetTranslation().x
				local rightwar = 0--thing:GetTranslation().y
				
				cmd:ClearMovement()
				cmd:SetForwardMove( forwar )
				cmd:SetSideMove( rightwar )
			else
				cmd:SetViewAngles( (tr2.HitPos-tr1.StartPos):Angle() )
				dong:Set( (tr2.HitPos-tr1.StartPos):Angle() )

				local pingas = (tr2.HitPos-tr1.StartPos):Angle()
				pingas:Normalize()
				pingas = ( cmd:GetViewAngles() - waga )
		
				local m1 = cmd:KeyDown( IN_FORWARD ) and 1 or cmd:KeyDown( IN_BACK ) and -1 or 0
				local m2 = cmd:KeyDown( IN_MOVERIGHT ) and 1 or cmd:KeyDown( IN_MOVELEFT ) and -1 or 0

				local thing = Matrix()
				thing:Rotate( pingas )
				thing:Translate( Vector( 1000 * m1, 1000 * m2, 0 ) )

				local forwar = thing:GetTranslation().x
				local rightwar = thing:GetTranslation().y

				cmd:ClearMovement()
				cmd:SetForwardMove( forwar )
				cmd:SetSideMove( rightwar )
			end
		end
	end
end)

local col_1 = Color(255, 255, 255, 200)
local col_2 = Color(0, 0, 0, 255)
local col_3 = Color(255, 127, 127, 255)
local col_4 = Color(255, 222, 222, 255)
local mat_dot = Material("stew/xhair/dot.png", "smooth")
local mat_long = Material("stew/xhair/long.png", "smooth")
local mat_dot_s = Material("stew/xhair/dot_s.png", "smooth")
local mat_long_s = Material("stew/xhair/long_s.png", "smooth")
local spacer_long = 2 -- screenscaled
local gap = 16
hook.Add("HUDPaint", "STEW_3DCrosshair", function()
	if GetConVar("stew_camera"):GetBool() then
		local ply = LocalPlayer()
		local w = ply:GetActiveWeapon()
		if IsValid(w) and w.STEW and w:GetUserSight() then
			local s, w, h = ScreenScale, ScrW(), ScrH()
			local pl_x, pl_y = w/2, h/2

			do
				local tr1 = util.TraceLine({
					start = ply:EyePos(),
					endpos = ply:EyePos() + (ply:EyeAngles():Forward()*10000),
					filter = ply
				})

				local tr2 = util.TraceLine({
					start = globhit,
					endpos = globhit + (globang:Forward()*10000),
					filter = ply
				})

				tr1f:Set(tr1.HitPos)
				tr2f:Set(tr2.HitPos)
			end

			pl_x = tr2f:ToScreen().x
			pl_y = tr2f:ToScreen().y
			ps_x = tr2f:ToScreen().x
			ps_y = tr2f:ToScreen().y

			local touse1 = col_1
			local touse2 = col_2
			if util.TraceLine({start = tr2f, endpos = tr1f, filter = ply}).Fraction != 1 and !tr2f:IsEqualTol(tr1f, 1) then
				touse1 = col_4
				touse2 = col_3
				pl_x = tr1f:ToScreen().x
				pl_y = tr1f:ToScreen().y
			end

			for i=1, 2 do
				local cooler = i == 1 and touse2 or touse1
				local poosx, poosy = i == 1 and ps_x or pl_x, i == 1 and ps_y or pl_y
				local mat1 = i == 1 and mat_long_s or mat_long
				local mat2 = i == 1 and mat_dot_s or mat_dot
				surface.SetDrawColor( cooler )
				surface.SetMaterial( mat1 )
				surface.DrawTexturedRectRotated( poosx - s(spacer_long) - gap, poosy, s(16), s(16), 0 )
				surface.DrawTexturedRectRotated( poosx + s(spacer_long) + gap, poosy, s(16), s(16), 0 )

				surface.SetDrawColor( cooler )
				surface.SetMaterial( mat2 )
				surface.DrawTexturedRectRotated( poosx, poosy - gap, s(16), s(16), 0 )
				surface.DrawTexturedRectRotated( poosx, poosy + gap, s(16), s(16), 0 )
			end
		end
	end
end)