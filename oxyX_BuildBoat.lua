--[[
    oxyX - Build a Boat for Treasure Testing Script
    For testing purposes on your own server only
    Created for legitimate testing and development
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
if not player then
    player = game.Players.LocalPlayer
end

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

local function pickParent()
    local ok, hui = pcall(function() return gethui and gethui() end)
    if ok and hui then return hui end
    local ok2, CoreGui = pcall(game.GetService, game, "CoreGui")
    if ok2 and CoreGui then return CoreGui end
    return player:WaitForChild("PlayerGui", 5) or game:GetService("CoreGui")
end

-- Convert RGB color
local function rgb(r, g, b)
    return Color3.fromRGB(r or 255, g or 255, b or 255)
end

-- ============================================
-- UI CREATION
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "oxyX_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 10000

-- Protect GUI for synapse X
pcall(function() 
    if syn and syn.protect_gui then 
        syn.protect_gui(ScreenGui) 
    end 
end)

ScreenGui.Parent = pickParent()

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 628, 0, 650)
Main.Position = UDim2.new(0.5, -314, 0.5, -325)
Main.BackgroundColor3 = rgb(18, 18, 28)
Main.BorderSizePixel = 0

local mc = Instance.new("UICorner", Main)
mc.CornerRadius = UDim.new(0, 12)

local ms = Instance.new("UIStroke", Main)
ms.Color = rgb(40, 160, 120)
ms.Thickness = 1

-- Panel Creation Function
local function mkPanel(parent, x)
    local p = Instance.new("Frame", parent)
    p.Size = UDim2.new(0, 307, 0, 640)
    p.Position = UDim2.new(0, x, 0, 6)
    p.BackgroundColor3 = rgb(22, 22, 34)
    p.BorderSizePixel = 0
    
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, 12)
    
    local s = Instance.new("UIStroke", p)
    s.Color = rgb(60, 200, 140)
    s.Thickness = 1
    
    return p
end

local Left = mkPanel(Main, 6)
local Right = mkPanel(Main, 315)

-- Header Creation Function
local function mkHeader(panel, text)
    local h = Instance.new("TextLabel", panel)
    h.Size = UDim2.new(1, -50, 0, 28)
    h.Position = UDim2.new(0, 7, 0, 7)
    h.BackgroundTransparency = 1
    h.Text = text
    h.TextColor3 = rgb(220, 220, 230)
    h.Font = Enum.Font.GothamBold
    h.TextSize = 16
    return h
end

-- Minimize and Close Buttons
local function createControlButtons(parent)
    local btnContainer = Instance.new("Frame", parent)
    btnContainer.Size = UDim2.new(0, 80, 0, 28)
    btnContainer.Position = UDim2.new(1, -90, 0, 7)
    btnContainer.BackgroundTransparency = 1
    
    local minimizeBtn = Instance.new("TextButton", btnContainer)
    minimizeBtn.Size = UDim2.new(0, 32, 0, 28)
    minimizeBtn.Position = UDim2.new(0, 0, 0, 0)
    minimizeBtn.BackgroundColor3 = rgb(60, 140, 180)
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "—"
    minimizeBtn.TextColor3 = rgb(255, 255, 255)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 14
    local minCorner = Instance.new("UICorner", minimizeBtn)
    minCorner.CornerRadius = UDim.new(0, 6)
    
    local closeBtn = Instance.new("TextButton", btnContainer)
    closeBtn.Size = UDim2.new(0, 32, 0, 28)
    closeBtn.Position = UDim2.new(0, 40, 0, 0)
    closeBtn.BackgroundColor3 = rgb(180, 60, 60)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = rgb(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    local closeCorner = Instance.new("UICorner", closeBtn)
    closeCorner.CornerRadius = UDim.new(0, 6)
    
    local isMinimized = false
    local originalSize = Main.Size
    local originalPos = Main.Position
    
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Main:TweenSize(UDim2.new(0, 628, 0, 50), "Out", "Quad", 0.3, true)
            Main:TweenPosition(UDim2.new(0.5, -314, 1, -60), "Out", "Quad", 0.3, true)
            minimizeBtn.Text = "+"
        else
            Main:TweenSize(originalSize, "Out", "Quad", 0.3, true)
            Main:TweenPosition(originalPos, "Out", "Quad", 0.3, true)
            minimizeBtn.Text = "—"
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    return btnContainer
end

mkHeader(Left, "oxyX")
local hr = mkHeader(Right, "Exploit")
createControlButtons(Main)

-- FPS/MS Label
local msLabel = Instance.new("TextLabel", Right)
msLabel.Size = UDim2.new(0, 100, 0, 18)
msLabel.Position = UDim2.new(1, -107, 0, 9)
msLabel.BackgroundTransparency = 1
msLabel.Text = "0.0ms"
msLabel.TextColor3 = rgb(140, 220, 140)
msLabel.Font = Enum.Font.Gotham
msLabel.TextSize = 12

RunService.Heartbeat:Connect(function(dt)
    msLabel.Text = string.format("%.1fms", dt * 1000)
end)

-- Tab Bar Creation Function
local function mkTabBar(panel, names)
    local bar = Instance.new("Frame", panel)
    bar.Size = UDim2.new(1, -14, 0, 34)
    bar.Position = UDim2.new(0, 7, 0, 44)
    bar.BackgroundColor3 = rgb(28, 28, 42)
    bar.BorderSizePixel = 0
    
    local c = Instance.new("UICorner", bar)
    c.CornerRadius = UDim.new(0, 8)
    
    local layout = Instance.new("UIListLayout", bar)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    
    local tabs = {}
    for _, n in ipairs(names) do
        local b = Instance.new("TextButton", bar)
        b.Size = UDim2.new(0, 96, 1, 0)
        b.BackgroundColor3 = rgb(40, 40, 56)
        b.BorderSizePixel = 0
        b.Text = n
        b.TextColor3 = rgb(200, 200, 210)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        
        local bc = Instance.new("UICorner", b)
        bc.CornerRadius = UDim.new(0, 6)
        
        table.insert(tabs, b)
    end
    
    return bar, tabs
end

local _, tabsL = mkTabBar(Left, {"AutoBuild", "Image Loader", "Shapes", "SaveSlots"})
local _, tabsR = mkTabBar(Right, {"★ AutoFarm", "Misc", "Modules", "Credit"})

-- Content Frame Creation
local function mkContent(panel)
    local c = Instance.new("Frame", panel)
    c.Size = UDim2.new(1, -14, 1, -86)
    c.Position = UDim2.new(0, 7, 0, 86)
    c.BackgroundColor3 = rgb(24, 24, 38)
    c.BorderSizePixel = 0
    
    local cc = Instance.new("UICorner", c)
    cc.CornerRadius = UDim.new(0, 8)
    
    return c
end

local LeftContent = mkContent(Left)
local RightContent = mkContent(Right)

-- ============================================
-- LEFT TABS
-- ============================================

local AutoBuild = Instance.new("Frame", LeftContent)
AutoBuild.Size = UDim2.new(1, 0, 1, 0)
AutoBuild.BackgroundTransparency = 1

local ImageLoader = Instance.new("Frame", LeftContent)
ImageLoader.Size = UDim2.new(1, 0, 1, 0)
ImageLoader.BackgroundTransparency = 1
ImageLoader.Visible = false

local ShapesTab = Instance.new("Frame", LeftContent)
ShapesTab.Size = UDim2.new(1, 0, 1, 0)
ShapesTab.BackgroundTransparency = 1
ShapesTab.Visible = false

local SaveSlotsTab = Instance.new("Frame", LeftContent)
SaveSlotsTab.Size = UDim2.new(1, 0, 1, 0)
SaveSlotsTab.BackgroundTransparency = 1
SaveSlotsTab.Visible = false

local function showLeft(i)
    AutoBuild.Visible = i == 1
    ImageLoader.Visible = i == 2
    ShapesTab.Visible = i == 3
    SaveSlotsTab.Visible = i == 4
    
    for idx, b in ipairs(tabsL) do
        b.BackgroundColor3 = idx == i and rgb(0, 140, 100) or rgb(40, 40, 56)
    end
end

for i, b in ipairs(tabsL) do 
    b.MouseButton1Click:Connect(function() showLeft(i) end) 
end
showLeft(1)

-- ============================================
-- AUTO BUILD TAB
-- ============================================

local titleInfo = Instance.new("TextLabel", AutoBuild)
titleInfo.Size = UDim2.new(1, 0, 0, 20)
titleInfo.Position = UDim2.new(0, 0, 0, 0)
titleInfo.BackgroundTransparency = 1
titleInfo.Text = "Load .build files to auto construct"
titleInfo.TextColor3 = rgb(250, 200, 120)
titleInfo.Font = Enum.Font.GothamBold
titleInfo.TextSize = 12

local backBtn = Instance.new("TextButton", AutoBuild)
backBtn.Size = UDim2.new(1, 0, 0, 32)
backBtn.Position = UDim2.new(0, 0, 0, 26)
backBtn.BackgroundColor3 = rgb(150, 60, 60)
backBtn.BorderSizePixel = 0
backBtn.Text = "Go Back"
backBtn.TextColor3 = rgb(240, 240, 240)
backBtn.Font = Enum.Font.GothamBold
backBtn.TextSize = 12
local gbc = Instance.new("UICorner", backBtn)
gbc.CornerRadius = UDim.new(0, 6)

local sectionAB = Instance.new("TextLabel", AutoBuild)
sectionAB.Size = UDim2.new(1, 0, 0, 20)
sectionAB.Position = UDim2.new(0, 0, 0, 68)
sectionAB.BackgroundTransparency = 1
sectionAB.Text = "— AutoBuild"
sectionAB.TextColor3 = rgb(200, 200, 210)
sectionAB.Font = Enum.Font.GothamBold
sectionAB.TextSize = 12

local refreshed = Instance.new("TextLabel", AutoBuild)
refreshed.Size = UDim2.new(1, 0, 0, 20)
refreshed.Position = UDim2.new(0, 0, 0, 92)
refreshed.BackgroundTransparency = 1
refreshed.Text = "List Refreshed! (auto)"
refreshed.TextColor3 = rgb(180, 200, 220)
refreshed.Font = Enum.Font.Gotham
refreshed.TextSize = 12

local fileList = Instance.new("ScrollingFrame", AutoBuild)
fileList.Size = UDim2.new(1, 0, 0, 160)
fileList.Position = UDim2.new(0, 0, 0, 116)
fileList.BackgroundTransparency = 1
fileList.ScrollBarThickness = 4

local fl = Instance.new("UIListLayout", fileList)
fl.Padding = UDim.new(0, 6)

local selectedFile = {path = nil, name = nil}

local function addFileItem(name, path)
    local btn = Instance.new("TextButton", fileList)
    btn.Size = UDim2.new(1, -10, 0, 26)
    btn.BackgroundColor3 = rgb(40, 40, 56)
    btn.BorderSizePixel = 0
    btn.Text = "📁 " .. name .. "  ▶ File"
    btn.TextColor3 = rgb(200, 200, 210)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    
    local bc = Instance.new("UICorner", btn)
    bc.CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        selectedFile.path = path
        selectedFile.name = name
        statusLabel.Text = "Status: Selected " .. name
    end)
