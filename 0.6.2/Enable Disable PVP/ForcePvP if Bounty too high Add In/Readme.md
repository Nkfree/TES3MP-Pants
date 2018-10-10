## Will Automatically enable PvP if Bounty gets over 3 tausand

### Automatically Enable PvP with exchanging this line in Bountys.lua

if Gold > 3000 then friendlyPvP.TurnOn(pid) end
else
tes3mp.SendMessage(pid,"You dont have enough Gold. \n",false)   -- else send him message
end



### exchange this function in friendlyPvP.lua
friendlyPvP.TurnOff = function(pid)
if tonumber(UserConfig.GetValue(targetpid, "Bounty")) < 3000 then 
UserConfig.SetValue(pid,"PVP","off")
tes3mp.SendMessage(pid,"PVP has been turned off.\n",false)
else
 tes3mp.SendMessage(pid,"You cant turn off PvP since your Bounty is too high \n",false)
end
end