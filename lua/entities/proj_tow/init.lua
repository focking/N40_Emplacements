AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Name = "SPG-9 Rocket HE"
ENT.Damage = 666
ENT.Radius = 1024
ENT.Mass = 120
ENT.Velocity = 256 
ENT.Model = "models/kali/weapons/tow/parts/bgm-71 tow missile.mdl"
ENT.ExplosionSounds = "emp/tow/explosion.wav"
ENT.Decal = "Scorch"
ENT.Explosion = "500lb_air"
ENT.IsHEAT = false 
ENT.FuseTime = 5
ENT.Stabilization = true
ENT.HasLoopSound = true
ENT.WireGuided = true
ENT.LoopSound = "loop.wav"
ENT.HasTail = true

function ENT:DoBabah(bruh)
   self:Remove()
  util.Decal( self.Decal, self:GetPos(), self:GetPos() + self:GetForward() * 256 , self )
  ParticleEffect( self.Explosion, self:GetPos(), self:GetAngles() )
  util.BlastDamage( self, self.Owner, self:GetPos(), self.Damage, self.Radius )
  sound.Play( self.ExplosionSounds, self:GetPos(), 120, math.random(90,110), 1 )
end

function ENT:PostPostInit()
	timer.Simple(0.2,function()
		self:SetBodygroup(1,1)
	end)
end  