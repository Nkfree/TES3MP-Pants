##Bonus Skills
when someone in the Party skills, there will be extra Skill Points
LevelParty

##Installation

put on top of serverCore.lua
``` 
skilledone = ""
skilledtwice = 2
```


Add the following in /player/base.lua under local baseValue = tes3mp.GetSkillBase(self.pid, skillId)

```
if baseValue ~= self.data.skills[name] then
			skilledone = name
			skilledtwice = 1
end
```

exchange in serverCore.lua

```
function OnPlayerSkill(pid)
	eventHandler.OnPlayerSkill(pid)
	if skilledtwice == 1 then
		skilledtwice = 2
		GroupParty.GetSkillPlayer(pid)
	end
end
```