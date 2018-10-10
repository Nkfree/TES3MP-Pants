elseif cmd[1] == "curecorprus" then 
	if Players[pid]~= nil and Players[pid]:IsLoggedIn() then
		myMod.RunConsoleCommandOnPlayer(pid, "player->removespell corprus")
	end
	