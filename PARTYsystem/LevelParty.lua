--LevelParty.lua

--This Script creates a Party System.
--If one player skills in a skill one other Partymember gets an extra point on this skill as well.
--Supports RandomGold and LootShuffle


LevelParty = {}
Partytable = {}
OptionsList = {}

--------
---needed functions
--------


LevelParty.IsNotTrainerCell = function(pid)
    local TrainerCells = {
	"Valenvaryon, Propylon Chamber", "Ald'ruhn, Guild of Mages","Balmora, Guild of Mages","Ald'ruhn, The Rat In The Pot","Balmora, South Wall Cornerclub", -- alchemy
	"Tel Branora, Seryne Relas's House", "Sadrith Mora, Gateway Inn: West Wing", "Indoranyon", "Vos, Vos Chapel","Ald'ruhn, Temple","Buckmoth Legion Fort, Interior","Sadrith Mora, Wolverine Hall: Mages Guild","Rotheran, Arena","Ald'ruhn, Gildan's House","Balmora, South Wall Cornerclub","Tel Branora, Sethan's Tradehouse","Tel Aruhn, Plot and Plaster","Vivec, Foreign Quarter Canalworks","Balmora, Guild of Mages","Suran, Suran Tradehouse","Vivec, The Lizard's Head","Ald Velothi, Outpost","Gnisis, Fort Darius", -- alteration
	"Ebonheart, Hawkmoth Legion Garrison","Dren Plantation , Storage Shack","Zainab Camp, Ababael Timsar-Dadisun's Yurt"," 	Balmora, Guild of Fighters", -- armorer
	"Kaushtababi Camp, Adibael's Yurt", "Aralen Ancestral Tomb, Dulo Ancestral Tomb, Sarethi Ancestral Tomb","Tel Fyr, Onyx Hall","Vivec Foreign, Black Shalk Cornerclub","Falasmaryon, Missun Akin's Hut","Kaushtababi Camp, Adibael's Yurt","Indarys Manor","Vivec, Hlaalu, Edryno Arethi's House","2,-7","Ahemmusa Camp, Assamma-Idan's Yurt","Balmora, Hlaalu Council Manor","Dren Plantation, Doves' Shack","Ald Velothi, Outpost","Urshilaku Camp, Zanummu's Yurt","Suran, Suran Tradehouse","Indarys Manor","Vivec Redoran, Redoran Plaza","6,9","Vivec, Redoran, Redoran Scout & Drillmaster","Gnaar Mok, Arenim Manor","Molag Mar, Redoran Stronghold","Ghostgate, Tower of Dusk Lower Level","7,12","Maar Gan, Outpost","16,-2","Ahemmusa Camp, Dutadalk's Yurt","Rethan Manor, Gols' House","10,14","-11,14","Balmora, Nine Toes' House","Salit Camp, Zelay's Yurt","Ebonheart, Hawkmoth Legion Garrison","Vivec, Elven Nations Cornerclub","Seyda Neen, Arrille's Tradehous","Vivec, No Name Club","Vivec, Arena Fighters Training","Vivec, Elven Nations Cornerclub","Vivec, No Name Club","15,-9","Ald'ruhn, The Rat In The Pot","Vivec, Arena Fighters Quarters","Balmora, Council Club","5,3","-7,17","-14,14","10,12","10,7","-6,10","Vos, Varo Tradehouse","Erabenimsun Camp, Assemmus' Yurt","Gnaar Mok, Druegh-jigger's Rest","Vivec, Redoran Waistworks","Ald'ruhn, Goras Andrelo's House","Wolverine Hall: Fighters Guild","13,-1","-9,15","5,4","14,1","13,8","2,4","-2,13","12,13","Wolverine Hall: Fighters Guild","Gnisis, Barracks","Gnisis, Fort Darius","Buckmoth Legion Fort, Interior","Vivec, The Flowers of Gold","Gnisis, Madach Tradehouse","-13,12","-8,13","9,5","17,0","11,6","16,5","Ald'ruhn, Redoran Council Hall","Molag Mar, Redoran Stronghold","Vivec, No Name Club","Sadrith Mora, Nevrila Areloth's House","Caldera, Shenk's Shovel","Gnaar Mok, Nadene Rotheran's Shack","Balmora, Council Club","Vivec, Hlaalu Waistworks","Balmora, Hlaalu Council Manor","Sadrith Mora, Dirty Muriel's Cornerclub","Vivec, Foreign Quarter Lower Waistworks","Ebonheart, Imperial Chapels","Buckmoth Legion Fort, Interior","Pelagiad, Halfway Tavern", --- Athletics
	"Dagon Fel, Vacant Tower","Balmora, Caius Cosades' House","Sadrith Mora, Telvanni Council House","Ald'ruhn, The Rat In The Pot","Vivec, Arena Fighters Training", -- unarmored
	"Ghostgate, Tower of Dusk Lower Level","Balmora, Guild of Fighters", -- spear
	"Balmora, Hecerinde's House","Balmora, South Wall Cornerclub","Balmora, Hlaalu Council Manor","Sadrith Mora, Dirty Muriel's Cornerclub","Suran, Oran Manor","Rethan Manor","Vivec, Elven Nations Cornerclub","Gnaar Mok, Nadene Rotheran's Shack","Hla Oad, Fatleg's Drop Off","Balmora, Council Club","Sadrith Mora, Nevrila Areloth's House","Sadrith Mora, Dirty Muriel's Cornerclub","0,-9","Dagon Fel, End of the World Renter Rooms", -- security
	"Vos, Vos Chapel","4,-8","Sarethi Ancestral Tomb","Dulo Ancestral Tomb","Aralen Ancestral Tomb","Tel Branora, Sethan's Tradehouse","Tel Aruhn, Plot and Plaster","Rotheran, Arena","Caldera, Surane Leoriane's House","Vivec, Foreign Quarter Canalworks","Balmora, Tyermaillin's House", -- restoration
	"Sadrith Mora, Gateway Inn: West Wing","Valenvaryon, Propylon Chamber","4,-8","Sadrith Mora, Dirty Muriel's Cornerclub","Tel Branora, Seryne Relas's House","Ald'ruhn, Temple","Tel Branora, Sethan's Tradehouse","Caldera, Surane Leoriane's House","Ald'ruhn, Gildan's House","Suran, Suran Tradehouse","Vivec, The Lizard's Head","Balmora, Tyermaillin's House","Ebonheart, Six Fishes", -- mysticismn
	"Zainab Camp, Ababael Timsar-Dadisun's Yurt","Vivec, Simine Fralinie: Bookseller","Dren Plantation, Verethi and Dralor","Ebonheart, Imperial Chapels","Ghostgate, Tower of Dusk Lower Level","Pelagiad, Halfway Tavern","Ald'ruhn, Redoran Council Hall","Ebonheart, Six Fishes","Vivec, Redoran Waistworks","Sadrith Mora, Nevrila Areloth's House","Gnaar Mok, Nadene Rotheran's Shack","Balmora, Council Club","Vivec, Hlaalu Waistworks","Vivec, Foreign Quarter Lower Waistworks", --merchantile
	"Falensarano, Upper Level","Moonmoth Legion Fort, Interior","Vivec, Foreign Quarter, Aradraen: Fletcher","Seyda Neen, Arrille's Tradehouse","Maar Gan, Andus Tradehouse","Vivec, Black Shalk Cornerclub","Dagon Fel, The End of the World","Balmora, Rithleen's House","Gnaar Mok, Druegh-jigger's Rest","Suran, Suran Tradehouse","Vivec, Redoran Scout & Drillmaster","Molag Mar, The Pilgrim's Rest","Tel Mora, The Covenant","Vivec, Telvanni Tower","Vivec, Guild of Fighters","Vivec, The Flowers of Gold", --med armor
	"Falasmaryon, Missun Akin's Hut","Vivec, Foreign Quarter, Aradraen: Fletcher","Sadrith Mora, Morag Tong Guild","Balmora, Morag Tong Guild","Ald'ruhn, Morag Tong Guildhall","Caldera, Governor's Hall","2,-11","-3,2","Sadrith Mora, Fara's Hole in the Wall","Ebonheart, Six Fishes", -- marksman
	"Sadrith Mora, Dirty Muriel's Cornerclub", "Wolverine Hall: Mages Guild","Balmora, Nine Toes' House", -- illusion
	"-2,5", "Molag Mar, Armigers Stronghold", "Khuul, Thongar's Tradehouse", -- heavy armor
	"Indoranyon","Sadrith Mora, Wolverine Hall: Mages Guild","Sadrith Mora, Telvanni Council House, Entry","Balmora, Tyermaillin's House","Sadrith Mora, Fara's Hole in the Wall", -- enchant
	"4,-8","Sadrith Mora, Gateway Inn: West Wing","Tel Branora, Seryne Relas's House","Vivec, The Lizard's Head","Caldera, Surane Leoriane's House","Tel Aruhn, Plot and Plaster", -- destruction
	"Ald'ruhn, Temple","Valenvaryon, Propylon Chamber","Dren Plantation, Storage Shack", -- conjuration
	"Falensarano, Upper Level","Ald'ruhn, Practice Room","Ebonheart, Hawkmoth Legion Garrison","Dren Plantation, Verethi and Dralor","Ald'ruhn, Morvayn Quarters","Khuul, Thongar's Tradehouse","Indarys Manor, Raram's House","-5,4","Caldera, Shenk's Shovel","Pelagiad, Fort Pelagiad","Balmora, Eight Plates", -- axe
	"Holamayan Monastery","Vivec, Arena Fighters Quarters","Vivec, High Fane","Ghostgate, Temple","Caldera, Governor's Hall","Vivec, Arena Hidden Area","Rethan Manor, Tures' House","Llirala's Shack","Pelagiad, Halfway Tavern","Sadrith Mora, Telvanni Council House, Chambers","Sadrith Mora, Balen Vendu: Monk","Vivec, Telvanni Waistworks","Tel Vos, Services Tower", --hand to hand
	"Vivec, The Abbey of St. Delyn the Wise","Gnaar Mok, Druegh-jigger's Rest","Ald'ruhn, Practice Room","Dren Plantation, Verethi and Dralor","Ald'ruhn, Morvayn Quarters","-3,-3","Vivec, Redoran Scout & Drillmaster", -- blunt weapon
	"Ebonheart, Grand Council Chambers","Maelkashishi, Shrine","Almurbalarammi, Shrine","Pinsun","Assalkushalit, Shrine","Addadshashanammu, Shrine","Nund","Vivec, St. Olms Waistworks","Ashinabi","Shurinbaal","Beshara","Nammu","Rethan Manor","Esutanamus, Shrine","Vivec, Simine Fralinie: Bookseller","-6,-5","Seyda Neen, Census and Excise Warehouse","Sadrith Mora, Nevrila Areloth's House","Gnaar Mok, Nadene Rotheran's Shack", -- speechcraft
	"Balmora, Lucky Lockup","Vivec, Hlaalu Ancestral Vaults","Andasreth, Upper Level","Ald'ruhn, Sarethi Manor","Hlormaren, Keep, Bottom Level","Vivec, Redoran Treasury","Dren Plantation, Dren's Villa","Vivec, Curio Manor","Vivec, Hlaalu Treasury","Saturan","Ald Sotha, Upper Level","Suran, Oran Manor","Andasreth, Upper Level","Gnaar Mok, Arenim Manor","0,17","Tel Fyr, Onyx Hall","Assernerairan, Shrine","Sha-Adnius","Pinsun","Hinnabi","Vivec, Elven Nations Cornerclub","Habinbaes","-11,15","Ularradallaku, Shrine","Ald'ruhn, Hanarai Assutlanipal's House","Gnaar Mok, Nadene Rotheran's Shack","Hla Oad, Fatleg's Drop Off","Sadrith Mora, Nevrila Areloth's House","Beshara","Abernanit","0,-9","Ulummusa","Aharunartus","-3,-3","Balmora, Eight Plates","Vivec, Redoran Scout & Drillmaster", -- short blade
	"Caldera, Shenk's Shovel","Maar Gan, Andus Tradehouse","Vivec, The Abbey of St. Delyn the Wise","Vivec, St. Olms Yngling Manor","Tel Branora, Tower Guardpost","Shashpilamat","Rethan Manor, Tures' House","Assalkushalit, Shrine","Gnaar Mok, Arenim Manor","Sha-Adnius","-11,15","Ald'ruhn, Hanarai Assutlanipal's House","Ebonheart, Argonian Mission","Beshara","Valenvaryon, Umug's Hut","Valenvaryon, Lambug's Hut", -- sneak
	"Shashpilamat","Pelagiad, Halfway Tavern","Llirala's Shack","Sadrith Mora, Balen Vendu: Monk","Gnisis, Barracks","Valenvaryon, Lambug's Hut", -- acrobatics
	"Vivec, Redoran Treasury","Vivec, Curio Manor","Saturan","Gnaar Mok, Arenim Manor","Shashpilamat","Sadrith Mora, Fara's Hole in the Wall","Hla Oad, Fatleg's Drop Off","Ulummusa", -- light armor
	"Caldera, Guild of Mages"
	
	
	--Long Blade and Block should be covered by the others
    }
	
	
	local cellName = tes3mp.GetCell(pid)
	if tableHelper.containsValue(TrainerCells, cellName) then 
		return false 
	else
		return true
	end

