###GroupParty.lua
This is a Grouping Up / Party - System
add Features to it via Add-In


##install instructions: 

put on top of serverCore.lua
```
GroupParty = require("GroupParty")
```


add in command chain in commandHandler.lua
```
elseif cmd[1] == "party" then
				GroupParty.ShowMain(pid)
```


add this line into the function in serverCore.lua
```
function OnPlayerDisconnect(pid)
	GroupParty.LeaveParty(pid)
```


add in onguiaction in serverCore.lua

```
if GroupParty.OnGUIAction(pid, idGui, data) then return end
```



##RandomGold and ShuffleLoot and Bonus Skills

You can have greater Benefits from Grouping up in Partys.
See Gold Add-In and Shuffle Loot Add-In and Bonus Skills Add-In