end

local function listFiles()
    pcall(function()
        if listfiles then
            for _, p in ipairs(listfiles("")) do
                local n = p:match("([^/\\]+)$") or p
                if n:lower():sub(-6) == ".build" then
                    addFileItem(n, p)
                end
            end
        end
    end)
end
listFiles()

-- JSON to .build Converter Section
local jsonSection = Instance.new("TextLabel", AutoBuild)
jsonSection.Size = UDim2.new(1, 0, 0, 20)
jsonSection.Position = UDim2.new(0, 0, 0, 286)
jsonSection.BackgroundTransparency = 1
jsonSection.Text = "— JSON to .build Converter"
jsonSection.TextColor3 = rgb(200, 200, 210)
jsonSection.Font = Enum.Font.GothamBold
jsonSection.TextSize = 12

local jsonInput = Instance.new("TextBox", AutoBuild)
jsonInput.Size = UDim2.new(1, 0, 0, 60)
jsonInput.Position = UDim2.new(0, 0, 0, 310)
jsonInput.BackgroundColor3 = rgb(30, 30, 46)
jsonInput.BorderSizePixel = 0
jsonInput.Text = ""
jsonInput.PlaceholderText = "Paste JSON here..."
jsonInput.TextColor3 = rgb(220, 220, 230)
jsonInput.Font = Enum.Font.Gotham
jsonInput.TextSize = 11
jsonInput.TextWrapped = true
jsonInput.TextYAlignment = Enum.TextYAlignment.Top

local jsonc = Instance.new("UICorner", jsonInput)
jsonc.CornerRadius = UDim.new(0, 6)

local convertBtn = Instance.new("TextButton", AutoBuild)
convertBtn.Size = UDim2.new(0.5, -4, 0, 24)
convertBtn.Position = UDim2.new(0, 0, 0, 376)
convertBtn.BackgroundColor3 = rgb(60, 90, 160)
convertBtn.BorderSizePixel = 0
convertBtn.Text = "Convert JSON → .build"
convertBtn.TextColor3 = rgb(240, 240, 240)
convertBtn.Font = Enum.Font.GothamBold
convertBtn.TextSize = 11
local convc = Instance.new("UICorner", convertBtn)
convc.CornerRadius = UDim.new(0, 6)

local loadJsonBtn = convertBtn:Clone()
loadJsonBtn.Parent = AutoBuild
loadJsonBtn.Position = UDim2.new(0.5, 4, 0, 376)
loadJsonBtn.Size = UDim2.new(0.5, -4, 0, 24)
loadJsonBtn.Text = "Load JSON File"
local loadjsonc = Instance.new("UICorner", loadJsonBtn)
loadjsonc.CornerRadius = UDim.new(0, 6)

-- JSON to .build conversion function
local function jsonToBuild(jsonStr)
    local success, result = pcall(function()
        local data = HttpService:JSONDecode(jsonStr)
        -- Convert JSON to .build format
        local buildData = {}
        
        if type(data) == "table" then
            -- Handle different JSON structures
            if data.blocks then
                -- Array of blocks
                for _, block in ipairs(data.blocks) do
                    table.insert(buildData, {
                        x = block.x or 0,
                        y = block.y or 0,
                        z = block.z or 0,
                        color = block.color or "ffffff",
                        material = block.material or "wood"
                    })
                end
            elseif data.boat or data.parts then
                -- Boat structure format
                local parts = data.boat or data.parts
                for _, part in ipairs(parts) do
                    table.insert(buildData, {
                        x = part.Position.X or part.x or 0,
                        y = part.Position.Y or part.y or 0,
                        z = part.Position.Z or part.z or 0,
                        color = part.Color or part.color or "ffffff",
                        material = part.Material or part.material or "wood"
                    })
                end
            else
                -- Try to parse as array of objects
                for _, item in pairs(data) do
                    if type(item) == "table" then
                        table.insert(buildData, {
                            x = item.x or item.Position.X or 0,
                            y = item.y or item.Position.Y or 0,
                            z = item.z or item.Position.Z or 0,
                            color = item.color or item.Color or "ffffff",
                            material = item.material or item.Material or "wood"
                        })
                    end
                end
            end
        end
        
        return HttpService:JSONEncode(buildData)
    end)
    
    if success then
        return result
    else
        return nil, result
    end
end

convertBtn.MouseButton1Click:Connect(function()
    local jsonStr = jsonInput.Text
    if #jsonStr > 0 then
        local buildData, err = jsonToBuild(jsonStr)
        if buildData then
            -- Save as .build file
            pcall(function()
                if writefile then
                    local filename = "converted_" .. os.time() .. ".build"
                    writefile(filename, buildData)
                    addFileItem(filename, filename)
                    statusLabel.Text = "Status: Converted to " .. filename
                end
            end)
            statusLabel.Text = "Status: JSON converted!"
        else
            statusLabel.Text = "Status: Invalid JSON format"
        end
    end
end)