end



LevelParty.GetLength = function(T)
local counter = 0

	for i, p in pairs(T) do
		counter = counter + 1
	end

return counter

end

LevelParty.IsParty = function(pid)

local yes = false

for i, paty in pairs(Partytable) do
	for iB, pl in pairs(Partytable[i].player) do
		if pl.pd ~= nil and pl.pd == pid then
			yes = true
		end
	end
end

if yes then
	return true 
else 
	return false 
end 

end

LevelParty.WhichParty = function(pid)

local slot = 0
for i, p in pairs(Partytable) do
	if p.name == Players[pid].data.customVariables.PartyName then 
		slot = i
	end
end

if slot ~= 0 then
	return slot
else
	return false
end 

end

LevelParty.SendToParty = function(pid, message)
local partyId = LevelParty.WhichParty(pid)

for i, p in pairs(Partytable[partyId].player) do
 tes3mp.SendMessage(p.pd, message, false)
end

end


LevelParty.Partyexists = function(data)

local yes = false
for i, p in pairs(Partytable) do
	if p.name == data then
		yes = true
	end
end

if yes == true then
	return true 
else 
	return false 
end 

end

LevelParty.GetPartyIdbyName = function(Patyname)

local slot = 0
for i, p in pairs(Partytable) do
	if p.name == Patyname then
		slot = i
	end
