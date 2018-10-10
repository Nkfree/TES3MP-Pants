//This is Stopping the Spam of PvP Safe Zone Messages.
//It just prints the message one time you enter a safe zone. and when you leave cells that are safe zones
//https://github.com/TES3MP-TeamFOSS/Scripts/tree/master/0.6.1/scripts/PvP

-- Find "function OnPlayerCellChange(pid)" inside server.lua and add:
-- Replace
 
 if PvP.IsPvP(pid) then PvP.ShowMessage(pid) end
 
--with
-- [[

   if PvP.IsPvP(pid) then
            if  Players[pid].data.customVariables.PvPlastCell ~= "yes" then
                    PvP.ShowMessage(pid) 
            end 
        Players[pid].data.customVariables.PvPlastCell = "yes"
    else
           if  Players[pid].data.customVariables.PvPlastCell == "yes" then
               tes3mp.SendMessage(pid,color.Red.."You left the PvP Safe Zone.\n"..color.Default, false)
        end 

        Players[pid].data.customVariables.PvPlastCell = "no"
    end
]]
-- directly underneath it.