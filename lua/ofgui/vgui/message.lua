local PANEL = {}

function PANEL:Init()
    self:SetExpensiveShadow(1, ColorAlpha(color_black, 140))

    self.Color = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
    
    -- 创建标题DLabel
    self.TitleLabel = vgui.Create("DLabel", self)
    self.TitleLabel:SetFont("ofgui_big")
    self.TitleLabel:SetTextColor(OFGUI.ButtonTextColor)
    self.TitleLabel:Dock(TOP)
    
    -- 创建描述DLabel
    self.DescLabel = vgui.Create("DLabel", self)
    self.DescLabel:SetFont("ofgui_medium")
    self.DescLabel:SetTextColor(OFGUI.ButtonTextColor)
    self.DescLabel:SetWrap(true)
    self.DescLabel:Dock(TOP)
    
    -- 默认大小
    self:SetSize(300, 64)
end

function PANEL:SetName(text)
    self.TitleLabel:SetText(text)
    self.TitleLabel:SetAutoStretchVertical(true)
    self:UpdateLayout()
end

function PANEL:SetText(text)
    self.DescLabel:SetText(text)
    self.DescLabel:SetAutoStretchVertical(true)
    self:UpdateLayout()
end

function PANEL:UpdateLayout()
    -- 更新面板高度
    local padding = 4 * OFGUI.ScreenScale
    local totalHeight = self.TitleLabel:GetTall() + padding + self.DescLabel:GetTall() + padding
    self:SetTall(totalHeight)
end

function PANEL:Paint(w, h)
    -- 只需绘制背景
    draw.RoundedBox(0, 0, 0, w, h, self.Color)
end

derma.DefineControl("OFMessage", "NPC信息区域", PANEL, "DPanel") 