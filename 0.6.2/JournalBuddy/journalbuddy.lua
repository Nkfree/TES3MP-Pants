journalbuddy = {}

journalbuddy.AskConnect = function(pid,targetpid)
if pid ~= targetpid then
	tes3mp.SendMessage(pid,"You asked another Player to connect Journals with you./n",false)
	tes3mp.CustomMessageBox(targetpid,2240,Players[pid].name.." wants to connect Journals","OK;NO")
	Players[targetpid].data.customVariables.WantsJournal = pid
else
	tes3mp.SendMessage(pid,"Dont use your own Pid\n",false)
end
end

journalbuddy.ConnectJournals = function(targetpid, pid)
Players[targetpid].data.customVariables.Journalbuddy = Players[pid].name
Players[pid].data.customVariables.Journalbuddy = Players[targetpid].name


for id, journalItem in pairs(Players[pid].data.journal) do
	if tableHelper.containsValue(Players[targetpid].data.journal, journalItem.quest,true) == false then
		table.insert(Players[targetpid].data.journal, journalItem)
	end
end

for id2, journalItem2 in pairs(Players[targetpid].data.journal) do
	if tableHelper.containsValue(Players[pid].data.journal, journalItem2.quest,true) == false then
		table.insert(Players[pid].data.journal, journalItem2)
	end
end

Players[pid]:Save()
Players[targetpid]:Save()
Players[pid]:LoadJournal()
Players[targetpid]:LoadJournal()



tes3mp.SendMessage(pid,"You have connected Journals with "..Players[targetpid].name.."\n", false)
tes3mp.SendMessage(targetpid,"You have connected Journals with "..Players[pid].name.."\n", false)
end

journalbuddy.SaveJournal = function(pid)
local targetpl = myMod.GetPlayerByName(Players[pid].data.customVariables.Journalbuddy)
local targetpid = targetpl.pid

for id, journalItem in pairs(Players[pid].data.journal) do
	if tableHelper.containsValue(Players[targetpid].data.journal, journalItem.quest,true) == false then
		table.insert(Players[targetpid].data.journal, journalItem)
	end
end
Players[targetpid]:Save()
Players[targetpid]:LoadJournal()
end


journalbuddy.OnGuiAction = function(pid, idGui, data)
if idGui == 2240 then
	if tonumber(data) == 0 then
		journalbuddy.ConnectJournals(pid,Players[pid].data.customVariables.WantsJournal)
	else
		tes3mp.SendMessage(pid,"you refused\n",false)
	end
end
end

return journalbuddy