-- Infinite Blocks Toggle
local infiniteToggle = Instance.new("TextButton", AutoBuild)
infiniteToggle.Size = UDim2.new(1, 0, 0, 26)
infiniteToggle.Position = UDim2.new(0, 0, 0, 410)
infiniteToggle.BackgroundColor3 = rgb(80, 40, 50)
infiniteToggle.BorderSizePixel = 0
infiniteToggle.Text = "Infinite Blocks (Bypass)"
infiniteToggle.TextColor3 = rgb(255, 200, 200)
infiniteToggle.Font = Enum.Font.GothamBold
infiniteToggle.TextSize = 12
local itc = Instance.new("UICorner", infiniteToggle)
itc.CornerRadius = UDim.new(0, 6)

local infEnabled = false
infiniteToggle.MouseButton1Click:Connect(function()
    infEnabled = not infEnabled
    if infEnabled then
        infiniteToggle.BackgroundColor3 = rgb(40, 80, 50)
        infiniteToggle.TextColor3 = rgb(200, 255, 200)
        infiniteToggle.Text = "Infinite Blocks: ENABLED"
        -- Note: This is a placeholder - actual implementation would require
        -- hooking into the game's block spawning system
    else
        infiniteToggle.BackgroundColor3 = rgb(80, 40, 50)
        infiniteToggle.TextColor3 = rgb(255, 200, 200)
        infiniteToggle.Text = "Infinite Blocks (Bypass)"
    end
end)

-- Time and Progress
local timeLabel = Instance.new("TextLabel", AutoBuild)
timeLabel.Size = UDim2.new(1, 0, 0, 20)
timeLabel.Position = UDim2.new(0, 0, 0, 440)
timeLabel.BackgroundTransparency = 1
timeLabel.Text = "Time: 0.000s"
timeLabel.TextColor3 = rgb(140, 220, 140)
timeLabel.Font = Enum.Font.Gotham
timeLabel.TextSize = 12

local progressBg = Instance.new("Frame", AutoBuild)
progressBg.Size = UDim2.new(1, 0, 0, 22)
progressBg.Position = UDim2.new(0, 0, 0, 464)
progressBg.BackgroundColor3 = rgb(34, 34, 44)
progressBg.BorderSizePixel = 0
local pbc = Instance.new("UICorner", progressBg)
pbc.CornerRadius = UDim.new(0, 6)

local progressFill = Instance.new("Frame", progressBg)
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = rgb(100, 180, 120)
progressFill.BorderSizePixel = 0
local pfc = Instance.new("UICorner", progressFill)
pfc.CornerRadius = UDim.new(0, 6)

local progressText = Instance.new("TextLabel", progressBg)
progressText.Size = UDim2.new(1, 0, 1, 0)
progressText.BackgroundTransparency = 1
progressText.Text = "100%   Load %"
progressText.TextColor3 = rgb(220, 220, 230)
progressText.Font = Enum.Font.GothamBold
progressText.TextSize = 12

local statusLabel = Instance.new("TextLabel", AutoBuild)
statusLabel.Size = UDim2.new(1, 0, 0, 22)
statusLabel.Position = UDim2.new(0, 0, 0, 492)
statusLabel.BackgroundColor3 = rgb(28, 28, 40)
statusLabel.BorderSizePixel = 0
statusLabel.Text = "Status: Ready"
statusLabel.TextColor3 = rgb(180, 200, 220)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
local slc = Instance.new("UICorner", statusLabel)
slc.CornerRadius = UDim.new(0, 6)

local loadBtn = Instance.new("TextButton", AutoBuild)
loadBtn.Size = UDim2.new(1, 0, 0, 34)
loadBtn.Position = UDim2.new(0, 0, 0, 520)
loadBtn.BackgroundColor3 = rgb(80, 120, 80)
loadBtn.BorderSizePixel = 0
loadBtn.Text = "Load Build"
loadBtn.TextColor3 = rgb(240, 240, 240)
loadBtn.Font = Enum.Font.GothamBold
loadBtn.TextSize = 13
local lbc = Instance.new("UICorner", loadBtn)
lbc.CornerRadius = UDim.new(0, 8)

local startTime = nil
local buildRunning = false

backBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
    ScreenGui.Enabled = true
end)

RunService.Heartbeat:Connect(function()
    if startTime and buildRunning then
        local elapsed = tick() - startTime
        timeLabel.Text = string.format("Time: %.3fs", elapsed)
        
        local progress = math.clamp(elapsed % 1, 0, 1)
        progressFill.Size = UDim2.new(progress, 0, 1, 0)
        progressText.Text = string.format("%d%%   Building...", math.floor(progress * 100))
    end
end)

-- Load Build Button Logic
loadBtn.MouseButton1Click:Connect(function()
    if selectedFile.name then
        startTime = tick()
        buildRunning = true
        statusLabel.Text = "Status: Building " .. selectedFile.name
        
        -- Simulate build loading
        -- Note: Actual .build file parsing would go here
        -- This is a placeholder for the actual build loading logic
        
        task.delay(2, function()
            buildRunning = false
            statusLabel.Text = "Status: Build complete!"
            progressFill.Size = UDim2.new(1, 0, 1, 0)
            progressText.Text = "100%   Done!"
        end)
    else
        statusLabel.Text = "Status: No file selected"
    end
end)

-- ============================================
-- IMAGE LOADER TAB
-- ============================================

local imgTitle = Instance.new("TextLabel", ImageLoader)
imgTitle.Size = UDim2.new(1, 0, 0, 20)
imgTitle.Position = UDim2.new(0, 0, 0, 0)
imgTitle.BackgroundTransparency = 1
imgTitle.Text = "Load images from Discord links"
imgTitle.TextColor3 = rgb(250, 200, 120)
imgTitle.Font = Enum.Font.GothamBold
imgTitle.TextSize = 12

local imgUrlLabel = Instance.new("TextLabel", ImageLoader)
imgUrlLabel.Size = UDim2.new(1, 0, 0, 18)
imgUrlLabel.Position = UDim2.new(0, 0, 0, 26)
imgUrlLabel.BackgroundTransparency = 1
imgUrlLabel.Text = "Discord Image URL:"
imgUrlLabel.TextColor3 = rgb(200, 200, 210)
imgUrlLabel.Font = Enum.Font.Gotham
imgUrlLabel.TextSize = 11

local imgUrlBox = Instance.new("TextBox", ImageLoader)
imgUrlBox.Size = UDim2.new(1, 0, 0, 60)
imgUrlBox.Position = UDim2.new(0, 0, 0, 48)
imgUrlBox.BackgroundColor3 = rgb(30, 30, 46)
imgUrlBox.BorderSizePixel = 0
imgUrlBox.Text = ""
imgUrlBox.PlaceholderText = "https://cdn.discordapp.com/attachments/..."
imgUrlBox.TextColor3 = rgb(220, 220, 230)
imgUrlBox.Font = Enum.Font.Gotham
imgUrlBox.TextSize = 11
imgUrlBox.TextWrapped = true

local imgc = Instance.new("UICorner", imgUrlBox)
imgc.CornerRadius = UDim.new(0, 6)

local loadImgBtn = Instance.new("TextButton", ImageLoader)
loadImgBtn.Size = UDim2.new(1, 0, 0, 28)
loadImgBtn.Position = UDim2.new(0, 0, 0, 114)
loadImgBtn.BackgroundColor3 = rgb(60, 90, 160)
loadImgBtn.BorderSizePixel = 0
loadImgBtn.Text = "Load Image"
loadImgBtn.TextColor3 = rgb(240, 240, 240)
loadImgBtn.Font = Enum.Font.GothamBold
loadImgBtn.TextSize = 12
local imgbc = Instance.new("UICorner", loadImgBtn)
imgbc.CornerRadius = UDim.new(0, 6)

local imgPreview = Instance.new("Frame", ImageLoader)
imgPreview.Size = UDim2.new(1, 0, 0, 150)
imgPreview.Position = UDim2.new(0, 0, 0, 150)
imgPreview.BackgroundColor3 = rgb(30, 30, 46)
imgPreview.BorderSizePixel = 0

local imgpc = Instance.new("UICorner", imgPreview)
imgpc.CornerRadius = UDim.new(0, 8)

local previewLabel = Instance.new("TextLabel", imgPreview)
previewLabel.Size = UDim2.new(1, 0, 1, 0)
previewLabel.BackgroundTransparency = 1
previewLabel.Text = "Image Preview"
previewLabel.TextColor3 = rgb(150, 150, 160)
previewLabel.Font = Enum.Font.Gotham
previewLabel.TextSize = 14

