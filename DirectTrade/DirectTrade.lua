-- DirectTrade.lua
-- This Script let you trade with others.





DirectTrade = {}



local locInvList = {}
local locPlList = {}
trade = { data = {}}



---=========
--Start GUIs
--==========


DirectTrade.ShowItem = function(pid)
		
		Players[pid].data.customVariables.GotGuiOpen = 1   --- no bugs when 2 Guis are opened at same time
		
		Players[pid]:Save()
		Players[pid]:Load()
		Players[pid]:LoadInventory()
		Players[pid]:LoadEquipment()   -- Do unequip later

trade.data[pid] = { targetPid = -1, gold = -1 , chosenitem = ""}
local InvList = ""
local slotcounter = 1
locInvList[pid] = { data = {}}
for slot, inv in pairs(Players[pid].data.inventory) do

	
		InvList = InvList .. inv.refId .."\n"
		locInvList[pid].data[slotcounter] = { ref = inv.refId}
		slotcounter = slotcounter + 1
	

end

InvList = InvList .. "***Close***"

	tes3mp.ListBox(pid,6320, "Those are the items in your Inventory ..", InvList)
	

end


DirectTrade.ShowPlayers = function(pid)


local PlList =""
local plrealcount = 1
locPlList[pid] = { data ={}}

for ipid, pl in pairs(Players) do
---------------------------------------------------------checks plus real counter
  PlList = PlList .. pl.name .. " \n"
   locPlList[pid].data[plrealcount] = {pd = pl.pid}
    plrealcount = plrealcount+1
end

PlList = PlList .. "***Close***"

tes3mp.ListBox(pid,6321,"Choose a Player", PlList)

end


DirectTrade.ShowGold = function(pid)

tes3mp.InputDialog(pid,6322,"do gold")

end


DirectTrade.AskGui = function(pid)
if Players[trade.data[pid].targetPid].data.customVariables.GotGuiOpen ~= 1 then 
Players[trade.data[pid].targetPid].data.customVariables.GotGuiOpen = 1
tes3mp.SendMessage(pid,"You are starting a trade. You have to wait if he accepts\n",false)

message = Players[pid].name.." wants to give you "..trade.data[pid].chosenitem.." for "..tostring(trade.data[pid].gold).." Gold..\n Do you accept the Trade?"
tes3mp.CustomMessageBox(trade.data[pid].targetPid, 6323, message, "OK;NO")
else
    Players[pid].data.customVariables.GotGuiOpen = 0
tes3mp.SendMessage(pid,"Sorry the targeted Player got alrdy a Gui opened.\n",false)
end
end


--==============
--REAL TRADe NOW
--==============



DirectTrade.TradeItem = function(pid)   ---- pid is one who started trade

local targetpid = trade.data[pid].targetPid  --- targetpid is one who clicked accept
local gold = trade.data[pid].gold 
local thing = trade.data[pid].chosenitem



tes3mp.SendMessage(pid," Beginning to trade...\n",false)
tes3mp.SendMessage(targetpid," Beginning to trade...\n",false)

		Players[targetpid]:Save()
		Players[pid]:Save()
		Players[targetpid]:Load()
		Players[pid]:Load()
		Players[targetpid]:LoadInventory()
		Players[pid]:LoadInventory()
		Players[targetpid]:LoadEquipment()
		Players[pid]:LoadEquipment()

local goldamount = 0  --calc goldamount of targetpid
local HeGotIt = 0
local TargetGotThing = 0
local SellerGotGold = 0
local ItsEquipped = 0

for slot, inv in pairs(Players[targetpid].data.inventory) do  -- get goldamount
 if inv.refId == "gold_001" then
	    goldamount = inv.count
		tes3mp.SendMessage(targetpid," He got goldamount"..tostring(goldamount).."\n",false)
	end	
end

for slot, inv in pairs( Players[pid].data.inventory) do --- does player have item
	 if inv.refId == thing then
	    HeGotIt = 1
		tes3mp.SendMessage(pid,"You got the Item\n",false)
	end	
end




if HeGotIt ~= 1 then tes3mp.SendMessage(pid,"You dont have the item. \n",false) end
if goldamount < gold then tes3mp.SendMessage(targetpid,"You dont have the Gold",false) end


for slot, inv in pairs(Players[pid].data.equipment) do -- does player have item equipped
	 if inv.refId == thing then
	    ItsEquipped = 1
		tes3mp.SendMessage(pid,"You have the item equipped. \n",false)
	end	
end

--and ItsEquipped ~= 1 for if you experiencing bugs while trading equipment
if HeGotIt == 1  then
	if goldamount >= gold then
		 tes3mp.SendMessage(pid,"after ifs\n",false)
					
			
-------------------------------------------TARGET ITEM
			for slot, inv in pairs(Players[targetpid].data.inventory) do -- check if target got alrdy a copy
					if inv.refId == thing and inv.count > 0 then
						
							Players[targetpid].data.inventory[slot].count = Players[targetpid].data.inventory[slot].count + 1
							tes3mp.SendMessage(targetpid,"You got extra "..thing.."\n",false)
							TargetGotThing = 1
						
					end
			end

			if TargetGotThing ~= 1 then  -- else he got new one
				tes3mp.SendMessage(targetpid,"You got new "..thing.."\n",false)
				table.insert(Players[targetpid].data.inventory, {refId = thing, count = 1, charge = -1})
			end



			 --tes3mp.SendMessage(pid,"item changed",false)
