AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.StaicWeaponName = "AGS-30"

ENT.NextFire = CurTime() -- Internal var, do not touch, used for shoot delay
ENT.GunBuildFinish = false -- Internal bool, do not touch
ENT.Gunner = nil -- Internal ent, do not touch, represents player 
ENT.Gun = nil -- Internal ent, do not touch, represents turret 
ENT.IsReloading = false -- Internal bool, do not touch

ENT.GunProjectile = "proj_30x29"
ENT.TripodModel = "models/escape from tarkov/static/weapons/tripod.mdl"
ENT.GunModel = "models/escape from tarkov/static/weapons/ags-30.mdl"
ENT.GunOffsetVec = Vector(0,0,0)
ENT.GunOffsetAng = Angle(0,90,0)

ENT.MatrixOffsetAngle = Angle(0,-90,0) -- Matrix rotation
ENT.TripodOffsetAngle = Angle(0,-90,0)

ENT.GunCameraUp = 24
ENT.GunCameraForward = 0
ENT.GunCameraRight = 0

ENT.ManualReload = true 
ENT.ProjectileList = {["proj_30x29"] = true}
ENT.RoundInChamber = nil 

ENT.ManualInsertSound = "emp/ags30/load.wav"
ENT.ManualEjectSound = "emp/ags30/unload.wav"
ENT.ProjectileOffset = Vector(0,36,17.5) -- Projectile spawn offset 
ENT.ExitDistance = 90 -- How far player can be from weapon
ENT.GunRPM = 60 / 400 -- 60 Seconds / Actual RPM

ENT.GunSoundFire = "emp/ags30/fire.wav"	-- Fire sound 
ENT.GunSoundReload = "emp/ags30/reload.wav" -- Reload sound 
ENT.GunSoundDistant = "emp/ags30/distant.wav" -- Distant fire sound 
ENT.ManualReloadTime = 0

function ENT:OnLoad()
	self.VisualMagazine = ents.Create("prop_physics")
	self.VisualMagazine:SetModel("models/escape from tarkov/static/weapons/magazine.mdl")
	self.VisualMagazine:SetPos(self.Gun:GetPos())
	self.VisualMagazine:SetAngles(self.Gun:GetAngles())
	self.VisualMagazine:Spawn()
	self.VisualMagazine:SetParent(self.Gun)
end 

function ENT:OnUnload()
	local dummy = ents.Create("prop_physics")
	dummy:SetModel("models/escape from tarkov/static/weapons/magazine.mdl")
	dummy:SetPos(self.VisualMagazine:GetPos())
	dummy:SetAngles(self.VisualMagazine:GetAngles())
	dummy:Spawn()
	self.VisualMagazine:Remove()
	dummy:SetBodygroup(1,1)
end

function ENT:OnFinishReload()
	--self.VisualMagazine = ents.Create("prop_physics")
	--self.VisualMagazine:SetModel("models/escape from tarkov/static/weapons/magazine.mdl")
	--self.VisualMagazine:SetPos(self.Gun:GetPos())
	--self.VisualMagazine:SetAngles(self.Gun:GetAngles())
	--self.VisualMagazine:Spawn()
	--self.VisualMagazine:SetParent(self.Gun)
end