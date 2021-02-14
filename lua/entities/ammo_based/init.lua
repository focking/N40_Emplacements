AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.ProjectilePrintName = "BRUH"
ENT.ProjectileName = "BRUH"
ENT.ProjectileModel = "models/models/models/heat64.mdl"

 
function ENT:Initialize()
		if SERVER then
        self:SetNWString("AMMO_NAME",self.ProjectilePrintName)
        self.ProjectileEnt = self.ProjectileName
		self:SetModel(self.ProjectileModel)
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
        self.Detonation = false 
    end
end

function ENT:Use(activator,caller)
    activator:PickupObject( self )
end