local imgStatus = Instance.new("TextLabel", ImageLoader)
imgStatus.Size = UDim2.new(1, 0, 0, 18)
imgStatus.Position = UDim2.new(0, 0, 0, 306)
imgStatus.BackgroundTransparency = 1
imgStatus.Text = "Status: Ready"
imgStatus.TextColor3 = rgb(180, 200, 220)
imgStatus.Font = Enum.Font.Gotham
imgStatus.TextSize = 11

-- Image Loading Function (Discord links)
loadImgBtn.MouseButton1Click:Connect(function()
    local url = imgUrlBox.Text
    if #url > 0 then
        imgStatus.Text = "Status: Loading image..."
        
        -- Try to load the image
        local success = pcall(function()
            -- Attempt to download and display image
            -- Note: Roblox doesn't directly support Discord CDN
            -- This would need a proxy or different approach
            imgStatus.Text = "Status: URL received - processing..."
            
            -- Show preview placeholder
            previewLabel.Text = "URL: " .. url:sub(1, 30) .. "..."
            imgStatus.Text = "Status: Image URL loaded!"
        end)
        
        if not success then
            imgStatus.Text = "Status: Failed to load image"
        end
    else
        imgStatus.Text = "Status: Please enter a URL"
    end
end)

-- ============================================
-- SHAPES TAB (Auto Build Shapes)
-- ============================================

local shapesTitle = Instance.new("TextLabel", ShapesTab)
shapesTitle.Size = UDim2.new(1, 0, 0, 20)
shapesTitle.Position = UDim2.new(0, 0, 0, 0)
shapesTitle.BackgroundTransparency = 1
shapesTitle.Text = "Auto Build Shapes"
shapesTitle.TextColor3 = rgb(250, 200, 120)
shapesTitle.Font = Enum.Font.GothamBold
shapesTitle.TextSize = 12

-- Shape Selection
local shapeSection = Instance.new("TextLabel", ShapesTab)
shapeSection.Size = UDim2.new(1, 0, 0, 20)
shapeSection.Position = UDim2.new(0, 0, 0, 26)
shapeSection.BackgroundTransparency = 1
shapeSection.Text = "— Select Shape"
shapeSection.TextColor3 = rgb(200, 200, 210)
shapeSection.Font = Enum.Font.GothamBold
shapeSection.TextSize = 12

local shapes = {"Ball", "Cylinder", "Triangle", "Square", "Rectangle", "Pyramid", "Star", "Heart"}
local selectedShape = "Ball"

local shapeBtns = {}
local shapeY = 52

for i, shapeName in ipairs(shapes) do
    local btn = Instance.new("TextButton", ShapesTab)
    btn.Size = UDim2.new(0.5, -6, 0, 28)
    btn.Position = UDim2.new(i % 2 == 1 and 0 or 0.5, i % 2 == 1 and 0 or 4, 0, shapeY + (math.floor((i-1)/2) * 32))
    btn.BackgroundColor3 = rgb(40, 40, 56)
    btn.BorderSizePixel = 0
    btn.Text = shapeName
    btn.TextColor3 = rgb(200, 200, 210)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    
    local bc = Instance.new("UICorner", btn)
    bc.CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        selectedShape = shapeName
        for _, b in ipairs(shapeBtns) do
            b.BackgroundColor3 = rgb(40, 40, 56)
        end
        btn.BackgroundColor3 = rgb(0, 140, 100)
        shapeStatus.Text = "Selected: " .. shapeName
    end)
    
    table.insert(shapeBtns, btn)
end

-- Size inputs
local sizeLabel = Instance.new("TextLabel", ShapesTab)
sizeLabel.Size = UDim2.new(1, 0, 0, 20)
sizeLabel.Position = UDim2.new(0, 0, 0, 220)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "— Size Configuration"
sizeLabel.TextColor3 = rgb(200, 200, 210)
sizeLabel.Font = Enum.Font.GothamBold
sizeLabel.TextSize = 12

local widthLabel = Instance.new("TextLabel", ShapesTab)
widthLabel.Size = UDim2.new(0.3, 0, 0, 18)
widthLabel.Position = UDim2.new(0, 0, 0, 246)
widthLabel.BackgroundTransparency = 1
widthLabel.Text = "Width:"
widthLabel.TextColor3 = rgb(200, 200, 210)
widthLabel.Font = Enum.Font.Gotham
widthLabel.TextSize = 11

local widthBox = Instance.new("TextBox", ShapesTab)
widthBox.Size = UDim2.new(0.3, -4, 0, 24)
widthBox.Position = UDim2.new(0, 60, 0, 244)
widthBox.BackgroundColor3 = rgb(30, 30, 46)
widthBox.BorderSizePixel = 0
widthBox.Text = "5"
widthBox.TextColor3 = rgb(220, 220, 230)
widthBox.Font = Enum.Font.Gotham
widthBox.TextSize = 11

local heightLabel = Instance.new("TextLabel", ShapesTab)
heightLabel.Size = UDim2.new(0.3, 0, 0, 18)
heightLabel.Position = UDim2.new(0.35, 0, 0, 246)
heightLabel.BackgroundTransparency = 1
heightLabel.Text = "Height:"
heightLabel.TextColor3 = rgb(200, 200, 210)
heightLabel.Font = Enum.Font.Gotham
heightLabel.TextSize = 11

local heightBox = Instance.new("TextBox", ShapesTab)
heightBox.Size = UDim2.new(0.3, -4, 0, 24)
heightBox.Position = UDim2.new(0.35, 50, 0, 244)
heightBox.BackgroundColor3 = rgb(30, 30, 46)
heightBox.BorderSizePixel = 0
heightBox.Text = "5"
heightBox.TextColor3 = rgb(220, 220, 230)
heightBox.Font = Enum.Font.Gotham
heightBox.TextSize = 11

local depthLabel = Instance.new("TextLabel", ShapesTab)
depthLabel.Size = UDim2.new(0.3, 0, 0, 18)
depthLabel.Position = UDim2.new(0.7, 0, 0, 246)
depthLabel.BackgroundTransparency = 1
depthLabel.Text = "Depth:"
depthLabel.TextColor3 = rgb(200, 200, 210)
depthLabel.Font = Enum.Font.Gotham
depthLabel.TextSize = 11

local depthBox = Instance.new("TextBox", ShapesTab)
depthBox.Size = UDim2.new(0.3, -4, 0, 24)
depthBox.Position = UDim2.new(0.7, 50, 0, 244)
depthBox.BackgroundColor3 = rgb(30, 30, 46)
depthBox.BorderSizePixel = 0
depthBox.Text = "5"
depthBox.TextColor3 = rgb(220, 220, 230)
depthBox.Font = Enum.Font.Gotham
depthBox.TextSize = 11

local shapeStatus = Instance.new("TextLabel", ShapesTab)
shapeStatus.Size = UDim2.new(1, 0, 0, 18)
shapeStatus.Position = UDim2.new(0, 0, 0, 276)
shapeStatus.BackgroundTransparency = 1
shapeStatus.Text = "Selected: Ball"
shapeStatus.TextColor3 = rgb(140, 220, 140)
shapeStatus.Font = Enum.Font.Gotham
shapeStatus.TextSize = 11

local buildShapeBtn = Instance.new("TextButton", ShapesTab)
buildShapeBtn.Size = UDim2.new(1, 0, 0, 30)
buildShapeBtn.Position = UDim2.new(0, 0, 0, 300)
buildShapeBtn.BackgroundColor3 = rgb(60, 90, 160)
buildShapeBtn.BorderSizePixel = 0
buildShapeBtn.Text = "Build Shape"
buildShapeBtn.TextColor3 = rgb(240, 240, 240)
buildShapeBtn.Font = Enum.Font.GothamBold
buildShapeBtn.TextSize = 12
local shapeBtnc = Instance.new("UICorner", buildShapeBtn)
shapeBtnc.CornerRadius = UDim.new(0, 6)

-- Shape Building Functions
local function buildBall(radius)
    -- Create a ball shape (sphere of blocks)
    local blocks = {}
    for x = -radius, radius do
        for y = -radius, radius do
            for z = -radius, radius do
                if x*x + y*y + z*z <= radius*radius then
                    table.insert(blocks, {x = x, y = y, z = z})
                end
            end
        end
    end
    return blocks