end

if slot ~= 0 then
return slot end

end



LevelParty.HowMuchPartys = function()

local count = LevelParty.GetLength(Partytable)
return count
end

LevelParty.GetPidbyName = function(name)
local GetPid = -1
for i, p in pairs(Players) do
	if p.name == name then
		GetPid = i
	end
end
return GetPid
end

LevelParty.HowMuchPlayersInParty = function(PartyId)

local count = LevelParty.GetLength(Partytable[PartyId]) -1

return count
end



-----------------
-------START GUIS
---------------




LevelParty.ShowMain = function(pid)
math.randomseed( os.time() )
if LevelParty.IsParty(pid) then
	LevelParty.ShowMembers(pid)
else
	tes3mp.CustomMessageBox(pid,5710,"Welcome to Party System.","Create Party;Join Party;Close")
end

end


LevelParty.ShowCreateParty = function(pid)
	tes3mp.InputDialog(pid,5720,"What name should the Party have?")
end



LevelParty.CreateParty = function(pid,data)

local partycount = LevelParty.HowMuchPartys() +1

if LevelParty.Partyexists(data) ~= true then
	Players[pid].data.customVariables.PartyName = data
	Partytable[partycount] = {}
	Partytable[partycount].name = data
	Partytable[partycount].OwnerPid = pid
	Partytable[partycount].player = {}
	table.insert(Partytable[partycount].player,{ name = Players[pid].name, pd = pid})
	
	tes3mp.SendMessage(pid,color.ForestGreen.."[PartySystem] "..color.Default.."Party with Name "..data.." was succesfully created\n",true)
