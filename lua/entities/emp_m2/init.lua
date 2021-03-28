AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.StaicWeaponName = "SPG-9"

ENT.NextFire = CurTime() -- Internal var, do not touch, used for shoot delay
ENT.GunBuildFinish = false -- Internal bool, do not touch
ENT.Gunner = nil -- Internal ent, do not touch, represents player 
ENT.Gun = nil -- Internal ent, do not touch, represents turret 
ENT.IsReloading = false -- Internal bool, do not touch

ENT.TripodModel = "models/m2/rs2_tripod.mdl"
ENT.GunModel = "models/m2/rs2_m2.mdl"
 
ENT.GunOffsetVec = Vector(-1.8,12.5,9)
ENT.GunOffsetAng = Angle(0,90,0) 

ENT.GunCameraUp = 9.9 --12 - 50m, 13 - 100m, 13.5 - 150m
ENT.GunCameraForward =-0.2 
ENT.GunCameraRight = -40
ENT.GunCameraFOV = 20


ENT.GunSpawnAngle = Angle(0,-90,0)
ENT.TripodOffsetAngle = Angle(0,-90,0)



ENT.ZeroingTable = {[1] = {["Distance"] = 50, ["CamUp"] = 9.9},[2] = {["Distance"] = 100, ["CamUp"] = 9.8},[3] = {["Distance"] = 150, ["CamUp"] = 9.7}}
ENT.ScopeSensetivity = 0.25
ENT.MatrixOffsetAngle = Angle(0,-90,0) -- Matrix rotation
ENT.ProjectileOffset = Vector(0,60,4) -- Projectile spawn offset 
ENT.ExitDistance = 128 -- How far player can be from weapon
ENT.GunRPM = 60 / 650 -- 60 Seconds / Actual RPM

ENT.GunSoundFire = "emp/m2/fire_new.wav"	-- Fire sound 
ENT.GunSoundReload = "emp/mk19/reload.wav" -- Reload sound 
ENT.GunSoundDistant = "emp/spg9/distant.wav" -- Distant fire sound 
ENT.Magazine = 1 -- Magazine capacity 
ENT.ReloadTime = 12 -- Reload time in seconds
ENT.HP = 100 

ENT.MuzzleFlashEffect = "muzzleflash_ak74"
ENT.ManualReload = true  
ENT.ProjectileList = {[ACT3_GetBulletID("50bmg_api")] = true, [ACT3_GetBulletID("50bmg_ap")] = true, [ACT3_GetBulletID("50bmg_hei")] = true, [ACT3_GetBulletID("50bmg_trg")] = true}
ENT.RoundInChamber = nil 
ENT.ManualInsertSound = "emp/m2/load.wav"
ENT.ManualEjectSound = "emp/m2/unload.wav"
ENT.DamageSimfphys = 5000
ENT.RotationSpeed = 32
ENT.MaxRotation = 180
ENT.MaxElevation = 25
ENT.MaxDescension = 10
ENT.ShouldFireBullets = true
ENT.CasingOffset = Vector(-10,-5,6)
ENT.SpawnOffset = Vector(0,0,230)
ENT.ManualReloadZoneOffset = Vector(18,-5,8)

function ENT:OnLastShot()
	self.Ammo:SetBodygroup(2,2)
end 

function ENT:OnUnload()
	self.Gun:SetBodygroup(1,1)
	local dummy = ents.Create("prop_physics")
	dummy:SetModel("models/m2/rs2_m2_ammo.mdl")
	dummy:SetPos(self.Ammo:GetPos())
	dummy:SetAngles(self.Ammo:GetAngles())
	dummy:Spawn()
	self.Ammo:Remove()
	dummy:SetBodygroup(2,2)
	dummy:SetBodygroup(1,1)
end 

function ENT:OnLoad()
	self.Ammo = ents.Create("prop_physics")
	self.Ammo:SetPos(self.Thingy:GetPos() + self.Thingy:GetRight()*-5 + self.Thingy:GetForward()*17 + self.Thingy:GetUp()*4)
	self.Ammo:SetModel("models/m2/rs2_m2_ammo.mdl")
	self.Ammo:SetParent(self.Thingy)
	self.Ammo:Spawn()
	self.Ammo:SetAngles(self.Thingy:GetAngles() - Angle(20,0,0))
	self.NextFire = CurTime() + 3
	timer.Simple(2,function()
		if not IsValid(self) then return end
		self:EmitSound("emp/m2/cover.wav")
		self.Gun:SetBodygroup(1,0)
		self.Gun:SetBodygroup(2,1)
		timer.Simple(1,function()
			if not IsValid(self) then return end
			self:EmitSound("emp/m2/cycle.wav")
		end)
	end)
end


function ENT:OnFinishInit()
	self.Gun:SetBodygroup(1,1)
	self.Gun:SetBodygroup(2,1)

