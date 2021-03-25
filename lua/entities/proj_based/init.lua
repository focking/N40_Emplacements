AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Name = "BASE"
ENT.Damage = 256 
ENT.Radius = 45
ENT.Mass = 0.62
ENT.Velocity = 12960 
ENT.Model = "models/Items/AR2_Grenade.mdl"
ENT.ExplosionSounds = {"emp/impact/impact_explosion_01.wav","emp/impact/impact_explosion_02.wav","emp/impact/impact_explosion_03.wav","emp/impact/impact_explosion_04.wav"}
ENT.Decal = "Scorch"
ENT.Explosion = "doi_artillery_explosion"
ENT.Scale = 1


function ENT:Initialize()
    if SERVER then
        self:SetModel(self.Model)
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )
        self:DrawShadow( true )
        self:SetModelScale(self.Scale,0)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:SetBuoyancyRatio(0)
            phys:SetMass(self.Mass)
        end
        self:PostInit() 
    end
end
function ENT:PostInit()

end 

function ENT:PhysicsCollide( data, phys )
  if ( data.Speed > 255 ) then self:DoBabah() end
end

function ENT:DoBabah()
  if not IsValid(self.Owner) then owner = self else owner = self.Owner end
   util.Decal( self.Decal, self:GetPos(), self:GetPos() + self:GetForward() * 256 , self )
   ParticleEffect( self.Explosion, self:GetPos(), self:GetAngles() )
     util.BlastDamage( self, owner, self:GetPos(), self.Damage, self.Radius )

   sound.Play( tostring(table.Random(self.ExplosionSounds)), self:GetPos(), 120, math.random(90,110), 1 )
   self:Remove()
end 


function ENT:Use(activator,caller)
     local phys = self:GetPhysicsObject()
     phys:EnableMotion(true)
      phys:AddVelocity(self:GetForward() * self.Mass * self.Velocity)

end   


function ENT:Draw()
    if CLIENT then
        self:DrawModel()
    end
end