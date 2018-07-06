--Colorful joined Message
The regular "Player joined the server." will be colorful.

//find function "Methods.OnPlayerConnect" in myMod.lua and replace the line with "local message"
//with the following

local message = Methods.GetChatName(pid) .. color.Green .. " JOINED THE SERVER.\n" .. color.Default 

//You can find other colors in color.lua

-- Welcome Sound
When the player joins a Dagoth Ur Welcome will be played.


//Find "Methods.OnPlayerEndCharGen" in myMod.lua and Put the following under Players[pid]:EndCharGen()

local loccom = "Player->Say, \"Vo\\Misc\\Dagoth Ur Welcome B.wav\", \"Welcome, Moon-and-Star, to this place where destiny is made.\""
	Methods.RunConsoleCommandOnPlayer(pid, loccom)
	
	
//If you like, find "Players[pid]:Message("You have successfully logged in.\n")"  and put it under it, too.
	
//You can find other Sounds in your DataFiles or in the Construction Set