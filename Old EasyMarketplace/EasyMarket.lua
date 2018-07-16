-- EasyMarket.lua
-- This Script let you trade with others.


EasyMarket = {}




EasyMarket.ItemChoose = function(pid)
tes3mp.SendMessage(pid,"Those are the items in your Inventory .. \n",false)
for slot= 0, 50, 1 do
 if Players[pid].data.inventory[slot] ~= nil then
	tes3mp.SendMessage(pid,Players[pid].data.inventory[slot].refId.."\n",false)
 end
end
end

EasyMarket.AskGui = function(pid, targetpid, thing, gold)

tes3mp.SendMessage(pid,"You are starting a trade. You have to wait if he accepts.\n",false)

Players[targetpid].data.customVariables.WantsToTradeWith = pid
Players[targetpid].data.customVariables.WantsToTradeThing = thing
Players[targetpid].data.customVariables.WantsToTradeGold = gold


message = tes3mp.GetName(pid).." wants to give you "..thing.." for "..tostring(gold).." Gold..\n Do you accept the Trade?"
tes3mp.CustomMessageBox(targetpid, 1144, message, "OK;NO")
    
end







EasyMarket.TradeItem = function(pid, targetpid, thing, gold)
tes3mp.SendMessage(pid," Beginning to trade...\n",false)
tes3mp.SendMessage(targetpid," Beginning to trade...\n",false)
local goldamount = 0  --calc goldamount of targetpid
local HeGotIt = 0
local TargetGotThing = 0
local SellerGotGold = 0
local ItsEquipped = 0

for slot= 0, 50, 1 do
 if Players[targetpid].data.inventory[slot] ~= nil then
	 if Players[targetpid].data.inventory[slot].refId == "gold_001" then
	    goldamount = Players[targetpid].data.inventory[slot].count
		--tes3mp.SendMessage(pid," He got goldamount"..tostring(goldamount).."\n",false)
	end
 end	
end

for slot= 0, 50, 1 do --- does player have item
 if Players[pid].data.inventory[slot] ~= nil then
			tes3mp.SendMessage(pid,Players[pid].data.inventory[slot],false)
	 if Players[pid].data.inventory[slot].refId == thing then
	    HeGotIt = 1
		--tes3mp.SendMessage(pid,"You got the Item\n",false)
	end
 end	
end

if HeGotIt ~= 1 then tes3mp.SendMessage(pid,"You dont have the item. \n",false) end
if goldamount < gold then tes3mp.SendMessage(targetpid,"You dont have the Gold. \n",false) end

for slot= 0, 50, 1 do --- does player have item equipped
 if Players[pid].data.equipment[slot] ~= nil then
	 if Players[pid].data.equipment[slot].refId == thing then
	    ItsEquipped = 1
		tes3mp.SendMessage(pid,"You cant trade an Item you got equipped\n",false)
	end
 end	
end



if HeGotIt == 1 and ItsEquipped ~= 1 then
	if goldamount >= gold then
			--tes3mp.SendMessage(pid,"after ifs\n",false)
			
			
			for slot= 0, 50, 1 do -- check if target got alrdy a copy
				if Players[targetpid].data.inventory[slot] ~= nil then
					if Players[targetpid].data.inventory[slot].refId == thing then
						if Players[targetpid].data.inventory[slot].count > 0 then
							Players[targetpid].data.inventory[slot].count = Players[targetpid].data.inventory[slot].count + 1
							tes3mp.SendMessage(pid,"You got extra "..thing.."\n",false)
							TargetGotThing = 1
						end
					end
				end	
			end
			
			if TargetGotThing ~= 1 then  -- else he got new one
				tes3mp.SendMessage(targetpid,"You got new "..thing.."\n",false)
				table.insert(Players[targetpid].data.inventory, {refId = thing, count = 1, charge = -1})
			end
						
					
			 
			 --tes3mp.SendMessage(pid,"item changed",false)
			
			
			for slot= 0, 50, 1 do --- remove gold
				if Players[targetpid].data.inventory[slot] ~= nil then
					if Players[targetpid].data.inventory[slot].refId == "gold_001" then
						Players[targetpid].data.inventory[slot].count = Players[targetpid].data.inventory[slot].count - gold
						tes3mp.SendMessage(targetpid,tostring(gold).." Gold was removed.\n",false)
						
						if Players[targetpid].data.inventory[slot].count < 1 then
								Players[targetpid].data.inventory[slot] = nil
						end
						
					end
				end	
			end
			
			
			
			
			for slot= 0, 50, 1 do -- check if seller got gold
				if Players[pid].data.inventory[slot] ~= nil then
					if Players[pid].data.inventory[slot].refId == "gold_001" then
						if Players[pid].data.inventory[slot].count > 0 then
							Players[pid].data.inventory[slot].count = Players[pid].data.inventory[slot].count + gold
							tes3mp.SendMessage(pid,"You got extra gold \n",false)
							SellerGotGold = 1
						end
					end
				end	
			end
			
			if SellerGotGold ~= 1 then  -- else he got new one
				tes3mp.SendMessage(pid,"You got new gold \n",false)
				table.insert(Players[pid].data.inventory, {refId = "gold_001", count = gold, charge = -1})
			end
			
			for slot= 0, 50, 1 do --- remove item
				if Players[pid].data.inventory[slot] ~= nil then
					if Players[pid].data.inventory[slot].refId == thing then
							Players[pid].data.inventory[slot].count = Players[pid].data.inventory[slot].count - 1
							
							
							if Players[pid].data.inventory[slot].count < 1 then
								Players[pid].data.inventory[slot] = nil
							end
							
							
						tes3mp.SendMessage(pid,"Item removed \n",false)
					end
				end	
			end
			tes3mp.SendMessage(pid,"Transaction is Done. Loading Inventorys.. \n",false)
			tes3mp.SendMessage(targetpid,"Transaction is Done. Loading Inventorys ..\n",false)
		Players[targetpid]:Save()	
		Players[pid]:Save()
		Players[targetpid]:LoadInventory()
		Players[pid]:LoadInventory()
		Players[targetpid]:LoadEquipment()
		Players[pid]:LoadEquipment()
	end
end

end


EasyMarket.OnGUIAction = function(pid, idGui, data)
if idGui == 1144 then 
	if tonumber(data) == 0 then
		EasyMarket.TradeItem(Players[pid].data.customVariables.WantsToTradeWith, pid, Players[pid].data.customVariables.WantsToTradeThing, Players[pid].data.customVariables.WantsToTradeGold)
	else
		tes3mp.SendMessage(pid, "You refused the Trade.\n", false)
		tes3mp.SendMessage(Players[pid].data.customVariables.WantsToTradeWith, tes3mp.GetName(pid).." refused the Trade. \n", false)	 
	end
	 
end
end


return EasyMarket
