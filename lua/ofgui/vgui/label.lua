local PANEL = {}

function PANEL:Init()
    -- 设置默认字体
    self:SetFont("ofgui_big")
    self:SetTextColor(color_white)
    self:SetAutoStretchVertical(true)
end

derma.DefineControl("OFTextLabel", "", PANEL, "DLabel")
