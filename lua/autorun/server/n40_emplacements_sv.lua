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

function TransferBones( base, ragdoll ) -- Transfers the bones of one entity to a ragdoll's physics bones (modified version of some of RobotBoy655's code)
	if !IsValid( base ) or !IsValid( ragdoll ) then return end
	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local bone = ragdoll:GetPhysicsObjectNum( i )
		if ( IsValid( bone ) ) then
			local pos, ang = base:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
			if ( pos ) then bone:SetPos( pos ) end
			if ( ang ) then bone:SetAngles( ang ) end
		end
	end
end

concommand.Add("playtest", function( ply, cmd, args )
	 ply:AnimRestartGesture( 6, ply:LookupSequence( "wos_l4d_die_standing" ) )
end)


hook.Add( 'PlayerDeath', 'DeathAnimation', function( victim, inflictor, attacker )
		if IsValid( victim:GetRagdollEntity() ) then -- Remove the default ragdoll
		victim:GetRagdollEntity():Remove()
	end
local animent = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation
	animent:SetModel(victim:GetModel())
	animent:SetPos(victim:GetPos())
	animent:Spawn()
	animent:Activate()
	animent:SetSequence( animent:LookupSequence( "wos_l4d_die_standing" ) )
	animent:SetPlaybackRate( 1 )
	animent.AutomaticFrameAdvance = true	
		function animent:Think() -- This makes the animation work
		self:NextThink( CurTime() )
		return true
	end
	timer.Simple( animent:SequenceDuration( seq ), function() -- After the sequence is done, spawn the ragdoll
		local rag = ents.Create( 'prop_ragdoll' )
		rag:SetPos(animent:GetPos())
		rag:SetModel(animent:GetModel())
		animent:Remove()
				rag:Spawn()
		rag:Activate()
				TransferBones( animent, rag )


	end )
end)