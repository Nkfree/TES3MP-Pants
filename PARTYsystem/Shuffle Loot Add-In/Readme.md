##Shuffles Items when they are picked up
exchange

```
function OnPlayerInventory(pid)
	LevelParty.CompareInventory(pid)
    myMod.OnPlayerInventory(pid)
	LevelParty.ShuffleItems(pid)
end

```
####function
```
LevelParty.ShuffleItems = function(pid)

--local slotcount= tes3mp.GetInventoryChangesSize(pid) - 1 -- old check
--local itemRefId = tes3mp.GetInventoryItemRefId(pid, slotcount) --old check
local itemRefId2 = ""
local ShuffleItem = {}

if LevelParty.IsParty(pid) then
for slot, item in pairs(Players[pid].data.inventory) do
	local yes = false
	
	for slot2, item2 in pairs(CompareInv) do -- check if item was in inventory before
		if item.refId == item2.refId then
			yes = true
		end
	end
	
	if yes == false then -- we have a PICK
		--tes3mp.SendMessage(pid,"inventory changed at "..item.refId)
		itemRefId2 = item.refId
		break
	end
end
end
```