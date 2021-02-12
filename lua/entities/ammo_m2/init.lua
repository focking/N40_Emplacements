AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.ProjectilePrintName = "box_m2"


function ENT:Initialize()
		if SERVER then
        self.ProjectileEnt = "box_m2"
        self.Capacity = 100
        self:SetNWString("Projectile",self.ProjectilePrintName)
		self:SetModel("models/m2/rs2_m2_ammo.mdl")
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
        self:SetBodygroup(2,1)
    end
end

function ENT:Use(activator,caller)
    activator:PickupObject( self )
end