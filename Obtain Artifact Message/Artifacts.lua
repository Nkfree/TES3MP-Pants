--Artifacts.lua
-- This Script shouts out a Message if Player obtains a Weapon Artifact

--Put --[[   Artifacts = require("Artifacts")     ]] on top of server.lua

--Replace function OnPlayerInventory in server.lua
--[[ 

function OnPlayerInventory(pid)
    myMod.OnPlayerInventory(pid)
	Artifacts.ShowArtifact(pid)
end

]]


color  = require("color")

Artifacts = {}


Artifacts.IsArtifact = function(itemRefId)
if itemRefId == "keening" then
	return true 
elseif itemRefId == "cleaverstfelms" then
	return true
elseif itemRefId == "axe_queen_of_bats_unique" then
	return true
elseif itemRefId == "mace of molag bal_unique" then
	return true
elseif itemRefId == "daedric_scourge_unique" then
	return true
elseif itemRefId == "warhammer_crusher_unique" then
	return true
elseif itemRefId == "sunder" then
	return true
elseif itemRefId == "crosierstllothis" then
	return true
elseif itemRefId == "staff_hasedoki_unique" then
	return true
elseif itemRefId == "staff_magnus_unique" then
	return true
elseif itemRefId == "dwarven_hammer_volendrung" then
	return true
elseif itemRefId == "ebony_bow_auriel" then
	return true
elseif itemRefId == "longbow_shadows_unique" then
	return true
elseif itemRefId == "katana_bluebrand_unique" then
	return true
elseif itemRefId == "katana_goldbrand_unique" then
	return true
elseif itemRefId == "claymore_chrysamere_unique" then
	return true
elseif itemRefId == "daedric_crescent_unique" then
	return true
elseif itemRefId == "claymore_iceblade_unique" then
	return true
elseif itemRefId == "longsword_umbra_unique" then
	return true
elseif itemRefId == "dagger_fang_unique" then
	return true
elseif itemRefId == "fork_horripilation_unique" then
	return true  
elseif itemRefId == "mehrunes'_razor_unique" then
	return true
elseif itemRefId == "spear_mercy_unique" then
	return true
else
	return false
end

end

Artifacts.ShowArtifact = function(pid)
local slotcount= tes3mp.GetInventoryChangesSize(pid) - 1
local itemRefId = tes3mp.GetInventoryItemRefId(pid, slotcount)
local lastArtifact = Players[pid].data.customVariables.lastObtained
if Artifacts.IsArtifact(itemRefId) and itemRefId ~= lastArtifact then
tes3mp.SendMessage(pid,"The Player "..color.Red..Players[pid].name..color.Default .. " obtained the Artifact "..color.Red.."["..itemRefId.."]"..color.Default.."\n", true)
Players[pid].data.customVariables.lastObtained = itemRefId
end

end

return Artifacts