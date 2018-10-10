# Place Bountys on other Players

and hunt them down to gather the Bounty

## InGame Use

/bounty
/bounty see
/bounty set


## Installation

put on top of serverCore.lua
```
Bountys = require("Bountys")
```

put in the cmdChain in commandHandler.lua
```
        elseif cmd[1] == "bounty" then
		
            if cmd[2] == "set" then
				Bountys.SetPlayer(pid)
            elseif cmd[2] == "see" then
				Bountys.SeeBounty(pid)
            else
                tes3mp.SendMessage(pid, "With Bounty you can see and set Bountys.\n Use bounty set or bounty see\n", false)
            end


```


replace function OnPlayerDeath in serverCore.lua
```
function OnPlayerDeath(pid)
    tes3mp.LogMessage(enumerations.log.INFO, "Called \"OnPlayerDeath\" for " .. logicHandler.GetChatName(pid))
    eventHandler.OnPlayerDeath(pid)
	Bountys.GotKilled(pid)
end
```

replace function OnGuiAction in serverCore.lua
```
function OnGUIAction(pid, idGui, data)
    tes3mp.LogMessage(enumerations.log.INFO, "Called \"OnGUIAction\" for " .. logicHandler.GetChatName(pid))
    if eventHandler.OnGUIAction(pid, idGui, data) then return end -- if eventHandler.OnGUIAction is called
	if Bountys.OnGUIAction(pid, idGui, data) then return end
end
```

