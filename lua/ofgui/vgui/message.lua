local PANEL = {}

function PANEL:Init()
    self:SetExpensiveShadow(1, ColorAlpha(color_black, 140))

    -- 修改为只存储条形的颜色
    self.Color = Color(255, 255, 255)
    
    -- 默认大小
    self:SetSize(300, 64)
    
    -- 初始化标题和描述文本
    self.titleMarkup = nil
    self.descMarkup = nil
    self.footnoteMarkup = nil  -- 新增：脚注markup
    self.titleText = ""    -- 保存原始标题文本
    self.descText = ""     -- 保存原始描述文本
    self.footnoteText = "" -- 新增：保存原始脚注文本
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

function PANEL:SetFootnote(text)
    -- 保存原始文本
    self.footnoteText = text
    -- 使用markup解析脚注文本
    self.footnoteMarkup = markup.Parse("<font=ofgui_tiny>" .. text .. "</font>", self:GetWide() - 8 * OFGUI.ScreenScale)
end

function PANEL:Think()
    if not self.titleMarkup or not self.descMarkup then return end
    
    self.titleMarkup = markup.Parse("<font=ofgui_big>" .. self.titleText .. "</font>", self:GetWide() - 8 * OFGUI.ScreenScale)
    self.descMarkup = markup.Parse("<font=ofgui_medium>" .. self.descText .. "</font>", self:GetWide() - 8 * OFGUI.ScreenScale)
    
    local padding = 6 * OFGUI.ScreenScale
    local totalHeight = self.titleMarkup:GetHeight() + self.descMarkup:GetHeight() + 3 * padding
    
    -- 如果有脚注，增加其高度
    if self.footnoteMarkup then
        totalHeight = totalHeight + self.footnoteMarkup:GetHeight() + padding
    end
    
    self:SetTall(totalHeight)
end

function PANEL:Paint(w, h)
    -- 绘制左侧条形
    local barWidth = 5 * OFGUI.ScreenScale
    draw.RoundedBox(0, 0, 0, barWidth, h, self.Color)
    
    -- 绘制标题和描述文本
    local padding = 6 * OFGUI.ScreenScale
    local paddingleft = 16 * OFGUI.ScreenScale
    
    if self.titleMarkup then
        -- 重新解析标题文本以使用条形颜色
        self.titleMarkup = markup.Parse(string.format("<color=%d,%d,%d,255><font=ofgui_big>%s</font></color>",
            self.Color.r, self.Color.g, self.Color.b, self.titleText))
        self.titleMarkup:Draw(paddingleft + barWidth, padding, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    
    if self.descMarkup then
        self.descMarkup:Draw(paddingleft + barWidth, padding + (self.titleMarkup and self.titleMarkup:GetHeight() or 0) + padding, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    
    -- 绘制脚注文本
    if self.footnoteMarkup then
        local y = padding + (self.titleMarkup and self.titleMarkup:GetHeight() or 0) + padding + (self.descMarkup and self.descMarkup:GetHeight() or 0) + padding
        -- 重新解析脚注为灰色
        self.footnoteMarkup = markup.Parse(string.format("<color=150,150,150,255><font=ofgui_tiny>%s</font></color>", self.footnoteText), self:GetWide() - 8 * OFGUI.ScreenScale)
        self.footnoteMarkup:Draw(paddingleft + barWidth, y, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
end

function PANEL:SetColor(col)
    -- 确保输入是一个有效的Color对象
    if not col or not col.r or not col.g or not col.b then return end
    self.Color = Color(col.r, col.g, col.b)
end

derma.DefineControl("OFMessage", "NPC信息区域", PANEL, "DPanel") 