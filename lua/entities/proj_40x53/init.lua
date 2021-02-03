AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Name = "40x53"
ENT.Damage = 300 
ENT.Mass = 30
ENT.Velocity = 146 
ENT.Model = "models/Items/AR2_Grenade.mdl"
ENT.ExplosionSounds = {"emp/impact/impact_explosion_01.wav","emp/impact/impact_explosion_02.wav","emp/impact/impact_explosion_03.wav","emp/impact/impact_explosion_04.wav"}
ENT.Decal = "Scorch"
ENT.Radius = 45
ENT.Explosion = "frag_explosion_air"