AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.StaicWeaponName = "MK-19" 

ENT.NextFire = CurTime() -- Internal var, do not touch, used for shoot delay
ENT.GunBuildFinish = false -- Internal bool, do not touch
ENT.Gunner = nil -- Internal ent, do not touch, represents player 
ENT.Gun = nil -- Internal ent, do not touch, represents turret 
ENT.IsReloading = false -- Internal bool, do not touch
ENT.NextScope = CurTime() -- Internal var, do not touch, used for scope delay
ENT.InspectionTime = 0 -- Internal var, do not touch, used for scope delay
ENT.IsCheckingAmmo = false -- Internal bool, do not touch



ENT.GunProjectile = "ags_projectile"
ENT.TripodModel = "models/models/tripod.mdl"
ENT.GunModel = "models/models/mk19_3.mdl"
ENT.GunOffsetVec = Vector(0,0,18)

ENT.GunOffsetAng = Angle(0,90,0)
ENT.MatrixOffsetAngle = Angle(0,-90,0) -- Matrix rotation
ENT.GunCameraUp = 1 -- Gun camera Z offset
ENT.GunCameraForward = 1
ENT.GunCameraRight = 1
ENT.ScopeOverlay = "none"


ENT.ScopeSensetivity = 1
ENT.SpawnOffset = Vector(0,0,0)

ENT.TripodOffsetAngle = Angle(0,0,0)
ENT.ProjectileOffset = Vector(0,0,0) -- Projectile spawn offset 
ENT.ExitDistance = 90 -- How far player can be from weapon
ENT.GunRPM = 60 / 400 -- 60 Seconds / Actual RPM
ENT.GunCameraFOV = 90
ENT.MuzzleFlashEffect = "muzzleflash_ar2_npc"
ENT.ZeroingTable = {}
ENT.GunSoundFire = "emp/ags30/fire.wav"	-- Fire sound 
ENT.GunSoundReload = "emp/ags30/reload.wav" -- Reload sound 
ENT.GunSoundDistant = "emp/ags30/distant.wav" -- Distant fire sound 
ENT.Magazine = 48 -- Magazine capacity 
ENT.ReloadTime = 12 -- Reload time in seconds

ENT.RotationSpeed = 15
ENT.MaxRotation = 15
ENT.MaxElevation = 15
ENT.MaxDescension = 15

ENT.ManualReloadZoneMaxs = Vector(8,8,8) -- BBOX of manual reloading zone
ENT.ManualReloadZoneMins = Vector(-8,-8,-8)
ENT.ManualReloadZoneOffset = Vector(0,-32,8) -- Offset of BBOX

ENT.ManualReload = false 
ENT.ProjectileList = {["proj_spg9_at"] = true ,["proj_spg9_shaped"] = true} -- Allowed ammo defined by ProjectileEnt in Ammo Ent
ENT.RoundInChamber = nil 
ENT.ManualInsertSound = ""
ENT.ManualEjectSound = ""
ENT.HP = 1000 
ENT.ManualReloadTime = 4 -- Delay in seconds before shell loaded in and ready



function ENT:Initialize()
	if SERVER then

		self:SetModel(self.TripodModel)
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetUseType(SIMPLE_USE)
        self:DrawShadow( true )
        self:SetAngles(self:GetAngles() + self.TripodOffsetAngle)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:SetBuoyancyRatio(0)
        end

		self:BuildGun()
		self:OnFinishInit()

    end 
    	self:SetPos(self:GetPos()+self.SpawnOffset)

    	self.ANGLE_TABLE = {
			["GunOffsetAng"] = self.GunOffsetAng,
			["MatrixOffsetAngle"] = self.MatrixOffsetAngle,
			["GunCameraUp"] = self.GunCameraUp,
			["GunCameraForward"] = self.GunCameraForward,
			["GunCameraRight"] = self.GunCameraRight,
			["ScopeOverlay"] = self.ScopeOverlay,
			["GunCameraFOV"] = self.GunCameraFOV,
		    ["ZeroingTable"] = self.ZeroingTable, 
		    ["ScopeOverlay"] = self.ScopeOverlay,
		    ["ScopeSensetivity"] = self.ScopeSensetivity,
		}

