-- Level Up Message

// This sends a Message when a Player achieves Level 10, 20 , 30 ...



//Find Players[pid]:SaveLevel() in myMod.lua and put the following under "Players[pid]:SaveStatsDynamic() " at it


		for levelCount= 0, 100, 10 do
			if tes3mp.GetLevel(pid) == levelCount then
				tes3mp.SendMessage(pid,"Player "..tes3mp.GetName(pid).." achieved Level "..color.OrangeRed..tostring(tes3mp.GetLevel(pid))..color.Default.."! \n",true)
			end
		end