AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.ProjectilePrintName = "SPG-9 HE"


function ENT:Initialize()
		if SERVER then
        self.ProjectileEnt = "proj_spg"
        self.Capacity = 1
        self:SetNWString("Projectile",self.ProjectilePrintName)
		self:SetModel("models/spg9/spg9_rocket_squad.mdl")
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetUseType(SIMPLE_USE)
        self:DrawShadow( true )
        self:SetAngles(self:GetAngles()+Angle(180,0,-90))
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