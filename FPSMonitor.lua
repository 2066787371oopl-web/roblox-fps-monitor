-- 📊 实时FPS显示器 v2.1 增强版
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 🎨 创建主GUI（增强样式）
local fpsGui = Instance.new("ScreenGui")
fpsGui.Name = "RealTimeFPS_Pro"
fpsGui.ResetOnSpawn = false
fpsGui.Parent = playerGui

-- FPS显示容器（带阴影效果）
local fpsContainer = Instance.new("Frame")
fpsContainer.Name = "DisplayContainer"
fpsContainer.Parent = fpsGui
fpsContainer.BackgroundTransparency = 1
fpsContainer.Size = UDim2.new(0, 110, 0, 35)
fpsContainer.Position = UDim2.new(1, -120, 0, 10)
fpsContainer.ZIndex = 99

-- 背景阴影（增强层次感）
local shadow = Instance.new("ImageLabel")
shadow.Name = "ShadowEffect"
shadow.Parent = fpsContainer
shadow.BackgroundTransparency = 1
shadow.Size = UDim2.new(1, 6, 1, 6)
shadow.Position = UDim2.new(0, -3, 0, -3)
shadow.Image = "rbxassetid://1316045217" -- 阴影纹理
shadow.ImageTransparency = 0.6
shadow.ZIndex = 98

-- FPS标签（增强视觉设计）
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSDisplay"
fpsLabel.Parent = fpsContainer
fpsLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
fpsLabel.BackgroundTransparency = 0.2
fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextScaled = true
fpsLabel.Text = "FPS: 60.0"
fpsLabel.TextStrokeTransparency = 0.8
fpsLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
fpsLabel.Size = UDim2.new(1, 0, 1, 0)
fpsLabel.Position = UDim2.new(0, 0, 0, 0)
fpsLabel.ZIndex = 100

-- 高级圆角处理
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = fpsLabel

-- 霓虹灯效果边框
local glow = Instance.new("UIStroke")
glow.Color = Color3.fromRGB(0, 120, 255)
glow.Thickness = 1
glow.Transparency = 0.8
glow.Parent = fpsLabel

-- 性能指示器（带动画过渡）
local function updateFPSVisuals(fps)
    -- 颜色逻辑
    local targetColor, glowColor
    if fps >= 60 then
        targetColor = Color3.fromRGB(40, 167, 69) -- 绿色
        glowColor = Color3.fromRGB(40, 200, 80) -- 霓虹绿
    elseif fps >= 30 then
        targetColor = Color3.fromRGB(255, 193, 7) -- 黄色
        glowColor = Color3.fromRGB(255, 220, 50) -- 霓虹黄
    else
        targetColor = Color3.fromRGB(220, 53, 69) -- 红色
        glowColor = Color3.fromRGB(255, 80, 100) -- 霓虹红
    end

    -- 颜色过渡动画
    TweenService:Create(fpsLabel, TweenInfo.new(0.5), {
        TextColor3 = targetColor
    }):Play()

    -- 霓虹灯效果动画
    TweenService:Create(glow, TweenInfo.new(0.8), {
        Color = glowColor,
        Transparency = fps < 30 and 0.5 or 0.8 -- 卡顿时边框更明显
    }):Play()

    -- 文字大小脉动（低帧率时）
    if fps < 30 then
        TweenService:Create(fpsLabel, TweenInfo.new(0.4), {
            TextScaled = false,
            TextSize = 18
        }):Play()
        wait(0.4)
        TweenService:Create(fpsLabel, TweenInfo.new(0.4), {
            TextScaled = true
        }):Play()
    end
end

-- 🖥️ 核心FPS计算引擎
local lastTime = tick()
local frameCount = 0
local fpsHistory = {} -- 用于平均计算

RunService.RenderStepped:Connect(function()
    frameCount += 1
    local now = tick()
    
    -- 每秒更新一次
    if now - lastTime >= 1 then
        local instantFPS = frameCount / (now - lastTime)
        table.insert(fpsHistory, 1, instantFPS)
        
        -- 保留最近5秒数据计算平均
        if #fpsHistory > 5 then
            table.remove(fpsHistory)
        end
        
        -- 计算加权平均FPS
        local avgFPS = 0
        for i, val in ipairs(fpsHistory) do
            avgFPS += val * (6 - i) -- 越新的数据权重越高
        end
        avgFPS /= 15 -- 总权重归一化
        
        -- 更新显示
        fpsLabel.Text = string.format("FPS: %.1f", avgFPS)
        updateFPSVisuals(avgFPS)
        
        -- 重置计数器
        frameCount = 0
        lastTime = now
    end
end)

-- 📱 智能设备适配
UserInputService.DeviceChanged:Connect(function()
    local isMobile = UserInputService.TouchEnabled
    local isConsole = UserInputService.GamepadEnabled
    
    -- 根据设备类型自动调整布局
    if isMobile then
        fpsContainer.Position = UDim2.new(1, -90, 0, 5)
        fpsContainer.Size = UDim2.new(0, 80, 0, 25)
        glow.Thickness = 1.5 -- 移动端更粗的边框
    elseif isConsole then
        fpsContainer.Position = UDim2.new(0.5, -55, 1, -40) -- 底部居中
        glow.Color = Color3.fromRGB(255, 255, 255) -- 主机平台白色主题
    else
        -- 默认PC布局
    end
end)

-- 初始化设备检测
if UserInputService.TouchEnabled then
    fpsContainer.Position = UDim2.new(1, -90, 0, 5)
    fpsContainer.Size = UDim2.new(0, 80, 0, 25)
end

print("🚀 增强版FPS显示器已加载！自适应多平台显示")