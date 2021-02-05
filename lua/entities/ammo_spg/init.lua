AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.ProjectilePrintName = "SPG-9 HE"


function ENT:Initialize()
		if SERVER then
        self.ProjectileEnt = "proj_spg"
        self.Capacity = 1
        self:SetNWString("Projectile",self.ProjectilePrintName)
		self:SetModel("models/spg9/cooller_round_4.mdl")
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