else
	tes3mp.SendMessage(pid,"This Party already exists\n",false)
end

end



LevelParty.ShowJoinParty = function(pid)
local realcount = 1
local PartyList = ""

OptionsList[pid] = {data = {}}

for i, p in pairs(Partytable) do 
	PartyList = PartyList.. p.name.."\n"
	OptionsList[pid].data[realcount] = p.OwnerPid
	realcount = realcount +1
end


	PartyList = PartyList.. "***CLOSE***"

if realcount > 1 then
	tes3mp.ListBox(pid,5730,"Choose Party",PartyList)
else
	tes3mp.SendMessage(pid,"There are no Partys yet. Go create one\n",false)
end

end


LevelParty.ShowJoinAccept = function(joinpid, OwnerPid)

if LevelParty.Partyexists(Players[OwnerPid].data.customVariables.PartyName) then
	local PartyId = LevelParty.WhichParty(OwnerPid)
		if Partytable[PartyId].name ~= nil then 
			Players[OwnerPid].data.customVariables.WantsToJoinParty = joinpid
			tes3mp.CustomMessageBox(OwnerPid,5731,Players[joinpid].name.." wants to join the Party. Do you accept?","OK;NO")
		end
end

end


LevelParty.JoinParty = function(Ownerpid, partyname, joinpid)
local partyId = LevelParty.GetPartyIdbyName(partyname)

