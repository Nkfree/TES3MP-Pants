



-- Completely Exchange Mehtods.OnPlayerDeath in myMod.lua

--add "friendlyPvP = require("friendlyPvP") " to top off server.lua


--[[Methods.OnPlayerDeath = function(pid)
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
			if friendlyPvP.CheckPvP(pid) then
			Players[pid]:ProcessDeath()
			
			
			else
			
			Methods.RunConsoleCommandOnPlayer(pid,"player->resurrect")
			tes3mp.Resurrect(pid,0)
			tes3mp.SetPos(pid, location.posX, location.posY, location.posZ)
			tes3mp.SetRot(pid, location.rotX, location.rotY)
			tes3mp.SendPos(pid)
			
			
			end
			
		end
    end 
end]]

--exchange on top of command chain:
--[[
function OnPlayerSendMessage(pid, message)
    local playerName = tes3mp.GetName(pid)
		local prefix = ""
	if  friendlyPvP.CheckPvP(pid) then
		prefix = prefix .. "[PVP]"
	end
]]

--add in the command chain
--[[
elseif cmd[1] == "pvp" then
	if cmd[2] == "on" then
		friendlyPvP.TurnOn(pid)
	else
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			friendlyPvP.TurnOff(pid)
		end
	end
	
]]
--exchange in the end of command chain
--[[
   return false -- commands should be hidden
    end
	tes3mp.SendMessage(pid,  color.Red..prefix..color.Default.. playerName .. "(" .. pid .. "): " .. message .. "\n", true)
    return false -- default behavior, chat messages should not. edit: changed.
end
]]

--add a line here in server.lua
--[[
tes3mp.LogMessage(1, "New player with pid("..pid..") connected!")
myMod.OnPlayerConnect(pid, playerName)
friendlyPvP.TurnOff(pid)		
		]]
		
		
		
friendlyPvP = {}

UserConfig = require("UserConfig")

-- max. "was killed by" messsage change

friendlyPvP.TurnOn = function(pid)
if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
UserConfig.SetValue(pid,"PVP","on")
tes3mp.SendMessage(pid,"PVP has been turned on.\n",false)
end
end

friendlyPvP.TurnOff = function(pid)
UserConfig.SetValue(pid,"PVP","off")
tes3mp.SendMessage(pid,"PVP has been turned off.\n",false)
end

friendlyPvP.CheckPvP = function(pid)
if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
if UserConfig.GetValue(pid,"PVP") == "on" then
return true
else
return false
end
end
end

return friendlyPvP