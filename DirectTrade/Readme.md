-- DirectTrade with fancy GUIs and stuff. Its a EasyMarket reworked complete version.


//put the following on top of server.lua

DirectTrade = require("DirectTrade")



//put the following in the command chain in server.lua

		elseif cmd[1] == "dtrade" then
				DirectTrade.ShowItem(pid)
				
				
				
				

//put the following under myMod.OnGUIAction in server.lua
	
	if DirectTrade.OnGUIAction(pid, idGui, data) then return end