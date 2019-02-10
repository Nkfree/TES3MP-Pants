-- kanaFurniture - Release 2.1 - For tes3mp v0.6.1
-- REQUIRES: decorateHelp (https://github.com/Atkana/tes3mp-scripts/blob/master/decorateHelp.lua)
-- Purchase and place an assortment of furniture

-- NOTE FOR SCRIPTS: pname requires the name to be in all LOWERCASE



-- this is a modded version by discordpeter for WorldBuilding
-- bugs
-- meshes are now missing collision
-- could need a variety of doors, lights, armor or weapons...
-- sometimes a cell doesnt exchange records so rocks trees arent always activatable
-- pickable indoors - does IsInExterior even work?
-- spawn higher with new dungeon
-- noPickUp Script for every miscellaneous item
-- change preObjects part to only send to players entering the cell
-- make tools necessary for mining
-- better just combine with RickOffs WorldMining
-- make keyed tables instead of table.insert when good
-- let players assign new destinations to doors
-- assign better craftrock items as used in worldmining
-- use world.json instead for doors and interiors data
-- or maybe own json for all 3 so people can still reset world.json
-- include automatic generation of miscellaneous records for usability with every plugin?
-- use string.match like GraphicHerbalismn when necessary
-- use kanaFurn functions when possible
-- include scale feature
-- make attach put them furn into their inventory?
-- make installation easier with less modification of files
-- clean up script
-- change price showing up and change "gold" to "material"
-- find way to export preObjects data and convert with txt2esp
-- maybe as a command with generating the necessary txt file and removing the entrys
-- remove print messages
-- check for activation of normal doors
--


--[[ INSTALLATION:
1) Save this file as "kanaFurnitureMod.lua" in mp-stuff/scripts
2) Add [ kanaFurnitureMod = require("kanaFurnitureMod") ] to the top of serverCore.lua
3) Add the following to the elseif chain for commands in "OnPlayerSendMessage" inside commandHandler.lua
[	

--those commands
	elseif cmd[1] == "furn" then
		kanaFurnitureMod.OnCommand(pid)
	elseif cmd[1] == "build" or cmd[1] == "make" then
		kanaFurnitureMod.OnBuild(pid)	
	elseif cmd[1] == "material" then
		kanaFurniture.OnCraftCommand(pid)
		
4) copy the provided jsons all over the place
4) add to eventHandlers OnActivate under if doesObjectHaveActivatingPlayer then

					activatingPid = tes3mp.GetObjectActivatingPid(index)
                    debugMessage = debugMessage .. logicHandler.GetChatName(activatingPid)
					
						--eventHandler OnActivate exchange for this door with uniqueIndex
						-- if its door and uniqueIndex is in placed list in WorldInstance
					if objectRefId and objectRefId == "ex_nord_door_01" then
						local cell = tes3mp.GetCell(pid)
						if WorldInstance.data.customVariables.kanaFurnitureMod.placed[cellDescription] ~= nil then
							if WorldInstance.data.customVariables.kanaFurnitureMod.placed[cellDescription][objectUniqueIndex] then
								kanaFurnitureMod.OnDoor(pid, objectUniqueIndex)
								isValid = false
							else
								print("door was not in worldinstance")
							end
						end
					end
						
					if objectRefId and tes3mp.IsInExterior(pid) then
						if tableHelper.containsValue(craftTable, objectRefId, true) then
							kanaFurnitureMod.OnHitActivate(pid, objectUniqueIndex, objectRefId, tes3mp.GetObjectRefNum(index), tes3mp.GetObjectMpNum(index))
							isValid = false
						end
					end
					
4) change to contentFixers.addpreexistingObjects

function contentFixer.AddPreexistingObjects(cellDescription)
	
	if WorldInstance.data.customVariables ~= nil and WorldInstance.data.customVariables.kanaFurnitureMod ~= nil and WorldInstance.data.customVariables.kanaFurnitureMod.placed ~= nil then
		local placed = WorldInstance.data.customVariables.kanaFurnitureMod.placed
		if placed[cellDescription] ~= nil then
			local unique = {}
			
			for refIndex, object in pairs(placed[cellDescription]) do
				--place kanaFurniture
				unique[refIndex] = logicHandler.CreateObjectAtLocation(cellDescription, object.loc, object.refId, "place")
			end
			
			for refIndex, uniqueId in pairs(unique) do
				-- swap positions in table after we created them
				WorldInstance.data.customVariables.kanaFurnitureMod.placed[cellDescription][uniqueId] = WorldInstance.data.customVariables.kanaFurnitureMod.placed[cellDescription][refIndex]
				WorldInstance.data.customVariables.kanaFurnitureMod.placed[cellDescription][refIndex] = nil
			end
			
        LoadedCells[cellDescription].forceActorListRequest = true
		end
	end
	
end

4) add to logicHandler.LoadCell under LoadedCells[cellDescription]:CreateEntry()

			contentFixer.AddPreexistingObjects(cellDescription)
			
4) copy miscellaneous recordStore	
4) for crafting add to top of eventHandler

local craftTable = {}
local furnLoader = jsonInterface.load("rocks.json")
for index, item in pairs(furnLoader) do
	table.insert(craftTable, {refId = item.ID, tip = "rocks"})
end
local furnLoader = jsonInterface.load("flora.json")
for index, item in pairs(furnLoader) do
	table.insert(craftTable, {refId = item.ID, tip = "flora"})
end

4) Add the following to OnGUIAction in serverCore.lua
	[ if kanaFurnitureMod.OnGUIAction(pid, idGui, data) then return end ]
5) Add the following to the end of  OnServerPostInit in serverCore.lua
	[ kanaFurnitureMod.OnServerPostInit() ]
]]

local config = {}
config.whitelist = false --If true, the player must be given permission to place items in the cell that they're in (set using this script's methods, or editing the world.json). Note that this only prevents placement, players can still move/remove items they've placed in the cell.
config.sellbackModifier = 1 -- The base cost that an item is multiplied by when selling the items back (0.75 is 75%)

--GUI Ids used for the script's GUIs. Shouldn't have to be edited.
config.MainGUI = 31363
config.BuyGUI = 31364
config.InventoryGUI = 31365
config.ViewGUI = 31366
config.InventoryOptionsGUI = 31367
config.ViewOptionsGUI = 31368

------------
--Indexed table of all available furniture. refIds should be in all lowercase
--Best resource I could find online was this: http://tamriel-rebuilt.org/content/resource-guide-models-morrowind (note, items that begin with TR are part of Tamriel Rebuilt, not basic Morrowind, and it certainly doesn't list all the furniture items)

jsonInterface = require("jsonInterface")
local craftTable = {}
local furnitureData = {}
local furnLoader = jsonInterface.load("npc.json")
for index, item in pairs(furnLoader) do
	table.insert(furnitureData, {name = item.Name, refId = item.ID, tip = "npc", need = "spawn"})
end
print("loaded npc data")
local furnLoader = jsonInterface.load("creature.json")
for index, item in pairs(furnLoader) do
	table.insert(furnitureData, {name = item.FIELD3, refId = item.FIELD2, tip = "creature", need = "spawn"} )
end
print("loaded creature data")
local furnLoader = jsonInterface.load("cave.json")
for index, item in pairs(furnLoader) do
	table.insert(furnitureData, {name = item.ID, refId = item.ID, tip = "dungeon", need = "place"} )
end
print("loaded dungeon data")
local furnLoader = jsonInterface.load("rocks.json")
for index, item in pairs(furnLoader) do
	table.insert(furnitureData, {name = item.ID, refId = item.ID, tip = "rocks", need = "place"} )
	table.insert(craftTable, {refId = item.ID, tip = "rocks"})
end
print("loaded rocks data")
local furnLoader = jsonInterface.load("furn.json")
for index, item in pairs(furnLoader) do
	table.insert(furnitureData, {name = item.ID, refId = item.ID, tip = "normal", need = "place"} )
end
print("loaded furniture data")
local furnLoader = jsonInterface.load("flora.json")
for index, item in pairs(furnLoader) do
	table.insert(furnitureData, {name = item.ID, refId = item.ID, tip = "flora", need = "place"} )
	table.insert(craftTable, {refId = item.ID, tip = "flora"})
end
print("loaded flora data")
local furnLoader = jsonInterface.load("exterior.json")
for index, item in pairs(furnLoader) do
	table.insert(furnitureData, {name = item.ID, refId = item.ID, tip = "exterior", need = "place"} )
end
print("loaded exterior data")
local furnLoader = jsonInterface.load("static.json")
for index, item in pairs(furnLoader) do
	table.insert(furnitureData, {name = item.ID, refId = item.ID, tip = "static", need = "place"} )
