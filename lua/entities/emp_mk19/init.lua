AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.StaicWeaponName = "MK-19"

ENT.NextFire = CurTime() -- Internal var, do not touch, used for shoot delay
ENT.GunBuildFinish = false -- Internal bool, do not touch
ENT.Gunner = nil -- Internal ent, do not touch, represents player 
ENT.Gun = nil -- Internal ent, do not touch, represents turret 
ENT.IsReloading = false -- Internal bool, do not touch

ENT.GunProjectile = "proj_40x53"
ENT.TripodModel = "models/mk19/tripod_fin.mdl"
ENT.GunModel = "models/mk19/mk19_fin.mdl"

ENT.GunOffsetVec = Vector(0,0,22)
ENT.GunOffsetAng = Angle(0,90,0) 
ENT.GunCameraUp = 7
ENT.GunCameraForward = 0
ENT.GunCameraRight =- 22
ENT.MatrixOffsetAngle = Angle(0,-90,0) -- Matrix rotation
ENT.ProjectileOffset = Vector(0,0,0) -- Projectile spawn offset 
ENT.ExitDistance = 90 -- How far player can be from weapon
ENT.GunRPM = 60 / 380 -- 60 Seconds / Actual RPM

ENT.GunSoundFire = "emp/mk19/fire.wav"	-- Fire sound 
ENT.GunSoundReload = "emp/mk19/reload.wav" -- Reload sound 
ENT.GunSoundDistant = "emp/mk19/distant.wav" -- Distant fire sound 
ENT.Magazine = 48 -- Magazine capacity 
ENT.ReloadTime = 12 -- Reload time in seconds
ENT.Health = 100 
function ENT:OnFinishReload()
	self.Gun:SetBodygroup(1, 0)
	self.Gun:SetBodygroup(2, 0)
	self.Gun:SetBodygroup(3, 0)
end 

function ENT:OnFirePewPews(roundsleft) -- Called after shot and parses mag capacity to this function 
	if roundsleft == 3 then 
		self.Gun:SetBodygroup(3, 1)
	end 
	if roundsleft == 2 then 
		self.Gun:SetBodygroup(2, 1)
	end 
	if roundsleft == 1 then 
		self.Gun:SetBodygroup(1, 1)
	end 
end 
