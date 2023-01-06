
--
-- Necessary for the base
--
AddCSLuaFile()
SWEP.Base					= "weapon_base"
SWEP.Spawnable				= false
SWEP.STEW					= true

--
-- Description
--
SWEP.PrintName				= "STEW base"
SWEP.Category				= "Your Category Here"
SWEP.Description			= [[Where it all starts!]]
SWEP.Slot					= 2
SWEP.XHairMode				= "pistol"

--
-- Appearance
--
SWEP.UseHands				= true
SWEP.ViewModel				= "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_famas.mdl"
SWEP.ViewModelFOV			= 75

SWEP.HoldTypeHip			= "ar2"
SWEP.HoldTypeSight			= "rpg"
SWEP.HoldTypeSprint			= "passive"

SWEP.GestureFire			= { ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1, 0 }
SWEP.GestureReload			= { ACT_HL2MP_GESTURE_RELOAD_SMG1, 0 }
SWEP.GestureDraw			= { ACT_GMOD_GESTURE_ITEM_THROW, 0.75 }
SWEP.GestureHolster			= { ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND, 0.6 }

SWEP.Sound_Blast			= {}
SWEP.Sound_Mech				= {}
SWEP.Sound_Tail				= {}

--
-- Functionality
--
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.ClipSize		= 20
SWEP.Delay					= ( 60 / 800 )

SWEP.Firemodes				=
{
	{
		Mode = math.huge,
	}
}

--
-- Damage
--
SWEP.DamageNear				= 30
SWEP.RangeNear				= 100
SWEP.DamageFar				= 22
SWEP.RangeFar				= 300
SWEP.Force					= 5

-- misc
SWEP.ReloadingTime			= 2
SWEP.ReloadingLoadTime		= 1


--
-- Useless shit that you should NEVER touch
--
SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.m_WeaponDeploySpeed	= 10
SWEP.Primary.Automatic		= true -- This should ALWAYS be true.
SWEP.Primary.DefaultClip	= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipMax		= -1

AddCSLuaFile("sh_holdtypes.lua")
include("sh_holdtypes.lua")

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "UserSight")
	self:NetworkVar("Bool", 1, "FiremodeDebounce")

	self:NetworkVar("Int", 0, "BurstCount")
	self:NetworkVar("Int", 1, "Firemode")
	self:NetworkVar("Int", 2, "ShotgunReloading")
	self:NetworkVar("Int", 3, "CycleCount")
	self:NetworkVar("Int", 4, "TotalShotCount")

	self:NetworkVar("Float", 0, "NextFire")
	self:NetworkVar("Float", 1, "Aim")
	self:NetworkVar("Float", 2, "ReloadingTime")
	self:NetworkVar("Float", 3, "LoadingTime")
	self:NetworkVar("Float", 4, "Holster_Time")
	self:NetworkVar("Float", 5, "SprintPer")

	self:NetworkVar("Entity", 4, "Holster_Entity")
	self.Primary.DefaultClip = self.Primary.ClipSize * 1
	self:SetFiremode(1)
end


local function quickie(en)
	if istable(en) then
		return table.Random(en)
	else
		return en
	end
end

local function getdamagefromrange( dmg_near, dmg_far, range_near, range_far, dist )
	local min, max = range_near, range_far
	local range = dist
	local XD = 0
	if range < min then
		XD = 0
	else
		XD = math.Clamp((range - min) / (max - min), 0, 1)
	end

	return math.ceil( Lerp( XD, dmg_near, dmg_far ) )
end