end
print("loaded static data")
	
	
	
	
--[[
local furnitureData = {
--Containers (Lowest quality container = 1 price per weight)
{tip = "normal", need = "place", name = "Barrel 1", refId = "barrel_01", price = 50},
{tip = "normal", need = "place", name = "Barrel 2", refId = "barrel_02", price = 50},
{tip = "normal", need = "place", name = "Crate 1", refId = "crate_01_empty", price = 200},
{tip = "normal", need = "place", name = "Crate 2", refId = "crate_02_empty", price = 200},
{tip = "normal", need = "place", name = "Basket", refId = "com_basket_01", price = 50},
{tip = "normal", need = "place", name = "Sack (Flat)", refId = "com_sack_01", price = 50},
{tip = "normal", need = "place", name = "Sack (Bag)", refId = "com_sack_02", price = 50},
{tip = "normal", need = "place", name = "Sack (Crumpled)", refId = "com_sack_03", price = 50},
{tip = "normal", need = "place", name = "Sack (Light)", refId = "com_sack_00", price = 50},
{tip = "normal", need = "place", name = "Urn 1", refId = "urn_01", price = 100},
{tip = "normal", need = "place", name = "Urn 2", refId = "urn_02", price = 100},
{tip = "normal", need = "place", name = "Urn 3", refId = "urn_03", price = 100},
{tip = "normal", need = "place", name = "Urn 4", refId = "urn_04", price = 100},
{tip = "normal", need = "place", name = "Urn 5", refId = "urn_05", price = 100},
{tip = "normal", need = "place", name = "Steel Keg", refId = "dwrv_barrel00_empty", price = 150},
{tip = "normal", need = "place", name = "Steel Quarter Keg", refId = "dwrv_barrel10_empty", price = 75},
--Chesty Containers
{tip = "normal", need = "place", name = "Cheap Chest", refId = "com_chest_11_empty", price = 150},
{tip = "normal", need = "place", name = "Cheap Chest (Open)", refId = "com_chest_11_open", price = 150},
{tip = "normal", need = "place", name = "Small Chest (Metal)", refId = "chest_small_01", price = 50}, --*2 price because fancier material
{tip = "normal", need = "place", name = "Small Chest (Wood)", refId = "chest_small_02", price = 25},

--Imperial Furniture Set
{tip = "normal", need = "place", name = "Imperial Closet", refId = "com_closet_01", price = 300},
{tip = "normal", need = "place", name = "Imperial Cupboard", refId = "com_cupboard_01", price = 100},
{tip = "normal", need = "place", name = "Imperial Drawers", refId = "com_drawers_01", price = 300},
{tip = "normal", need = "place", name = "Imperial Hutch", refId = "com_hutch_01", price = 75},
{tip = "normal", need = "place", name = "Imperial Chest (Cheap)", refId = "com_chest_01", price = 150},
{tip = "normal", need = "place", name = "Imperial Chest (Fine)", refId = "com_chest_02", price = 400}, --*2 price because fancier

--Dunmer Furniture Set
{tip = "normal", need = "place", name = "Dunmer Closet (Cheap)", refId = "de_p_closet_02", price = 300},
{tip = "normal", need = "place", name = "Dunmer Closet (Fine)", refId = "de_r_closet_01", price = 600}, --*2 for quality
{tip = "normal", need = "place", name = "Dunmer Desk", refId = "de_p_desk_01", price = 75},
{tip = "normal", need = "place", name = "Dunmer Drawers (Cheap)", refId = "de_drawers_02", price = 300},
{tip = "normal", need = "place", name = "Dunmer Drawers (Fine)", refId = "de_r_drawers_01", price = 600},
{tip = "normal", need = "place", name = "Dunmer Drawer Table (Large)", refId = "de_p_table_02", price = 25},
{tip = "normal", need = "place", name = "Dunmer Drawer Table (Small)", refId = "de_p_table_01", price = 25},
{tip = "normal", need = "place", name = "Dunmer Chest (Cheap)", refId = "de_r_chest_01", price = 200},
{tip = "normal", need = "place", name = "Dunmer Chest (Fine)", refId = "de_p_chest_02", price = 400}, --*2 because fancy

--General Furniture
{tip = "normal", need = "place", name = "Stool (Crude)", refId = "furn_de_ex_stool_02", price = 50},
{tip = "normal", need = "place", name = "Stool (Prayer)", refId = "furn_velothi_prayer_stool_01", price = 50},
{tip = "normal", need = "place", name = "Stool (Bar Stool)", refId = "furn_com_rm_barstool", price = 100},
{tip = "normal", need = "place", name = "Chair (Camp)", refId = "furn_com_pm_chair_02", price = 50},
{tip = "normal", need = "place", name = "Chair (General 1)", refId = "furn_com_rm_chair_03", price = 100},
{tip = "normal", need = "place", name = "Chair (General 2)", refId = "furn_de_p_chair_01", price = 100},
{tip = "normal", need = "place", name = "Chair (General 3)", refId = "furn_de_p_chair_02", price = 100},
{tip = "normal", need = "place", name = "Chair (Fine)", refId = "furn_de_r_chair_03", price = 200},
{tip = "normal", need = "place", name = "Chair (Padded)", refId = "furn_com_r_chair_01", price = 200},
{tip = "normal", need = "place", name = "Chair (Chieftain)", refId = "furn_chieftains_chair", price = 200},
{tip = "normal", need = "place", name = "Bench, Long (Cheap)", refId = "furn_de_p_bench_03", price = 200},
{tip = "normal", need = "place", name = "Bench, Short (Cheap)", refId = "furn_de_p_bench_04", price = 200},
{tip = "normal", need = "place", name = "Bench, Long (Fine)", refId = "furn_de_r_bench_01", price = 400},
{tip = "normal", need = "place", name = "Bench, Short (Fine)", refId = "furn_de_r_bench_02", price = 400},
{tip = "normal", need = "place", name = "Bench (Crude)", refId = "furn_de_p_bench_03", price = 150},
{tip = "normal", need = "place", name = "Common Bench 1", refId = "furn_com_p_bench_01", price = 200},
{tip = "normal", need = "place", name = "Common Bench 2", refId = "furn_com_rm_bench_02", price = 200},

{tip = "normal", need = "place", name = "Table, Big Oval (Fine)", refId = "furn_de_r_table_03", price = 800},
{tip = "normal", need = "place", name = "Table, Big Rectangle (Cheap)", refId = "furn_de_p_table_04", price = 400},
{tip = "normal", need = "place", name = "Table, Big Rectangle (Fine)", refId = "furn_de_r_table_07", price = 800},
{tip = "normal", need = "place", name = "Table, Low Round (Cheap) 1", refId = "furn_de_p_table_01", price = 400},
{tip = "normal", need = "place", name = "Table, Low Round (Cheap) 2", refId = "furn_de_p_table_06", price = 400},
{tip = "normal", need = "place", name = "Table, Low Round (Fine)", refId = "furn_de_r_table_08", price = 800},
{tip = "normal", need = "place", name = "Table, Small Square (Cheap)", refId = "furn_de_p_table_05", price = 400},
{tip = "normal", need = "place", name = "Table, Small Square (Fine)", refId = "furn_de_r_table_09", price = 800},
{tip = "normal", need = "place", name = "Table, Small Round (Cheap)", refId = "furn_de_p_table_02", price = 400},
{tip = "normal", need = "place", name = "Table, Square (Crude)", refId = "furn_de_ex_table_02", price = 200},
{tip = "normal", need = "place", name = "Table, Rectangle (Crude)", refId = "furn_de_ex_table_03", price = 200},

{tip = "normal", need = "place", name = "Table, Colony", refId = "furn_com_table_colony", price = 400},
{tip = "normal", need = "place", name = "Table, Rectangle 1", refId = "furn_com_rm_table_04", price = 400},
{tip = "normal", need = "place", name = "Table, Rectangle 2", refId = "furn_com_r_table_01", price = 800},
{tip = "normal", need = "place", name = "Table, Small Rectangle", refId = "furn_com_rm_table_05", price = 400},
{tip = "normal", need = "place", name = "Table, Round", refId = "furn_com_rm_table_03", price = 400},
{tip = "normal", need = "place", name = "Table, Oval", refId = "furn_de_table10", price = 800},

{tip = "normal", need = "place", name = "Bar Counter, Middle", refId = "furn_com_rm_bar_01", price = 200},
{tip = "normal", need = "place", name = "Bar Counter, End Cap 1", refId = "furn_com_rm_bar_04", price = 200},
{tip = "normal", need = "place", name = "Bar Counter, End Cap 2", refId = "furn_com_rm_bar_02", price = 200},
{tip = "normal", need = "place", name = "Bar Counter, Corner", refId = "furn_com_rm_bar_03", price = 200},

{tip = "normal", need = "place", name = "Bar Counter, Middle (Dunmer)", refId = "furn_de_bar_01", price = 200},
{tip = "normal", need = "place", name = "Bar Counter, End Cap 1 (Dunmer)", refId = "furn_de_bar_04", price = 200},
{tip = "normal", need = "place", name = "Bar Counter, End Cap 2 (Dunmer)", refId = "furn_de_bar_02", price = 200},
{tip = "normal", need = "place", name = "Bar Counter, Corner (Dunmer)", refId = "furn_de_bar_03", price = 200},

{tip = "normal", need = "place", name = "Bookshelf, Backed (Cheap)", refId = "furn_com_rm_bookshelf_02", price = 500},
{tip = "normal", need = "place", name = "Bookshelf, Backed (Fine)", refId = "furn_com_r_bookshelf_01", price = 1000},
{tip = "normal", need = "place", name = "Bookshelf, Standing (Cheap)", refId = "furn_de_p_bookshelf_01", price = 350},
{tip = "normal", need = "place", name = "Bookshelf, Standing (Fine)", refId = "furn_de_r_bookshelf_02", price = 700},

--Beds
{tip = "normal", need = "place", name = "Bedroll", refId = "active_de_bedroll", price = 100},
{tip = "normal", need = "place", name = "Standing Hammock", refId = "active_de_r_bed_02", price = 150},
{tip = "normal", need = "place", name = "Bunk Bed 1", refId = "active_com_bunk_01", price = 800},
{tip = "normal", need = "place", name = "Bunk Bed 2", refId = "active_com_bunk_02", price = 800},
{tip = "normal", need = "place", name = "Bunk Bed 3", refId = "active_de_p_bed_03", price = 800},
{tip = "normal", need = "place", name = "Bunk Bed 4", refId = "active_de_p_bed_09", price = 800},
{tip = "normal", need = "place", name = "Bed, Single 1 (Imperial, Dark, Red Patterned)", refId = "active_com_bed_02", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 2 (Imperial, Light, Pale Red)", refId = "active_com_bed_03", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 3 (Imperial, Dark, Pale Green)", refId = "active_com_bed_04", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 4 (Imperial, Light, Grey)", refId = "active_com_bed_05", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 5 (Dunmer, Grey-Brown)", refId = "active_de_p_bed_04", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 6 (Dunmer, Pale Red)", refId = "active_de_p_bed_10", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 7 (Dunmer, Blue Patterned)", refId = "active_de_p_bed_11", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 8 (Dunmer, Blue Patterned)", refId = "active_de_p_bed_12", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 9 (Dunmer, Red Patterned)", refId = "active_de_p_bed_13", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 10 (Dunmer, Grey)", refId = "active_de_p_bed_14", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 11 (Headboard, Blue Patterned)", refId = "active_de_pr_bed_07", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 12 (Headboard, Blue Patterned)", refId = "active_de_pr_bed_21", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 13 (Headboard, Red Patterned)", refId = "active_de_pr_bed_22", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 14 (Headboard, Red Patterned)", refId = "active_de_pr_bed_23", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 15 (Headboard, Grey-Brown)", refId = "active_de_pr_bed_24", price = 400},
{tip = "normal", need = "place", name = "Bed, Single 16 (Headboard, Pale Green)", refId = "active_de_pr_bed_24", price = 400},

{tip = "normal", need = "place", name = "Bed, Single Cot 1 (Dunmer, Blue Patterned)", refId = "active_de_r_bed_01", price = 400},
{tip = "normal", need = "place", name = "Bed, Single Cot 2 (Dunmer, Blue Patterned)", refId = "active_de_r_bed_17", price = 400},
{tip = "normal", need = "place", name = "Bed, Single Cot 3 (Dunmer, Red Patterned)", refId = "active_de_r_bed_18", price = 400},
{tip = "normal", need = "place", name = "Bed, Single Cot 4 (Dunmer, Red Patterned)", refId = "active_de_r_bed_19", price = 400},

{tip = "normal", need = "place", name = "Bed, Double 1 (Dunmer, Pale Green)", refId = "active_de_p_bed_05", price = 800},
{tip = "normal", need = "place", name = "Bed, Double 2 (Dunmer, Red Patterned)", refId = "active_de_p_bed_15", price = 800},
{tip = "normal", need = "place", name = "Bed, Double 3 (Dunmer, Red Patterned)", refId = "active_de_p_bed_16", price = 800},
{tip = "normal", need = "place", name = "Bed, Double 4 (Headboard, Pale Green)", refId = "active_de_pr_bed_27", price = 800},
{tip = "normal", need = "place", name = "Bed, Double 5 (Headboard, Red Patterned)", refId = "active_de_pr_bed_26", price = 800},
{tip = "normal", need = "place", name = "Bed, Double 6 (Headboard, Red Patterned)", refId = "active_de_pr_bed_08", price = 800},
{tip = "normal", need = "place", name = "Bed, Double 7 (Cot, Red Patterned)", refId = "active_de_r_bed_20", price = 800},
{tip = "normal", need = "place", name = "Bed, Double 8 (Cot, Red Patterned)", refId = "active_de_r_bed_06", price = 800},
{tip = "normal", need = "place", name = "Bed, Double 9 (Imperial, Four Poster, Blue)", refId = "active_com_bed_06", price = 800},

--Rugs
{tip = "normal", need = "place", name = "Dunmer Rug 1", refId = "furn_de_rug_01", price = 200},
{tip = "normal", need = "place", name = "Dunmer Rug 2", refId = "furn_de_rug_02", price = 200},
{tip = "normal", need = "place", name = "Wolf Rug", refId = "furn_colony_wolfrug01", price = 50},
{tip = "normal", need = "place", name = "Bearskin Rug", refId = "furn_rug_bearskin", price = 100},
{tip = "normal", need = "place", name = "Rug, Big Round 1 (Red)", refId = "furn_de_rug_big_01", price = 200},
{tip = "normal", need = "place", name = "Rug, Big Round 2 (Red)", refId = "furn_de_rug_big_02", price = 200},
{tip = "normal", need = "place", name = "Rug, Big Round 3 (Green)", refId = "furn_de_rug_big_03", price = 200},
{tip = "normal", need = "place", name = "Rug, Big Round 4 (Blue)", refId = "furn_de_rug_big_08", price = 200},
{tip = "normal", need = "place", name = "Rug, Big Rectangle 1 (Red)", refId = "furn_de_rug_big_04", price = 200},
{tip = "normal", need = "place", name = "Rug, Big Rectangle 2 (Red)", refId = "furn_de_rug_big_05", price = 200},
{tip = "normal", need = "place", name = "Rug, Big Rectangle 3 (Green)", refId = "furn_de_rug_big_06", price = 200},
{tip = "normal", need = "place", name = "Rug, Big Rectangle 4 (Green)", refId = "furn_de_rug_big_07", price = 200},
{tip = "normal", need = "place", name = "Rug, Big Rectangle 5 (Blue)", refId = "furn_de_rug_big_09", price = 200},

--Fireplaces
{tip = "normal", need = "place", name = "Firepit", refId = "furn_de_firepit", price = 100},
{tip = "normal", need = "place", name = "Firepit 2", refId = "furn_de_firepit_01", price = 100},
{tip = "normal", need = "place", name = "Fireplace (Simple Oven)", refId = "furn_t_fireplace_01", price = 500},
{tip = "normal", need = "place", name = "Fireplace (Forge)", refId = "furn_de_forge_01", price = 500},
{tip = "normal", need = "place", name = "Fireplace (Nord)", refId = "in_nord_fireplace_01", price = 1500},
{tip = "normal", need = "place", name = "Fireplace", refId = "furn_fireplace10", price = 2000},
{tip = "normal", need = "place", name = "Fireplace (Grand Imperial)", refId = "in_imp_fireplace_grand", price = 5000},

--Lighting
{tip = "normal", need = "place", name = "Yellow Paper Lantern", refId = "light_de_lantern_03", price = 25},
{tip = "normal", need = "place", name = "Blue Paper Lantern", refId = "light_de_lantern_08", price = 25},
{tip = "normal", need = "place", name = "Yellow Candles", refId = "light_com_candle_07", price = 25},
{tip = "normal", need = "place", name = "Blue Candles", refId = "light_com_candle_11", price = 25},
{tip = "normal", need = "place", name = "Blue Candles", refId = "light_com_candle_11", price = 25},
{tip = "normal", need = "place", name = "Wall Sconce (Three Candles)", refId = "light_com_sconce_02_128", price = 25},
{tip = "normal", need = "place", name = "Wall Sconce (Single Candle)", refId = "light_com_sconce_01", price = 25},
{tip = "normal", need = "place", name = "Standing Candleholder (Three Candles)", refId = "light_com_lamp_02_128", price = 50},
{tip = "normal", need = "place", name = "Chandelier, Simple (Four Candles)", refId = "light_com_chandelier_03", price = 50},

--Special Containers
{tip = "normal", need = "place", name = "Skeleton 1", refId = "contain_corpse00", price = 122}, --120 for weight + 2 for the bonemeal :P
{tip = "normal", need = "place", name = "Skeleton 2", refId = "contain_corpse10", price = 122},
{tip = "normal", need = "place", name = "Skeleton 3", refId = "contain_corpse20", price = 122},

--Misc
{tip = "normal", need = "place", name = "Anvil", refId = "furn_anvil00", price = 200},
{tip = "normal", need = "place", name = "Keg On Stand", refId = "furn_com_kegstand", price = 200},
{tip = "normal", need = "place", name = "Cauldron, Standing", refId = "furn_com_cauldron_01", price = 100},
{tip = "normal", need = "place", name = "Ashpit", refId = "in_velothi_ashpit_01", price = 100},
{tip = "normal", need = "place", name = "Shack Awning", refId = "ex_de_shack_awning_03", price = 100},
{tip = "normal", need = "place", name = "Mounted Bear Head (Brown)", refId = "bm_bearhead_brown", price = 200},
{tip = "normal", need = "place", name = "Mounted Wolf Head (White)", refId = "bm_wolfhead_white", price = 200},
{tip = "normal", need = "place", name = "Paper Wallscreen", refId = "furn_de_r_wallscreen_02", price = 100},

{tip = "normal", need = "place", name = "Banner (Imperial, Tapestry 2 - Tree)", refId = "furn_com_tapestry_02", price = 100},
{tip = "normal", need = "place", name = "Banner (Imperial, Tapestry 3)", refId = "furn_com_tapestry_03", price = 100},
{tip = "normal", need = "place", name = "Banner (Imperial, Tapestry 4 - Empire)", refId = "furn_com_tapestry_04", price = 100},
{tip = "normal", need = "place", name = "Banner (Imperial, Tapestry 5)", refId = "furn_com_tapestry_05", price = 100},

{tip = "normal", need = "place", name = "Banner (Dunmer, Tapestry 2)", refId = "furn_de_tapestry_02", price = 100},
{tip = "normal", need = "place", name = "Banner (Dunmer, Tapestry 5)", refId = "furn_de_tapestry_05", price = 100},
{tip = "normal", need = "place", name = "Banner (Dunmer, Tapestry 6)", refId = "furn_de_tapestry_06", price = 100},
{tip = "normal", need = "place", name = "Banner (Dunmer, Tapestry 7)", refId = "furn_de_tapestry_07", price = 100},

{tip = "normal", need = "place", name = "Banner (Temple 1)", refId = "furn_banner_temple_01_indoors", price = 100},
{tip = "normal", need = "place", name = "Banner (Temple 2)", refId = "furn_banner_temple_02_indoors", price = 100},
{tip = "normal", need = "place", name = "Banner (Temple 3)", refId = "furn_banner_temple_03_indoors", price = 100},

{tip = "normal", need = "place", name = "Banner (Akatosh)", refId = "furn_c_t_akatosh_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Arkay)", refId = "furn_c_t_arkay_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Dibella)", refId = "furn_c_t_dibella_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Juilianos)", refId = "furn_c_t_julianos_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Kynareth)", refId = "furn_c_t_kynareth_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Mara)", refId = "furn_c_t_mara_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Stendarr)", refId = "furn_c_t_stendarr_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Zenithar)", refId = "furn_c_t_zenithar_01", price = 100},

{tip = "normal", need = "place", name = "Banner (Apprentice)", refId = "furn_c_t_apprentice_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Golem)", refId = "furn_c_t_golem_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Lady)", refId = "furn_c_t_lady_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Lord)", refId = "furn_c_t_lord_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Lover)", refId = "furn_c_t_lover_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Ritual)", refId = "furn_c_t_ritual_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Shadow)", refId = "furn_c_t_shadow_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Steed)", refId = "furn_c_t_steed_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Thief)", refId = "furn_c_t_thief_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Tower)", refId = "furn_c_t_tower_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Warrior)", refId = "furn_c_t_warrior_01", price = 100},
{tip = "normal", need = "place", name = "Banner (Wizard)", refId = "furn_c_t_wizard_01", price = 100},

--
--Dwarven Furniture Set
{tip = "normal", need = "place", name = "Heavy Dwemer Chest", refId = "dwrv_chest00", price = 200}, --NOTE: Contains 2 random dwarven items
{tip = "normal", need = "place", name = "Heavy Dwemer Chest", refId = "dwrv_chest00", price = 200},
{tip = "normal", need = "place", name = "Dwemer Cabinet", refId = "dwrv_cabinet10", price = 200},
{tip = "normal", need = "place", name = "Dwemer Desk", refId = "dwrv_desk00", price = 50},
{tip = "normal", need = "place", name = "Dwemer Drawers", refId = "dwrv_desk00", price = 300}, --NOTE: Contains paper + one dwarven coin
{tip = "normal", need = "place", name = "Dwemer Drawer Table", refId = "dwrv_table00", price = 50}, --NOTE: Contains dwarven coin
{tip = "normal", need = "place", name = "Dwemer Chair", refId = "furn_dwrv_chair00", price = 000},
{tip = "normal", need = "place", name = "Dwemer Shelf", refId = "furn_dwrv_bookshelf00", price = 000},
--in_dwe_slate00 to in_dwe_slate11
--furn_com_p_table_01
--furn_com_planter

}
-- {tip = "normal", need = "place", name = "name", refId = "ref_id", price = 50},
]]
------------
decorateHelp = require("decorateHelp")
tableHelper = require("tableHelper")
logicHandler = require("logicHandler")