if LevelParty.Partyexists(partyname) == true then
	if Players[joinpid] ~= nil and Players[joinpid]:IsLoggedIn() then
		Players[joinpid].data.customVariables.PartyName = partyname
		table.insert(Partytable[partyId].player,{ name = Players[joinpid].name, pd = joinpid})
	
		local message = color.ForestGreen.."[PartySystem] "..color.Default..Players[joinpid].name.." joined the Party!!\n"
		LevelParty.SendToParty(Ownerpid, message)
	end
else
	tes3mp.SendMessage(Ownerpid,"This Party does not exists Strange Error\n",false)
end
	

end





LevelParty.ShowMembers = function(pid)
OptionsList[pid] = {data = {}}

local realcount = 1
local PartyId = LevelParty.WhichParty(pid)
local PartyList = ""
for i, p in pairs(Partytable[PartyId].player) do
	PartyList = PartyList.. p.name.."\n"
	OptionsList[pid].data[realcount] = p.name
	realcount = realcount +1
end

PartyList = PartyList.."LEAVE PARTY \n"
PartyList = PartyList.. "***CLOSE***"
if realcount > 1 then
	tes3mp.ListBox(pid,5740,"Choose a Player to Kick or Leave Party",PartyList)
else
	tes3mp.SendMessage(pid,"There are no Members\n",false)
end
end







LevelParty.KickParty = function(pid,kickName)
local KickPid = LevelParty.GetPidbyName(kickName)
local PartyIdTwo = LevelParty.WhichParty(KickPid)
local PartyId = LevelParty.WhichParty(pid)

if PartyIdTwo == PartyId and KickPid ~= pid and pid == Partytable[PartyId].OwnerPid then

	for i, p in pairs(Partytable[PartyId].player) do
		if string.lower(Players[KickPid].name) == string.lower(p.name) then
			table.remove(Partytable[PartyId].player, i) -- remove player from table
			Players[KickPid].data.customVariables.PartyName = ""
		end
	end
	
	local message = color.ForestGreen.."[PartySystem] "..color.Default.."Kicked Player "..Players[KickPid].name.." from Party "..Partytable[PartyId].name.."\n"
	LevelParty.SendToParty(pid, message)
else
tes3mp.SendMessage(pid,"You cant Kick yourself. You can just Leave. Or you are not the Owner of the Party\n",false)
end
end




LevelParty.LeaveParty = function(pid)