function SWEP:PrimaryAttack()
	local p = self:GetOwner()
	if CurTime() < self:GetNextFire() then
		return false
	end
	if CurTime() < self:GetReloadingTime() then
		return false
	end
	if self:GetSprintPer() > 0.2 then
		return false
	end
	if self:Clip1() <= 0 then
		return false
	end
	if self:GetBurstCount() >= self:GetFiremodeTable().Mode then
		return false
	end

	self:SetNextFire( CurTime() + self.Delay )
	self:SetClip1( self:Clip1() - 1 )
	self:SetBurstCount( self:GetBurstCount() + 1 )
	self:SetTotalShotCount( self:GetTotalShotCount() + 1 )
	self:CallOnClient("TPAttack")

	local shotthing1 = 150+((self:GetTotalShotCount()+0)%3)
	local shotthing2 = 154+((self:GetTotalShotCount()+1)%3)
	local shotthing3 = 158+((self:GetTotalShotCount()+2)%3)

	if #self.Sound_Blast > 0 then
		self.Sound_Blast["BaseClass"] = nil
		local detail = self.Sound_Blast[math.Round(util.SharedRandom("STEW_SoundBlast1", 1, #self.Sound_Blast))]
		self:EmitSound( detail, 80, 100, 0.8, shotthing1 )
	end

	if #self.Sound_Mech > 0 then
		self.Sound_Mech["BaseClass"] = nil
		local detail = self.Sound_Mech[math.Round(util.SharedRandom("STEW_SoundBlast2", 1, #self.Sound_Mech))]
		self:EmitSound( detail, 90, 100, 1, shotthing2 )
	end

	if #self.Sound_Tail > 0 then
		self.Sound_Tail["BaseClass"] = nil
		local detail = self.Sound_Tail[math.Round(util.SharedRandom("STEW_SoundBlast2", 1, #self.Sound_Tail))]
		self:EmitSound( detail, 160, 100, 1, shotthing3 )
	end

	local bullet = self
	self:FireBullets({
		Attacker = IsValid(p) and p or self,
		Damage = 0,
		Force = self.Force,
		Tracer = 0,
		Dir = p:EyeAngles():Forward(),
		Src = p:EyePos(),
		Callback = function( atk, tr, dmg )
			local ent = tr.Entity

			if self.CustomCallback then self:CustomCallback( atk, tr, dmg ) end

			dmg:SetDamage( bullet.DamageNear )
			dmg:SetDamageType( DMG_BULLET )

			dmg:SetDamage( getdamagefromrange( bullet.DamageNear, bullet.DamageFar, bullet.RangeNear, bullet.RangeFar, atk:GetPos():Distance(tr.HitPos) ) )
		end
	})

	return true
end

function SWEP:SecondaryAttack()
	return true
end

function SWEP:Deploy()
	self:SetHolster_Time(0)
	self:SetHolster_Entity(NULL)

	if !GetConVar("stew_mod_mgsv"):GetBool() then
		self:CallOnClient("TPDraw")
	end
	return true
end

function SWEP:Holster( ent )
	if ent == self then return end

	if self:GetHolster_Time() != 0 and self:GetHolster_Time() <= CurTime() or IsValid( self:GetHolster_Entity() ) or !IsValid( ent ) then
		self:SetHolster_Time(0)
		self:SetHolster_Entity( NULL )
		return true
	elseif GetConVar("stew_mod_mgsv"):GetBool() then
		return true
	elseif !IsValid(self:GetHolster_Entity()) then
		self:CallOnClient("TPHolster")
		self:SetReloadingTime(CurTime() + 0.25)
		self:SetHolster_Time(CurTime() + 0.25)
		self:SetHolster_Entity( ent )
	end
end

function SWEP:SwitchFiremode(prev)
	-- lol?
	local nextfm = self:GetFiremode() + 1
	if #self.Firemodes < nextfm then
		nextfm = 1
	end
	if self:GetFiremode() != nextfm then
		self:SetFiremode(nextfm)
		if SERVER then
			SuppressHostEvents( self:GetOwner() )
		end
		self:EmitSound("weapons/smg1/switch_single.wav", 60, 100, 0.5, CHAN_STATIC)
		if SERVER then
			SuppressHostEvents( NULL )
		end
	end
end

function SWEP:GetFiremodeName(cust)
	local ftn = self:GetFiremodeTable(cust or self:GetFiremode())
	if ftn.Name then
		ftn = ftn.Name
	elseif ftn.Count == math.huge then
		ftn = "Automatic"
	elseif ftn.Count == 1 then
		ftn = "Semi-automatic"
	else
		ftn = ftn.Count .. "-round burst"
	end

	return ftn
end

function SWEP:GetFiremodeTable(cust)
	return self.Firemodes[cust or self:GetFiremode()] or false
end

hook.Add( "StartCommand", "STEW_Holster", function( ply, cmd )
	if ply and IsValid(ply) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon().STEW then
		local wep = ply:GetActiveWeapon()
		if wep:GetHolster_Time() != 0 and wep:GetHolster_Time() <= CurTime() then
			if IsValid(wep:GetHolster_Entity()) then
				cmd:SelectWeapon(wep:GetHolster_Entity())
			end
		end

		if cmd:GetImpulse() == 150 then
			wep:SwitchFiremode()
		end
	end
end)

function SWEP:Reload()
	if CurTime() < self:GetNextFire() then
		return false
	end
	if CurTime() < self:GetReloadingTime() then
		return false
	end
	if self:Clip1() >= self.Primary.ClipSize then
		return false
	end
	if self:GetOwner():KeyDown(IN_USE) then
		if !self:GetFiremodeDebounce() then
			self:GetOwner():ConCommand("impulse 150")
			self:SetFiremodeDebounce( true )
		end
		return false
	end

	self:CallOnClient("TPReload")

	self:SetReloadingTime(CurTime() + self.ReloadingTime)
	self:SetLoadingTime(CurTime() + self.ReloadingLoadTime)
end

function SWEP:TPAttack()
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, self:GetOwner():SelectWeightedSequence(self.GestureFire[1]), self.GestureFire[2], true )
end

function SWEP:TPReload()
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, self:GetOwner():SelectWeightedSequence(self.GestureReload[1]), self.GestureReload[2], true )
end

function SWEP:TPDraw()
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_GRENADE, self:GetOwner():SelectWeightedSequence(self.GestureDraw[1]), self.GestureDraw[2], true )
end

function SWEP:TPHolster()
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_GRENADE, self:GetOwner():SelectWeightedSequence(self.GestureHolster[1]), self.GestureHolster[2], true )
end

local doit = 1
local doit2 = 1
local poit = 1
local poit2 = 1
function SWEP:Think()
	local p = self:GetOwner()
	if IsValid(p) then
		local ht = self.HoldTypeHip
		if self:GetAim() > 0.2 then
			ht = self.HoldTypeSight
		end
		local spint = self:GetSprintPer() > 0.2
		if spint then
			ht = self.HoldTypeSprint
		end
		self:SetSprintPer( math.Approach( self:GetSprintPer(), p:IsSprinting() and 1 or 0, FrameTime() / 0.3 ) )
		if GetConVar("stew_mod_mgsv"):GetBool() then
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
					self:SetReloadingTime( math.max( self:GetReloadingTime(), CurTime() + 0.3 ) )
				end
				doit2 = doit
			end
		end
		self:SetHoldType( ht )
		self:SetWeaponHoldType( ht )

		self:SetUserSight( p:KeyDown( IN_ATTACK2 ) )
		self:SetAim( math.Approach( self:GetAim(), (self:GetUserSight() and !spint) and 1 or 0, FrameTime() / 0.4 ) )

		if self:GetLoadingTime() != 0 and self:GetLoadingTime() <= CurTime() then
			local needtoload = math.min( self.Primary.ClipSize - self:Clip1(), self:Ammo1() )
			self:SetClip1(self:Clip1() + needtoload)
			self:GetOwner():RemoveAmmo( needtoload, self.Primary.Ammo )
			self:SetLoadingTime( 0 )
		end

		if !p:KeyDown( IN_ATTACK ) then
			self:SetBurstCount( 0 )
		end
		if self:GetFiremodeDebounce() and !p:KeyDown(IN_RELOAD) then
			self:SetFiremodeDebounce( false )
		end
	end
end

function SWEP:DrawWorldModel( flags )
	if IsValid(self:GetOwner()) and (!self:GetUserSight() and self:GetReloadingTime() <= CurTime() and GetConVar("stew_mod_mgsv"):GetBool() or self:GetHolster_Time() != 0) then
		return false
	else
		self:DrawModel( flags )
	end
end


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
local eye_stand = 64
local eye_duck = 44
local eye_prone = 24
local globhit = Vector()
local globang = Angle()

waga = waga or Angle()

local ptimei = 0
hook.Add("CalcView", "STEW_TP", function( ply, pos, angles, fov )
	local w = ply:GetActiveWeapon()
	local scam = GetConVar("stew_camera"):GetInt()
	if !IsValid(w) then
		w = false
	end
	local ve = IsValid(ply:GetViewEntity()) and (ply != ply:GetViewEntity())
	if (scam == 2) or (scam == 1 and w and w.STEW) and !ve then
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
		
		if w and !w.STEW then
			view.fov = nil
		end

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
local desire = Angle( 0, 000, 0 )
local vel = 0
local lastviewangles = Angle()
hook.Add( "StartCommand", "STEW_StartCommand", function( ply, cmd )
	if CLIENT then
		local w = ply:GetActiveWeapon()
		local scam = GetConVar("stew_camera"):GetInt()
		if !IsValid(w) then
			w = false
		end
		local ve = IsValid(ply:GetViewEntity()) and (ply != ply:GetViewEntity())
		if !((scam == 2) or (scam == 1 and w and w.STEW)) or ve then
			waga:Set( cmd:GetViewAngles() )
		else
			local w = ply:GetActiveWeapon()
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

			local muul = 1
			if IsValid(w) and w.AdjustMouseSensitivity then
				muul = w:AdjustMouseSensitivity() or muul
			end
			waga:Add( Angle( cmd:GetMouseY() * 0.022 * muul, cmd:GetMouseX() * -0.022 * muul, 0 ) )
			waga:Sub( ( lastviewangles - cmd:GetViewAngles() ) )
			waga.x = math.Clamp( waga.x, -89, 89 )
			waga:Normalize()

			local w = ply:GetActiveWeapon()
			local compatiblyaimed = false
			if IsValid(w) then
				if w.GetUserSight and w:GetUserSight() == false and GetConVar("stew_mod_mgsv"):GetBool() then
					compatiblyaimed = true
				elseif (w:GetNWBool( "insights", "shaa" ) == false) then
					--compatiblyaimed = true
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

				vel = math.Approach( vel, ply:GetAbsVelocity():Length2D(), FrameTime()*250 )
				--print("vel", vel)

				local honk = Vector( 100 * m1, 100 * -m2, 0 )
				honk = honk:Angle()
				honk.y = honk.y + waga.y
				if m3 > 0 then
					desire.y = honk.y
				end
				if honk.x != 90 then
				end
				local thingy = Lerp( Lerp( vel/100, 0, 100 )/100, 0.5, 0.5 )
				--print("thingy", thingy)
				dong.y = math.ApproachAngle( dong.y, desire.y, FrameTime()/(thingy/360) )
				cmd:SetViewAngles( dong )

				local thing = Matrix()
				--thing:Rotate( Angle( 0, waga.y, 0 ) )
				thing:Translate( Vector( 1000 * m3, 0, 0 ) )
				
				local forwar = thing:GetTranslation().x
				local rightwar = 0--thing:GetTranslation().y
				
				cmd:ClearMovement()
				cmd:SetForwardMove( forwar )
				cmd:SetSideMove( rightwar )
			else
				local planner = (tr2.HitPos-tr1.StartPos):Angle()
				planner:Normalize()
				cmd:SetViewAngles( planner )
				dong:Set( planner )
				desire:Set( planner )

				local pingas = Angle()
				pingas:Set( planner )
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
			lastviewangles:Set( cmd:GetViewAngles() )
		end
	end
end)

function SWEP:DoDrawCrosshair()
	return true
end

local col_1 = Color(255, 255, 255, 200)
local col_2 = Color(0, 0, 0, 255)
local col_3 = Color(255, 127, 127, 255)
local col_4 = Color(255, 222, 222, 255)
local mat_dot = Material("stew/xhair/dot.png", "mips smooth")
local mat_long = Material("stew/xhair/long.png", "mips smooth")
local mat_dot_s = Material("stew/xhair/dot_s.png", "mips smooth")
local mat_long_s = Material("stew/xhair/long_s.png", "mips smooth")
local spacer_long = 2 -- screenscaled
local gap = 24
hook.Add("HUDPaint", "STEW_3DCrosshair", function()
	if true then
		local ply = LocalPlayer()
		local w = ply:GetActiveWeapon()
		local wep = w
		
		local scam = GetConVar("stew_camera"):GetInt()
		if !IsValid(w) then
			w = false
		end

		local ve = IsValid(ply:GetViewEntity()) and (ply != ply:GetViewEntity())
		if ((scam >= 1 and w and w.STEW) and (!GetConVar("stew_mod_mgsv"):GetBool() or w:GetUserSight())) then
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
			if ve then
				pl_x = tr1f:ToScreen().x
				pl_y = tr1f:ToScreen().y
				ps_x = tr1f:ToScreen().x
				ps_y = tr1f:ToScreen().y
			elseif util.TraceLine({start = tr2f, endpos = tr1f, filter = ply}).Fraction != 1 and !tr2f:IsEqualTol(tr1f, 1) then
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
				if wep.XHairMode == "rifle" then
					surface.SetMaterial( mat1 )
					surface.DrawTexturedRectRotated( poosx - s(spacer_long) - gap, poosy, s(16), s(16), 0 )
					surface.DrawTexturedRectRotated( poosx + s(spacer_long) + gap, poosy, s(16), s(16), 0 )

					surface.SetMaterial( mat2 )
					surface.DrawTexturedRectRotated( poosx, poosy - gap, s(16), s(16), 0 )
					surface.DrawTexturedRectRotated( poosx, poosy + gap, s(16), s(16), 0 )
				elseif wep.XHairMode == "smg" then
					surface.SetMaterial( mat1 )
					surface.DrawTexturedRectRotated( poosx, poosy + gap + s(spacer_long), s(16), s(16), 90 )
					surface.DrawTexturedRectRotated( poosx - (math.sin(math.rad(45))*gap) - (math.sin(math.rad(45))*s(spacer_long)), poosy - (math.sin(math.rad(45))*gap) - (math.sin(math.rad(45))*s(spacer_long)), s(16), s(16), -45 )
					surface.DrawTexturedRectRotated( poosx + (math.sin(math.rad(45))*gap) + (math.sin(math.rad(45))*s(spacer_long)), poosy - (math.sin(math.rad(45))*gap) - (math.sin(math.rad(45))*s(spacer_long)), s(16), s(16), 45 )

					surface.SetMaterial( mat2 )
					surface.DrawTexturedRectRotated( poosx, poosy, s(16), s(16), 0 )
				else -- pistol
					surface.SetMaterial( mat2 )
					surface.DrawTexturedRectRotated( poosx - gap, poosy, s(16), s(16), 0 )
					surface.DrawTexturedRectRotated( poosx + gap, poosy, s(16), s(16), 0 )

					surface.SetMaterial( mat2 )
					surface.DrawTexturedRectRotated( poosx, poosy - gap, s(16), s(16), 0 )
					surface.DrawTexturedRectRotated( poosx, poosy + gap, s(16), s(16), 0 )
				end
			end
		end
	end
end)