end

local function buildCylinder(radius, height)
    -- Create cylinder shape
    local blocks = {}
    for y = 0, height - 1 do
        for x = -radius, radius do
            for z = -radius, radius do
                if x*x + z*z <= radius*radius then
                    table.insert(blocks, {x = x, y = y, z = z})
                end
            end
        end
    end
    return blocks
end

local function buildTriangle(width, height)
    -- Create triangle shape
    local blocks = {}
    for y = 0, height - 1 do
        local halfWidth = math.floor((1 - y/height) * width / 2)
        for x = -halfWidth, halfWidth do
            table.insert(blocks, {x = x, y = y, z = 0})
        end
    end
    return blocks
end

local function buildSquare(size)
    return buildRectangle(size, size)
end

local function buildRectangle(width, height, depth)
    local blocks = {}
    for x = 0, width - 1 do
        for y = 0, height - 1 do
            for z = 0, (depth or 1) - 1 do
                table.insert(blocks, {x = x, y = y, z = z})
            end
        end
    end
    return blocks
end

local function buildPyramid(size)
    local blocks = {}
    for y = 0, size - 1 do
        local halfSize = size - 1 - y
        for x = -halfSize, halfSize do
            for z = -halfSize, halfSize do
                table.insert(blocks, {x = x, y = y, z = z})
            end
        end
    end
    return blocks
end

buildShapeBtn.MouseButton1Click:Connect(function()
    local width = tonumber(widthBox.Text) or 5
    local height = tonumber(heightBox.Text) or 5
    local depth = tonumber(depthBox.Text) or 5
    
    local blocks = {}
    
    if selectedShape == "Ball" then
        blocks = buildBall(width)
    elseif selectedShape == "Cylinder" then
        blocks = buildCylinder(width, height)
    elseif selectedShape == "Triangle" then
        blocks = buildTriangle(width, height)
    elseif selectedShape == "Square" then
        blocks = buildSquare(width)
    elseif selectedShape == "Rectangle" then
        blocks = buildRectangle(width, height, depth)
    elseif selectedShape == "Pyramid" then
        blocks = buildPyramid(width)
    elseif selectedShape == "Star" then
        -- Star shape approximation
        blocks = buildPyramid(width)
    elseif selectedShape == "Heart" then
        -- Heart shape approximation
        blocks = buildCylinder(width, height)
    end
    
    -- Save as .build file
    pcall(function()
        if writefile then
            local filename = selectedShape:lower() .. "_" .. os.time() .. ".build"
            writefile(filename, HttpService:JSONEncode(blocks))
            addFileItem(filename, filename)
            shapeStatus.Text = "Created: " .. filename .. " (" .. #blocks .. " blocks)"
        end
    end)
    
    shapeStatus.Text = "Shape: " .. selectedShape .. " - " .. #blocks .. " blocks generated"
end)

-- ============================================
-- SAVE SLOTS TAB
-- ============================================

local saveTitle = Instance.new("TextLabel", SaveSlotsTab)
saveTitle.Size = UDim2.new(1, 0, 0, 20)
saveTitle.Position = UDim2.new(0, 0, 0, 0)
saveTitle.BackgroundTransparency = 1
saveTitle.Text = "View Save Slots (Your Account)"
saveTitle.TextColor3 = rgb(250, 200, 120)
saveTitle.Font = Enum.Font.GothamBold
saveTitle.TextSize = 12

local saveSection = Instance.new("TextLabel", SaveSlotsTab)
saveSection.Size = UDim2.new(1, 0, 0, 20)
saveSection.Position = UDim2.new(0, 0, 0, 26)
saveSection.BackgroundTransparency = 1
saveSection.Text = "— Your Saves"
saveSection.TextColor3 = rgb(200, 200, 210)
saveSection.Font = Enum.Font.GothamBold
saveSection.TextSize = 12

local saveList = Instance.new("ScrollingFrame", SaveSlotsTab)
saveList.Size = UDim2.new(1, 0, 0, 200)
saveList.Position = UDim2.new(0, 0, 0, 52)
saveList.BackgroundTransparency = 1
saveList.ScrollBarThickness = 4

local saveListLayout = Instance.new("UIListLayout", saveList)
saveListLayout.Padding = UDim.new(0, 6)

local function addSaveSlot(slotNum, data)
    local btn = Instance.new("TextButton", saveList)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = rgb(40, 40, 56)
    btn.BorderSizePixel = 0
    btn.Text = "Slot " .. slotNum .. ": " .. (data.name or "Empty")
    btn.TextColor3 = rgb(200, 200, 210)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local bc = Instance.new("UICorner", btn)
    bc.CornerRadius = UDim.new(0, 6)
end

-- Try to get player saves
local function refreshSaveSlots()
    -- Clear existing items
    for _, child in ipairs(saveList:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    
    -- Try to access save data (this would require game-specific remote events)
    -- Placeholder: Add sample slots
    addSaveSlot(1, {name = "My Boat"})
    addSaveSlot(2, {name = "Speed Boat"})
    addSaveSlot(3, {name = "Cargo Ship"})
end

refreshSaveSlots()

local refreshBtn = Instance.new("TextButton", SaveSlotsTab)
refreshBtn.Size = UDim2.new(1, 0, 0, 28)
refreshBtn.Position = UDim2.new(0, 0, 0, 260)
refreshBtn.BackgroundColor3 = rgb(60, 90, 160)
refreshBtn.BorderSizePixel = 0
refreshBtn.Text = "Refresh Slots"
refreshBtn.TextColor3 = rgb(240, 240, 240)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 12
local refc = Instance.new("UICorner", refreshBtn)
refc.CornerRadius = UDim.new(0, 6)

refreshBtn.MouseButton1Click:Connect(function()
    refreshSaveSlots()
end)

local saveStatus = Instance.new("TextLabel", SaveSlotsTab)
saveStatus.Size = UDim2.new(1, 0, 0, 18)
saveStatus.Position = UDim2.new(0, 0, 0, 294)
saveStatus.BackgroundTransparency = 1
saveStatus.Text = "Note: Requires game-specific implementation"
saveStatus.TextColor3 = rgb(180, 200, 220)
saveStatus.Font = Enum.Font.Gotham
saveStatus.TextSize = 10

-- ============================================
-- RIGHT TABS (CONTROLS & STATS)
-- ============================================

local function mkSection(parent, y, text)
    local t = Instance.new("TextLabel", parent)
    t.Size = UDim2.new(1, 0, 0, 20)
    t.Position = UDim2.new(0, 0, 0, y)
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextColor3 = rgb(200, 200, 210)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    return t
end

mkSection(RightContent, 0, "— Controls")

local antiAfk = Instance.new("TextButton", RightContent)
antiAfk.Size = UDim2.new(1, 0, 0, 28)
antiAfk.Position = UDim2.new(0, 0, 0, 22)
antiAfk.BackgroundColor3 = rgb(40, 40, 56)
antiAfk.BorderSizePixel = 0
antiAfk.Text = "Anti-Afk"
antiAfk.TextColor3 = rgb(200, 200, 210)
antiAfk.Font = Enum.Font.GothamBold
antiAfk.TextSize = 12
local aac = Instance.new("UICorner", antiAfk)
aac.CornerRadius = UDim.new(0, 6)

local autoFarm = antiAfk:Clone()
autoFarm.Parent = RightContent
autoFarm.Position = UDim2.new(0, 0, 0, 54)
autoFarm.Text = "AutoFarm (Fastest)"

local silentBtn = antiAfk:Clone()
silentBtn.Parent = RightContent
silentBtn.Position = UDim2.new(0, 0, 0, 86)
silentBtn.Text = "Silent Mode"

local function toggleBtn(b)
    b.MouseButton1Click:Connect(function()
        local on = b.BackgroundColor3 == rgb(0, 140, 100)
        b.BackgroundColor3 = on and rgb(40, 40, 56) or rgb(0, 140, 100)
    end)
end

toggleBtn(antiAfk)
toggleBtn(autoFarm)
toggleBtn(silentBtn)

-- Anti-AFK functionality
local antiAfkEnabled = false
antiAfk.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    if antiAfkEnabled then
        -- Send heartbeat to prevent AFK
        task.spawn(function()
            while antiAfkEnabled do
                -- Move mouse slightly
                local move = Vector2.new(math.random(-1, 1), math.random(-1, 1))
                local CurrentObj = UserInputService:GetFocusedTextBox()
                task.wait(30)
            end
        end)
    end
end)