local Methods = {}
--Forward declarations:
local showMainGUI, showBuyGUI, showInventoryGUI, showViewGUI, showInventoryOptionsGUI, showViewOptionsGUI
------------
local playerBuyOptions = {} --Used to store the lists of items each player is offered so we know what they're trying to buy
local playerInventoryOptions = {} --
local playerInventoryChoice = {}
local playerViewOptions = {} -- [pname = [index = [refIndex = x, refId = y] ]
local playerViewChoice = {}

-- ===========
--  DATA ACCESS
-- ===========

local function getFurnitureInventoryTable()
	return WorldInstance.data.customVariables.kanaFurnitureMod.inventories
end

local function getPermissionsTable()
	return WorldInstance.data.customVariables.kanaFurnitureMod.permissions
end

local function getPlacedTable()
	return WorldInstance.data.customVariables.kanaFurnitureMod.placed
end

local function addPlaced(refIndex, cell, pname, refId, save, pPos, packetType)
	local placed = getPlacedTable()
	
	if not placed[cell] then
		placed[cell] = {}
	end
	
	placed[cell][refIndex] = {owner = pname, refId = refId, loc = pPos, need = packetType}
	
	if save then
		WorldInstance:Save()
	end
end

local function removePlaced(refIndex, cell, save)
	local placed = getPlacedTable()
	
	placed[cell][refIndex] = nil
	
	if save then
		WorldInstance:Save()
	end
end

local function getPlaced(cell)
	local placed = getPlacedTable()
	
	if placed[cell] then
		return placed[cell]
	else
		return false
	end
end

local function addFurnitureItem(pname, refId, count, save)
	local fInventories = getFurnitureInventoryTable()
	
	if fInventories[pname] == nil then
		fInventories[pname] = {}
	end
	
	fInventories[pname][refId] = (fInventories[pname][refId] or 0) + (count or 1)
	
	--Remove the entry if the count is 0 or less (so we can use this function to remove items, too!)
	if fInventories[pname][refId] <= 0 then
		fInventories[pname][refId] = nil
	end
	
	if save then
		WorldInstance:Save()
	end
end

Methods.OnServerPostInit = function()
	--Create the script's required data if it doesn't exits
	if WorldInstance.data.customVariables.kanaFurnitureMod == nil then
		WorldInstance.data.customVariables.kanaFurnitureMod = {}
		WorldInstance.data.customVariables.kanaFurnitureMod.placed = {}
		WorldInstance.data.customVariables.kanaFurnitureMod.permissions = {}
		WorldInstance.data.customVariables.kanaFurnitureMod.inventories = {}
		WorldInstance:Save()
	end
	
	--Slight Hack for updating pnames to their new values. In release 1, the script stored player names as their login names, in release 2 it stores them as their all lowercase names.
	local placed = getPlacedTable()
	for cell, v in pairs(placed) do
		for refIndex, v in pairs(placed[cell]) do
			placed[cell][refIndex].owner = string.lower(placed[cell][refIndex].owner)
		end
	end
	local permissions = getPermissionsTable()
		
	for cell, v in pairs(permissions) do
		local newNames = {}
		
		for pname, v in pairs(permissions[cell]) do
			table.insert(newNames, string.lower(pname))
		end
		
		permissions[cell] = {}
		for k, newName in pairs(newNames) do
			permissions[cell][newName] = true
		end
	end
	
	local inventories = getFurnitureInventoryTable()
	local newInventories = {}
	for pname, invData in pairs(inventories) do
		newInventories[string.lower(pname)] = invData
	end
	
	WorldInstance.data.customVariables.kanaFurnitureMod.inventories = newInventories
	
	WorldInstance:Save()
end

-------------------------

local function getSellValue(baseValue)
	return math.max(0, math.floor(baseValue * config.sellbackModifier))
end

local function getName(pid)
	--return Players[pid].data.login.name
	--Release 2 change: Now uses all lowercase name for storage
	return string.lower(Players[pid].accountName)
end

local function getObject(refIndex, cell)
	if refIndex == nil then
		return false
	end
	
	if not LoadedCells[cell] then
		--TODO: Should ideally be temporary
		logicHandler.LoadCell(cell)
	end

	if LoadedCells[cell]:ContainsObject(refIndex)  then 
		return LoadedCells[cell].data.objectData[refIndex]
	else
		return false
	end	
end

--Returns the amount of gold in a player's inventory
local function getPlayerGold(pid)
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "material", -1)
	
	if goldLoc then
		return Players[pid].data.inventory[goldLoc].count
	else
		return 0
	end
