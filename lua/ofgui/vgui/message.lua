local PANEL = {}

function PANEL:Init()
    self:SetExpensiveShadow(1, ColorAlpha(color_black, 140))

    self.Color = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
    
    -- 默认文本
    self.Title = ""
    self.Description = ""
    
    -- 默认大小
    self:SetSize(300, 64)
end

function PANEL:SetName(text)
    self.Title = text
end

function PANEL:SetText(text)
    self.Description = text
end

function PANEL:Paint(w, h)
    -- 绘制背景
    draw.RoundedBox(0, 0, 0, w, h, self.Color)
    
    -- 计算文本高度
    local titleHeight = draw.GetFontHeight("ofgui_big")
    local descHeight = draw.GetFontHeight("ofgui_medium")
    local totalTextHeight = titleHeight + descHeight + 5 * OFGUI.ScreenScale  -- 5是标题和描述之间的间距
    
    -- 计算整体文本块的起始Y坐标，使其垂直居中
    local startY = (h - totalTextHeight) / 2
    
    -- 文本X坐标调整
    local titleX = 8 * OFGUI.ScreenScale
    
    -- 绘制标题和描述
    draw.SimpleText(self.Title, "ofgui_big", titleX, startY, OFGUI.ButtonTextColor)
    draw.SimpleText(self.Description, "ofgui_medium", titleX, startY + titleHeight + 5, OFGUI.ButtonTextColor)
end

derma.DefineControl("OFMessage", "NPC信息区域", PANEL, "DPanel") 