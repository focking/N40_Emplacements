print("N40 Emplacements CL")

net.Receive( "n40_emp_enter_sight", function( len, pl )
	if LocalPlayer().InEMPSights == true then return end
	AngleData = net.ReadTable() 
	Gun = net.ReadEntity() 
	LocalPlayer().InEMPSights = true
end )


net.Receive( "n40_emp_check_ammo", function( len, pl )
	local ammo = net.ReadString()
	print("ammo"..ammo)
	local maxammo = net.ReadFloat()
	DrawAmmoBar(ammo,maxammo)
end )

function DrawAmmoBar(ammo,maxammo)
	local TextShit = {}
	local text = tostring(ammo.." / "..maxammo)
	local font = "N40_DisplayFont"
	local lifetime = 4
	local posx = ScrW()*0.85
	local posy = ScrH()*0.85

	TextShit[text] = {["text"] = text,["font"] = font,["posx"] = posx, ["posy"] = posy, ["color"] = Color(255,255,255,255),["fading"] = false}

	TextShit[text].startVal = 0
	TextShit[text].endVal = 255
	TextShit[text].speed = 64

	TextShit[text].alpha = 0	

	hook.Add("HUDPaint", "HandlerN40Ammo", function() 
		for k,v in pairs(TextShit) do 

			TextShit[text].alpha = TextShit[text].alpha + TextShit[text].speed * FrameTime( )
			TextShit[text].alpha = math.Clamp( TextShit[text].alpha, TextShit[text].startVal, TextShit[text].endVal )


			surface.SetFont( v["font"] )

			if v["fading"] == true then 
				TextShit[text].speed = -64
			end 

			local width, height = surface.GetTextSize( v["text"] )
			surface.SetDrawColor(0,0,0,TextShit[text].alpha)
			surface.DrawRect(  v["posx"]-3, v["posy"], width+6, height )

			surface.SetTextColor( 255, 255, 255,TextShit[text].alpha  )
			surface.SetTextPos( v["posx"], v["posy"] ) 
			surface.DrawText( v["text"] )

		end 
	end)

	for k, v in pairs(TextShit) do 
		timer.Simple(lifetime/2,function()
			if TextShit[k] then 
				TextShit[k]["fading"] = true
			end
		end)
		timer.Simple(lifetime,function()
			if TextShit[k] then 
				TextShit[k] = nil
			end
		end)
	end 


end 






net.Receive( "n40_emp_exit_sight", function( len, pl )
	LocalPlayer().InEMPSights = false
	Tripod = nil 
	Gun = nil 
end )



hook.Add( "CalcView", "CalcViewOpticsN40", function( ply, pos, angles, fov )
if LocalPlayer().InEMPSights == true then 
	local m = Matrix()
	ang = (LocalPlayer():GetEyeTrace().HitPos - Gun:GetPos()):Angle()
	m:SetAngles(ang)
	Mat = Matrix()
	Mat:SetAngles(Angle(0,0,0))
	m = m * Mat
	local view = {
		origin = Gun:GetPos()+Gun:GetUp()*AngleData["GunCameraUp"] +Gun:GetForward()*AngleData["GunCameraForward"] + Gun:GetRight() * AngleData["GunCameraRight"] ,
		angles = m:GetAngles(),
		fov = AngleData["GunCameraFOV"],
		drawviewer = false
	}

	return view
end
end )

--hook.Add( "HUDPaint", "HudPaintOpticsN40", function()
--	if LocalPlayer().InEMPSights == true then 
-- --	 DrawMaterialOverlay(AngleData["ScopeOverlay"], 0)
--	end
--end )

surface.CreateFont( "N40_DisplayFont", {
	font = "bender", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 64,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

surface.CreateFont( "N40_DisplayFont42", {
	font = "bender", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 32,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

game.AddParticles( "particles/ammo_cache_ins.pcf" )
game.AddParticles( "particles/doi_explosion_fx.pcf" )
game.AddParticles( "particles/doi_explosion_fx_b.pcf" )
game.AddParticles( "particles/doi_explosion_fx_c.pcf" )
game.AddParticles( "particles/doi_explosion_fx_grenade.pcf" )
game.AddParticles( "particles/doi_explosion_fx_new.pcf" )
game.AddParticles( "particles/doi_explosions_smoke.pcf" )
game.AddParticles( "particles/doi_impact_fx.pcf" )
game.AddParticles( "particles/doi_rockettrail.pcf" )
game.AddParticles( "particles/doi_weapon_fx.pcf" )
game.AddParticles( "particles/environment_fx.pcf" )
game.AddParticles( "particles/explosion_fx_ins.pcf" )
game.AddParticles( "particles/explosion_fx_ins_b.pcf" )
game.AddParticles( "particles/gb_water.pcf" )
game.AddParticles( "particles/gb5_100lb.pcf" )
game.AddParticles( "particles/gb5_500lb.pcf" )
game.AddParticles( "particles/gb5_1000lb.pcf" )
game.AddParticles( "particles/gb5_fireboom.pcf" )
game.AddParticles( "particles/gb5_high_explosive_2.pcf" )
game.AddParticles( "particles/gb5_high_explosive.pcf" )
game.AddParticles( "particles/gb5_jdam.pcf" )
game.AddParticles( "particles/gb5_large_explosion.pcf" )
game.AddParticles( "particles/gb5_light_bomb.pcf" )
game.AddParticles( "particles/gb5_napalm.pcf" )
game.AddParticles( "particles/gred_particles.pcf" )
game.AddParticles( "particles/impact_fx_ins.pcf" )
game.AddParticles( "particles/ins_rockettrail.pcf" )
game.AddParticles( "particles/gb_c4.pcf")
game.AddParticles( "particles/gb_wick.pcf")
game.AddParticles( "particles/gb_water.pcf")
game.AddParticles( "particles/gb_goliath.pcf")
game.AddParticles( "particles/gb_smallbomb.pcf")
game.AddParticles( "particles/gb_nebeltrail.pcf")
game.AddParticles( "particles/gb_frag.pcf")
game.AddParticles( "particles/gb_fab.pcf")
game.AddParticles( "particles/gb_daisy.pcf")
game.AddParticles( "particles/gb_melon.pcf")
game.AddParticles( "particles/gb_smoke_mortar.pcf")
game.AddParticles( "particles/gb_mortar_phosph.pcf")
game.AddParticles( "particles/gb_smokegrenade.pcf")
game.AddParticles( "particles/gb_thermite.pcf")
game.AddParticles( "particles/gb_rpgtrail.pcf")
game.AddParticles( "particles/gb_gascan.pcf")
game.AddParticles( "particles/gb_sprengtrail.pcf")
game.AddParticles( "particles/gb_booster.pcf")
game.AddParticles( "particles/gb_bstr_trail.pcf")
game.AddParticles( "particles/gb_oildrum.pcf")
game.AddParticles( "particles/gb_electro.pcf")
game.AddParticles( "particles/gb_canister.pcf")
game.AddParticles( "particles/gb_molotov.pcf")
game.AddParticles( "particles/gb_combinemine.pcf")
game.AddParticles( "particles/gb_nqbarrel.pcf")
game.AddParticles( "particles/gb_flash.pcf")
game.AddParticles( "particles/gb_m18.pcf")
game.AddParticles( "particles/gb_hazexplosion.pcf")
game.AddParticles( "particles/gb_moab.pcf")


PrecacheParticleSystem( "ExplosionCore_wall" )