AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.StaicWeaponName = "SHD Turret-9"

ENT.NextFire = CurTime() -- Internal var, do not touch, used for shoot delay
ENT.GunBuildFinish = false -- Internal bool, do not touch
ENT.Gunner = nil -- Internal ent, do not touch, represents player 
ENT.Gun = nil -- Internal ent, do not touch, represents turret 
ENT.IsReloading = false -- Internal bool, do not touch

ENT.TripodModel = "models/shd/shd_turret_base.mdl"
ENT.GunModel = "models/shd/shd_gun-1.mdl"
 
ENT.GunOffsetVec = Vector(0,0,0)
ENT.GunOffsetAng = Angle(0,90,0) 
ENT.GunSpawnAngle = Angle(0,180,0)
ENT.TripodOffsetAngle = Angle(0,-90,0)
ENT.ExitDistance = 1228 -- How far player can be from weapon
ENT.GunRPM = 60 / 650 -- 60 Seconds / Actual RPM
ENT.GunSoundFire = "emp/turret/fire.wav"	-- Fire sound 

ENT.SpawnOffset = Vector(0,0,230)

ENT.ProjectileOffset = Vector(13,0,4)
ENT.MuzzleFlashEffect = "muzzleflash_ak74"

ENT.ShouldBeMountable = false
ENT.LifeTime = 15
ENT.HP = 256
ENT.RotationSpeed = 100

function ENT:OnFinishInit()
	self:SetBodygroup(1, 1)
end 

function ENT:OnGunBuild()
	self.Thingy = ents.Create("prop_dynamic")
	self.Thingy:SetPos(self:GetPos())
	self.Thingy:SetAngles(self.Gun:GetAngles())
	self.Thingy:SetModel("models/shd/shd_turret_thingy.mdl")
	self.Thingy:SetParent(self)
	self.Thingy:Spawn()	
	self.InternalLifeTime = CurTime() + self.LifeTime
end 


function ENT:PostThink()

	if self.Thingy then 
		self.Thingy:SetAngles(Angle(self:GetAngles().p,self.Gun:GetAngles().y,self:GetAngles().r))
	end 

	local a = ents.FindInSphere(self:GetPos(), 2048) 

	for k, v in pairs(a) do 
		if v:IsNPC() then 
			if v:Health() <= 0 then return end

			local target_angle = (v:GetPos() + v:OBBCenter() - self:GetPos()):Angle()

			local dir = dir or self.Gun:GetAngles():Forward()
		
			local old_angle = self.Gun:GetAngles()


    		local newpitch = math.ApproachAngle( old_angle.p, target_angle.p, self.RotationSpeed * FrameTime() )
			local newyaw = math.ApproachAngle( old_angle.y, target_angle.y, self.RotationSpeed * FrameTime() )
    		local newelev = math.ApproachAngle( old_angle.r, target_angle.r, self.RotationSpeed * FrameTime() )

   			self.Gun:SetAngles(Angle(math.ApproachAngle( old_angle.p, newpitch, self.RotationSpeed * FrameTime()),newyaw,math.ApproachAngle( old_angle.r, newelev, self.RotationSpeed * FrameTime() ) )) 
   			
			if self.Gun:Visible(v) then 
   				self:ShootBulletsCustom()
   			end

		end 	
	end 


end 


function ENT:ShootBulletsCustom()

	if self.NextFire <= CurTime() then 

		sound.Play( self.GunSoundFire, self:GetPos(), 120, math.random(90,110), 1 )
		bullet = {}
		bullet.Num=1
		bullet.Src = self.Gun:GetPos()
		bullet.Dir = self.Gun:GetAngles():Forward()
		bullet.Spread=Vector(0.01,0.01,0)
		bullet.TracerName = "tracer_green"	
		bullet.Tracer = 4
		bullet.Force= 1
		bullet.Damage= 3

		local light = ents.Create("light_dynamic")
		light:Spawn()
		light:Activate()
		light:SetKeyValue("distance", 128) 
		light:SetKeyValue("brightness", 5)
		light:SetKeyValue("_light", "255 192 64") 
		light:Fire("TurnOn")
		light:SetPos(self.Gun:GetPos())
	
		timer.Simple(0.1,function() light:Remove() end)

		self.Gun:FireBullets(bullet)		
		self.NextFire = CurTime() + self.GunRPM

		ParticleEffect(self.MuzzleFlashEffect, self.Gun:GetPos() + self.Gun:GetForward() * self.ProjectileOffset.X + self.Gun:GetRight() * self.ProjectileOffset.Y + self.Gun:GetUp() * self.ProjectileOffset.Z,  self.Gun:GetAngles()- Angle(0,0,0))

	 	self:OnFirePewPews(self.Mag)

	end
end