end




function ENT:OnLastShot()

end 

function ENT:OnShoot(shell_angle)

end 



function ENT:CheckAmmo()
	if self.IsCheckingAmmo == false then 
		self.NextFire = CurTime() + 0.5
		self.IsCheckingAmmo = true 
		net.Start("n40_emp_check_ammo")
		net.WriteString(tostring(self.Mag))
		net.WriteFloat(self.Magazine)
		net.Send(self.Gunner)
		timer.Simple(1,function()
			self.IsCheckingAmmo = false
		end)
	end 
end


function ENT:Think()

	if self.ManualReload == true and not self.RoundInChamber then 
		local gunpos = self.Gun:GetPos() + self.Gun:GetForward() * self.ManualReloadZoneOffset.X + self.Gun:GetRight() * self.ManualReloadZoneOffset.Y + self.Gun:GetUp() * self.ManualReloadZoneOffset.Z
		local scan_area = ents.FindInBox(gunpos + self.ManualReloadZoneMins, gunpos + self.ManualReloadZoneMaxs)
		for k,v in pairs(scan_area) do 
			if self.ProjectileList[v.ProjectileEnt] then 
				self:ReloadPewPewsManually(v)
			end 
		end 

	end

	if IsValid(self.Gunner) then -- Disable gun after gunner death 

		local Gunner = self.Gunner 
		local Gun = self.Gun 

		if not Gunner:Alive() then 
			self:ExitGun(Gunner)
		return end 


		self:YawCorrection()	


       if Gunner:KeyPressed(IN_FORWARD) or Gunner:KeyPressed(IN_BACK) or Gunner:KeyPressed(IN_MOVELEFT) or Gunner:KeyPressed(IN_MOVERIGHT) then 
       	self:ExitGun(Gunner)
       end 


        
       -- end 



        if Gunner:KeyDown(IN_RELOAD) then 
        	self.InspectionTime = self.InspectionTime + 1
        	if self.InspectionTime >= 45 then 
        		self.NextFire = CurTime()
        		self:CheckAmmo()
        		self.InspectionTime = 0
        	end 
        end 

        if Gunner:KeyReleased(IN_RELOAD) then 
        	if self.IsCheckingAmmo == false and self.InspectionTime <= 22 then
        		if self.ManualReload == true then self:UnloadShell() return end
        		self:ReloadPewPews()
        	end
        	self.InspectionTime = 0
        end 

        if Gunner:KeyDown(IN_ATTACK) then 
        	self:ShootPewPews()
        end 

        if Gunner:KeyPressed(IN_ATTACK2) then 
        	self:EnterSight()
		end

        local distance = Gunner:GetPos():DistToSqr(self:GetPos()) -- Calculate auto kick distance w/o square root cause fuck square root 
        if distance > (self.ExitDistance * self.ExitDistance) then 
        	self:ExitGun(Gunner)
        end 



	end 




	debugoverlay.BoxAngles( self.Gun:GetPos(), self.ManualReloadZoneMins, self.ManualReloadZoneMaxs, self.Gun:GetAngles(),0.1, Color( 255, 255, 255,0 ) )
	debugoverlay.BoxAngles( self.Gun:GetPos() + self.Gun:GetForward() * self.ManualReloadZoneOffset.X + self.Gun:GetRight() * self.ManualReloadZoneOffset.Y + self.Gun:GetUp() * self.ManualReloadZoneOffset.Z, self.ManualReloadZoneMins, self.ManualReloadZoneMaxs, self.Gun:GetAngles(),0.1, Color( 255, 255, 255,0 ) )



	self:PostThink()

    self:NextThink( CurTime() ) -- Force Think() to run every tick for smoother animations 
    return true	
end 

function ENT:PostThink()

end 

