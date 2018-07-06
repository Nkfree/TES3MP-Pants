--EasyMarket lets you trade with others.
--Use /wts command.
--Use /wts itemlist to see the RefIDs in your inventory.
--Use /wts ID ItemsRefID Goldamount to trade with player ID the Item for Goldamount.
--Like /wts 2 common_pants_02 1000
--removes gold at your end and gives player with ID 2 some pants.
--The other Player got the ability to accept your trade or not.

//This Script is not able to trade multiple items at the same time.
//This Script does not offer a visible Marketplace
//You have to offer your items in Chat with I WTS DEADRIC SHIT FOR 1000 Gold
//Or I WTB SOME
//-This Script could use some fancy lists


--------------------------------
---Installation
--------------------------------





// put the following on top of server.lua


EasyMarket = require("EasyMarket")


//put the following in the command chain in server.lua

		elseif cmd[1] == "wts" then
			if cmd[2] ~= nil then
				if cmd[2] == "itemlist" then 
					EasyMarket.ItemChoose(pid)
				else
					if myMod.CheckPlayerValidity(pid, cmd[2]) then
						if tonumber(cmd[4]) ~= nil then
							if tonumber(cmd[2]) ~= pid then
                
								EasyMarket.AskGui(pid,tonumber(cmd[2]),cmd[3],tonumber(cmd[4]))
							else
								tes3mp.SendMessage(pid,"You cant trade with yourself.\n",false)
							end
						else
							tes3mp.SendMessage(pid,"Enter a valid Goldamount.\n",false)
						end
					end
				end
			else
				tes3mp.SendMessage(pid,"With Command wts you can trade with others.\n Use /wts itemlist.\n After wts enter ID ItemRefID Gold.\n",false)						
			end
			
			
			
			

//find function OnGUIAction in server.lua and put the following under it
	
	if EasyMarket.OnGUIAction(pid, idGui, data) then return end