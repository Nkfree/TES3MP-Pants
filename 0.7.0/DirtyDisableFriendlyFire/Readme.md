# Turn Friendly Fire Off 
If you accidentaly hit your buddy and kill him. He will be instantly resurrected.
This is a dirty Version to stop Friendly Fire.

## Installation
find eventHandler.OnPlayerDeath = function(pid)   in eventHandler.lua

and replace the complete function with the following

```
eventHandler.OnPlayerDeath = function(pid)
local GotKilledbyPlayer = 0
local location = {
        posX = tes3mp.GetPosX(pid), posY = tes3mp.GetPosY(pid), posZ = tes3mp.GetPosZ(pid),
        rotX = tes3mp.GetRotX(pid), rotY = 0, rotZ = tes3mp.GetRotZ(pid)
    }
	
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
	
			if logicHandler.GetPlayerByName(tes3mp.GetDeathReason(pid)) ~= nil then
				if logicHandler.GetPlayerByName(tes3mp.GetDeathReason(pid)).name ~= Players[pid].name then
					GotKilledbyPlayer = 1
				end
			end
			
			
			
		if GotKilledbyPlayer ~= 1 then	     
			
			Players[pid]:ProcessDeath()
		
		else 
			

			logicHandler.RunConsoleCommandOnPlayer(pid,"player->resurrect")
			tes3mp.Resurrect(pid,0)
			tes3mp.SetPos(pid, location.posX, location.posY, location.posZ)
			tes3mp.SetRot(pid, location.rotX, location.rotY)
			tes3mp.SendPos(pid)
		
		end
    end 
end
```