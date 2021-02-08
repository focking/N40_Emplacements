include ("shared.lua")

function ENT:Think()
end
 
function ENT:Draw()
	self:DrawModel()

--	local text = self:GetNWString("AMMO_NAME")
--
--	-- The position. We use model bounds to make the text appear just above the model. Customize this to your liking.
--	local mins, maxs = self:GetModelBounds()
--	local pos = self:GetPos() + Vector( 0, 0, maxs.z + 2 )
--
--	-- The angle
--	local ang = Angle( 0, SysTime() * 100 % 360, 90 )
--
--	-- Draw front
--	Draw3DText( pos, ang, 0.2, text, false )
--	-- DrawDraw3DTextback
--	Draw3DText( pos, ang, 0.2, text, true )
end

--Roboto