AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.ProjectilePrintName = "AGS-30 Drum"


function ENT:Initialize()
		if SERVER then
        self.ProjectileEnt = "proj_30x29"
        self.Capacity = 29
        self:SetNWInt("Capacity",self.Capacity)
        self:SetNWString("Projectile",self.ProjectilePrintName)
		self:SetModel("models/escape from tarkov/static/weapons/magazine.mdl")
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetUseType(SIMPLE_USE)
        self:DrawShadow( true )

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:SetBuoyancyRatio(0)
            phys:SetMass(20)
        end
    end
end

function ENT:Use(activator,caller)
    activator:PickupObject( self )
end