if LevelParty.IsParty(pid) then
local PartyId = LevelParty.WhichParty(pid)
local leavemessage = color.ForestGreen.."[PartySystem] "..color.Default..Players[pid].name.." left the Party!\n"
	

	for i, p in pairs(Partytable[PartyId].player) do
		if string.lower(Players[pid].name) == string.lower(p.name) then
			table.remove(Partytable[PartyId].player, i)
			Players[pid].data.customVariables.PartyName = ""
		end
	end
	

		if LevelParty.GetLength(Partytable[PartyId].player) <= 0 then -- delete party if party is empty
			table.remove(Partytable, PartyId)
		else
			if Partytable[PartyId].OwnerPid == pid then 		-- set new party owner if owner leaves party
				
				local Ptab = {}
				
				for i, p in pairs(Partytable[PartyId].player) do
					table.insert(Ptab, p.pd)
				end
				
				
				local newpid = Ptab[math.random(#Ptab)]
				Partytable[PartyId].OwnerPid = newpid
				local message = color.ForestGreen.."[PartySystem] "..color.Default.."New Owner of the Party is "..Players[newpid].name.."\n"
				LevelParty.SendToParty(newpid, message)
				LevelParty.SendToParty(newpid, leavemessage)
			end
		end
		
	tes3mp.SendMessage(pid, leavemessage, false)
end
end



-------------------------
--- LevelParty
----------




LevelParty.RandomGold = function(pid) -- think about saving, reloading inventory and equipment
if LevelParty.IsParty(pid) then -- add party needs two
 local PartyId = LevelParty.WhichParty(pid)
 
	if LevelParty.GetLength(Partytable[PartyId].player) > 1 and LevelParty.IsNotTrainerCell(pid) then 
	if  Players[pid].data.customVariables.GoldTimer == nil or Players[pid].data.customVariables.GoldTimer  + 20 < os.time() then
	for i, p in pairs(Partytable[PartyId].player) do
		local randGold = math.random(50) + math.random(20)
		myMod.RunConsoleCommandOnPlayer(p.pd, "player->additem \"gold_001\" "..tostring(randGold))
		Players[p.pd].data.customVariables.GoldTimer = os.time()
		tes3mp.SendMessage(p.pd,color.ForestGreen.."[PartySystem] "..color.Default..tostring(randGold)..color.Gold.." GOLD "..color.Default.."added.\n", false)
	end
	end
	end

  
end
end

LevelParty.CompareInventory = function(pid)
if LevelParty.IsParty(pid) then
	CompareInv = Players[pid].data.inventory
end

end

LevelParty.ShuffleItems = function(pid)

local itemRefId2 = ""
local ShuffleItem = {}

if LevelParty.IsParty(pid) then
for slot, item in pairs(Players[pid].data.inventory) do
	local yes = false
	
	for slot2, item2 in pairs(CompareInv) do -- check if item was in inventory before
		if item.refId == item2.refId then
			yes = true
		end
	end
	
	if yes == false then -- we have a PICK
		itemRefId2 = item.refId
		break
	end
end
end



if itemRefId2 ~= "" and itemRefId2 ~= "gold_001" and LevelParty.IsParty(pid) then -- dont do this in trainer cells and add party needs two
	
	
		Players[pid]:Save()		
		Players[pid]:Load()
		
		
	for slot, item in pairs(Players[pid].data.inventory) do -- remove item 
		if item.refId == itemRefId2 then
			ShuffleItem = item
			Players[pid].data.inventory[slot] = nil
		end
	end
	
	
end



if next(ShuffleItem) ~= nil and LevelParty.IsParty(pid) then 

	local PartyId = LevelParty.WhichParty(pid)
	
	if LevelParty.GetLength(Partytable[PartyId].player) > 1 then 
	
	local Ptab = {} -- get random
				
				for i, p in pairs(Partytable[PartyId].player) do
					table.insert(Ptab, p.pd)
				end
				
				
				local ShuffleToPid = Ptab[math.random(#Ptab)]
	
	Players[ShuffleToPid]:Save()
	Players[ShuffleToPid]:Load()
	
	
	table.insert(Players[ShuffleToPid].data.inventory, ShuffleItem)
	
	
		Players[ShuffleToPid]:Save()	
		Players[pid]:Save()		
		Players[ShuffleToPid]:Load()
		Players[pid]:Load()
		Players[ShuffleToPid]:LoadInventory()
		Players[pid]:LoadInventory()
		Players[ShuffleToPid]:LoadEquipment()
		Players[pid]:LoadEquipment()
	
	
	local message = color.ForestGreen.."[PartySystem] "..color.Default..ShuffleItem.refId.." goes to "..Players[ShuffleToPid].name.."\n"
	LevelParty.SendToParty(ShuffleToPid, message)
	end
end

end -- end function
	

LevelParty.GetSkillPlayer = function(pid) -- make skilledone better

if LevelParty.IsParty(pid) then
	local PartyId = LevelParty.WhichParty(pid)
	
	if LevelParty.GetLength(Partytable[PartyId].player) > 1 and LevelParty.IsNotTrainerCell(pid) then -- check if at least 2 players are in party
				local Ptab = {}
				
				for i, p in pairs(Partytable[PartyId].player) do
					table.insert(Ptab, p.pd)
				end
				
				
				local firstpid = Ptab[math.random(#Ptab)]
				local secondpid = Ptab[math.random(#Ptab)]
				
				if firstpid ~= secondpid then
					if tes3mp.GetSkillBase(firstpid,tes3mp.GetSkillId(skilledone)) > tes3mp.GetSkillBase(secondpid,tes3mp.GetSkillId(skilledone)) then
							LevelParty.ProcessSkill(pid, secondpid)
					else
							LevelParty.ProcessSkill(pid,firstpid)
					end
				else
					LevelParty.ProcessSkill(pid,firstpid)
				end
	end
end

	
end



LevelParty.ProcessSkill = function(pid, linkedpid)
				if Players[linkedpid] ~= nil and Players[linkedpid]:IsLoggedIn() then
					local beforeskill = tes3mp.GetSkillBase(linkedpid, tes3mp.GetSkillId(skilledone))
					Players[linkedpid].data.skills[skilledone] = beforeskill + 1
					tes3mp.SetSkillBase(linkedpid,  tes3mp.GetSkillId(skilledone), beforeskill+1)
					tes3mp.SendSkills(linkedpid)
					
					local message = color.ForestGreen.."[PartySystem] "..color.Default.."Hey "..tes3mp.GetName(linkedpid).." got "..color.Green.."EXTRA Point "..color.Default.."on "..skilledone.." from "..tes3mp.GetName(pid).."\n"
					LevelParty.SendToParty(linkedpid, message)
				end

end





----------------------------------
--OnGUIAction
--------
LevelParty.OnGUIAction  = function(pid, idGui, data)


if idGui == 5710 then --ShowMain
	if tonumber(data) == 0 then
		LevelParty.ShowCreateParty(pid)
	elseif tonumber(data) == 1 then
		LevelParty.ShowJoinParty(pid)
	else 
		return 
	end
end


if idGui == 5720 then --CreateParty
	if data ~= "" then
		LevelParty.CreateParty(pid,data)
	else
		tes3mp.SendMessage(pid, "Enter a valid Name\n",false)
	end
end



if idGui == 5730 then -- JoinParty
	if tonumber(data) < LevelParty.GetLength(OptionsList[pid].data) then
		local OwnerPid = OptionsList[pid].data[tonumber(data) + 1]
		if Players[OwnerPid].data.customVariables.PartyName ~= nil then 
			LevelParty.ShowJoinAccept(pid,OwnerPid)
			tes3mp.SendMessage(pid,color.ForestGreen.."[PartySystem]"..color.Default.."You have to wait if "..Players[OwnerPid].name.." accepts your Request to join "..Players[OwnerPid].data.customVariables.PartyName.." !\n", false)
		else
			tes3mp.SendMessage(pid,"well sth went terribly wrong\n",false)
		end
	else
		tes3mp.SendMessage(pid,"You closed the Menu\n",false)
	end
end


if idGui == 5731 then --accept party
	if tonumber(data) == 0 then
		LevelParty.JoinParty(pid, Players[pid].data.customVariables.PartyName,Players[pid].data.customVariables.WantsToJoinParty)
	else
		tes3mp.SendMessage(pid,"You refused\n",false)
	end
end

if idGui == 5740 then -- showMembers
	if tonumber(data) < LevelParty.GetLength(OptionsList[pid].data) then
		LevelParty.KickParty(pid, OptionsList[pid].data[tonumber(data) + 1])
	elseif tonumber(data) == LevelParty.GetLength(OptionsList[pid].data)  then
		LevelParty.LeaveParty(pid)
	else
		tes3mp.SendMessage(pid,"You closed the Menu \n",false)
	end
end


end -- end OnGUIAction


return LevelParty