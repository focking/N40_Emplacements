include ("shared.lua")

function ENT:Think()
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:OnRemove()
   	EmitSound( Sound("emp/distant/impact_distant_spg_0"..math.random(1,3)..".wav"),  Entity(1):GetPos(), 1, CHAN_AUTO, 1, 75, 0, math.random(75,120) )
end