end

local function addGold(pid, amount)
	--TODO: Add functionality to add gold to offline player's inventories, too
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "material", -1)
	
	if goldLoc then
		Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + amount
	else
		table.insert(Players[pid].data.inventory, {refId = "material", count = amount, charge = -1})
	end
	
	Players[pid]:Save()
	Players[pid]:LoadInventory()
	Players[pid]:LoadEquipment()
end

local function getFurnitureData(refId)
	local location = tableHelper.getIndexByNestedKeyValue(furnitureData, "refId", refId)
	if location then
		return furnitureData[location], location
	else
		return false
	end
end

local function hasPlacePermission(pname, cell)
	local perms = getPermissionsTable()
	
	if not config.whitelist then
		return true
	end
	
	if perms[cell] then
		if perms[cell]["all"] or perms[cell][pname] then
			return true
		else
			return false
		end
	else
		--There's not even any data for that cell
		return false
	end
end

local function getPlayerFurnitureInventory(pid)
	local invlist = getFurnitureInventoryTable()
	local pname = getName(pid)
	
	if invlist[pname] == nil then
		invlist[pname] = {}
		WorldInstance:Save()
	end
	
	return invlist[pname]
end

local function getSortedPlayerFurnitureInventory(pid)
	local inv = getPlayerFurnitureInventory(pid)
	local sorted = {}
	
	for refId, amount in pairs(inv) do
		local name = getFurnitureData(refId).name
		table.insert(sorted, {name = name, count = amount, refId = refId})
	end
	
	return sorted
