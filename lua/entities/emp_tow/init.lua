AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.StaicWeaponName = "BGM-71 TOW"

ENT.NextFire = CurTime() -- Internal var, do not touch, used for shoot delay
ENT.GunBuildFinish = false -- Internal bool, do not touch
ENT.Gunner = nil -- Internal ent, do not touch, represents player 
ENT.Gun = nil -- Internal ent, do not touch, represents turret 
ENT.IsReloading = false -- Internal bool, do not touch

ENT.TripodModel = "models/kali/weapons/tow/parts/m220 tow launcher tripod.mdl"
ENT.GunModel = "models/kali/weapons/tow/parts/m220 tow launcher barrel.mdl"
 
ENT.GunOffsetVec = Vector(0,0,34)

ENT.GunOffsetAng = Angle(0,0,0) 
ENT.GunSpawnAngle = Angle(0,-180,0)

ENT.GunCameraUp = 0 --12 - 50m, 13 - 100m, 13.5 - 150m
ENT.GunCameraForward = 3.4 
ENT.GunCameraRight = -8
ENT.GunCameraFOV = 12
ENT.ZeroingTable = {[1] = {["Distance"] = 50, ["CamUp"] = 12},[2] = {["Distance"] = 100, ["CamUp"] = 13}}

ENT.MatrixOffsetAngle = Angle(0,0,0) -- Matrix rotation
ENT.ProjectileOffset = Vector(0,0,0) -- Projectile spawn offset 
ENT.ExitDistance = 128 -- How far player can be from weapon
ENT.GunRPM = 60 / 6 -- 60 Seconds / Actual RPM

ENT.GunSoundFire = "emp/tow/fire.wav"	-- Fire sound 
ENT.GunSoundReload = "emp/mk19/reload.wav" -- Reload sound 
ENT.GunSoundDistant = "emp/spg9/distant.wav" -- Distant fire sound 
ENT.Magazine = 1 -- Magazine capacity 
ENT.ReloadTime = 12 -- Reload time in seconds
ENT.Health = 100 
ENT.ScopeOverlay = "scopes/tow.png"
ENT.MuzzleFlashEffect = "ins_weapon_at4_frontblast"
ENT.ManualReload = true  
ENT.ProjectileList = {["proj_tow"] = true}
ENT.RoundInChamber = nil 
ENT.ManualInsertSound = "emp/spg9/load.wav"
ENT.ManualEjectSound = "emp/spg9/unload.wav"
ENT.DamageSimfphys = 5000
ENT.RotationSpeed = 32
ENT.MaxRotation = 360
ENT.MaxElevation = 180
ENT.MaxDescension = 180
ENT.ManualReloadTime = 1
ENT.ScopeSensetivity = 0.1
ENT.SpawnOffset = Vector(0,0,230)
ENT.HP = 200 

ENT.ManualReloadZoneMaxs = Vector(8,8,8) -- BBOX of manual reloading zone
ENT.ManualReloadZoneMins = Vector(-8,-8,-8)
ENT.ManualReloadZoneOffset = Vector(-10,0,0)


ENT.ShouldDoBackBlast = true 

ENT.ShouldDoBackBlast = true 
ENT.BackblastPosition = Vector(-200,0,8)
ENT.BackblastRange = 128

function ENT:DoBackblast()


	local position = self.Gun:GetPos() + self.Gun:GetForward() * self.BackblastPosition.X + self.Gun:GetRight() * self.BackblastPosition.Y + self.Gun:GetUp() * self.BackblastPosition.Z
	ParticleEffect("door_explosion_core", position,  self.Gun:GetAngles() - Angle(0,180,0))
	local back_check = util.TraceLine( {
		start = self.Gun:GetPos() - self.Gun:GetForward()* 32,
		endpos = position,
		filter = {self,self.Gun,self.AmmoTube,self.Thingy, "proj_tow"}
	})

	local d = position:Distance(back_check.HitPos) 

	local backblast_zone = ents.FindInSphere(back_check.HitPos, self.BackblastRange + d) 


	if d >= 35 then 
		--print("Overpressure!")
			ParticleEffect("ep2_ExplosionCore", position,  self.Gun:GetAngles() - Angle(0,180,0))
			self:EmitSound("impact/Overpressure.wav")
	end 

	for k,v in pairs(backblast_zone) do 
		local tr = util.TraceLine({
		start = self.Gun:GetPos()- self.Gun:GetForward() * 32,
		endpos = v:GetPos(),
		filter = {self,self.Gun,self.AmmoTube,self.Thingy}
		})	

		if tr.Entity == v then 
			--print(v:GetClass().." has been hit with blastwave")
			local m = v:GetPos():Distance(back_check.HitPos) * 1.95 / 100 
			if d <= 0 then d = 1 end
			v:TakeDamage(100/m*d/10, self.Gunner, self)
			if v:GetClass() == "prop_physics" then 
				local phys = v:GetPhysicsObject()
				phys:ApplyForceCenter(self:GetPos() - tr.HitNormal * 9069 )
			end 

		end 

	end 
end 


function ENT:OnLastShot()
	self.AmmoTube:SetBodygroup(1,1)	
end 

function ENT:OnUnload()
	self.AmmoTube:Remove()

	local shell = ents.Create("prop_physics")
	shell:SetPos(self.Gun:GetPos() - self.Gun:GetForward() * 49 )
	shell:SetAngles(self.Gun:GetAngles())
	shell:SetModel("models/kali/weapons/tow/parts/m220 tow launcher missile tube.mdl")
	shell:Spawn()
	shell:SetBodygroup(1,1)
end 

function ENT:OnLoad()

	self.AmmoTube = ents.Create("prop_dynamic")
	self.AmmoTube:SetPos(self:GetPos()+ self:GetUp()*34)
	self.AmmoTube:SetAngles(self.Gun:GetAngles())
	self.AmmoTube:SetModel("models/kali/weapons/tow/parts/m220 tow launcher missile tube.mdl")
	self.AmmoTube:SetParent(self.Gun)
	self.AmmoTube:Spawn()

	self.Gun:SetBodygroup(1,0)
	self.Gun:SetBodygroup(2,1)
end


function ENT:OnFinishInit()
	
end 

function ENT:OnShoot(shell_angle)

	util.ScreenShake( self:GetPos(), 10, 10, 0.6, 1000 )
end 

function ENT:PostThink()
	if self.Thingy then 
		self.Thingy:SetAngles(Angle(self:GetAngles().p,self.Gun:GetAngles().y,self:GetAngles().r))
	end 
end 

function ENT:OnGunBuild()
	self.Thingy = ents.Create("prop_dynamic")
	self.Thingy:SetPos(self:GetPos()+ self:GetUp()*21)
	self.Thingy:SetAngles(self.Gun:GetAngles())
	self.Thingy:SetModel("models/kali/weapons/tow/parts/m220 tow launcher cradle.mdl")
	self.Thingy:SetParent(self)
	self.Thingy:Spawn()

	self.Scope = ents.Create("prop_dynamic")
	self.Scope:SetPos(self:GetPos() - self:GetRight()*10 + self:GetUp()*40)
	self.Scope:SetAngles(self.Gun:GetAngles())
	self.Scope:SetModel("models/kali/weapons/tow/parts/m220 tow launcher sight.mdl")
	self.Scope:SetParent(self.Thingy)
	self.Scope:Spawn()
end 