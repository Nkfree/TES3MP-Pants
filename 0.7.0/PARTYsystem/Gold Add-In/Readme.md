##Adds RandomGold to Players in the Party

add the line to OnPlayerSkill in serverCore.lua 
and whereever you want PartyPlayers to get Random Extra GOLD
```
function OnPlayerSkill(pid)
	eventHandler.OnPlayerSkill(pid)
	LevelParty.RandomGold(pid)
end
```
	
	