end 

function ENT:OnShoot(shell_angle)

	util.ScreenShake( self:GetPos(), 10, 10, 0.6, 1000 )
end 


function ENT:OnGunBuild()
	self.Thingy = ents.Create("prop_dynamic")
	self.Thingy:SetPos(self:GetPos() + self:GetRight()*12 - self:GetForward()*2 + self:GetUp()*9)
	self.Thingy:SetAngles(self.Gun:GetAngles())
	self.Thingy:SetModel("models/m2/rs2_support.mdl")
	self.Thingy:SetParent(self)
	self.Thingy:Spawn()
end 
ENT.Spread = Vector(0,0,0)


ENT.NextFart = CurTime()

function ENT:PostThink()
	if self.Thingy then 
		self.Thingy:SetAngles(Angle(self:GetAngles().p,self.Gun:GetAngles().y,self:GetAngles().r))
		if self.Heat > 0 then 
			self.Heat = math.Clamp(self.Heat  - 2, 0, 1000)
		end
		self.Spread = Vector(self.Heat ,self.Heat ,0)
		if self.Heat >= 400 then 
			if self.HeatEffect == false then  
				self.Gun.Smoke = ents.Create("prop_dynamic")
				self.Gun.Smoke:SetModel("models/hunter/blocks/cube025x025x025.mdl")
				self.Gun.Smoke:Spawn()
				self.Gun.Smoke:SetPos(self.Gun:GetPos() + self.Gun:GetForward() * self.ProjectileOffset.X + self.Gun:GetRight() * self.ProjectileOffset.Y + self.Gun:GetUp() * self.ProjectileOffset.Z)
				self.Gun.Smoke:SetParent(self.Gun)
				self.Gun.Smoke:SetAngles(self.Gun:GetAngles())
				self.Gun.Smoke:SetModelScale(0)
				self.HeatEffect = true 
				ParticleEffectAttach("smoke_gib_01",PATTACH_ABSORIGIN,self.Gun.Smoke,1)
				timer.Simple(5,function() self.Gun.Smoke:Remove() self.HeatEffect = false end)
			end
		end 

	end 

end 

ENT.Heat = 0
ENT.HeatEffect = false 
function ENT:ShootBulletsCustom()

	if self.ManualReload == true and not self.RoundInChamber then return end

	if self.Mag <= 0 or self.IsReloading == true and not self.ManualReload then 
		--self:ReloadPewPews()
	return end 

	if self.NextFire <= CurTime() then 

		local r_vec = VectorRand( -10 * self.Spread.x / 30, 10 * self.Spread.y / 30 )
		self.Gun:SetNWVector("R_VEC", r_vec)

		pos = self.Gun:GetPos() + self.Gun:GetForward() * self.ProjectileOffset.X + self.Gun:GetRight() * self.ProjectileOffset.Y + self.Gun:GetUp() * self.ProjectileOffset.Z
		ACT3_ShootPBullet(pos + self.Gun:GetRight()*64, self.Gun:GetRight()*46000 + self.Gun:GetNWVector("r_vec"), self, self, self.RoundInChamber, true, 1, 1, 1, 100000)
		self.NextFire = CurTime() + self.GunRPM
		sound.Play( self.GunSoundFire, self:GetPos(), 120, math.random(80,100), 1 )

		self.Gunner:ViewPunch( Angle( -0.45, 0, 0 ) )
    	self.Heat = math.Clamp(self.Heat + 30, 0, 10000)

		ParticleEffect(self.MuzzleFlashEffect, self.Gun:GetPos() + self.Gun:GetForward() * self.ProjectileOffset.X + self.Gun:GetRight() * self.ProjectileOffset.Y + self.Gun:GetUp() * self.ProjectileOffset.Z,  self.Gun:GetAngles()- Angle(0,90,0))
		--local vPoint = self.Gun:GetPos() + self.Gun:GetForward() * self.CasingOffset.X + self.Gun:GetRight() * self.CasingOffset.Y + self.Gun:GetUp() * self.CasingOffset.Z
		--local effectdata = EffectData()
		--effectdata:SetOrigin( vPoint )
		--effectdata:SetFlags( 2 )
		--effectdata:SetAngles( self.Gun:GetAngles() - Angle(0,0,90))
		--util.Effect( "EjectBrass_338Mag", effectdata )

	 	if self.ManualReload == true then 
     	   	self.Mag = self.Mag - 1
     	   	if self.Mag <= 0 then 
     	   		self:OnLastShot()
     	   		self.RoundInChamber = "empty" 
     	   	end
     	   end 
	
     	   if self.ManualReload == false then 
	 	  		self.Mag = self.Mag - 1 -- Mag consumption
	 	  		if self.Mag == 0 then self:OnLastShot() end 
	 	  	end  
	
	 	  	self:OnFirePewPews(self.Mag)
	end
end
