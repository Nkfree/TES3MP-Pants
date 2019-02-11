local txt2esp = {}

--[[

txt2esp.lua creates a text file that can be converted to ESP with txt2esp4 tool

INSTALLATION:
-put this file into mp-stuff/scripts/

-put txt2esp = require("txt2esp") on top of serverCore.lua

-put the following into commandHandler.lua's command elseif Chain
if cmd[1]== "txt2esp" then
	txt2esp.create(pid)
	
]]


txt2esp.create = function(pid)

local cell = tes3mp.GetCell(pid)
local theTransferString = ""
for _, unique in pairs(LoadedCells[cell].data.packets.place) do
	--rotation seems to be not 100% correct. but close enough
	--txt2esp needs integers
	local rotX = math.floor(math.deg(LoadedCells[cell].data.objectData[unique].location.rotX) +0,5)
	local rotY = math.floor(math.deg(LoadedCells[cell].data.objectData[unique].location.rotY) +0,5)
	local rotZ = math.floor(math.deg(LoadedCells[cell].data.objectData[unique].location.rotZ) +0,5)
	
	if LoadedCells[cell].data.objectData[unique] ~= nil then
		theTransferString = theTransferString.. "reference \""..LoadedCells[cell].data.objectData[unique].refId.."\" 1 <"..rotX.." "..rotY.." "..rotZ.."> <"..math.floor(LoadedCells[cell].data.objectData[unique].location.posX+0,5).." "..math.floor(LoadedCells[cell].data.objectData[unique].location.posY+0,5).." "..math.floor(LoadedCells[cell].data.objectData[unique].location.posZ+0,5).."> \n"
	end
end
	--write string into text file
local f = io.open(tes3mp.GetModDir().."/txt2esp-"..cell..".txt", "w")
if f == nil then print("an error occured while opening the file") end

f:write(theTransferString)
io.close(f)
print("wrote CellData into Textfile")

tes3mp.CustomMessageBox(pid, -1, "Successful wrote the CellData into a Textfile. Next use txt2esp tool","OK")
end


return txt2esp