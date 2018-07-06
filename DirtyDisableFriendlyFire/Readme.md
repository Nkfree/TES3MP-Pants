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
			
			for i= 0, 50, 1 do 
			 if Players[i] ~= nil and Players[i]:IsLoggedIn() then
			  if Players[i].name == tes3mp.GetDeathReason(pid) then
				GotKilledbyPlayer = 1
			  end
			 end
			end
			
		if GotKilledbyPlayer ~= 1 then	     
		Players[pid]:ProcessDeath()
			else 
			

		Methods.RunConsoleCommandOnPlayer(pid,"player->resurrect")
		tes3mp.Resurrect(pid,actionTypes.resurrect.IMPERIAL_SHRINE)
		tes3mp.SetPos(pid, location.posX, location.posY, location.posZ)
		tes3mp.SetRot(pid, location.rotX, location.rotY)
		tes3mp.SendPos(pid)
		end
    end 
end