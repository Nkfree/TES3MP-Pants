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




-- Add [ 

MotD = require("MotD")


 ] to the top of myMod.lua

-- Find "Players[pid]:Message("You have successfully logged in.\n")" inside myMod.lua and add:
-- [ 

MotD.Show(pid)

 ]
-- directly underneath it.

-- Find "Players[pid]:Registered(data)" inside myMod.lua and add:
-- [

 MotD.Show(pid)

 ]
-- directly underneath it.