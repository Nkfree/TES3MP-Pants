----SkillLink.lua

--This Script links two players with each other.
--If one player skills in a skill the other one gets an extra point on this skill as well.



Methods = {}


Methods.ProcessLink = function(pid, linkID)

	
			tes3mp.CustomMessageBox(tonumber(linkID), 122, "Do you want to link with "..tes3mp.GetName(pid).." ? \n", "OK;NO")

			UserConfig.SetValue(pid, "linkedid", linkID)
			UserConfig.SetValue(tonumber(linkID), "linkedid", tostring(pid))
				 
			tes3mp.SendMessage(pid, "If he accepts your offer.. \nYou are linked with ".. tes3mp.GetName(tonumber(linkID)) .." ! \n", false)
			

end			

Methods.ProcessSkill = function(pid)
local linked = UserConfig.GetValue(pid, "linkedid")
	
	if linked ~= -1 and linked ~= "wrong" then
		local linkedpid = tonumber(linked)
		
			if pid == tonumber(UserConfig.GetValue(linkedpid, "linkedid")) then
		
				if Players[linkedpid] ~= nil and Players[linkedpid]:IsLoggedIn() then
					local beforeskill = tes3mp.GetSkillBase(linkedpid, tes3mp.GetSkillId(skilledone))
		
					tes3mp.SetSkillBase(linkedpid,  tes3mp.GetSkillId(skilledone), beforeskill+1)
					tes3mp.SendSkills(linkedpid)
					tes3mp.SendMessage(pid, "Hey "..tes3mp.GetName(linkedpid).." got "..color.Green.."EXTRA Point "..color.Default.."on "..skilledone.." from "..tes3mp.GetName(pid).."\n", false)
					tes3mp.SendMessage(linkedpid, "Hey "..tes3mp.GetName(linkedpid).." got "..color.Green.."EXTRA Point "..color.Default.."on "..skilledone.." from "..tes3mp.GetName(pid).."\n", false)
				end
			end
	end
end
	

Methods.OnGUIAction  = function(pid, idGui, data)
 if idGui == 122 then
   
		if data == 1 then	
			UserConfig.SetValue(pid, "linkedid", "wrong") 
			tes3mp.SendMessage(pid, "You refused his offer.\n", false)
		else
			tes3mp.SendMessage(pid, "You accepted his offer.\n", false)
		end

 end
end

return Methods