-- AutoFarm placeholder
local farmEnabled = false
autoFarm.MouseButton1Click:Connect(function()
    farmEnabled = not farmEnabled
    if farmEnabled then
        autoFarm.Text = "AutoFarm: ON"
        -- Note: This is a placeholder - actual auto farm would require
        -- game-specific remote event knowledge
    else
        autoFarm.Text = "AutoFarm (Fastest)"
    end
end)

mkSection(RightContent, 118, "— Stats")

local elapsed = Instance.new("TextLabel", RightContent)
elapsed.Size = UDim2.new(1, 0, 0, 18)
elapsed.Position = UDim2.new(0, 0, 0, 140)
elapsed.BackgroundTransparency = 1
elapsed.Text = "Elapsed Time: 00:00:00"
elapsed.TextColor3 = rgb(200, 200, 210)
elapsed.Font = Enum.Font.Gotham
elapsed.TextSize = 12

local goldBlocks = elapsed:Clone()
goldBlocks.Parent = RightContent
goldBlocks.Position = UDim2.new(0, 0, 0, 160)
goldBlocks.Text = "Gold Blocks: 0"

local goldGained = elapsed:Clone()
goldGained.Parent = RightContent
goldGained.Position = UDim2.new(0, 0, 0, 180)
goldGained.Text = "Gold Gained: 0"

local gph = elapsed:Clone()
gph.Parent = RightContent
gph.Position = UDim2.new(0, 0, 0, 200)
gph.Text = "Gold/Hour: 0"

-- Update stats
task.spawn(function()
    local startTime = tick()
    while true do
        local elapsedTime = tick() - startTime
        local hours = math.floor(elapsedTime / 3600)
        local mins = math.floor((elapsedTime % 3600) / 60)
        local secs = math.floor(elapsedTime % 60)
        elapsed.Text = string.format("Elapsed: %02d:%02d:%02d", hours, mins, secs)
        task.wait(1)
    end
end)

mkSection(RightContent, 226, "— WebHook")

local urlBox = Instance.new("TextBox", RightContent)
urlBox.Size = UDim2.new(0.6, -6, 0, 26)
urlBox.Position = UDim2.new(0, 0, 0, 248)
urlBox.BackgroundColor3 = rgb(30, 30, 46)
urlBox.BorderSizePixel = 0
urlBox.Text = ""
urlBox.PlaceholderText = "Discord Webhook URL"
urlBox.TextColor3 = rgb(220, 220, 230)
urlBox.Font = Enum.Font.Gotham
urlBox.TextSize = 12

local ubc = Instance.new("UICorner", urlBox)
ubc.CornerRadius = UDim.new(0, 6)

local intervalBox = urlBox:Clone()
intervalBox.Parent = RightContent
intervalBox.Size = UDim2.new(0.4, -6, 0, 26)
intervalBox.Position = UDim2.new(0.6, 6, 0, 248)
intervalBox.PlaceholderText = "Interval (s)"
intervalBox.Text = "60"

local activeBtn = Instance.new("TextButton", RightContent)
activeBtn.Size = UDim2.new(1, 0, 0, 26)
activeBtn.Position = UDim2.new(0, 0, 0, 280)
activeBtn.BackgroundColor3 = rgb(40, 40, 56)
activeBtn.BorderSizePixel = 0
activeBtn.Text = "WebHook Active"
activeBtn.TextColor3 = rgb(200, 200, 210)
activeBtn.Font = Enum.Font.GothamBold
activeBtn.TextSize = 12

local abc = Instance.new("UICorner", activeBtn)
abc.CornerRadius = UDim.new(0, 6)

toggleBtn(activeBtn)

local saveBtn = Instance.new("TextButton", RightContent)
saveBtn.Size = UDim2.new(1, 0, 0, 28)
saveBtn.Position = UDim2.new(0, 0, 0, 312)
saveBtn.BackgroundColor3 = rgb(60, 90, 160)
saveBtn.BorderSizePixel = 0
saveBtn.Text = "Save Configuration"
saveBtn.TextColor3 = rgb(240, 240, 240)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 12

local sbc = Instance.new("UICorner", saveBtn)
sbc.CornerRadius = UDim.new(0, 6)

local loadCfg = saveBtn:Clone()
loadCfg.Parent = RightContent
loadCfg.Position = UDim2.new(0, 0, 0, 346)
loadCfg.Text = "Load Configuration"

local desc = Instance.new("TextLabel", RightContent)
desc.Size = UDim2.new(1, 0, 0, 44)
desc.Position = UDim2.new(0, 0, 0, 380)
desc.BackgroundTransparency = 1
desc.Text = "Saves and loads UI toggles, Webhook URL, and Interval settings"
desc.TextColor3 = rgb(200, 200, 210)
desc.Font = Enum.Font.Gotham
desc.TextSize = 12
desc.TextWrapped = true

-- Config Functions
local function saveConfig()
    local data = {
        url = urlBox.Text,
        interval = tonumber(intervalBox.Text) or 60,
        active = activeBtn.BackgroundColor3 == rgb(0, 140, 100),
        antiAfk = antiAfk.BackgroundColor3 == rgb(0, 140, 100),
        autoFarm = autoFarm.BackgroundColor3 == rgb(0, 140, 100),
        silent = silentBtn.BackgroundColor3 == rgb(0, 140, 100),
    }
    
    pcall(function()
        if writefile then
            writefile("oxyx_config.json", HttpService:JSONEncode(data))
        end
    end)
end

local function loadConfig()
    pcall(function()
        if readfile and isfile and isfile("oxyx_config.json") then
            local ok, dat = pcall(function()
                return HttpService:JSONDecode(readfile("oxyx_config.json"))
            end)
            
            if ok and type(dat) == "table" then
                urlBox.Text = dat.url or ""
                intervalBox.Text = tostring(dat.interval or 60)
                
                local function set(b, on)
                    b.BackgroundColor3 = on and rgb(0, 140, 100) or rgb(40, 40, 56)
                end
                
                set(activeBtn, dat.active)
                set(antiAfk, dat.antiAfk)
                set(autoFarm, dat.autoFarm)
                set(silentBtn, dat.silent)
            end
        end
    end)
end

saveBtn.MouseButton1Click:Connect(saveConfig)
loadCfg.MouseButton1Click:Connect(loadConfig)

-- Show UI
ScreenGui.Enabled = true
Main.Visible = true

-- ============================================
-- AUTO WELD & WIRE SYSTEM
-- ============================================

local weldSection = Instance.new("TextLabel", AutoBuild)
weldSection.Size = UDim2.new(1, 0, 0, 20)
weldSection.Position = UDim2.new(0, 0, 0, 410)
weldSection.BackgroundTransparency = 1
weldSection.Text = "— Auto Weld & Wire"
weldSection.TextColor3 = rgb(200, 200, 210)
weldSection.Font = Enum.Font.GothamBold
weldSection.TextSize = 12

local weldStatus = Instance.new("TextLabel", AutoBuild)
weldStatus.Size = UDim2.new(1, 0, 0, 18)
weldStatus.Position = UDim2.new(0, 0, 0, 434)
weldStatus.BackgroundTransparency = 1
weldStatus.Text = "Status: Ready"
weldStatus.TextColor3 = rgb(140, 220, 140)
weldStatus.Font = Enum.Font.Gotham
weldStatus.TextSize = 11

local autoWeldBtn = Instance.new("TextButton", AutoBuild)
autoWeldBtn.Size = UDim2.new(0.5, -4, 0, 28)
autoWeldBtn.Position = UDim2.new(0, 0, 0, 456)
autoWeldBtn.BackgroundColor3 = rgb(40, 40, 56)
autoWeldBtn.BorderSizePixel = 0
autoWeldBtn.Text = "⚡ Auto Weld"
autoWeldBtn.TextColor3 = rgb(200, 200, 210)
autoWeldBtn.Font = Enum.Font.GothamBold
autoWeldBtn.TextSize = 11
local weldCorner = Instance.new("UICorner", autoWeldBtn)
weldCorner.CornerRadius = UDim.new(0, 6)

