print("N40 Emplacements CL") 

net.Receive( "n40_emp_enter_sight", function( len, pl )
	if LocalPlayer().InEMPSights == true then return end
	AngleData = net.ReadTable() 
	Gun = net.ReadEntity() 
	ZeroingIndex = 1 
	ScopeOverlay = nil
	MaxZeroingIndex = table.Count( AngleData["ZeroingTable"] ) - 1
	if AngleData["ScopeOverlay"] == "none" then ScopeOverlay = false else 
		ScopeOverlay = Material(AngleData["ScopeOverlay"] )
	end
	LocalPlayer().InEMPSights = true

	--print(MaxZeroingIndex)
	--print(AngleData["ZeroingTable"][1])
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
	local posy = ScrH()*0.75

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

function DrawZeroingBar(ammo)
	local TextShit = {}
	local font = "N40_DisplayFont"
	local lifetime = 4
	local text = tostring(ammo)
	local posx = ScrW()*0.85
	local posy = ScrH()*0.85

	TextShit[text] = {["text"] = text,["font"] = font,["posx"] = posx, ["posy"] = posy, ["color"] = Color(255,255,255,255),["fading"] = false}

	TextShit[text].startVal = 0
	TextShit[text].endVal = 255
	TextShit[text].speed = 255

	TextShit[text].alpha = 0	

	hook.Add("HUDPaint", "HandlerN40Zeruing", function() 
		for k,v in pairs(TextShit) do 

			TextShit[text].alpha = TextShit[text].alpha + TextShit[text].speed * FrameTime( )
			TextShit[text].alpha = math.Clamp( TextShit[text].alpha, TextShit[text].startVal, TextShit[text].endVal )


			surface.SetFont( v["font"] )

			if v["fading"] == true then 
				TextShit[text].speed = -255
			end 

			local width, height = surface.GetTextSize( v["text"] )
			surface.SetDrawColor(0,0,0,2)
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
	ang = (LocalPlayer():GetEyeTrace().HitPos - LocalPlayer():GetPos()):Angle()

	local view = {
		origin = Gun:GetPos()+Gun:GetUp()*AngleData["GunCameraUp"] +Gun:GetForward()*AngleData["GunCameraForward"] + Gun:GetRight() * AngleData["GunCameraRight"] ,
		angles = angles,
		fov = AngleData["GunCameraFOV"],
		drawviewer = false
	}

	return view
end
end )


hook.Add( "AdjustMouseSensitivity", "AdjustMouseSensitivityEMP", function( defaultSensitivity  )
	if LocalPlayer().InEMPSights == true then 
		return AngleData["ScopeSensetivity"]
	end

end)


NEXT_SCROLL = CurTime()

hook.Add("InputMouseApply", "testMouseWheel", function(cmd, x, y, ang)
	if LocalPlayer().InEMPSights == true then 

		if ( input.WasMouseReleased( MOUSE_WHEEL_UP ) ) then 
			if NEXT_SCROLL <= CurTime() and ZeroingIndex != MaxZeroingIndex  then 
				NEXT_SCROLL = CurTime() + 0.11
				ZeroingIndex = ZeroingIndex + 1
				 AngleData["GunCameraUp"] = AngleData["ZeroingTable"][ZeroingIndex]["CamUp"]
				 DrawZeroingBar(AngleData["ZeroingTable"][ZeroingIndex]["Distance"])
			else
			DrawZeroingBar(AngleData["ZeroingTable"][ZeroingIndex]["Distance"]) 
			end 
		end

		if ( input.WasMouseReleased( MOUSE_WHEEL_DOWN ) ) then 
			if NEXT_SCROLL <= CurTime() and ZeroingIndex > 1  then 
				NEXT_SCROLL = CurTime() + 0.11
				ZeroingIndex = ZeroingIndex - 1
				AngleData["GunCameraUp"] = AngleData["ZeroingTable"][ZeroingIndex]["CamUp"]
				DrawZeroingBar(AngleData["ZeroingTable"][ZeroingIndex]["Distance"])
			else 
				DrawZeroingBar(AngleData["ZeroingTable"][ZeroingIndex]["Distance"])
			end 
		end



	end
end)






local hide = {
	["CHudWeaponSelection"] = true,
	["CHudCrosshair"] = true,
}

hook.Add( "HUDShouldDraw", "HideHUDBruh", function( name )
	if LocalPlayer().InEMPSights == true then 
		if ( hide[ name ] ) then
			return false
		end
	end
end )


--ScopeOverlay
hook.Add( "HUDPaint", "EMPHUD", function()

	if LocalPlayer().InEMPSights == true and ScopeOverlay != false then 

 --- Scope overlay from ACT3 by Arctic
    local x = ScrW()/2
    local y = ScrH()/2

		local scopesize = ScrH()
   		scopesize = math.ceil(scopesize * 1.05)

   		local scopeposx = x - ( scopesize / 2 )
    	local scopeposy = y - ( scopesize / 2 )

		surface.SetDrawColor( 0, 0, 0 )

  		surface.SetDrawColor( 0, 0, 0 )

        surface.DrawRect( scopeposx - ScrW(), scopeposy - ScrH(), 4 * ScrW(), ScrH() )
        surface.DrawRect( scopeposx - ScrW(), scopeposy + scopesize , 4 * ScrW(), ScrH() )

        surface.DrawRect( scopeposx - ScrW(), scopeposy - ScrH(), ScrW(), 4 * ScrH() )
        surface.DrawRect( scopeposx + scopesize, scopeposy - ScrH() , ScrW(), 4 * ScrH() )

        surface.SetMaterial( ScopeOverlay )
    	surface.DrawTexturedRect( scopeposx, scopeposy, scopesize, scopesize )
	end 

end 


)
hook.Add( "HUDShouldDraw", "DistanceMeter", function( name )
	--if LocalPlayer().InEMPSights == true and ScopeOverlay != false then 
	--	local tr = LocalPlayer():GetEyeTrace()
	--	print(LocalPlayer():GetPos():Distance(tr.HitPos)* 1.95 / 100)
	--end
end )


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
game.AddParticles( "particles/ayykyu_muzzleflashes.pcf")

PrecacheParticleSystem("muzzleflash_pistol_red")
PrecacheParticleSystem("muzzleflash_pistol_rbull")
PrecacheParticleSystem("muzzleflash_4")
PrecacheParticleSystem("muzzleflash_6")
PrecacheParticleSystem("muzzleflash_ak74")
PrecacheParticleSystem("muzzleflash_m24")
PrecacheParticleSystem("muzzleflash_shotgun")
PrecacheParticleSystem("muzzleflash_smg")
PrecacheParticleSystem("muzzleflash_suppressed")
PrecacheParticleSystem("muzzleflash_vollmer")
PrecacheParticleSystem("muzzleflash_hmg")
PrecacheParticleSystem("muzzleflash_p90")
PrecacheParticleSystem("muzzleflash_mpx")

PrecacheParticleSystem("muzzleflash_pistol_npc")
PrecacheParticleSystem("muzzleflash_smg_npc")
PrecacheParticleSystem("muzzleflash_shotgun_npc")
PrecacheParticleSystem("muzzleflash_sniper_npc")
PrecacheParticleSystem("muzzleflash_ar2_npc")
PrecacheParticleSystem( "ExplosionCore_wall" )