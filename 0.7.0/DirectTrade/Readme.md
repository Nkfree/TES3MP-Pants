# DirectTrade 
Its a EasyMarket
You can exchange Items with other Players against Gold


## Installation

put the following on top of serverCore.lua
```
DirectTrade = require("DirectTrade")
```


put the following in the command chain in commandHandler.lua
```
		elseif cmd[1] == "dtrade" then
				DirectTrade.ShowItem(pid)
```				
				
				
				
put the following under logicHandler.OnGUIAction in serverCore.lua
```	
	if DirectTrade.OnGUIAction(pid, idGui, data) then return end
```