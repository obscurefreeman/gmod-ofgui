local PANEL = {}

function PANEL:Init()
    self:SetExpensiveShadow(1, ColorAlpha(color_black, 140))

    self.Color = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
    
    -- 默认大小
    self:SetSize(300, 64)
    
    -- 初始化标题和描述文本
    self.titleMarkup = nil
    self.descMarkup = nil
    self.titleText = ""    -- 保存原始标题文本
    self.descText = ""     -- 保存原始描述文本
end

function PANEL:SetName(text)
    -- 保存原始文本
    self.titleText = text
    -- 使用markup解析标题文本
    self.titleMarkup = markup.Parse("<font=ofgui_big>" .. text .. "</font>")
end

function PANEL:SetText(text)
    -- 保存原始文本
    self.descText = text
    -- 使用markup解析描述文本
    self.descMarkup = markup.Parse("<font=ofgui_medium>" .. text .. "</font>", self:GetWide() - 8 * OFGUI.ScreenScale)
end

function PANEL:Think()
    if not self.titleMarkup or not self.descMarkup then return end
    
    -- 使用保存的原始文本重新解析
    self.descMarkup = markup.Parse("<font=ofgui_medium>" .. self.descText .. "</font>", self:GetWide() - 8 * OFGUI.ScreenScale)
    
    local padding = 4 * OFGUI.ScreenScale
    local totalHeight = self.titleMarkup:GetHeight() + self.descMarkup:GetHeight() + 3 * padding
    self:SetTall(totalHeight)
end

function PANEL:Paint(w, h)
    -- 只需绘制背景
    draw.RoundedBox(0, 0, 0, w, h, self.Color)
    
    -- 绘制标题和描述文本
    local padding = 4 * OFGUI.ScreenScale
    
    if self.titleMarkup then
        self.titleMarkup:Draw(padding, padding, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    
    if self.descMarkup then
        self.descMarkup:Draw(padding, padding + (self.titleMarkup and self.titleMarkup:GetHeight() or 0) + padding, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
end

derma.DefineControl("OFMessage", "NPC信息区域", PANEL, "DPanel") 