function ENT:YawCorrection()
	local Gunner = self.Gunner 
	local Gun = self.Gun 
	local m = Matrix() 

	local dir = dir or Gunner:GetAimVector()

	local trace = {}

	trace.start = Gunner:EyePos()
	trace.endpos = trace.start + ( dir * ( 4096 * 8 ) )
	trace.filter = {Gunner,self,self.Gun}

	ang = (util.TraceLine( trace ).HitPos - self:GetPos()):Angle()

    m:SetAngles(ang)
    self.TargetAngOffset = Matrix() 
	self.TargetAngOffset:SetAngles(self.GunOffsetAng) --- Rotate gun to aim properly cuz i messed up directions 
    m = m * self.TargetAngOffset
    local old = Gun:GetAngles()



    local orig = self.Gun.OriginAngles

    local newyaw = math.ApproachAngle( old.y, m:GetAngles().y, self.RotationSpeed * FrameTime() )
    if orig.y - self.MaxRotation >= self.Gun:GetLocalAngles().y then newyaw = newyaw + math.Approach( 0, 1, self.RotationSpeed * FrameTime() ) end
    if orig.y + self.MaxRotation <= self.Gun:GetLocalAngles().y then newyaw = newyaw - math.Approach( 0, 1, self.RotationSpeed * FrameTime() ) end


    local newelev = math.ApproachAngle( old.r, m:GetAngles().r, self.RotationSpeed * FrameTime() )

    if orig.r - self.MaxElevation >= self.Gun:GetLocalAngles().r then newelev = newelev + math.Approach( 0, 1, self.RotationSpeed * FrameTime() ) end
  	if orig.r + self.MaxDescension <= self.Gun:GetLocalAngles().r then newelev = newelev - math.Approach( 0, 1, self.RotationSpeed * FrameTime() ) end

    Gun:SetAngles(Angle(math.ApproachAngle( old.p, m:GetAngles().p, self.RotationSpeed * FrameTime()),newyaw,math.ApproachAngle( old.r, newelev, self.RotationSpeed * FrameTime() ) )) 
end 

function ENT:EnterSight()
	if self.Gunner.IN_EMP_SIGHT == false then  
		net.Start("n40_emp_enter_sight")
		self.Gunner.IN_EMP_SIGHT = true 
		net.WriteTable(self.ANGLE_TABLE)
		net.WriteEntity(self.Gun)
		net.Send(self.Gunner)
	else 
		self:ExitSight(self.Gunner)
	end 
end

function ENT:ExitSight(ent)
	net.Start("n40_emp_exit_sight")
	net.Send(ent)
	self.Gunner.IN_EMP_SIGHT = false 

end





function ENT:EnterGun(ent)
	if not ent:IsPlayer() then return end 
	local ply = ent 
	ply:SetActiveWeapon(none) -- Give player empty hands
	self:SetOwner(ply)
	self.Gunner = ply
end 

function ENT:ExitGun(ent)
	self:ExitSight(ent)
	self.Gunner = nil 
	self:SetOwner(nil)

	--self.Gun:SetAngles(self:GetAngles() + self.GunOffsetAng) -- Restore gun angles after exit
end 

function ENT:OnTakeDamage( dmginfo )
	if ( not self.m_bApplyingDamage ) then
		self.HP = self.HP - dmginfo:GetDamage() 
		if self.HP <= 0 then 
		sound.Play( "spg9/penetration.wav", self:GetPos(), 120, math.random(90,110), 1 )
		util.BlastDamage(self, self, self:GetPos(), 256, 256 )
		self:Remove() 
	end 

		self.m_bApplyingDamage = true
		self:TakeDamageInfo( dmginfo )
		self.m_bApplyingDamage = false
	end
end

function ENT:OnRemove()
	if self.Gunner then 
		self:ExitSight(self.Gunner)
	end 
end 

function ENT:BuildGun()
	local gun = ents.Create("prop_physics")
	gun:SetModel(self.GunModel)
	gun:SetPos(self:GetPos() + self:GetForward() * self.GunOffsetVec.X + self:GetRight() * self.GunOffsetVec.Y + self:GetUp() * self.GunOffsetVec.Z) 
	gun:SetAngles(self:GetAngles() - self.GunOffsetAng - self.TripodOffsetAngle )
	gun:Spawn()
	gun:SetParent(self)
	self.Gun = gun
	self.Gun.OriginAngles = gun:GetLocalAngles() 
	self.Mag = self.Magazine
	if self.ManualReload == true then 
		self.Mag = 0
	end 
	self:OnGunBuild()