end

local function placeFurniture(refId, loc, cell, packetType)
	print("placing item")
	print(refId)
	print(packetType)
	local mpNum = WorldInstance:GetCurrentMpNum() + 1
	local location = {
		posX = loc.posX, posY = loc.posY, posZ = loc.posZ,
		rotX = 0, rotY = 0, rotZ = 0
	}
	local refIndex =  0 .. "-" .. mpNum
	
	WorldInstance:SetCurrentMpNum(mpNum)
	tes3mp.SetCurrentMpNum(mpNum)
	
	if not LoadedCells[cell] then
		--TODO: Should ideally be temporary
		logicHandler.LoadCell(cell)
	end

	LoadedCells[cell]:InitializeObjectData(refIndex, refId)
	LoadedCells[cell].data.objectData[refIndex].location = location
	table.insert(LoadedCells[cell].data.packets.place, refIndex)
	
     if packetType == "place" then
        table.insert(LoadedCells[cell].data.packets.place, refIndex)
    elseif packetType == "spawn" then
        table.insert(LoadedCells[cell].data.packets.spawn, refIndex)
        table.insert(LoadedCells[cell].data.packets.actorList, refIndex)
    end

	for onlinePid, player in pairs(Players) do
		if player:IsLoggedIn() then
			tes3mp.InitializeEvent(onlinePid)
			tes3mp.SetEventCell(cell)
			tes3mp.SetObjectRefId(refId)
			tes3mp.SetObjectRefNumIndex(0)
			tes3mp.SetObjectMpNum(mpNum)
			tes3mp.SetObjectPosition(location.posX, location.posY, location.posZ)
			tes3mp.SetObjectRotation(location.rotX, location.rotY, location.rotZ)
			tes3mp.AddWorldObject()
			
			        if packetType == "place" then
						tes3mp.SendObjectPlace(true)
					elseif packetType == "spawn" then
						tes3mp.SendObjectSpawn(true)
					end
			
			
			
		end
	end
	
	LoadedCells[cell]:Save()
	
	return refIndex
end

local function removeFurniture(refIndex, cell)
	--If for some reason the cell isn't loaded, load it. Causes a bit of spam in the server log, but that can't really be helped.
	--TODO: Ideally this should only be a temporary load
	if LoadedCells[cell] == nil then
		logicHandler.LoadCell(cell)
	end
	
	if LoadedCells[cell]:ContainsObject(refIndex) and not tableHelper.containsValue(LoadedCells[cell].data.packets.delete, refIndex) then --Shouldn't ever have a delete packet, but it's worth checking anyway
		--Delete the object for all the players currently online
		local splitIndex = refIndex:split("-")
		
		for onlinePid, player in pairs(Players) do
			if player:IsLoggedIn() then
				tes3mp.InitializeEvent(onlinePid)
				tes3mp.SetEventCell(cell)
				tes3mp.SetObjectRefNumIndex(splitIndex[1])
				tes3mp.SetObjectMpNum(splitIndex[2])
				tes3mp.AddWorldObject()
				tes3mp.SendObjectDelete()
			end
		end
		
		LoadedCells[cell]:DeleteObjectData(refIndex)
		LoadedCells[cell]:Save()
		--Removing the object from the placed list will be done elsewhere
	end
end

local function getAvailableFurnitureStock(pid, tip)
	--In the future this can be used to customise what items are available for a particular player, like making certain items only available for things like their race, class, level, their factions, or the quests they've completed. For now, however, everything in furnitureData is available :P
	
	local options = {}
	
	for i = 1, #furnitureData do
		if furnitureData[i].tip == tip or tip == "all" then
			table.insert(options, furnitureData[i])
		end
	end
	
	return options
end

--If the player has placed items in the cell, returns an indexed table containing all the refIndexes of furniture that they have placed.
local function getPlayerPlacedInCell(pname, cell)
	local cellPlaced = getPlaced(cell)
	
	if not cellPlaced then
		-- Nobody has placed items in this cell
		return false
	end
	
	local list = {}
	for refIndex, data in pairs(cellPlaced) do
		if data.owner == pname then
			table.insert(list, refIndex)
		end
	end
	
	if #list > 0 then
		return list
	else
		--The player hasn't placed any items in this cell
		return false
	end
end

local function addFurnitureData(data)
	--Check the furniture doesn't already have an entry, if it does, overwrite it
	--TODO: Should probably check that the data is valid
	local fdata, loc = getFurnitureData(data.refId)
	
	if fdata then
		furnitureData[loc] = data
	else
		table.insert(furnitureData, data)
	end
end

Methods.AddFurnitureData = function(data)
	addFurnitureData(data)
end
--NOTE: Both AddPermission and RemovePermission use pname, rather than pid
Methods.AddPermission = function(pname, cell)
	local perms = getPermissionsTable()
	
	if not perms[cell] then
		perms[cell] = {}
	end
	
	perms[cell][pname] = true
	WorldInstance:Save()
end

Methods.RemovePermission = function(pname, cell)
	local perms = getPermissionsTable()
	
	if not perms[cell] then
		return
	end
	
	perms[cell][pname] = nil
	
	WorldInstance:Save()
end

