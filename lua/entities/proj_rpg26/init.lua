AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Name = "30x29"
ENT.Damage = 512 
ENT.Mass = 10
ENT.Velocity = 400  
ENT.Model = "models/spg9/cooller_round_4.mdl"
ENT.ExplosionSounds = {"emp/impact/impact_explosion_01.wav","emp/impact/impact_explosion_02.wav","emp/impact/impact_explosion_03.wav","emp/impact/impact_explosion_04.wav"}
ENT.Decal = "Scorch"
ENT.Explosion = "high_explosive_air"
ENT.Radius = 666

function ENT:DoBabah(bruh)
   self:Remove()
  util.Decal( self.Decal, self:GetPos(), self:GetPos() + self:GetForward() * 256 , self )
  ParticleEffect( self.Explosion, self:GetPos(), self:GetAngles() )
  util.BlastDamage( self, self.Owner, self:GetPos(), self.Damage, self.Radius )
  sound.Play( tostring(table.Random(self.ExplosionSounds)), self:GetPos(), 120, math.random(90,110), 1 )
end