end 

function ENT:OnGunBuild()

end 


function ENT:ReloadPewPews()
	if self.ManualReload == true then return end 
	if self.IsReloading then return end 
	self.IsReloading = true 
	self.Mag = 0
	self:EmitSound(self.GunSoundReload)
	self:OnStartReload()
	timer.Simple(self.ReloadTime,function()
        if not IsValid(self) then return end
		self.Mag = self.Magazine
		self.IsReloading = false 
		self:OnFinishReload()
	end)	
end 


function ENT:UnloadShell()
	if self.RoundInChamber == "empty" then 
		self:EmitSound(self.ManualEjectSound)
		self.RoundInChamber = nil 
		self:OnUnload() 
	end
end 

function ENT:OnUnload()

end 

function ENT:OnLoad()

end

function ENT:ReloadPewPewsManually(shell)
	if self.IsReloading then return end 
	self.IsReloading = true 
	self.Mag = 0
	self:EmitSound(self.ManualInsertSound)
	self.RoundInChamber = shell.ProjectileEnt
	self.Magazine = shell.Capacity
	shell:Remove()
	self:OnLoad()
	timer.Simple(self.ManualReloadTime,function()
        if not IsValid(self) then return end
		self.Mag = self.Magazine
		self.IsReloading = false 
	end)
end 



function ENT:ShootPewPews()

	if self.ManualReload == true and not self.RoundInChamber then return end

	if self.Mag <= 0 or self.IsReloading == true and not self.ManualReload then 
		--self:ReloadPewPews()
	return end 

	if self.NextFire <= CurTime() then 
		sound.Play( self.GunSoundDistant, self:GetPos(), 120, math.random(90,110), 1 )
		self:EmitSound( self.GunSoundFire)

		local shoot_entity = self.GunProjectile
		if self.RoundInChamber != "empty" or self.RoundInChamber != nil  then shoot_entity = self.RoundInChamber end

		local babah = ents.Create(shoot_entity) -- Projectile ENT
 		local m = Matrix()
	    local ang = (self.Gun:GetAngles())
        m:SetAngles(ang)
        self.TargetAngOffset = Matrix()
		self.TargetAngOffset:SetAngles(self.MatrixOffsetAngle) -- Do same shit as in Think() to correct projectile angle
        m = m * self.TargetAngOffset	
        babah.Owner = self.Owner
        babah.BaseEmp = self
        babah:SetAngles(m:GetAngles()) --ProjectileOffset
        babah:SetPos(self.Gun:GetPos() + self.Gun:GetForward() * self.ProjectileOffset.X + self.Gun:GetRight() * self.ProjectileOffset.Y + self.Gun:GetUp() * self.ProjectileOffset.Z) -- Apply projectile offset 
        babah:Spawn()
       -- print(self:GetOwner())
   
        babah:Fire("Use") -- Activate projectile
		ParticleEffect(self.MuzzleFlashEffect, self.Gun:GetPos() + self.Gun:GetForward() * self.ProjectileOffset.X + self.Gun:GetRight() * self.ProjectileOffset.Y + self.Gun:GetUp() * self.ProjectileOffset.Z,  m:GetAngles())
		self:OnShoot(m)

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
	   	self.NextFire = CurTime() + self.GunRPM -- delay before next shot 
	end 

end

function ENT:Use(activator,caller) 
	if self.Gunner then 
		if activator == self.Gunner then -- If gunner pressed E then exit gun
			self:ExitGun(self.Gunner)
		return end 
		if activator != self.Gunner then -- If someone else pressed E then nothing 
		return end 
	end 
	if not self.Gunner then -- If gun is empty and player pressed E then let player in 
		self:EnterGun(activator)
	return end 

end 

function ENT:OnFirePewPews(roundsleft) -- Called after shot and parses mag capacity to this function 
end 

function ENT:OnStartReload()
end 

function ENT:OnFinishReload()
end 

function ENT:OnFinishInit() -- Called after all models were drawn and initialized 
end 
