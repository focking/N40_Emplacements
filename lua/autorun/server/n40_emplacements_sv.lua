print("N40 Emplacements SV")

util.AddNetworkString( "n40_emp_enter_sight" )
util.AddNetworkString( "n40_emp_exit_sight" )
util.AddNetworkString( "n40_emp_check_ammo" )

concommand.Add("n40_strip_weapons", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		ply:StripWeapons()
	end
end)

concommand.Add("n40_reset_env", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		local tbl = physenv.GetPerformanceSettings()

		local old = tbl.MaxVelocity
		tbl.MaxVelocity = 4000
		physenv.SetPerformanceSettings(tbl)

		ply:ChatPrint("Env Physics: MaxVelocity restored to 4000, was "..old)
	end
end)

function N40_TestMortar(ply)
	local pos = ply:GetEyeTrace().HitPos
	local tr = util.QuickTrace(pos, pos+Vector(0,0,999999))
	if tr.HitSky then 
		ply:ChatPrint("Target confirmed")
		for i = 1, 10 do 
			timer.Simple(2 + i,function()

				local pos = tr.HitPos + Vector(VectorRand(-1024,1024),VectorRand(-1024,1024),0)
				if not util.IsInWorld( pos ) then 
					pos = tr.HitPos + Vector(VectorRand(-1024,1024),VectorRand(-1024,1024),0)
				end
				local a = ents.Create("proj_82mm")
				a:SetPos(pos)
				a:Spawn()
			end)
		end 
	else 
	ply:ChatPrint("Adjust coordinates")
	end
end 

concommand.Add("n40_emp_info", function( ply, cmd, args )
	
	print("=============================")
	print("Ver. 1202")
	print("N40 Emplacements Warning!")
	print("Due changes to enviroment physics this addon can cause unpredictable projectile behaviour.")
	print("You can restore env settings by typing 'n40_reset_env' in console")	
	print("You need to manually eject drum mags / shells by pressing [R]")
	print("To load new mag simply drag it in the turret")	
	print("Controlls: ")
	print("Reload / Unload: Press R")
	print("Check Ammo: Hold R")	
	print("ADS: RMB")	
	print("=============================")
end)




N40_EMP_VERSION = 2603


---https://raw.githubusercontent.com/focking/N40_Emplacements/main/version

local theReturnedHTML = "" -- Blankness

http.Fetch( "https://raw.githubusercontent.com/focking/N40_Emplacements/main/version",
	
	function( body, length, headers, code )
		theReturnedHTML = body
		for s in string.gmatch(theReturnedHTML, "[^%s,]+") do
   			if s == tostring(N40_EMP_VERSION) then 
   				PrintMessage(HUD_PRINTTALK,"[n40 Emplacements] Is up to date, Current Version: ("..N40_EMP_VERSION..")")
   			else 
   				PrintMessage(HUD_PRINTTALK,"[n40 Emplacements] Update avaliable, https://github.com/focking/N40_Emplacements ")
   				PrintMessage(HUD_PRINTTALK,"Current Version: "..N40_EMP_VERSION..", GitHub version "..s)
   			end 
		end
	end,
	function( message )
		
	end,

	{ 
		["accept-encoding"] = "gzip, deflate",
		["accept-language"] = "fr" 
	}
)


hook.Add( "PlayerTick", "N40_EMP_HANDLE_BUTONS", function(ply,mv)
	--if ply:GetNWEntity("N40_EMP") then 
	--	print("BRUUUH")
	--end 
end )

hook.Add( "PlayerSpawn", "N40_EMP_HANDLE_NW", function(ply)
	--ply:SetNWEntity("N40_EMP", nil)
end )