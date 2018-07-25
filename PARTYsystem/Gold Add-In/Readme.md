##Adds RandomGold to Players in the Party

add the line to OnPlayerSkill and whereever you want PartyPlayers to get Random Extra GOLD
```
function OnPlayerSkill(pid)
	myMod.OnPlayerSkill(pid)
	LevelParty.RandomGold(pid)
	```
	
	
	
	the function 
	```
	LevelParty.RandomGold = function(pid) -- think about saving, reloading inventory and equipment
if LevelParty.IsParty(pid) then -- add party needs two
 local PartyId = LevelParty.WhichParty(pid)
 
	for i, p in pairs(Partytable[PartyId].player) do
	local randGold = math.random(50) + math.random(20)
		myMod.RunConsoleCommandOnPlayer(p.pd, "player->additem \"gold_001\" "..tostring(randGold))
		tes3mp.SendMessage(p.pd,tostring(randGold).." GOLD added.\n", false)
	end
end
end
```