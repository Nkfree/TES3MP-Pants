----SkillLink.lua

--This Script links two players with each other.
--If one player skills in a skill the other one gets an extra point on this skill as well.




--[[







---------------------------
--INSTALLATION
---------------------------


--You need UserConfig.lua
--https://github.com/TES3MP-TeamFOSS/Scripts/blob/master/0.6.1/scripts/UserConfig/UserConfig.lua
--Install UserConfig.lua

--put all this in a textfile and call it SkillLink.lua and put it in mp-stuff/scripts


---Add the following in base.lua under local baseValue = tes3mp.GetSkillBase(self.pid, skillId)


if baseValue ~= self.data.skills[name] then
			skilledone = name
		skilledtwice = 1
end



---Add the following to the top of server.lua

skilledone = ""
skilledtwice = 2
SkillLink = require("SkillLink")



--Add the following in the chain of commands in server.lua


	 elseif cmd[1] == "link" then
			if cmd[2] ~= nil then	
				if myMod.CheckPlayerValidity(pid, cmd[2]) then
					if tonumber(cmd[2]) ~= pid then
                
							
						SkillLink.ProcessLink(pid, cmd[2])
						
					else
			
						tes3mp.SendMessage(pid, "Invalid input for link. \n", false)
					end
				end
			else
			
			tes3mp.SendMessage(pid, "With the command link you can link with a player. \nAfter link type in the player id. \n", false)
			
			end




--Add the following in function onGUIAction in server.lua


if SkillLink.OnGUIAction(pid, idGui, data) then return end





--Add the following on the top of myMod.lua



SkillLink = require("SkillLink")



--Add the following under the end of function OnPlayerSkill in myMod.lua


	if skilledtwice == 1 then
		SkillLink.ProcessSkill(pid)
		skilledtwice = skilledtwice + 1	
	end



--if you like, add the following under Players[pid] = nil in function OnPlayerDisconnect in myMod.lua

UserConfig.SetValue(pid, "linkedid", "wrong")


]]--