Methods.RemoveAllPermissions = function(cell)
	local perms = getPermissionsTable()
	
	perms[cell] = nil
	WorldInstance:Save()
end

Methods.RemoveAllPlayerFurnitureInCell = function(pname, cell, returnToOwner)
	local placed = getPlacedTable()
	local cInfo = placed[cell] or {}
	
	for refIndex, info in pairs(cInfo) do
		if info.owner == pname then
			if returnToOwner then
				addFurnitureItem(info.owner, info.refId, 1, false)
			end
			removeFurniture(refIndex, cell)
			removePlaced(refIndex, cell, false)
		end
	end
	WorldInstance:Save()
end

Methods.RemoveAllFurnitureInCell = function(cell, returnToOwner)
	local placed = getPlacedTable()
	local cInfo = placed[cell] or {}
	
	for refIndex, info in pairs(cInfo) do
		if returnToOwner then
			addFurnitureItem(info.owner, info.refId, 1, false)
		end
		removeFurniture(refIndex, cell)
		removePlaced(refIndex, cell, false)
	end
	WorldInstance:Save()
end

--Change the ownership of the specified furniture object (via refIndex) to another character's (playerToName). If playerCurrentName is false, the owner will be changed to the new one regardless of who owned it first.
Methods.TransferOwnership = function(refIndex, cell, playerCurrentName, playerToName, save)
	local placed = getPlacedTable()
	
	if placed[cell] and placed[cell][refIndex] and (placed[cell][refIndex].owner == playerCurrentName or not playerCurrentName) then
		placed[cell][refIndex].owner = playerToName
	end
	
	if save then
		WorldInstance:Save()
	end
	
	--Unset the current player's selected item, just in case they had that furniture as their selected item
	if playerCurrentName and logicHandler.IsPlayerNameLoggedIn(playerCurrentName) then
		decorateHelp.SetSelectedObject(logicHandler.GetPlayerByName(playerCurrentName).pid, "")
	end
end

--Same as TransferOwnership, but for all items in a given cell
Methods.TransferAllOwnership = function(cell, playerCurrentName, playerToName, save)
	local placed = getPlacedTable()
	
	if not placed[cell] then
		return false
	end
	
	for refIndex, info in pairs(placed[cell]) do
		if not playerCurrentName or info.owner == playerCurrentName then
			placed[cell][refIndex].owner = playerToName
		end
	end
	
	if save then
		WorldInstance:Save()
	end
	
	--Unset the current player's selected item, just in case they had any of the furniture as their selected item
	if playerCurrentName and logicHandler.IsPlayerNameLoggedIn(playerCurrentName) then
		decorateHelp.SetSelectedObject(logicHandler.GetPlayerByName(playerCurrentName).pid, "")
	end
end

--New Release 2 Methods:
Methods.GetSellBackPrice = function(value)
	return getSellValue(value)
end

Methods.GetFurnitureDataByRefId = function(refId)
	return getFurnitureData(refId)
end

Methods.GetPlacedInCell = function(cell)
	return getPlaced(cell)
end


-- ====
--  GUI
-- ====

-- VIEW (OPTIONS)
showViewOptionsGUI = function(pid, loc)
	local message = ""
	local choice = playerViewOptions[getName(pid)][loc]
	local fdata = getFurnitureData(choice.refId)
	
	message = message .. "Item Name: " .. fdata.name .. " (RefIndex: " .. choice.refIndex .. "). Price: 1 (Sell price: 1)"
	
	playerViewChoice[getName(pid)] = choice
	tes3mp.CustomMessageBox(pid, config.ViewOptionsGUI, message, "Select;Put Away;Sell;Close")
end

local function onViewOptionSelect(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)
	
	if getObject(choice.refIndex, cell) then
		decorateHelp.SetSelectedObject(pid, choice.refIndex)
		tes3mp.MessageBox(pid, -1, "Object selected, use /dh to move.")
	else
		tes3mp.MessageBox(pid, -1, "The object seems to have been removed.")
	end
end

local function onViewOptionPutAway(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)
	
	if getObject(choice.refIndex, cell) then
		removeFurniture(choice.refIndex, cell)
		removePlaced(choice.refIndex, cell, true)
		
		addFurnitureItem(pname, choice.refId, 1, true)
		tes3mp.MessageBox(pid, -1, getFurnitureData(choice.refId).name .. " has been added to your furniture inventory.")
	else
		tes3mp.MessageBox(pid, -1, "The object seems to have been removed.")
	end
end

local function onViewOptionSell(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)
	
	if getObject(choice.refIndex, cell) then
		local saleGold = 1
		
		--Add gold to inventory
		addGold(pid, saleGold)
		
		--Remove the item from the cell
		removeFurniture(choice.refIndex, cell)
		removePlaced(choice.refIndex, cell, true)
		
		--Inform the player
		tes3mp.MessageBox(pid, -1, saleGold .. " Gold has been added to your inventory and the furniture has been removed from the cell.")
	else
		tes3mp.MessageBox(pid, -1, "The object seems to have been removed.")
	end
end

