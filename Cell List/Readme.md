In server.lua find  
 
 elseif cmd[1] == "cells" and moderator then
            GUI.ShowCellList(pid)
			
			
and replace it with

 elseif cmd[1] == "cells" then
            GUI.ShowCellList(pid)
			
			
			
//by removing moderator you give every Player the possibility to see where others are around.