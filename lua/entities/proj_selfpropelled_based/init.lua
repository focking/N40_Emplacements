AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


ENT.Name = "SelfPropelled Based"
ENT.FuseTime = 2
ENT.Mass = 2
ENT.Velocity = 180 
ENT.Model = ""
ENT.Damage = 256
ENT.DamageSimfphys = 0
ENT.Radius = 512
ENT.Drag = 2
ENT.Decal = "Scorch"
ENT.Explosion = "grenade_explosion_01"
ENT.ExplosionSounds = {"spg9/explosion.wav"}
ENT.HasTail = false 
ENT.Stabilization = true -- Add cuewl rotation to rocket 

ENT.Heatseeking = false 
ENT.Target = nil  
ENT.HeatseekingAngle = 20

ENT.TrailDelay = 0.15 --
ENT.TrailDelayPassed = false 

ENT.HasLoopSound = true
ENT.Loop = "loop.wav"

function ENT:Initialize()

    if SERVER then
        self:SetModel(self.Model)
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_BBOX )
        self:SetUseType( SIMPLE_USE )
        self:DrawShadow( true )
        self:SetModelScale(1.5,0)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:SetBuoyancyRatio(0)
            phys:SetMass(self.Mass)
            phys:EnableDrag(true)
            phys:SetDragCoefficient(self.Drag) 
        end
        self:PostInit()
        self:CreateLight()

	
		
		local tbl = physenv.GetPerformanceSettings()
		
		tbl.MaxVelocity = 200000000
		
		physenv.SetPerformanceSettings(tbl)
    end
    print(self.Owner)
end

function ENT:CreateLight()
  if self.HasTail == true then 
    local light = ents.Create("light_dynamic")
    light:Spawn()
    light:Activate()
    light:SetKeyValue("distance", 512) 
    light:SetKeyValue("brightness", 6)
    light:SetKeyValue("_light", "255 192 64") 
    light:Fire("TurnOn")
    light:SetPos(self:GetPos())
    light:SetParent(self)
  end
end 

function ENT:PostInit()
  self.FuseTime = CurTime() + self.FuseTime
  self.TrailDelay = CurTime() + self.TrailDelay
  self.Pen = false 
  self:PostPostInit()
end 

function ENT:PostPostInit()
end 


function ENT:IRTrack()
    local size = 1600
    local dir = self:GetForward()
    local angle = math.cos( math.rad( self.HeatseekingAngle ) )
    local startPos = self:GetPos()

    local _ents = ents.FindInCone( startPos, dir, size, angle )
    for k,v in pairs(_ents) do 
      if v.LFS == true  then 
        self.Target = v
      else self.Target = nil end
    end 
end  


ENT.NextAng = CurTime()

function ENT:Think()

if SERVER then 

     if self.Stabilization == true then 
      local phys = self:GetPhysicsObject()
        phys:AddAngleVelocity( Vector(90,0,0) )
     end 

  if self.FuseTime >= CurTime() then 

      local phys = self:GetPhysicsObject()
      	phys:ApplyForceCenter(self:GetForward() * self.Mass * self.Velocity )

      if self.HasTail == true then 
        if self.TrailDelay <= CurTime() then 
          if self.HasLoopSound == true then 
            self.Loop = CreateSound( self, self.LoopSound)
            self.Loop:Play()
          end 
          ParticleEffectAttach("ins_rockettrail",PATTACH_ABSORIGIN_FOLLOW,self,1)
          self.HasTail = false
        end 
      end
  end 

	if self.Heatseeking == true and self.FuseTime > 0 then 
		  self:IRTrack()
   		if IsValid(self.Target) and self.NextAng <= CurTime() then 
        self.Target:EmitSound("weapons/lase.wav")
   			local dist = self:GetPos():Distance(self.Target:GetPos())
   		  local diff = (self.Target:GetPos()+self.Target:OBBCenter() - self:GetPos()):Angle()
        self:SetAngles(diff)

        local phys = self:GetPhysicsObject()
        phys:AddVelocity(self:GetForward() * self.Mass/3 * self.Velocity/3 )

   		end 
	end  



  self:NextThink( CurTime() ) -- Set the next think to run as soon as possible, i.e. the next frame.
  return true 
end


end 

function ENT:DoBabah(owner)
end 


function ENT:PhysicsCollide( data, phys )
  self.FuseTime = CurTime()
  self.Stabilization = false
   if ( data.Speed > 100 ) then self:DoBabah(self.Owner) end
   if simfphys then 
  		 if simfphys.IsCar(data.HitEntity) then 
  		 		data.HitEntity:SetCurHealth(data.HitEntity:GetCurHealth() - self.DamageSimfphys)
  		 end
    end
end

function ENT:OnRemove()
  if self.HasLoopSound == true then 
    self.Loop:Stop() 
  end 
end 