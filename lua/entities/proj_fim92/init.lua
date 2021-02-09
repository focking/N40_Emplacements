AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Name = "SPG-9 Rocket HE"
ENT.Damage = 512
ENT.Radius = 1024
ENT.Mass = 120
ENT.Velocity = 250 
ENT.Model = "models/fim92/missile2.mdl"
ENT.ExplosionSounds = {"explosions/impact_stinger.wav"}
ENT.Decal = "Scorch"
ENT.Explosion = "high_explosive_air"
ENT.IsHEAT = false 
ENT.FuseTime = 25
ENT.Heatseeking = false  
ENT.HasTail = true
ENT.LoopSound = "loop.wav" 
ENT.HasLoopSound = true

function ENT:DoBabah()

 	local _ents = ents.FindInSphere(self:GetPos(), 512)
    for k,v in pairs(_ents) do 
      if v.LFS == true  then 
        v:TakeDamage( 750 , self, self )
      end 
    end 

   util.Decal( self.Decal, self:GetPos(), self:GetPos() + self:GetForward() * 256 , self )
   ParticleEffect( self.Explosion, self:GetPos(), self:GetAngles() )
   util.BlastDamage( self, self,self:GetPos(), self.Damage, self.Radius )
   sound.Play( tostring(table.Random(self.ExplosionSounds)), self:GetPos(), 120, math.random(90,110), 1 )
   self:Remove()
end 