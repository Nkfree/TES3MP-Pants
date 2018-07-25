--Better do use:
https://github.com/Texafornian/Plugins-0.6.1/tree/master/stuck










--This is a working /stuck version
//The Player needs to skill in a new cell and will get a position.
//if he uses command stuck he will get back to that postition.
//he can use command stuck every 2 minutes.

-------------------

        tes3mp.SetCell(self.pid, config.defaultRespawnCell)
        tes3mp.SendCell(self.pid)
		
		-- is this the better way?


-----------------
//Put 

	if Players[pid].data.location.posX ~= nil then
	Players[pid].data.customVariables.StuckPosX = Players[pid].data.location.posX 
		Players[pid].data.customVariables.StuckPosY = Players[pid].data.location.posY 
		Players[pid].data.customVariables.StuckPosZ = Players[pid].data.location.posZ 
	end
	
	
//in function "Methods.OnPlayerSkill" in mymod.lua


//Put

		elseif cmd[1] == "stuck" then
		

                if Players[pid].data.customVariables.StuckTime == nil or
                    os.time() >= Players[pid].data.customVariables.StuckTime + 120 then
					
					local X = Players[pid].data.customVariables.StuckPosX 
					local Y = Players[pid].data.customVariables.StuckPosY
					local Z = Players[pid].data.customVariables.StuckPosZ
					
                    myMod.RunConsoleCommandOnPlayer(pid, "player->Position "..X..", "..Y..", "..Z..", 0")
					
                    Players[pid].data.customVariables.StuckTime = os.time()
					tes3mp.SendMessage(pid, "You have fixed your position!\n", false)	
				else
					tes3mp.SendMessage(pid, "You cant use it yet!\n", false)
				end
				
				
				
				
//in the Command Chain in server.lua