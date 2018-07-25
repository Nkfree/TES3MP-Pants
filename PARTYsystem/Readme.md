###LevelParty.lua
This enables Party System. Join Partys Leave Party Kick Members
And of course .. if someone skills ... there will be extra points on skills


##install instructions: 

on top of server.lua
```
skilledone = ""
skilledtwice = 2
LevelParty = require("LevelParty")
```
add in command chain in server.lua
```
elseif cmd[1] == "party" then
				LevelParty.ShowMain(pid)
```

exchange in server.lua
```
function OnPlayerSkill(pid)
	myMod.OnPlayerSkill(pid)
	--LevelParty.RandomGold(pid)
	if skilledtwice == 1 then
		skilledtwice = 2
		LevelParty.GetSkillPlayer(pid)
	end
end
```
add this line in server.lua in the right function:
```
function OnPlayerDisconnect(pid)
	LevelParty.LeaveParty(pid)
```
add in onguiaction in server.lua
```
if LevelParty.OnGUIAction(pid, idGui, data) then return end
```

Add the following in /player/base.lua under local baseValue = tes3mp.GetSkillBase(self.pid, skillId)

```
if baseValue ~= self.data.skills[name] then
			skilledone = name
		skilledtwice = 1
end
```


##RandomGold and ShuffleLoot

You can have greater Benefits from Grouping up in Partys.
See Gold Add-In and Shuffle Loot Add-In

### Bugs Issues Reports Suggestions
Go to the Discord in the first Readme and report everything