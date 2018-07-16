--Turn Friendly Fire Off
--If you accidentaly hit your buddy and kill him. He will be instantly resurrected.
--This is a dirty Version to stop Friendly Fire.


//find Methods.OnPlayerDeath = function(pid)   in myMod.lua

//and replace the complete function with the following

Methods.OnPlayerDeath = function(pid)
local GotKilledbyPlayer = 0
local location = {
        posX = tes3mp.GetPosX(pid), posY = tes3mp.GetPosY(pid), posZ = tes3mp.GetPosZ(pid),
        rotX = tes3mp.GetRotX(pid), rotY = 0, rotZ = tes3mp.GetRotZ(pid)
    }
	
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			
			-- If the deathReason is a player's name, make sure we get their corresponding accountName
			-- in case they have weird characters in their regular name
			--local deathReason = fileHelper.fixFilename(tes3mp.GetDeathReason(pid))

			if myMod.GetPlayerByName(tes3mp.GetDeathReason(pid)) ~= nil then
			
					--if myMod.GetPlayerByName(deathReason) ~= nil then
				GotKilledbyPlayer = 1
				
			end
			
			
			
		if GotKilledbyPlayer ~= 1 then	     
			
			Players[pid]:ProcessDeath()
		
		else 
			

			Methods.RunConsoleCommandOnPlayer(pid,"player->resurrect")
			tes3mp.Resurrect(pid,actionTypes.resurrect.REGULAR)
			tes3mp.SetPos(pid, location.posX, location.posY, location.posZ)
			tes3mp.SetRot(pid, location.rotX, location.rotY)
			tes3mp.SendPos(pid)
		
		end
    end 
end