local Partyhealth = {}

Partyhealth.comparehealth = {}

function Partyhealth.One(pid, targetpd)
	local currenthealth = math.floor(tes3mp.GetHealthCurrent(targetpd))
    local basehealth = math.floor(tes3mp.GetHealthBase(targetpd))
    local nameofpid = tes3mp.GetName(targetpd)
	local healthRatio = currenthealth/basehealth
	if Partyhealth.comparehealth[pid] ~= currenthealth then
		Partyhealth.comparehealth[pid] = currenthealth
		if healthRatio < 1 and healthRatio >= 0.75 then
			tes3mp.MessageBox(pid, 8790, nameofpid .. "'s HP: " .. color.Green .. currenthealth .. color.GoldenRod .. "/" .. color.Green .. basehealth)
		elseif healthRatio < 0.75 and healthRatio >= 0.5 then
			tes3mp.MessageBox(pid, 8791, nameofpid .. "'s HP: " .. color.Yellow .. currenthealth .. color.GoldenRod .. "/" .. color.Green .. basehealth)
		elseif healthRatio < 0.5 then
			tes3mp.MessageBox(pid, 8792, color.Red .. "Immediatelly Heal: " .. nameofpid .. " (" .. color.Red .. currenthealth .. color.GoldenRod .. "/" .. color.Red .. basehealth .. ")")
		end
		Partyhealth.comparehealth[pid] = currenthealth
		tes3mp.SendMessage(pid, Partyhealth.comparehealth[pid])
	else
		if healthRatio < 1 and healthRatio >= 0.75 then
			tes3mp.MessageBox(pid, 8793, nameofpid .. "'s HP: " .. currenthealth .. "/" .. basehealth)
		elseif healthRatio < 0.75 and healthRatio >= 0.5 then
			tes3mp.MessageBox(pid, 8794, nameofpid .. "'s HP: " .. currenthealth .. "/" .. basehealth)
		elseif healthRatio < 0.5 then
			tes3mp.MessageBox(pid, 8795, color.Default .. "Immediatelly Heal: " .. nameofpid .. " (" .. color.Red .. currenthealth .. color.GoldenRod .. "/" .. color.Red .. basehealth .. ")") 
		end
	end
end



return Partyhealth
