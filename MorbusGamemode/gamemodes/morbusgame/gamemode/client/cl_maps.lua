/*========================================
VOTING SYSTEM
======================================*/

if !SMV then
	SMV = {}
end

SMV.Winner = nil
SMV.Voting = false
SMV.Votes = {}
SMV.VotingPanel = nil
SMV.VotingMaps = {}
SMV.Maps = {}


function SMV.StartVote()
	SMV.Maps = net.ReadTable()
	SMV.Voting = true
	if SMV.VotingPanel then
		SMV.VotingPanel:Remove()
	end
	timer.Simple(2,SMV.OpenVotingPanel)
end
net.Receive("smv_start",SMV.StartVote)

function SMV.EndVote()
	SMV.Voting = false
	if SMV.VotingPanel then
		SMV.VotingPanel.HideVotingButtons()
	end
end
net.Receive("smv_end",SMV.EndVote)

function SMV.GetWinner()
	SMV.Winner = net.ReadString()
end
net.Receive("smv_winner",SMV.GetWinner)

function SMV.GetVotes()
	SMV.Votes = net.ReadTable()
	if SMV.VotingPanel then
		SMV.VotingPanel.UpdateButtons()
	end
end
net.Receive("smv_vote_status",SMV.GetVotes)

function SMV.OpenVotingPanel()
	local pnl = vgui.Create("DPanel")
	pnl:SetSize(800,600)
	pnl:Center()
	pnl:SetMouseInputEnabled(true)
	gui.EnableScreenClicker(true)
	//pnl:MakePopup()
	pnl.VotingButtons = {}

	function pnl:Paint()
		draw.RoundedBox(6, 0, 0, self:GetWide(), self:GetTall(), Color(100,100,100,100))
		draw.SimpleTextOutlined("Map vote", "HUDNumber1", self:GetWide()/2, 50, Color(255,255,255,255),TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))

		if SMV.Winner then
			draw.SimpleTextOutlined("Winner:", "HUDNumber2", self:GetWide()/2, 110, Color(255,255,255,255),TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
			draw.SimpleTextOutlined(SMV.Winner, "HUDNumber1", self:GetWide()/2, 160, Color(255,255,255,255),TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
		end
	end

	local tab = table.Shuffle(SMV.Maps)
	SMV.VotingMaps = tab

	PrintTable(tab)

	local n = 30
	if #tab < n then n = #tab end

	local x = 0
	local y = 0
	local z = 10

	for i=1, n do
		if SMV.VotingMaps[i] then
			local btn = vgui.Create("DButton",pnl)
			btn:SetSize(240,40)
			btn:SetPos(20 + (x * 260), 60 + (y * 44))
			btn:SetText(SMV.VotingMaps[i].." - 0 votes")
			btn.Map = SMV.VotingMaps[i]
			function btn.DoClick()
				if SMV.Voting then
					MsgN("Voted "..btn.Map)
					net.Start("smv_vote")
					net.WriteString(btn.Map)
					net.SendToServer()
				end
			end
			pnl.VotingButtons[SMV.VotingMaps[i]] = btn
			y = y + 1
			if y == z then
				x = x + 1
				y = 0
			end
		end
	end

	function pnl.UpdateButtons()
		for k,v in pairs(pnl.VotingButtons) do
			v:SetText(k.." - 0 votes")
		end
		for k,v in pairs(SMV.Votes) do
			if pnl.VotingButtons[k] then
				pnl.VotingButtons[k]:SetText(k.." - "..v.." votes")
			end
		end
	end

	function pnl.HideVotingButtons()
		for k,v in pairs(pnl.VotingButtons) do
			v:SetVisible(false)
		end
	end

	if true then

		local xb = vgui.Create("DButton",pnl)
		xb:SetSize(80,20)
		xb:SetPos(pnl:GetWide()-82,2)
		xb:SetText("Exit")
		function xb:DoClick()
			pnl:SetVisible(false)
			gui.EnableScreenClicker(false)
		end
	end
	
	SMV.VotingPanel = pnl

	

end