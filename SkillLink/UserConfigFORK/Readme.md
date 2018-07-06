-- HOW TO INSTALL UserConfig

change userConfigPath variable to your full path. where the userconfigs should be stored.
before every slash you put another slash, like this "C:\\Users\\Admin\\TES3MP\\mp-stuff\\userconfig\\"

put 

userConfig = require ("UserConfig")   --on top of server.lua and myMod.lua

put

UserConfig.Init(pid)   -- in function "OnPlayerEndCharGen" in myMod.lua


thats all.

write in your UserConfig with SetValue and read values with GetValue....