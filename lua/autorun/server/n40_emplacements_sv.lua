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