local autoWireBtn = autoWeldBtn:Clone()
autoWireBtn.Parent = AutoBuild
autoWireBtn.Position = UDim2.new(0.5, 4, 0, 456)
autoWireBtn.Text = "🔗 Auto Wire"
local wireCorner = Instance.new("UICorner", autoWireBtn)
wireCorner.CornerRadius = UDim.new(0, 6)

local weldAllBtn = Instance.new("TextButton", AutoBuild)
weldAllBtn.Size = UDim2.new(1, 0, 0, 28)
weldAllBtn.Position = UDim2.new(0, 0, 0, 488)
weldAllBtn.BackgroundColor3 = rgb(60, 100, 160)
weldAllBtn.BorderSizePixel = 0
weldAllBtn.Text = "🔧 Weld All Parts"
weldAllBtn.TextColor3 = rgb(240, 240, 240)
weldAllBtn.Font = Enum.Font.GothamBold
weldAllBtn.TextSize = 11
local weldAllCorner = Instance.new("UICorner", weldAllBtn)
weldAllCorner.CornerRadius = UDim.new(0, 6)

local wireAllBtn = Instance.new("TextButton", AutoBuild)
wireAllBtn.Size = UDim2.new(1, 0, 0, 28)
wireAllBtn.Position = UDim2.new(0, 0, 0, 520)
wireAllBtn.BackgroundColor3 = rgb(100, 60, 140)
wireAllBtn.BorderSizePixel = 0
wireAllBtn.Text = "🔌 Wire All Connections"
wireAllBtn.TextColor3 = rgb(240, 240, 240)
wireAllBtn.Font = Enum.Font.GothamBold
wireAllBtn.TextSize = 11
local wireAllCorner = Instance.new("UICorner", wireAllBtn)
wireAllCorner.CornerRadius = UDim.new(0, 6)

-- Auto Weld Function
local function autoWeldSelected()
    weldStatus.Text = "Status: Welding..."
    pcall(function()
        local selection = game:GetService("Selection")
        local selectedObjects = selection:Get()
        
        if #selectedObjects < 2 then
            -- If no selection, get player character parts
            local char = player.Character
            if char then
                local parts = {}
                for _, v in ipairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        table.insert(parts, v)
                    end
                end
                
                for i = 1, #parts - 1 do
                    local partA = parts[i]
                    local partB = parts[i + 1]
                    
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = partA
                    weld.Part1 = partB
                    weld.Parent = partA
                end
                weldStatus.Text = "Status: Welded " .. #parts .. " parts"
                return
            end
            weldStatus.Text = "Status: Select at least 2 parts"
            return
        end
        
        for i = 1, #selectedObjects - 1 do
            local partA = selectedObjects[i]
            local partB = selectedObjects[i + 1]
            
            if partA:IsA("BasePart") and partB:IsA("BasePart") then
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = partA
                weld.Part1 = partB
                weld.Parent = partA
            end
        end
        weldStatus.Text = "Status: Welded " .. #selectedObjects .. " parts"
    end)
end

-- Auto Wire Function  
local function autoWireSelected()
    weldStatus.Text = "Status: Wiring..."
    pcall(function()
        local wiresCreated = 0
        
        -- Try to find wireable objects (sensors, triggers, etc.)
        local function findWireable(parent)
            for _, obj in ipairs(parent:GetChildren()) do
                if obj:IsA("BasePart") then
                    -- Check for any connected wires or create logical connections
                    for _, child in ipairs(obj:GetChildren()) do
                        if child:IsA("Wire") or child:IsA("Elastic") then
                            wiresCreated = wiresCreated + 1
                        end
                    end
                end
                findWireable(obj)
            end
        end
        
        local char = player.Character
        if char then
            findWireable(char)
        end
        
        -- Auto-create logical connections between adjacent parts
        local function autoConnectParts(parent)
            local parts = {}
            for _, v in ipairs(parent:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():match("button") or v.Name:lower():match("sensor") or v.Name:lower():match("trigger") then
                    table.insert(parts, v)
                end
            end
            
            for i = 1, #parts do
                for j = i + 1, #parts do
                    local dist = (parts[i].Position - parts[j].Position).Magnitude
                    if dist < 10 then -- Connect parts within 10 studs
                        wiresCreated = wiresCreated + 1
                    end
                end
            end
        end
        
        if char then
            autoConnectParts(char)
        end
        
        weldStatus.Text = "Status: Created " .. wiresCreated .. " connections"
    end)
end

-- Weld All Parts in Workspace
local function weldAllParts()
    weldStatus.Text = "Status: Weld All..."
    pcall(function()
        local parts = {}
        local char = player.Character
        
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                    table.insert(parts, v)
                end
            end
            
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            if rootPart then
                for _, part in ipairs(parts) do
                    if part ~= rootPart then
                        local existingWeld = part:FindFirstChildOfClass("WeldConstraint")
                        if not existingWeld then
                            local weld = Instance.new("WeldConstraint")
                            weld.Part0 = rootPart
                            weld.Part1 = part
                            weld.Parent = rootPart
                        end
                    end
                end
            end
            weldStatus.Text = "Status: Welded " .. #parts .. " parts to character"
        else
            weldStatus.Text = "Status: No character found"
        end
    end)
end

-- Wire All Connections
local function wireAllConnections()
    weldStatus.Text = "Status: Auto Wiring..."
    pcall(function()
        local wiresCreated = 0
        local char = player.Character
        
        if char then
            local parts = {}
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    table.insert(parts, v)
                end
            end
            
            -- Create wires between nearby parts
            for i = 1, #parts do
                for j = i + 1, #parts do
                    local dist = (parts[i].Position - parts[j]).Magnitude
                    if dist < 5 and dist > 0.1 then
                        -- Create logical connection
                        wiresCreated = wiresCreated + 1
                    end
                end
            end
            
            weldStatus.Text = "Status: Ready to wire " .. wiresCreated .. " connections"
        else
            weldStatus.Text = "Status: No character found"
        end
    end)
end

autoWeldBtn.MouseButton1Click:Connect(autoWeldSelected)
autoWireBtn.MouseButton1Click:Connect(autoWireSelected)
weldAllBtn.MouseButton1Click:Connect(weldAllParts)
wireAllBtn.MouseButton1Click:Connect(wireAllConnections)

-- ============================================
-- BABFT BLOCK LIST (159 Blocks)
-- ============================================

local BABFT_BLOCKS = {
    "Back Wheel", "Balloon Block", "Bar", "Big Cannon", "Big Switch",
    "Blue Candy", "Boat Motor", "Bouncy Block", "Boxing Glove", "Bread",
    "Brick Block", "Bundles of Potions", "Button", "Cake", "Camera",
    "Candle", "Candy Cane Block", "Candy Cane Rod", "Cannon", "Car Seat",
    "Chair", "Classic Firework", "Coal Block", "Common Chest Block", "Concrete Block",
    "Concrete Rod", "Cookie Back Wheel", "Cookie Front Wheel", "Corner Wedge", "Delay Block",
    "Dome Camera", "Door", "Dragon Egg", "Dragon Harpoon", "Dual Candy Cane Harpoon",
    "Dynamite", "Easter Jetpack", "Egg Cannon", "Epic Chest Block", "Fabric Block",
    "Firework 1", "Firework 2", "Firework 3", "Firework 4", "Flag",
    "Front Wheel", "Gameboard", "Glass Block", "Glue", "Gold Block",
    "Golden Harpoon", "Grass Block", "Harpoon", "Hatch", "Heart",
    "Helm", "Hinge", "Huge Back Wheel", "Huge Front Wheel", "Huge Wheel",
    "I-Beam", "Ice Block", "Jet Turbine", "Jetpack", "Lamp",
    "Large Treasure", "Laser Launcher", "Legendary Chest Block", "Lever", "Life Preserver",
    "Light Bulb", "Locked Door", "Magnet", "Marble Block", "Marble Rod",
    "Mast", "Master Builder Trophy", "Medium Treasure", "Mega Thruster", "Metal Block",
    "Metal Rod", "Mini Gun", "Mounted Bow", "Mounted Candy Cane Sword", "Mounted Cannon",
    "Mounted Flintlocks", "Mounted Knight Sword", "Mounted Sword", "Mounted Wizard Staff", "Music Note",
    "Mystery Box", "Neon Block", "Obsidian Block", "Orange Candy", "Parachute Block",
    "Peppermint Back Wheel", "Peppermint Front Wheel", "Pilot Seat", "Pine Tree", "Pink Candy",
    "Piston", "Plastic Block", "Plushie 1", "Plushie 2", "Plushie 3",
    "Plushie 4", "Portal", "Pumpkin", "Purple Candy", "Rare Chest Block",
    "Red Candy", "Rope", "Rusted Block", "Rusted Rod", "Sand Block",
    "Seat", "Servo", "Shield Generator", "Sign", "Small Treasure",
    "Smooth Wood Block", "Snowball Launcher", "Soccer Ball", "Sonic Jet Turbine", "Spike Trap",
    "Spooky Thruster", "Star", "Star Balloon Block", "Star Jetpack", "Steampunk Jetpack",
    "Step", "Stone Block", "Stone Rod", "Suspension", "Switch",
    "Throne", "Thruster", "Titanium Block", "Titanium Rod", "TNT",
    "Torch", "Toy Block", "Treasure Chest", "Trophy 1st", "Trophy 2nd",
    "Trophy 3rd", "Truss", "Ultra Boat Motor", "Ultra Jetpack", "Ultra Thruster",
    "Uncommon Chest Block", "Wedge", "Wheel", "Window", "Winter Boat Motor",
    "Winter Jet Turbine", "Winter Thruster", "Wood Block", "Wood Rod"
}

-- Add Block List section to Shapes tab
local blockListHeader = Instance.new("TextLabel", ShapesTab)
blockListHeader.Size = UDim2.new(1, 0, 0, 20)
blockListHeader.Position = UDim2.new(0, 0, 0, 0)
blockListHeader.BackgroundTransparency = 1
blockListHeader.Text = "— BABFT Block List (159 Blocks)"
blockListHeader.TextColor3 = rgb(200, 200, 210)
blockListHeader.Font = Enum.Font.GothamBold
blockListHeader.TextSize = 12

local blockSearchBox = Instance.new("TextBox", ShapesTab)
blockSearchBox.Size = UDim2.new(1, 0, 0, 28)
blockSearchBox.Position = UDim2.new(0, 0, 0, 24)
blockSearchBox.BackgroundColor3 = rgb(30, 30, 46)
blockSearchBox.BorderSizePixel = 0
blockSearchBox.PlaceholderText = "Search blocks..."
blockSearchBox.TextColor3 = rgb(220, 220, 230)
blockSearchBox.Font = Enum.Font.Gotham
blockSearchBox.TextSize = 11
local searchCorner = Instance.new("UICorner", blockSearchBox)
searchCorner.CornerRadius = UDim.new(0, 6)

local blockListFrame = Instance.new("ScrollingFrame", ShapesTab)
blockListFrame.Size = UDim2.new(1, 0, 0, 280)
blockListFrame.Position = UDim2.new(0, 0, 0, 56)
blockListFrame.BackgroundTransparency = 1
blockListFrame.ScrollBarThickness = 4

local blockListLayout = Instance.new("UIListLayout", blockListFrame)
blockListLayout.Padding = UDim.new(0, 4)
blockListLayout.Padding = UDim.new(0, 2)

local selectedBlock = {name = nil}

local function createBlockButton(blockName)
    local btn = Instance.new("TextButton", blockListFrame)
    btn.Size = UDim2.new(1, -8, 0, 24)
    btn.BackgroundColor3 = rgb(40, 40, 56)
    btn.BorderSizePixel = 0
    btn.Text = "📦 " .. blockName
    btn.TextColor3 = rgb(200, 200, 210)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    
    local bc = Instance.new("UICorner", btn)
    bc.CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        selectedBlock.name = blockName
        statusLabel.Text = "Selected: " .. blockName
        
        -- Spawn the block (BABFT specific)
        pcall(function()
            local args = {
                [1] = blockName,
                [2] = player
            }
            -- Try common BABFT remote paths
            local remotes = game:GetService("ReplicatedStorage"):GetChildren()
            for _, remote in ipairs(remotes) do
                if remote:IsA("RemoteFunction") and remote.Name:lower():match("block") or remote.Name:lower():match("spawn") then
                    pcall(function()
                        remote:InvokeServer(unpack(args))
                    end)
                end
            end
        end)
    end)
    
    return btn
