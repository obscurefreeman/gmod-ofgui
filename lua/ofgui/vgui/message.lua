local PANEL = {}

function PANEL:Init()
    self:SetExpensiveShadow(1, ColorAlpha(color_black, 140))

    self.Color = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
    
    -- 创建标题DLabel
    self.TitleLabel = vgui.Create("DLabel", self)
    self.TitleLabel:SetFont("ofgui_big")
    self.TitleLabel:SetTextColor(Color(255, 255, 255, 255))
    self.TitleLabel:DockMargin(4 * OFGUI.ScreenScale, 4 * OFGUI.ScreenScale, 4 * OFGUI.ScreenScale, 2 * OFGUI.ScreenScale)
    self.TitleLabel:Dock(TOP)
    
    -- 创建描述DLabel
    self.DescLabel = vgui.Create("DLabel", self)
    self.DescLabel:SetFont("ofgui_medium")
    self.DescLabel:SetTextColor(Color(255, 255, 255, 255))
    self.DescLabel:SetWrap(true)
    self.DescLabel:DockMargin(4 * OFGUI.ScreenScale, 2 * OFGUI.ScreenScale, 4 * OFGUI.ScreenScale, 4 * OFGUI.ScreenScale)
    self.DescLabel:Dock(TOP)
    
    -- 默认大小
    self:SetSize(300, 64)
end

function PANEL:SetName(text)
    self.TitleLabel:SetText(text)
    self.TitleLabel:SetAutoStretchVertical(true)
end

function PANEL:SetText(text)
    self.DescLabel:SetText(text)
    self.DescLabel:SetAutoStretchVertical(true)
end

function PANEL:Think()
    local padding = 4 * OFGUI.ScreenScale
    local totalHeight = self.TitleLabel:GetTall() + self.DescLabel:GetTall() + 3 * padding
    self:SetTall(totalHeight)
end

function PANEL:Paint(w, h)
    -- 只需绘制背景
    draw.RoundedBox(0, 0, 0, w, h, self.Color)
end

derma.DefineControl("OFMessage", "NPC信息区域", PANEL, "DPanel") 