-- VIEW (MAIN)
showViewGUI = function(pid)
	local pname = getName(pid)
	local cell = tes3mp.GetCell(pid)
	local options = getPlayerPlacedInCell(pname, cell)
	
	local list = "* CLOSE *\n"
	local newOptions = {}
	
	if options and #options > 0 then
		for i = 1, #options do
			--Make sure the object still exists, and get its data
			local object = getObject(options[i], cell)
			
			if object then
				print("object was")
				print(object)
				local furnData = getFurnitureData(object.refId)
				
				list = list .. furnData.name .. " (at " .. math.floor(object.location.posX + 0.5) .. ", "  ..  math.floor(object.location.posY + 0.5) .. ", " .. math.floor(object.location.posZ + 0.5) .. ")"
				if not(i == #options) then
					list = list .. "\n"
				end
				
				table.insert(newOptions, {refIndex = options[i], refId = object.refId})
			end
		end
	end
	
	playerViewOptions[pname] = newOptions
	tes3mp.ListBox(pid, config.ViewGUI, "Select a piece of furniture you've placed in this cell. Note: The contents of containers will be lost if removed.", list)
	--getPlayerPlacedInCell(pname, cell)
end

local function onViewChoice(pid, loc)
	showViewOptionsGUI(pid, loc)
end

-- INVENTORY (OPTIONS)
showInventoryOptionsGUI = function(pid, loc)
	local message = ""
	local choice = playerInventoryOptions[getName(pid)][loc]
	local fdata = getFurnitureData(choice.refId)
	
	message = message .. "Item Name: " .. choice.name .. ". Price: 1 (Sell price: 1)"
	
	playerInventoryChoice[getName(pid)] = choice
	tes3mp.CustomMessageBox(pid, config.InventoryOptionsGUI, message, "Place;Sell;Close")
end

local function onInventoryOptionPlace(pid)
	local pname = getName(pid)
	local curCell = tes3mp.GetCell(pid)
	local choice = playerInventoryChoice[pname]
	
	--First check the player is allowed to place items where they are currently
	if config.whitelist and not hasPlacePermission(pname, curCell) then
		--Player isn't allowed
		tes3mp.MessageBox(pid, -1, "You don't have permission to place furniture here.")
		return false
	end
	
	--Remove 1 instance of the item from the player's inventory
	addFurnitureItem(pname, choice.refId, -1, true)
	
	--Place the furniture in the world
	local pPos = {posX = tes3mp.GetPosX(pid), posY = tes3mp.GetPosY(pid), posZ = tes3mp.GetPosZ(pid),  rotX = tes3mp.GetRotX(pid), rotY = 0, rotZ= tes3mp.GetRotZ(pid) }
	for index, item in pairs(furnitureData) do
		if item.refId == choice.refId then
			choice.need = item.need
			print("found need")
			break
		end
	end
	local furnRefIndex = placeFurniture(choice.refId, pPos, curCell, choice.need)
	
	--Update the database of all placed furniture
	addPlaced(furnRefIndex, curCell, pname, choice.refId, true, pPos, choice.need)
	--Set the placed item as the player's active object for decorateHelp to use
	decorateHelp.SetSelectedObject(pid, furnRefIndex)
end

local function onInventoryOptionSell(pid)
	local pname = getName(pid)
	local choice = playerInventoryChoice[pname]
	
	local saleGold = 1
	
	--Add gold to inventory
	addGold(pid, saleGold)
	
	--Remove 1 instance of the item from the player's inventory
	addFurnitureItem(pname, choice.refId, -1, true)
	
	--Inform the player
	tes3mp.MessageBox(pid, -1, saleGold .. " Gold has been added to your inventory.")
end

-- INVENTORY (MAIN)
showInventoryGUI = function(pid)
	local options = getSortedPlayerFurnitureInventory(pid)
	local list = "* CLOSE *\n"
	
	for i = 1, #options do
		list = list .. options[i].name .. " (" .. options[i].count .. ")"
		if not(i == #options) then
			list = list .. "\n"
		end
	end
	
	playerInventoryOptions[getName(pid)] = options
	tes3mp.ListBox(pid, config.InventoryGUI, "Select the piece of furniture from your inventory that you wish to do something with", list)
end

local function onInventoryChoice(pid, loc)
	showInventoryOptionsGUI(pid, loc)
end

-- BUY (MAIN)
showBuyGUI = function(pid)
	local options = getAvailableFurnitureStock(pid, "normal")
	local list = "* CLOSE *\n"
	
	for i = 1, #options do
		list = list .. options[i].name .. " (" .. tostring(0) .. " Gold)"
		if not(i == #options) then
			list = list .. "\n"
		end
	end
	
	playerBuyOptions[getName(pid)] = options
	tes3mp.ListBox(pid, config.BuyGUI, "Select an item you wish to buy", list)
end

-- BUY (MAIN)
Methods.showBuyGUIall = function(pid,tip)
	local options = getAvailableFurnitureStock(pid, tip)
	local list = "* CLOSE *\n"
	
	for i = 1, #options do
		list = list .. options[i].name .. " (" .. tostring(0) .. " Gold)"
		if not(i == #options) then
			list = list .. "\n"
		end
	end
	
	playerBuyOptions[getName(pid)] = options
	tes3mp.ListBox(pid, config.BuyGUI, "Select an item you wish to buy", list)
end



local function onBuyChoice(pid, loc)
	local pgold = getPlayerGold(pid)
	local choice = playerBuyOptions[getName(pid)][loc]
	
	if pgold < 1 then
		tes3mp.MessageBox(pid, -1, "You can't afford to buy a " .. choice.name .. ".")
		return false
	end
	
	addGold(pid, -1)
	addFurnitureItem(getName(pid), choice.refId, 1, true)
	
	tes3mp.MessageBox(pid, -1, "A " .. choice.name .. " has been added to your furniture inventory.")
	return true
end

-- MAIN
showMainGUI = function(pid)
	local message = "Welcome to the furniture menu. Use 'Buy' to purchase furniture for your furniture inventory, 'Inventory' to view the furniture items you own, 'View' to display a list of all the furniture that you own in the cell you're currently in.\n\nNote: The current version of tes3mp doesn't really like when lots of items are added to a cell, so try to restrain yourself from complete home renovations."
	tes3mp.CustomMessageBox(pid, config.MainGUI, message, "Buy;Inventory;View;Close")
end

local function onMainBuy(pid)
	showBuyGUI(pid)
end

local function onMainInventory(pid)
	showInventoryGUI(pid)
end

local function onMainView(pid)
	showViewGUI(pid)
end

-- GENERAL
Methods.OnGUIAction = function(pid, idGui, data)
	
	if idGui == config.MainGUI then -- Main
		if tonumber(data) == 0 then --Buy
			onMainBuy(pid)
			return true
		elseif tonumber(data) == 1 then -- Inventory
			onMainInventory(pid)
			return true
		elseif tonumber(data) == 2 then -- View
			onMainView(pid)
			return true
		elseif tonumber(data) == 3 then -- Close
			--Do nothing
			return true
		end
	elseif idGui == config.BuyGUI then -- Buy
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true
		else
			onBuyChoice(pid, tonumber(data))
			showMainGUI(pid)
			return true
		end
	elseif idGui == config.InventoryGUI then --Inventory main
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true
		else
			onInventoryChoice(pid, tonumber(data))
			return true
		end
	elseif idGui == config.InventoryOptionsGUI then --Inventory options
		if tonumber(data) == 0 then --Place
			onInventoryOptionPlace(pid)
			return true
		elseif tonumber(data) == 1 then --Sell
			onInventoryOptionSell(pid)
			return true
		else --Close
			--Do nothing
			return true
		end
	elseif idGui == config.ViewGUI then --View
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true
		else
			onViewChoice(pid, tonumber(data))
			return true
		end
	elseif idGui == config.ViewOptionsGUI then -- View Options
		if tonumber(data) == 0 then --Select
			onViewOptionSelect(pid)
			return true
		elseif tonumber(data) == 1 then --Put away
			onViewOptionPutAway(pid)
		elseif tonumber(data) == 2 then --Sell
			onViewOptionSell(pid)
		else --Close
			--Do nothing
			return true
		end
	elseif idGui == 1334 then
		if tonumber(data) == 0 then
			kanaFurnitureMod.showBuyGUIall(pid,"creature")
		elseif tonumber(data) == 1 then
			kanaFurnitureMod.showBuyGUIall(pid,"npc")
		elseif tonumber(data) == 2 then
			showMainGUI(pid)
		elseif tonumber(data) == 3 then
			kanaFurnitureMod.showBuyGUIall(pid,"all")
		elseif tonumber(data) == 4 then
			kanaFurnitureMod.showBuyGUIall(pid,"dungeon")
		elseif tonumber(data) == 5 then
			kanaFurnitureMod.showBuyGUIall(pid,"rocks")
		elseif tonumber(data) == 6 then
			kanaFurnitureMod.showBuyGUIall(pid,"flora")
		elseif tonumber(data) == 7 then
			kanaFurnitureMod.showBuyGUIall(pid,"exterior")
		elseif tonumber(data) == 8 then
			kanaFurnitureMod.showBuyGUIall(pid,"static")
		elseif tonumber(data) == 9 then -- door
			tes3mp.CustomMessageBox(pid, 1335, "where should this door head to?","New Dungeon;One of my Doors")
		end
	elseif idGui == 1335 then
		if tonumber(data) == 0 then
			newDungeon(pid)
		elseif tonumber(data) == 1 then
			toDoor(pid)
		end
	elseif idGui == 1336 then
		if Players[pid].DoorOptions[tonumber(data)] ~= nil then
			toDoorSecond(pid, tonumber(data))
		else
			print("error with dooroptions")
		end
	elseif idGui == 1337 then
		if tonumber(data) == 0 then
			craft(pid)
		elseif tonumber(data) == 1 then
			-- do nothing, close
		end
	end
end

--all, normal, dungeon, npc, creature, rocks, furn, flora, exterior, static,
Methods.OnCommand = function(pid)
	showMainGUI(pid)
end
Methods.OnBuild = function(pid)
	tes3mp.CustomMessageBox(pid, 1334, "Choose your Weapon", "Creature;NPC;NormalFurn;ALL;Dungeon;Rocks;Flora;Ext;All Static;Create Door")
end


newDungeon = function(pid) --just create some doors in interiors
	local interiors = jsonInterface.load("exampleInteriors.json")
	local dungeonCell
	local counter = 0
	local currentCell = tes3mp.GetCell(pid)
	local pname = getName(pid)
	-- on interior get necessary variables
		-- choose any interior
		-- if player is in interior take this one
		if tes3mp.IsInExterior(pid) == false then
			dungeonCell = tes3mp.GetCell(pid)
		else
			
		-- else choose from list --make a good example list
		-- get the one with smallest dungeonCount from example list
			for index, item in pairs(interiors) do
				if item.dungeonCount < counter or counter == 0 then
					counter = item.dungeonCount
					dungeonCell = index
				end
			end
		end
		
		-- save which examples have been taken how many times
		-- increase dungeoncount
			if interiors[dungeonCell] == nil then interiors[dungeonCell] = {} end
			if interiors[dungeonCell].dungeonCount == nil then
				interiors[dungeonCell].dungeonCount = 1
			else
				interiors[dungeonCell].dungeonCount = interiors[dungeonCell].dungeonCount + 1
			end
		-- save interiors json back inter
			jsonInterface.save("exampleInteriors.json", interiors)
			
			
			
		--now we got a cell for it
		-- get location in that cell
		local Ilse = interiors[dungeonCell].dungeonCount + 1
		local dungeonLocation = {posX = 0, posY = 0, posZ = 1000 * Ilse,  rotX = 0, rotY = 0, rotZ= 0 }
		
	--save door into json for OnActivate
		--save loc
		local pPos = {posX = tes3mp.GetPosX(pid), posY = tes3mp.GetPosY(pid), posZ = tes3mp.GetPosZ(pid),  rotX = tes3mp.GetRotX(pid), rotY = 0, rotZ= tes3mp.GetRotZ(pid) }
	
		--save door with loc and owner into json
		--plus desination
		myDoor = {location = pPos, owner = pname, destination = {cell = dungeonCell, location = dungeonLocation}}
		
		local doors = jsonInterface.load("createdDoors.json")
		if doors[currentCell] == nil then doors[currentCell] = {} end
		table.insert(doors[currentCell], myDoor)
		jsonInterface.save("createdDoors.json", doors)
	

	--spawn door 
		local furnRefIndex = placeFurniture("ex_nord_door_01", myDoor.location, currentCell, "place")	--Update the database of all placed furniture
		-- save to all placed ones
		addPlaced(furnRefIndex, currentCell, pname, "ex_nord_door_01", true, myDoor.location, "place")
		--Set the placed item as the player's active object for decorateHelp to use
		-- dont do this since we spawn him in new cell instead
		--decorateHelp.SetSelectedObject(pid, furnRefIndex)
		
	
	--spawn plate in this cell
		local furnRefIndex = placeFurniture("ex_de_docks_end", dungeonLocation, dungeonCell, "place")	--Update the database of all placed furniture
		-- save to all placed ones
		addPlaced(furnRefIndex, dungeonCell, pname, "ex_de_docks_end", true, dungeonLocation, "place")
		--Set the placed item as the player's active object for decorateHelp to use
		decorateHelp.SetSelectedObject(pid, furnRefIndex)
		
	--spawn player on top of plate
				
			tes3mp.SetCell(pid, dungeonCell)
			tes3mp.SendCell(pid)

			tes3mp.SetPos(pid, dungeonLocation.posX, dungeonLocation.posY, dungeonLocation.posZ + 10)
			tes3mp.SetRot(pid, 0, 0)
			tes3mp.SendPos(pid)
			
	-- send fancy message
end

toDoor = function(pid)
	--on players door.
	--check json for a list of existing doors
		
		local doors = jsonInterface.load("createdDoors.json")
		
		local list = ""
		local count = 0
		local pname = getName(pid)
		Players[pid].DoorOptions = {}
		
		for cell, item2 in pairs(doors) do
			for index, item in pairs(item2) do
				if item.owner == pname then
					Players[pid].DoorOptions[count] = {cell = cell, loc = item.location}
					count = count + 1
					list = list.."Door in Cell "..cell.."\n"
				else
					print("item was")
					print("not owner")
					print(item.owner)
				end
			end
		end
		
		tes3mp.ListBox(pid, 1336, "Choose one of your doors", list)
end

toDoorSecond = function(pid, data)	

		-- get old door
	local chosen = Players[pid].DoorOptions[data]
	local chosenCell = chosen.cell
	local chosenLoc = chosen.loc
	local currentCell = tes3mp.GetCell(pid)
	local pname = getName(pid)
		local doors = jsonInterface.load("createdDoors.json")
	
	--save new door into json for OnActivate
		--save loc
		local pPos = {posX = tes3mp.GetPosX(pid), posY = tes3mp.GetPosY(pid), posZ = tes3mp.GetPosZ(pid),  rotX = tes3mp.GetRotX(pid), rotY = 0, rotZ= tes3mp.GetRotZ(pid) }
	
		--save door with loc and owner into json
		--plus desination
		myDoor = {location = pPos, owner = pname, destination = {cell = chosenCell, location = chosenLoc}}
		
		if doors[currentCell] == nil then doors[currentCell] = {} end
		table.insert(doors[currentCell], myDoor)
		jsonInterface.save("createdDoors.json", doors)
		
		
	--spawn new door
		local furnRefIndex = placeFurniture("ex_nord_door_01", myDoor.location, currentCell, "place")	--Update the database of all placed furniture
		-- save to all placed ones
		addPlaced(furnRefIndex, currentCell, pname, "ex_nord_door_01", true, myDoor.location, "place")
		--Set the placed item as the player's active object for decorateHelp to use
		-- dont do this since we spawn him in new cell instead
		--decorateHelp.SetSelectedObject(pid, furnRefIndex)
		decorateHelp.SetSelectedObject(pid, furnRefIndex)
		
	--fancy message
	
end

Methods.OnDoor = function(pid, unqId)
local cell = tes3mp.GetCell(pid)
local activated = WorldInstance.data.customVariables.kanaFurnitureMod.placed[cell][unqId]
local solution
-- if thers more than one door in that cell compare with position in json
-- and take the one that is closer to the activated one

	local doors = jsonInterface.load("createdDoors.json")
	if #doors[cell] > 1 then
		print("sharp door was")
		print(#doors[cell])
			--beginn complicated math
		local distance = {}
		for index, item in pairs(doors[cell]) do
			distance[index] = math.sqrt((item.location.posX - activated.loc.posX)^2 + (item.location.posY - activated.loc.posY)^2 + (item.location.posZ - activated.loc.posZ)^2)
		end
			--get smallest distance
		local count = -1
		for index, item in pairs(distance) do
			print("distances")
			print(item)
			if item < count or count == -1 then
				solution = doors[cell][index] -- we got the best door in solution
				count = item
			end
		end
		print("chosen door")
		print("got distance")
		print(count)
	else
		print("found only one door")
		for index, item in pairs(doors[cell]) do
			solution = doors[cell][index]
			break
		end
	end
--teleport to destination
			tes3mp.SetCell(pid, solution.destination.cell)
			tes3mp.SendCell(pid)

			tes3mp.SetPos(pid, solution.destination.location.posX, solution.destination.location.posY, solution.destination.location.posZ + 10)
			tes3mp.SetRot(pid, 0, 0)
			tes3mp.SendPos(pid)
	--maybe fancy message you entered one of playerNames doors
end
							
Methods.OnHitActivate = function(pid, unique, refId, refNum, mpNum)
--count to 3 for uniqueId
logicHandler.RunConsoleCommandOnPlayer(pid, "player->say, \"AM/MinerSOund1.wav\", \"\"", false)

if Players[pid].data.customVariables.craftUnique == nil then
	Players[pid].data.customVariables.craftUnique = unique
	Players[pid].data.customVariables.craftCount = 1
elseif Players[pid].data.customVariables.craftUnique == unique then
	if Players[pid].data.customVariables.craftCount < 3 then
		Players[pid].data.customVariables.craftCount = Players[pid].data.customVariables.craftCount + 1
	else
		-- he hit 3 times get him a rock or tree
			for index, item in pairs(craftTable) do
				if string.lower(item.refId) == refId then
					if item.tip == "rocks" then -- should we go over inventory at all, or store just in a table instead?
						inventoryHelper.addItem(Players[pid].data.inventory, "craftrock", 1, -1, -1, "")
						Players[pid]:LoadInventory()
						Players[pid]:LoadEquipment()
					elseif item.tip == "flora" then
						inventoryHelper.addItem(Players[pid].data.inventory, "crafttree", 1, -1, -1, "")
						Players[pid]:LoadInventory()
						Players[pid]:LoadEquipment()
					end
					break -- found one match for that inventory item break loop
				end
			end
			logicHandler.RunConsoleCommandOnObject("disable", tes3mp.GetCell(pid), refId, refNum, mpNum)
		--send fancy message
	end
else -- if he activated another one
	Players[pid].data.customVariables.craftUnique = unique
	Players[pid].data.customVariables.craftCount = 1
end
end

craft = function(pid)
--require material while kanaFurnin
--remove one of each
	inventoryHelper.removeItem(Players[pid].data.inventory, "crafttree", 1)
	inventoryHelper.removeItem(Players[pid].data.inventory, "craftrock", 1)

--add material
	inventoryHelper.addItem(Players[pid].data.inventory, "material", 1, -1, -1, "")
	Players[pid]:LoadInventory()
	Players[pid]:LoadEquipment()
--fancy message
logicHandler.RunConsoleCommandOnPlayer(pid, "player->say, \"AM/MinerSOund2.wav\", \"\"", false)
Methods.OnCraftCommand(pid)
end

Methods.OnCraftCommand = function(pid)

--get counts
local count = {terrain = 0, flora = 0}

local index = inventoryHelper.getItemIndex(Players[pid].data.inventory, "crafttree")
if index ~= nil then count.flora = Players[pid].data.inventory[index].count end

local index2 = inventoryHelper.getItemIndex(Players[pid].data.inventory, "craftrock")
if index2 ~= nil then count.terrain = Players[pid].data.inventory[index2].count end



--craftrock, crafttree
if count.terrain > 0 and count.flora > 0 then
	tes3mp.CustomMessageBox(pid, 1337, "you got "..count.terrain.." Rocks and "..count.flora.." Trees", "Craft Material;Close")
else
	tes3mp.SendMessage(pid, "you got not enough rocks and tress\n", false)
end
end

return Methods
