--more a ressource as List of Trainer Cells
---Just Use if you know what you are doing.
--for questions go to my discord on the first page



DisableTrainers = {}

DisableTrainers.IsTrainerCell = function(pid)
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
	
	
	
	--Long Blade and Block should be covered by the others
    }
	
	
	local cellName = tes3mp.GetCell(pid)
	if tableHelper.containsValue(TrainerCells, cellName) then return true end
    return false

end

return DisableTrainers