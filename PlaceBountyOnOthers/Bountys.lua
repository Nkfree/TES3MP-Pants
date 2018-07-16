
UserConfig = require("UserConfig")

local Bountys = {}

Bountys.SeeBounty = function(pid)

tes3mp.SendMessage(pid,"Those are the Bountys set:\n\n",false)


for i, Pl in pairs(Players) do  -- print all online players bounty
	if UserConfig.GetValue(Pl.pid, "Bounty") ~= "-1" and UserConfig.GetValue(Pl.pid, "Bounty") ~= -1 then
		local BountyGold = UserConfig.GetValue(Pl.pid, "Bounty")
		tes3mp.SendMessage(pid,Pl.name.." has a bounty of "..BountyGold.. "Golden Drakes\n",false)
	end
end

end -- end function


Bountys.SetBountyValue = function (pid, targetpid, gold)

local BeforeGold = 0
local GoldAmount = 0
		Players[pid]:Save()
		Players[pid]:Load()
		Players[pid]:LoadInventory() -- load before so everythings correct
		Players[pid]:LoadEquipment()

for i, inv in pairs(Players[pid].data.inventory) do --- check inv if he have does gold
		if 	inv.refId == "gold_001" then
				GoldAmount = inv.count
				--tes3mp.SendMessage(pid," has a bounty of "..BountyGold.. "Golden Drakes")("\n",false)
				break
		end	
end





if GoldAmount >= gold then -- if he got more gold than he wants to place

	for i, inv in pairs(Players[pid].data.inventory) do --- remove gold
		if 	inv.refId == "gold_001" then
				Players[pid].data.inventory[i].count = inv.count - gold
				tes3mp.SendMessage(pid,tostring(gold).." Golden Drakes removed.\n",false)
						
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
		tes3mp.SendMessage(targetpid,Players[targetpid].name.."got a bounty on Top. He now has "..tostring(gold).." Bounty \n",true)
	else													--- set new bounty
		UserConfig.SetValue(targetpid, "Bounty", tostring(gold))
		tes3mp.SendMessage(targetpid,Players[targetpid].name.."now got a Bounty. He now has"..tostring(gold).." Bounty\n",false)
	end


else
tes3mp.SendMessage(pid,"You dont have enough Golden Drakes. \n",false)   -- else send him message
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
		tes3mp.SendMessage(BountyHunterPid,Players[pid].name.." has claimed the bounty for killing "..Players[BountyHunterPid].name.."!! \n",true)
		
		
			for i, inv in pairs(Players[BountyHunterPid].data.inventory) do ---add gold if he got gold
				if 	inv.refId == "gold_001" then
					Players[BountyHunterPid].data.inventory[i].count = inv.count + tonumber(WinBounty)
					tes3mp.SendMessage(BountyHunterPid,WinBounty.." Golden Drakes added.\n",false)
						HeGotGold = true
					if Players[BountyHunterPid].data.inventory[i].count < 1 then  -- if empty remove. i think this doesnt happen
						Players[BountyHunterPid].data.inventory[i] = nil
					end
					break
				end
			end
		
			if HeGotGold == false then
				table.insert(Players[BountyHunterPid].data.inventory, {refId = "gold_001", count = tonumber(WinBounty), charge = -1})
			end
			
	end
	
	
		Players[BountyHunterPid]:Save()
		Players[BountyHunterPid]:Load()
		Players[BountyHunterPid]:LoadInventory()
		Players[BountyHunterPid]:LoadEquipment()
		
	tes3mp.SendMessage(pid,"Processed BountyStuff. You no longer have a Bounty.\n",false)
	tes3mp.SendMessage(BountyHunterPid,"Processed BountyStuff. You recieved the reward for killing.\n",false)
	
end

end





return Bountys