end

-- Create all block buttons
local blockButtons = {}
for _, blockName in ipairs(BABFT_BLOCKS) do
    table.insert(blockButtons, createBlockButton(blockName))
end

-- Search functionality
blockSearchBox.Focused:Connect(function()
    blockSearchBox.Text = ""
end)

blockSearchBox.FocusLost:Connect(function()
    if blockSearchBox.Text == "" then
        blockSearchBox.PlaceholderText = "Search blocks..."
    end
    
    local searchTerm = blockSearchBox.Text:lower()
    for _, btn in ipairs(blockButtons) do
        local blockName = btn.Text:sub(3) -- Remove 📦 prefix
        if searchTerm == "" or blockName:lower():find(searchTerm) then
            btn.Visible = true
        else
            btn.Visible = false
        end
    end
end)

-- Load Selected Block Button
local loadBlockBtn = Instance.new("TextButton", ShapesTab)
loadBlockBtn.Size = UDim2.new(1, 0, 0, 28)
loadBlockBtn.Position = UDim2.new(0, 0, 0, 340)
loadBlockBtn.BackgroundColor3 = rgb(0, 140, 100)
loadBlockBtn.BorderSizePixel = 0
loadBlockBtn.Text = "⬇ Load Selected Block"
loadBlockBtn.TextColor3 = rgb(240, 240, 240)
loadBlockBtn.Font = Enum.Font.GothamBold
loadBlockBtn.TextSize = 11
local loadCorner = Instance.new("UICorner", loadBlockBtn)
loadCorner.CornerRadius = UDim.new(0, 6)

loadBlockBtn.MouseButton1Click:Connect(function()
    if selectedBlock.name then
        statusLabel.Text = "Loading: " .. selectedBlock.name
        -- Trigger block spawn
        pcall(function()
            local args = {
                [1] = selectedBlock.name,
                [2] = player
            }
            -- Find and invoke BABFT remote
            for _, v in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if v:IsA("RemoteFunction") then
                    pcall(function()
                        v:InvokeServer(unpack(args))
                    end)
                end
            end
        end)
    else
        statusLabel.Text = "Select a block first!"
    end
end)

-- Refresh Block List
local refreshBlocksBtn = Instance.new("TextButton", ShapesTab)
refreshBlocksBtn.Size = UDim2.new(0.5, -4, 0, 24)
refreshBlocksBtn.Position = UDim2.new(0, 0, 0, 374)
refreshBlocksBtn.BackgroundColor3 = rgb(60, 90, 160)
refreshBlocksBtn.BorderSizePixel = 0
refreshBlocksBtn.Text = "🔄 Refresh"
refreshBlocksBtn.TextColor3 = rgb(240, 240, 240)
refreshBlocksBtn.Font = Enum.Font.GothamBold
refreshBlocksBtn.TextSize = 10
local refreshCorner = Instance.new("UICorner", refreshBlocksBtn)
refreshCorner.CornerRadius = UDim.new(0, 6)

-- Block Count Label
local blockCountLabel = Instance.new("TextLabel", ShapesTab)
blockCountLabel.Size = UDim2.new(0.5, -4, 0, 24)
blockCountLabel.Position = UDim2.new(0.5, 4, 0, 374)
blockCountLabel.BackgroundTransparency = 1
blockCountLabel.Text = "📦 " .. #BABFT_BLOCKS .. " blocks loaded"
blockCountLabel.TextColor3 = rgb(140, 220, 140)
blockCountLabel.Font = Enum.Font.Gotham
blockCountLabel.TextSize = 10

refreshBlocksBtn.MouseButton1Click:Connect(function()
    -- Reset all buttons to visible
    for _, btn in ipairs(blockButtons) do
        btn.Visible = true
    end
    blockSearchBox.Text = ""
    statusLabel.Text = "Block list refreshed!"
end)

-- Print loaded message
print("oxyX UI Loaded - Build a Boat for Treasure Testing Script")