--------------------------- TARGET GOLD

			for slot, inv in pairs(Players[targetpid].data.inventory) do --- remove gold
					if inv.refId == "gold_001" then
						Players[targetpid].data.inventory[slot].count = Players[targetpid].data.inventory[slot].count - gold
						tes3mp.SendMessage(targetpid,tostring(gold).." Gold was removed.\n",false)

						if Players[targetpid].data.inventory[slot].count < 1 then
								Players[targetpid].data.inventory[slot] = nil
						end

					end
					
			end
			
----------------------------------SELLER GOLD


			for slot, inv in pairs(Players[pid].data.inventory) do -- check if seller got gold
					if inv.refId == "gold_001" and inv.count > 0 then
						
							Players[pid].data.inventory[slot].count = Players[pid].data.inventory[slot].count + gold
							tes3mp.SendMessage(pid,"You got extra gold \n",false)
							SellerGotGold = 1
						
					end
					
			end

			if SellerGotGold ~= 1 then  -- else he got new one
				tes3mp.SendMessage(pid,"You got new gold \n",false)
				table.insert(Players[pid].data.inventory, {refId = "gold_001", count = gold, charge = -1})
			end

			
			
			--------------------- SELLER ITEM
			
									if ItsEquipped == 1 then --- THIS 
											for slot, inv in pairs(Players[pid].data.equipment) do --- remove item
												if inv.refId == thing then
														Players[pid].data.equipment[slot] = nil
												


												tes3mp.SendMessage(pid,"Item removed from equipment \n",false)
												end
											end
											
									end
										----------after removing from equippment and if its only in inventory .. remove from inventory
										for slot, inv in pairs(Players[pid].data.inventory) do --- remove item
											if inv.refId == thing then
												Players[pid].data.inventory[slot].count = Players[pid].data.inventory[slot].count - 1


													if Players[pid].data.inventory[slot].count < 1 then
														Players[pid].data.inventory[slot] = nil
													end


											tes3mp.SendMessage(pid,"Item removed from inventory\n",false)
											end
										end
								
					
			
			tes3mp.SendMessage(pid,"Transaction is Done. Loading Inventorys.. \n",false)
			tes3mp.SendMessage(targetpid,"Transaction is Done. Loading Inventorys ..\n",false)

			-------------------RELOAD ALL INV			
		
		Players[targetpid]:Save()	
		Players[pid]:Save()		
		Players[targetpid]:Load()
		Players[pid]:Load()
		Players[targetpid]:LoadInventory()
		Players[pid]:LoadInventory()
		Players[targetpid]:LoadEquipment()
		Players[pid]:LoadEquipment()
	end
end

Players[pid].data.customVariables.GotGuiOpen = 0
Players[targetpid].data.customVariables.GotGuiOpen = 0

end


----===============
-----GUI STUFF
----===============




DirectTrade.OnGUIAction = function(pid, idGui, data)


if idGui == 6320 then
 if table.getn(locInvList[pid].data) > 0 and tonumber(data) < table.getn(locInvList[pid].data) then
 local slot = tonumber(data) + 1
 trade.data[pid].chosenitem =locInvList[pid].data[slot].ref
 
 tes3mp.SendMessage(pid,"Item Selected:"..trade.data[pid].chosenitem.."\n",false)
 DirectTrade.ShowPlayers(pid)
 
 else
 
 tes3mp.SendMessage(pid,"You closed the Menu.\n",false)
 Players[pid].data.customVariables.GotGuiOpen = 0
 end
end
 
if idGui == 6321 then
 if table.getn(locPlList[pid].data) > 0 and tonumber(data) < table.getn(locPlList[pid].data) then
	local slot = tonumber(data) + 1
  trade.data[pid].targetPid =locPlList[pid].data[slot].pd
	if Players[trade.data[pid].targetPid] ~= nil and Players[trade.data[pid].targetPid]:IsLoggedIn() and trade.data[pid].targetPid ~= pid then
	 trade.data[trade.data[pid].targetPid].IncomingTradePid = pid --- do checks before??
				tes3mp.SendMessage(pid,"Pid Selected:"..trade.data[pid].targetPid.."\n",false)
		DirectTrade.ShowGold(pid)
	else
				tes3mp.SendMessage(pid,"Playerspid id invalid \n",false)
				Players[pid].data.customVariables.GotGuiOpen = 0
	end
 else-------------bug if nothing is selected

 tes3mp.SendMessage(pid,"You closed the Menu.\n",false)
 Players[pid].data.customVariables.GotGuiOpen = 0
  end
end
 

if idGui == 6322 then
 if tonumber(data) ~= nil and tonumber(data) > 0 then
 trade.data[pid].gold = tonumber(data)
 tes3mp.SendMessage(pid,"Gold Selected:"..data.."\n",false)
 DirectTrade.AskGui(pid)
 else
 tes3mp.SendMessage(pid, "Enter a valid Goldamount \n",false)
 Players[pid].data.customVariables.GotGuiOpen = 0
 end
end
 

if idGui == 6323 then 
	if tonumber(data) == 0 then
		DirectTrade.TradeItem(trade.data[pid].IncomingTradePid)
	else
		tes3mp.SendMessage(pid, "You refused the Trade.\n", false)
		Players[pid].data.customVariables.GotGuiOpen = 0
		tes3mp.SendMessage(trade.data[pid].IncomingTradePid, tes3mp.GetName(pid).." refused the Trade. \n", false)	 
		Players[trade.data[pid].IncomingTradePid].data.customVariables.GotGuiOpen = 0
	end

end

end -- end OnGui function


return DirectTrade