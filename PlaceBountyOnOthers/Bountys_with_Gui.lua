friendlyPvP = require("friendlyPvP")
UserConfig = require("UserConfig")

local Bountys = {}
BountyOptionsList = {}

Bountys.SetPlayer = function(pid)
local realcount = 1
local PlList = ""
BountyOptionsList[pid] = { data = {} }

for i, p in pairs(Players) do
PlList = PlList ..p.name.."\n"
BountyOptionsList[pid].data[realcount] = i
realcount = realcount + 1
end
PlList = PlList .."***Close***"

tes3mp.ListBox(pid, 1210, "Choose Player to set Bounty on", PlList)
end


Bountys.ShowGoldInput = function(pid)
tes3mp.InputDialog(pid,1220,"How much Gold?")
end


Bountys.SeeBounty = function(pid)
local PlList = ""


for i, Pl in pairs(Players) do  -- print all online players bounty
	if UserConfig.GetValue(Pl.pid, "Bounty") ~= "-1" and UserConfig.GetValue(Pl.pid, "Bounty") ~= -1 then
		local BountyGold = UserConfig.GetValue(Pl.pid, "Bounty")
		
  PlList = PlList..Pl.name.." has Bounty "..BountyGold.."\n"
  end
end

tes3mp.ListBox(pid,1230,"The Bountys",PlList)

--[[
tes3mp.SendMessage(pid,"Those are the Bountys set:\n\n",false)


for i, Pl in pairs(Players) do  -- print all online players bounty
	if UserConfig.GetValue(Pl.pid, "Bounty") ~= "-1" and UserConfig.GetValue(Pl.pid, "Bounty") ~= -1 then
		local BountyGold = UserConfig.GetValue(Pl.pid, "Bounty")
		tes3mp.SendMessage(pid,Pl.name.." is worth "..BountyGold.. " #DAA520Golden Drakes#FFFFFF\n",false)
	end
end]]--

end -- end function


Bountys.SetBountyValue = function(pid)

local targetpid = Players[pid].data.customVariables.BountyChosenPid
local gold = Players[pid].data.customVariables.BountyChosenGold
local BeforeGold = 0
local GoldAmount = 0
		Players[pid]:Save()
		Players[pid]:Load()
		Players[pid]:LoadInventory() -- load before so everythings correct
		Players[pid]:LoadEquipment()

for i, inv in pairs(Players[pid].data.inventory) do --- check inv if he have does gold
		if 	inv.refId == "tie_goldendrake" then
				GoldAmount = inv.count
				--tes3mp.SendMessage(pid," is worth "..BountyGold.. " #DAA520Golden Drakes#FFFFFF")("\n",false)
				break
		end	
end





if GoldAmount >= gold and gold > 0 then -- if he got more gold than he wants to place

	for i, inv in pairs(Players[pid].data.inventory) do --- remove gold
		if 	inv.refId == "tie_goldendrake" then
				Players[pid].data.inventory[i].count = inv.count - gold
				tes3mp.SendMessage(pid,tostring(gold).." #DAA520Golden Drakes#FFFFFF were removed from your inventory.\n",false)
						
				if inv.count < 1 then  -- if empty remove
						Players[pid].data.inventory[i] = nil
				end
				break
		end
	end		






	if UserConfig.GetValue(targetpid, "Bounty") ~= "-1" and UserConfig.GetValue(targetpid, "Bounty") ~= -1 then  -- increase bounty
		BeforeGold = tonumber(UserConfig.GetValue(targetpid, "Bounty"))
		gold = gold + BeforeGold
		UserConfig.SetValue(targetpid, "Bounty", tostring(gold))
		tes3mp.SendMessage(targetpid,Players[targetpid].name.." had a private bounty placed on their head worth "..tostring(gold).." #DAA520Golden Drakes#FFFFFF. Kill them to claim the reward!\n",true)
	else													--- set new bounty
		UserConfig.SetValue(targetpid, "Bounty", tostring(gold))
		tes3mp.SendMessage(targetpid,Players[targetpid].name.." had their private bounty total increased to "..tostring(gold).." #DAA520Golden Drakes#FFFFFF, kill them to claim the reward!\n",true)
	end

	if gold > 3000 then friendlyPvP.TurnOn(targetpid) end

