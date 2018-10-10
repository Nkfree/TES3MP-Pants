##Shuffles Items when they are picked up

exchange in serverCore.lua

```
function OnPlayerInventory(pid)
	LevelParty.CompareInventory(pid)
    eventHandler.OnPlayerInventory(pid)
	LevelParty.ShuffleItems(pid)
end

```