AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Name = "82mm"
ENT.Damage = 512 
ENT.Mass = 20
ENT.Velocity = 186 
ENT.Model = "models/emp/models/emp/m252_round.mdl"
ENT.ExplosionSounds = {"emp/m252/exp_close_01.wav","emp/m252/exp_close_02.wav","emp/m252/exp_close_03.wav"}
ENT.Decal = "Scorch"
ENT.Radius = 1024
ENT.Explosion = "c4_explosion"