include ("shared.lua")

function ENT:Think()
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:OnRemove()
   	EmitSound( Sound("emp/tow/explosion.wav"),  Entity(1):GetPos(), 1, CHAN_AUTO, 1, 75, 0, math.random(75,120) )
end

ENT.PlayWoosh = false 
function ENT:Think()
	if self.PlayWoosh == false then 
		if LocalPlayer():GetPos():DistToSqr(self:GetPos()) <= 512*512 then 
			--print("CLOSE")
			surface.PlaySound( "emp/spg9/flyby/spg9_heat_flyby_0"..math.random(1,6)..".wav" )
			util.ScreenShake( Vector(0, 0, 0), 5, 5, 1, 256 )

			self.PlayWoosh = true
		end 
	end 
end 


