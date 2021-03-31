AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.StaicWeaponName = "SPG-9"

ENT.NextFire = CurTime() -- Internal var, do not touch, used for shoot delay
ENT.GunBuildFinish = false -- Internal bool, do not touch
ENT.Gunner = nil -- Internal ent, do not touch, represents player 
ENT.Gun = nil -- Internal ent, do not touch, represents turret 
ENT.IsReloading = false -- Internal bool, do not touch

ENT.TripodModel = "models/spg9/spg9_tripod_squad.mdl"
ENT.GunModel = "models/spg9/spg9_tube_squad.mdl"
 
ENT.GunOffsetVec = Vector(4,0,15)

ENT.GunOffsetAng = Angle(0,90,0) 
ENT.GunSpawnAngle = Angle(0,-90,0)

ENT.GunCameraUp = 12 --12 - 50m, 13 - 100m, 13.5 - 150m
ENT.GunCameraForward = 3.4 
ENT.GunCameraRight = 22
ENT.GunCameraFOV = 40
ENT.ZeroingTable = {[1] = {["Distance"] = 50, ["CamUp"] = 12},[2] = {["Distance"] = 100, ["CamUp"] = 13},[3] = {["Distance"] = 150, ["CamUp"] = 13.5}}
ENT.ScopeSensetivity = 0.25
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
ENT.DamageSimfphys = 5000
ENT.RotationSpeed = 15
ENT.MaxRotation = 15
ENT.MaxElevation = 10
ENT.MaxDescension = 10
ENT.HP = 200 
ENT.SpawnOffset = Vector(0,0,230)

ENT.ShouldDoBackBlast = true 
ENT.BackblastPosition = Vector(0,-200,8)
ENT.BackblastRange = 128

function ENT:DoBackblast()


	local position = self.Gun:GetPos() + self.Gun:GetForward() * self.BackblastPosition.X + self.Gun:GetRight() * self.BackblastPosition.Y + self.Gun:GetUp() * self.BackblastPosition.Z
	ParticleEffect("door_explosion_core", position,  self.Gun:GetAngles() - Angle(0,180,0))

	local back_check = util.TraceLine( {
		start = self.Gun:GetPos(),
		endpos = position,
		filter = {self,self.Gun}
	})

	local d = position:Distance(back_check.HitPos) 

	local backblast_zone = ents.FindInSphere(back_check.HitPos, self.BackblastRange + d) 


	if d >= 35 then 
		--print("Overpressure!")
					ParticleEffect("ep2_ExplosionCore", back_check.HitPos,  self.Gun:GetAngles() - Angle(0,180,0))
			self:EmitSound("emp/impact/Overpressure.wav")
	end 

	for k,v in pairs(backblast_zone) do 
		local tr = util.TraceLine({
		start = self.Gun:GetPos(),
		endpos = v:GetPos(),
		filter = {self,self.Gun, self}
		})	

		if tr.Entity == v then 
			--print(v:GetClass().." has been hit with blastwave")
			local m = v:GetPos():Distance(back_check.HitPos) * 1.95 / 100 
			if d <= 0 then d = 1 end
			print(100 / m * d / 10)
			v:TakeDamage(100/m*d/10, self.Gunner, self)
			if v:GetClass() == "prop_physics" then 
				local phys = v:GetPhysicsObject()
				phys:ApplyForceCenter(self:GetPos() - tr.HitNormal * 9069 )
			end 

		end 

	end 
end 



function ENT:DoBackblast2()


end 



function ENT:OnLastShot()
	self.Gun:SetBodygroup(1,1)
end 

function ENT:OnUnload()
	self.Gun:SetBodygroup(1,1)
	self.Gun:SetBodygroup(2,0)
end 

function ENT:OnLoad()
	self.Gun:SetBodygroup(1,0)
	self.Gun:SetBodygroup(2,1)
end


function ENT:OnFinishInit()
	self.Gun:SetBodygroup(1,1)
end 

function ENT:OnShoot(shell_angle)
	util.ScreenShake( self:GetPos(), 10, 10, 0.6, 1000 )
end 