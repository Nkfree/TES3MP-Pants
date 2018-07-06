-- Modified Version. The Player gets two Buttons.
-- OnGuiAction is new.
-- for now it just says what button got pressed.
-- In Commentary is a example how to use the modification.
--[[ for installation put

if MotD.OnGUIAction(pid, idGui, data) then return end

//under "if myMod.OnGUIAction(pid, idGui, data) then return end" in server.lua

]]--







-- MotD.lua -*-lua-*-
-- "THE BEER-WARE LICENCE" (Revision 42):
-- <mail@michael-fitzmayer.de> wrote this file.  As long as you retain
-- this notice you can do whatever you want with this stuff. If we meet
-- some day, and you think this stuff is worth it, you can buy me a beer
-- in return.  Michael Fitzmayer


require("color")


Methods = {}


-- Add [ MotD = require("MotD") ] to the top of myMod.lua

-- Find "Players[pid]:Message("You have successfully logged in.\n")" inside myMod.lua and add:
-- [ MotD.Show(pid) ]
-- directly underneath it.

-- Find "Players[pid]:Registered(data)" inside myMod.lua and add:
-- [ MotD.Show(pid) ]
-- directly underneath it.


Methods.Show = function(pid)
    local motd = "YOUR\\PATH\\motd.txt"
    local message

    local f = io.open(motd, "r")
    if f == nil then return -1 end

    message = f:read("*a")
    f:close()

    message = color.Orange .. message
    message = message .. color.OrangeRed .. os.date("\n Current time: %A %I:%M %p") .. color.Default .. "\n"
    tes3mp.CustomMessageBox(pid, 777, message, "OK;NO")
    return 0
end

Methods.OnGUIAction  = function(pid, idGui, data)
 if idGui == 777 then
   tes3mp.SendMessage(pid,"Button "..data.." pressed\n")
 end
 
--[[

	if idGui == 777 then
			if tonumber(data) = 0 then
			   tes3mp.SendMessage(pid, "You accepted the Rules. Thank You. \n", false)
			else
				Players[pid]:Kick()
			end
	end
	


]]--
end

return Methods