AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Name = "SPG-9 Rocket HE"
ENT.Damage = 666
ENT.Radius = 1024
ENT.Mass = 120
ENT.Velocity = 1000 
ENT.Model = "models/spg9/spg9_rocket_squad.mdl"
ENT.ExplosionSounds = {"spg9/explosion.wav"}
ENT.Decal = "Scorch"
ENT.Explosion = "high_explosive_air"
ENT.IsHEAT = false 
ENT.FuseTime = 0.25
ENT.Stabilization = true
ENT.HasLoopSound = false

function ENT:DoBabah(bruh)
   self:Remove()
  util.Decal( self.Decal, self:GetPos(), self:GetPos() + self:GetForward() * 256 , self )
  ParticleEffect( self.Explosion, self:GetPos(), self:GetAngles() )
  util.BlastDamage( self, self.Owner, self:GetPos(), self.Damage, self.Radius )
  sound.Play( tostring(table.Random(self.ExplosionSounds)), self:GetPos(), 120, math.random(90,110), 1 )
end

function ENT:PostPostInit()
	timer.Simple(0.2,function(self)
		if IsValid(self) then 
			self:SetBodygroup(1,1)
		end
	end)
end  