else
tes3mp.SendMessage(pid,"You don't have enough #DAA520Golden Drakes#FFFFFF.\n",false)   -- else send him message
end



		
		Players[pid]:Save()    ------reload because we changed gold
		Players[pid]:LoadInventory()
		Players[pid]:LoadEquipment()


end --end function



Bountys.GotKilled = function (pid)

local BountyHunterPid = -1
local Deathreason = tes3mp.GetDeathReason(pid)
local HeGotGold = false

for i, Pl in pairs(Players) do  -- check if he got killed from player
	if string.lower(Pl.name) == string.lower(Deathreason)  then
		BountyHunterPid = Pl.pid
		break
	end
end





if BountyHunterPid ~= -1 then 
		
		Players[BountyHunterPid]:Save()
		Players[BountyHunterPid]:Load()
		Players[BountyHunterPid]:LoadInventory()
		Players[BountyHunterPid]:LoadEquipment()
		
	if UserConfig.GetValue(pid, "Bounty") ~= "-1" and UserConfig.GetValue(pid, "Bounty") ~= -1  then  -- check if player got bounty
		local WinBounty = UserConfig.GetValue(pid, "Bounty")
		UserConfig.SetValue(pid, "Bounty", "-1")
		tes3mp.SendMessage(BountyHunterPid,Players[BountyHunterPid].name.." has claimed a private bounty reward for killing "..Players[pid].name.."!! \n",true)
		
		
			for i, inv in pairs(Players[BountyHunterPid].data.inventory) do ---add gold if he got gold
				if 	inv.refId == "tie_goldendrake" then
					Players[BountyHunterPid].data.inventory[i].count = inv.count + tonumber(WinBounty)
					tes3mp.SendMessage(BountyHunterPid,WinBounty.." #DAA520Golden Drakes#FFFFFF added.\n",false)
						HeGotGold = true
					if Players[BountyHunterPid].data.inventory[i].count < 1 then  -- if empty remove. i think this doesnt happen
						Players[BountyHunterPid].data.inventory[i] = nil
					end
					break
				end
			end
		
			if HeGotGold == false then
				table.insert(Players[BountyHunterPid].data.inventory, {refId = "tie_goldendrake", count = tonumber(WinBounty), charge = -1})
			end
			
	end
	
	
		Players[BountyHunterPid]:Save()
		Players[BountyHunterPid]:Load()
		Players[BountyHunterPid]:LoadInventory()
		Players[BountyHunterPid]:LoadEquipment()
		
	tes3mp.SendMessage(pid,"Processed BountyStuff. Your private bounty has been cleared.\n",false)
	tes3mp.SendMessage(BountyHunterPid,"Processed BountyStuff. You've claimed a private bounty!\n",false)
	
end

end

Bountys.OnGuiAction = function(pid,idGui,data)

if idGui == 1210 then
  if tonumber(data) < table.getn(BountyOptionsList[pid].data) then
  
  local chosenpid = BountyOptionsList[pid].data[tonumber(data)  + 1]
 if myMod.CheckPlayerValidity(pid, chosenpid) then Players[pid].data.customVariables.BountyChosenPid = chosenpid
  Bountys.ShowGoldInput(pid)
  end
  else
   tes3mp.SendMessage(pid,"You closed the Menu \n The data was "..data,false)
   end
end


if idGui == 1220 then
if tonumber(data) ~= nil then
 Players[pid].data.customVariables.BountyChosenGold = tonumber(data)
 Bountys.SetBountyValue(pid)
else
tes3mp.SendMessage(pid,"Enter a Valid Gold Amount.\n",false)
end
end

end -- end ongui



return Bountys