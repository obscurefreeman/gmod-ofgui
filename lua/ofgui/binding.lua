OFGUI.Opened = {}

function OFGUI.GetLast()
	return table.GetLastValue(OFGUI.Opened)
end

function OFGUI.GetFirst()
	return table.GetFirstValue(OFGUI.Opened)
end

function OFGUI.GetAmount()
	local amount = 0
	for _, pnl in ipairs(OFGUI.Opened) do
		if IsValid(pnl) and pnl:IsVisible() then
			amount = amount + 1
		end
	end
	return amount
end

function OFGUI.RemoveLast()
	local last = OFGUI.GetLast()
	if IsValid(last) then
		last:Close()
	end
end

function OFGUI.Add(pnl)
	table.insert(OFGUI.Opened, pnl)
end

function OFGUI.PlaySound(path)
	if OFGUI.SoundEnabled then
		surface.PlaySound(path)
	end
end

local firstPressed
hook.Add("PreRender", "OFGUI Binding", function()
	if not firstPressed and input.IsButtonDown(KEY_ESCAPE) and OFGUI.GetAmount() > 0 then
		OFGUI.RemoveLast()
		firstPressed = true
		if gui.IsGameUIVisible() then
			gui.HideGameUI()
			return true
		end
	elseif not input.IsButtonDown(KEY_ESCAPE) then
		firstPressed = false
	end
end)