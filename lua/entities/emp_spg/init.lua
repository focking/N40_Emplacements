AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.StaicWeaponName = "SPG-9"

ENT.NextFire = CurTime() -- Internal var, do not touch, used for shoot delay
ENT.GunBuildFinish = false -- Internal bool, do not touch
ENT.Gunner = nil -- Internal ent, do not touch, represents player 
ENT.Gun = nil -- Internal ent, do not touch, represents turret 
ENT.IsReloading = false -- Internal bool, do not touch

ENT.GunProjectile = "proj_40x53"
ENT.TripodModel = "models/spg9/cooller_tripod_8.mdl"
ENT.GunModel = "models/static/spg9_squad_fin.mdl"

ENT.GunOffsetVec = Vector(4,0,15)

ENT.GunOffsetAng = Angle(0,90,0) 
ENT.GunCameraUp = 12
ENT.GunCameraForward = 3.4 
ENT.GunCameraRight = 22
ENT.GunCameraFOV = 40
ENT.MatrixOffsetAngle = Angle(0,-90,0) -- Matrix rotation
ENT.ProjectileOffset = Vector(0,86,8) -- Projectile spawn offset 
ENT.ExitDistance = 128 -- How far player can be from weapon
ENT.GunRPM = 60 / 6 -- 60 Seconds / Actual RPM

ENT.GunSoundFire = "emp/spg9/fire.wav"	-- Fire sound 
ENT.GunSoundReload = "emp/mk19/reload.wav" -- Reload sound 
ENT.GunSoundDistant = "emp/spg9/distant.wav" -- Distant fire sound 
ENT.Magazine = 1 -- Magazine capacity 
ENT.ReloadTime = 12 -- Reload time in seconds
ENT.Health = 100 

ENT.MuzzleFlashEffect = "ins_weapon_at4_frontblast"
ENT.ManualReload = true  
ENT.ProjectileList = {["proj_spg"] = true}
ENT.RoundInChamber = nil 
ENT.ManualInsertSound = "emp/spg9/load.wav"
ENT.ManualEjectSound = "emp/spg9/unload.wav"

function ENT:OnLastShot()
	self.Gun:SetBodygroup(1,1)
end 

function ENT:OnUnload()
	self.Gun:SetBodygroup(1,1)
	self.Gun:SetBodygroup(2,0)
end 

function ENT:OnLoad()
	print("OnLoad")
	self.Gun:SetBodygroup(1,0)
	self.Gun:SetBodygroup(2,1)
end


function ENT:OnFinishInit()
	self.Gun:SetBodygroup(1,1)
end 

function ENT:OnShoot(shell_angle)
	util.ScreenShake( self:GetPos(), 10, 10, 0.6, 1000 )
end 