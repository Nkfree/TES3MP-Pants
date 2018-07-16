--only drops Artifacts at DeathDrop

--Put on top of deathdrop.lua
--[[
Artifacts = require("Artifacts")
color = require("color")
]]--

--you need Artifacts.lua
--replace the following code sequence in deathdrop.lua


	if decision == true then -- only remove Artifacts Add In
		
		local x = tes3mp.GetPosX(pid) -- gets player position.
		local y = tes3mp.GetPosY(pid) + 1
		local z = tes3mp.GetPosZ(pid)
		
		--[[
		for index,item in pairs(player.data.equipment) do
			tes3mp.UnequipItem(pid, index) -- creates unequipItem packet
			tes3mp.SendEquipment(pid) -- sends packet to pid
		end]]--
		
		for index,item in pairs(player.data.equipment) do
			if Artifacts.IsArtifact(item.refId) then
				tes3mp.UnequipItem(pid, index) -- creates unequipItem packet
				tes3mp.SendEquipment(pid) -- sends packet to pid
				Players[pid].data.equipment[index] = nil 
			end
		end
		
		local temp = {}
		
		
		for index,item in pairs(player.data.inventory) do
			if Artifacts.IsArtifact(item.refId) then
				temp[index] = item -- save item to spawn in world
				Players[pid].data.inventory[index] = nil -- remove item from inventory
				tes3mp.SendMessage(pid,"Player "..color.Red..player.name..color.Default.." dropped Artifact "..color.Red.."["..item.refId.."]"..color.Default.."\n",true)
					Players[pid].data.customVariables.lastObtained = "null"
			end
		end
		
		--[[
		for index, item in pairs(Players[pid].data.equipment) do-- clear inventory data in the files
				Players[pid].data.equipment[index]= nil
		end
		
		for index, item in pairs(Players[pid].data.inventory) do-- clear inventory data in the files
				Players[pid].data.inventory[index]= nil
		end
		
		]]
		
		--tes3mp.ClearInventory(pid) -- clear inventory data on the server
		Players[pid]:Save()
		Players[pid]:Load()
		Players[pid]:LoadInventory()
		Players[pid]:LoadEquipment()

		local currentMpNum = WorldInstance:GetCurrentMpNum() + 1 -- Store the MpNum for the first object in the inventory
		local tempMpNum
		
		for _,p in pairs(Players) do -- Send the packet to each player online
			local playerID = p.pid
			tempMpNum = currentMpNum -- this will be the "iterator" each packet needs to send the same MpNum for each item or duplicates happen
			for index,item in pairs(temp) do -- Construct and send the packet
				local mpNum = tempMpNum + 1 -- The current MpNum is being used so increment by 1
				tes3mp.InitializeEvent(playerID) --tes3mp.InitiateEvent(playerID) -- Creates packet for "pid" to be sent
				tes3mp.SetEventCell(cellDescription) -- Let packet know what cell we are talking about
				tes3mp.SetObjectRefId(item.refId)
				tes3mp.SetObjectCount(item.count)
				tes3mp.SetObjectCharge(item.charge) -- Add object data to packet
				tes3mp.SetObjectPosition(x, y, z)
				tes3mp.SetObjectRefNumIndex(0)
				tes3mp.SetObjectMpNum(mpNum)
				tes3mp.AddWorldObject() -- Actually binds the object to packet
				tes3mp.SendObjectPlace() -- sends created packet to initiated pid in InitiateEvent(pid)
				tempMpNum = tempMpNum + 1 -- go to the next available MpNum
			end
		end
		WorldInstance:SetCurrentMpNum(tempMpNum) -- set new MpNum so other server functions dont try to overwrite our new world objects
	end
end