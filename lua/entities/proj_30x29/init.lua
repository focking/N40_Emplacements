AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Name = "30x29"
ENT.Damage = 256 
ENT.Mass = 20
ENT.Velocity = 186 
ENT.Model = "models/Items/AR2_Grenade.mdl"
ENT.ExplosionSounds = {"emp/impact/impact_explosion_01.wav","emp/impact/impact_explosion_02.wav","emp/impact/impact_explosion_03.wav","emp/impact/impact_explosion_04.wav"}
ENT.Decal = "Scorch"
ENT.Radius = 256
ENT.Explosion = "frag_explosion_air"