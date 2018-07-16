put this in mp-stuff/scripts/
https://github.com/Schnibbsel/TES3MP-Pants/tree/master/SkillLink/UserConfigFORK
GitHub
Schnibbsel/TES3MP-Pants
TES3MP-Pants - Dirty Short Lua Scripts
install userconfig
https://github.com/TES3MP-TeamFOSS/Scripts/blob/master/0.6.1/scripts/UserConfig/UserConfig.lua
GitHub
TES3MP-TeamFOSS/Scripts
Scripts - Ashfall – TES3MP script repository









put 
Bountys = require("Bountys")
under UserConfig = require("UserConfig")
in server.lua

        elseif cmd[1] == "bounty" then
            if cmd[2] == "set" then
                if myMod.CheckPlayerValidity(pid, cmd[3]) and tonumber(cmd[4]) ~= nil then
                    Bountys.SetBountyValue(pid,tonumber(cmd[3]),tonumber(cmd[4]))
                end
            elseif cmd[2] == "see" then
                    Bountys.SeeBounty(pid)
            else
                tes3mp.SendMessage(pid, "With Bounty you can see and set Bountys.\n Use bounty set or bounty see\n", false)
            end


put this in he command chain in server.lua
replace function ondeath

function OnPlayerDeath(pid)
    
    myMod.OnPlayerDeath(pid)
    Bountys.GotKilled(pid)
end

-----------------------------------------------------
---------------------------------------------------------
-----------------------------------------------------
ingame Use

/bounty
/bounty see
/bounty set
-----------------
For /bounty set use PID and DrakenAmount
for example i want to put 100 drakens on Nervar i open up /list look at his ID its 7 i do 

/bounty set 7 100

in chat
tell me the bug reports and feedback