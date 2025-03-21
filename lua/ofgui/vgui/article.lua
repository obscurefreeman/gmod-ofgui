local PANEL = {}

function PANEL:Init()
    self:SetExpensiveShadow(1, ColorAlpha(color_black, 140))
    
    -- 默认大小
    self:SetSize(300, 64)
    
    -- 初始化标题和描述文本
    self.titleMarkup = nil
    self.subtitleMarkup = nil  -- 新增副标题
    self.descMarkup = nil
    self.titleText = ""    -- 保存原始标题文本
    self.subtitleText = "" -- 保存原始副标题文本
    self.descText = ""     -- 保存原始描述文本

    -- 添加图片控件
    self.Image = vgui.Create("DImage", self)
    self.Image:SetVisible(false)
    self.ImagePadding = 6 * OFGUI.ScreenScale

    -- 添加背景颜色和圆角属性
    self.Color = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
    self.CornerRadius = 6 * OFGUI.ScreenScale
    self.FrameBlur = true
end

function PANEL:SetName(text)
    -- 保存原始文本
    self.titleText = text
    -- 使用markup解析标题文本，固定为白色
    self.titleMarkup = markup.Parse("<color=255,255,255,255><font=ofgui_eva>" .. text .. "</font></color>")
end

function PANEL:SetSubtitle(text)
    -- 保存原始文本
    self.subtitleText = text
    -- 使用markup解析副标题文本
    self.subtitleMarkup = markup.Parse("<color=200,200,200,255><font=ofgui_small>" .. text .. "</font></color>", self:GetWide() - 8 * OFGUI.ScreenScale)
end

function PANEL:SetText(text)
    -- 保存原始文本
    self.descText = text
    -- 使用markup解析描述文本
    self.descMarkup = markup.Parse("<font=ofgui_small>" .. text .. "</font>", self:GetWide() - 8 * OFGUI.ScreenScale)
end

function PANEL:SetImage(material)
    if type(material) == "string" then
        material = Material(material)
    end
    self.Image:SetMaterial(material)
    self.Image:SetVisible(true)
end

function PANEL:Think()
    if not self.titleMarkup or not self.descMarkup then return end
    
    self.titleMarkup = markup.Parse("<font=ofgui_eva>" .. self.titleText .. "</font>", self:GetWide() - 40 * OFGUI.ScreenScale)
    self.subtitleMarkup = self.subtitleText ~= "" and markup.Parse("<color=200,200,200,255><font=ofgui_small>" .. self.subtitleText .. "</font>", self:GetWide() - 40 * OFGUI.ScreenScale) or nil
    self.descMarkup = markup.Parse("<font=ofgui_small>" .. self.descText .. "</font>", self:GetWide() - 40 * OFGUI.ScreenScale)
    
    local padding = 20 * OFGUI.ScreenScale
    local imageHeight = self.Image:IsVisible() and self.Image:GetTall() + padding or 0
    local subtitleHeight = self.subtitleMarkup and self.subtitleMarkup:GetHeight() + padding or 0
    local totalHeight = self.titleMarkup:GetHeight() + subtitleHeight + self.descMarkup:GetHeight() + 3 * padding + imageHeight
    self:SetTall(totalHeight)
end

function PANEL:Paint(w, h)
    -- 绘制背景框
    self.PolyMask = surface.PrecacheRoundedRect(0, 0, w, h, self.CornerRadius, 16)

    EZMASK.DrawWithMask(function()
        surface.SetDrawColor(color_white)
        surface.DrawPoly(self.PolyMask)
    end, function()
        if self.FrameBlur then
            surface.DrawPanelBlur(self, 6)
        end
        draw.RoundedBox(self.CornerRadius, 0, 0, w, h, self.Color)
    end)

    -- 绘制标题和描述文本
    local padding = 20 * OFGUI.ScreenScale
    
    if self.titleMarkup then
        self.titleMarkup:Draw(padding, padding, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    
    -- 绘制副标题
    if self.subtitleMarkup then
        local subtitleY = padding + (self.titleMarkup and self.titleMarkup:GetHeight() or 0) + padding / 2
        self.subtitleMarkup:Draw(padding, subtitleY, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    
    -- 绘制图片
    if self.Image:IsVisible() then
        local imageY = padding + (self.titleMarkup and self.titleMarkup:GetHeight() or 0) + padding
        if self.subtitleMarkup then
            imageY = imageY + self.subtitleMarkup:GetHeight() + padding / 2
        end
        local imageW = w - padding * 2
        local mat = self.Image:GetMaterial()
        local imageH = imageW * (mat:Height() / mat:Width())
        self.Image:SetPos(padding, imageY)
        self.Image:SetSize(imageW, imageH)
    end
    
    if self.descMarkup then
        local descY = padding + (self.titleMarkup and self.titleMarkup:GetHeight() or 0) + padding
        if self.subtitleMarkup then
            descY = descY + self.subtitleMarkup:GetHeight() + padding / 2
        end
        if self.Image:IsVisible() then
            descY = descY + self.Image:GetTall() + padding
        end
        self.descMarkup:Draw(padding, descY, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
end

derma.DefineControl("OFArticle", "NPC信息区域", PANEL, "DPanel") 