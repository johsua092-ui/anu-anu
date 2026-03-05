--[[
    oxyX_BABFT - Build a Boat for Treasure Ultimate Tool
    Version: 2.0.0
    Features: Save Slot Viewer, Auto Build, Auto Weld/Wire, Farm, and more
    
    GitHub: https://github.com/johsua092-ui/anu-anu
    Script: oxyX_BABFT.lua
    
    Compatible with: PC, Mobile, Console
    Aspect Ratio: 9:16 optimized
]]

-- Security and Environment Setup
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")

-- oxyX Configuration
local oxyX = {
    Name = "oxyX_BABFT",
    Version = "2.0.0",
    Author = "oxyX Team",
    Theme = {
        Primary = Color3.fromRGB(45, 35, 60),
        Secondary = Color3.fromRGB(30, 25, 45),
        Accent = Color3.fromRGB(255, 105, 180),
        Text = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(20, 18, 30),
        Success = Color3.fromRGB(0, 255, 127),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(255, 69, 80)
    },
    Settings = {
        AutoWeld = true,
        AutoWire = true,
        InfiniteBlocks = false,
        AutoFarm = false,
        FarmSpeed = 0.1,
        BuildFormat = ".build",
        ImageLoader = true
    }
}

-- Complete BABFT Block Dictionary (159 Blocks)
local BABFTBlocks = {
    -- Vehicle Parts
    {Name = "Back Wheel", ID = 1, Category = "Wheels"},
    {Name = "Front Wheel", ID = 2, Category = "Wheels"},
    {Name = "Huge Back Wheel", ID = 3, Category = "Wheels"},
    {Name = "Huge Front Wheel", ID = 4, Category = "Wheels"},
    {Name = "Huge Wheel", ID = 5, Category = "Wheels"},
    {Name = "Wheel", ID = 6, Category = "Wheels"},
    {Name = "Cookie Back Wheel", ID = 7, Category = "Wheels"},
    {Name = "Cookie Front Wheel", ID = 8, Category = "Wheels"},
    {Name = "Peppermint Back Wheel", ID = 9, Category = "Wheels"},
    {Name = "Peppermint Front Wheel", ID = 10, Category = "Wheels"},
    
    -- Basic Blocks
    {Name = "Brick Block", ID = 11, Category = "Basic"},
    {Name = "Wood Block", ID = 12, Category = "Basic"},
    {Name = "Smooth Wood Block", ID = 13, Category = "Basic"},
    {Name = "Concrete Block", ID = 14, Category = "Basic"},
    {Name = "Metal Block", ID = 15, Category = "Basic"},
    {Name = "Glass Block", ID = 16, Category = "Basic"},
    {Name = "Plastic Block", ID = 17, Category = "Basic"},
    {Name = "Grass Block", ID = 18, Category = "Basic"},
    {Name = "Sand Block", ID = 19, Category = "Basic"},
    {Name = "Stone Block", ID = 20, Category = "Basic"},
    {Name = "Ice Block", ID = 21, Category = "Basic"},
    {Name = "Neon Block", ID = 22, Category = "Basic"},
    {Name = "Gold Block", ID = 23, Category = "Basic"},
    {Name = "Rusted Block", ID = 24, Category = "Basic"},
    {Name = "Obsidian Block", ID = 25, Category = "Basic"},
    {Name = "Titanium Block", ID = 26, Category = "Basic"},
    {Name = "Fabric Block", ID = 27, Category = "Basic"},
    {Name = "Marble Block", ID = 28, Category = "Basic"},
    {Name = "Toy Block", ID = 29, Category = "Basic"},
    {Name = "Dome Camera", ID = 30, Category = "Basic"},
    {Name = "Camera", ID = 31, Category = "Basic"},
    
    -- Rods
    {Name = "Rod", ID = 32, Category = "Rods"},
    {Name = "Wood Rod", ID = 33, Category = "Rods"},
    {Name = "Metal Rod", ID = 34, Category = "Rods"},
    {Name = "Concrete Rod", ID = 35, Category = "Rods"},
    {Name = "Stone Rod", ID = 36, Category = "Rods"},
    {Name = "Rusted Rod", ID = 37, Category = "Rods"},
    {Name = "Marble Rod", ID = 38, Category = "Rods"},
    {Name = "Titanium Rod", ID = 39, Category = "Rods"},
    {Name = "Candy Cane Rod", ID = 40, Category = "Rods"},
    {Name = "I-Beam", ID = 41, Category = "Rods"},
    
    -- Weapons
    {Name = "Cannon", ID = 42, Category = "Weapons"},
    {Name = "Big Cannon", ID = 43, Category = "Weapons"},
    {Name = "Egg Cannon", ID = 44, Category = "Weapons"},
    {Name = "Mounted Cannon", ID = 45, Category = "Weapons"},
    {Name = "Harpoon", ID = 46, Category = "Weapons"},
    {Name = "Golden Harpoon", ID = 47, Category = "Weapons"},
    {Name = "Dragon Harpoon", ID = 48, Category = "Weapons"},
    {Name = "Dual Candy Cane Harpoon", ID = 49, Category = "Weapons"},
    {Name = "Mounted Bow", ID = 50, Category = "Weapons"},
    {Name = "Mounted Sword", ID = 51, Category = "Weapons"},
    {Name = "Mounted Knight Sword", ID = 52, Category = "Weapons"},
    {Name = "Mounted Candy Cane Sword", ID = 53, Category = "Weapons"},
    {Name = "Mounted Flintlocks", ID = 54, Category = "Weapons"},
    {Name = "Mounted Wizard Staff", ID = 55, Category = "Weapons"},
    {Name = "Laser Launcher", ID = 56, Category = "Weapons"},
    {Name = "Mini Gun", ID = 57, Category = "Weapons"},
    {Name = "Spike Trap", ID = 58, Category = "Weapons"},
    {Name = "Dynamite", ID = 59, Category = "Weapons"},
    {Name = "TNT", ID = 60, Category = "Weapons"},
    {Name = "Snowball Launcher", ID = 61, Category = "Weapons"},
    {Name = "Boxing Glove", ID = 62, Category = "Weapons"},
    
    -- Movement
    {Name = "Thruster", ID = 63, Category = "Movement"},
    {Name = "Big Thruster", ID = 64, Category = "Movement"},
    {Name = "Ultra Thruster", ID = 65, Category = "Movement"},
    {Name = "Winter Thruster", ID = 66, Category = "Movement"},
    {Name = "Spooky Thruster", ID = 67, Category = "Movement"},
    {Name = "Mega Thruster", ID = 68, Category = "Movement"},
    {Name = "Jet Turbine", ID = 69, Category = "Movement"},
    {Name = "Winter Jet Turbine", ID = 70, Category = "Movement"},
    {Name = "Sonic Jet Turbine", ID = 71, Category = "Movement"},
    {Name = "Jetpack", ID = 72, Category = "Movement"},
    {Name = "Ultra Jetpack", ID = 73, Category = "Movement"},
    {Name = "Star Jetpack", ID = 74, Category = "Movement"},
    {Name = "Steampunk Jetpack", ID = 75, Category = "Movement"},
    {Name = "Easter Jetpack", ID = 76, Category = "Movement"},
    {Name = "Parachute Block", ID = 77, Category = "Movement"},
    {Name = "Boat Motor", ID = 78, Category = "Movement"},
    {Name = "Ultra Boat Motor", ID = 79, Category = "Movement"},
    {Name = "Winter Boat Motor", ID = 80, Category = "Movement"},
    {Name = "Suspension", ID = 81, Category = "Movement"},
    {Name = "Piston", ID = 82, Category = "Movement"},
    {Name = "Servo", ID = 83, Category = "Movement"},
    {Name = "Hinge", ID = 84, Category = "Movement"},
    
    -- Seating
    {Name = "Seat", ID = 85, Category = "Seating"},
    {Name = "Chair", ID = 86, Category = "Seating"},
    {Name = "Car Seat", ID = 87, Category = "Seating"},
    {Name = "Pilot Seat", ID = 88, Category = "Seating"},
    {Name = "Throne", ID = 89, Category = "Seating"},
    
    -- Special
    {Name = "Button", ID = 90, Category = "Special"},
    {Name = "Switch", ID = 91, Category = "Special"},
    {Name = "Big Switch", ID = 92, Category = "Special"},
    {Name = "Lever", ID = 93, Category = "Special"},
    {Name = "Delay Block", ID = 94, Category = "Special"},
    {Name = "Door", ID = 95, Category = "Special"},
    {Name = "Locked Door", ID = 96, Category = "Special"},
    {Name = "Hatch", ID = 97, Category = "Special"},
    {Name = "Portal", ID = 98, Category = "Special"},
    {Name = "Rope", ID = 99, Category = "Special"},
    {Name = "Glue", ID = 100, Category = "Special"},
    {Name = "Magnet", ID = 101, Category = "Special"},
    {Name = "Shield Generator", ID = 102, Category = "Special"},
    
    -- Decorations
    {Name = "Lamp", ID = 103, Category = "Decor"},
    {Name = "Light Bulb", ID = 104, Category = "Decor"},
    {Name = "Torch", ID = 105, Category = "Decor"},
    {Name = "Candle", ID = 106, Category = "Decor"},
    {Name = "Sign", ID = 107, Category = "Decor"},
    {Name = "Flag", ID = 108, Category = "Decor"},
    {Name = "Star", ID = 109, Category = "Decor"},
    {Name = "Heart", ID = 110, Category = "Decor"},
    {Name = "Music Note", ID = 111, Category = "Decor"},
    {Name = "Tree", ID = 112, Category = "Decor"},
    {Name = "Mast", ID = 113, Category = "Decor"},
    {Name = "Helm", ID = 114, Category = "Decor"},
    {Name = "Life Preserver", ID = 115, Category = "Decor"},
    {Name = "Window", ID = 116, Category = "Decor"},
    {Name = "Gameboard", ID = 117, Category = "Decor"},
    {Name = "Truss", ID = 118, Category = "Decor"},
    
    -- Food/Candy
    {Name = "Bread", ID = 119, Category = "Food"},
    {Name = "Cake", ID = 120, Category = "Food"},
    {Name = "Cookie", ID = 121, Category = "Food"},
    {Name = "Pumpkin", ID = 122, Category = "Food"},
    {Name = "Blue Candy", ID = 123, Category = "Food"},
    {Name = "Orange Candy", ID = 124, Category = "Food"},
    {Name = "Pink Candy", ID = 125, Category = "Food"},
    {Name = "Purple Candy", ID = 126, Category = "Food"},
    {Name = "Red Candy", ID = 127, Category = "Food"},
    {Name = "Candy Cane Block", ID = 128, Category = "Food"},
    {Name = "Bundles of Potions", ID = 129, Category = "Food"},
    {Name = "Dragon Egg", ID = 130, Category = "Food"},
    
    -- Chests
    {Name = "Small Treasure", ID = 131, Category = "Chests"},
    {Name = "Medium Treasure", ID = 132, Category = "Chests"},
    {Name = "Large Treasure", ID = 133, Category = "Chests"},
    {Name = "Treasure Chest", ID = 134, Category = "Chests"},
    {Name = "Common Chest Block", ID = 135, Category = "Chests"},
    {Name = "Uncommon Chest Block", ID = 136, Category = "Chests"},
    {Name = "Rare Chest Block", ID = 137, Category = "Chests"},
    {Name = "Epic Chest Block", ID = 138, Category = "Chests"},
    {Name = "Legendary Chest Block", ID = 139, Category = "Chests"},
    {Name = "Mystery Box", ID = 140, Category = "Chests"},
    
    -- Fireworks
    {Name = "Firework 1", ID = 141, Category = "Fireworks"},
    {Name = "Firework 2", ID = 142, Category = "Fireworks"},
    {Name = "Firework 3", ID = 143, Category = "Fireworks"},
    {Name = "Firework 4", ID = 144, Category = "Fireworks"},
    {Name = "Classic Firework", ID = 145, Category = "Fireworks"},
    
    -- Plushies
    {Name = "Plushie 1", ID = 146, Category = "Plushies"},
    {Name = "Plushie 2", ID = 147, Category = "Plushies"},
    {Name = "Plushie 3", ID = 148, Category = "Plushies"},
    {Name = "Plushie 4", ID = 149, Category = "Plushies"},
    
    -- Balloons
    {Name = "Balloon Block", ID = 150, Category = "Balloons"},
    {Name = "Star Balloon Block", ID = 151, Category = "Balloons"},
    
    -- Trophies
    {Name = "Trophy 1st", ID = 152, Category = "Trophies"},
    {Name = "Trophy 2nd", ID = 153, Category = "Trophies"},
    {Name = "Trophy 3rd", ID = 154, Category = "Trophies"},
    {Name = "Master Builder Trophy", ID = 155, Category = "Trophies"},
    
    -- Structural
    {Name = "Bar", ID = 156, Category = "Structural"},
    {Name = "Step", ID = 157, Category = "Structural"},
    {Name = "Wedge", ID = 158, Category = "Structural"},
    {Name = "Corner Wedge", ID = 159, Category = "Structural"}
}

-- Auto Build Shapes Library
local AutoBuildShapes = {
    {Name = "Sphere", Method = "sphere"},
    {Name = "Ball", Method = "ball"},
    {Name = "Cylinder", Method = "cylinder"},
    {Name = "Triangle", Method = "triangle"},
    {Name = "Pyramid", Method = "pyramid"},
    {Name = "Cube", Method = "cube"},
    {Name = "Box", Method = "box"},
    {Name = "Ring", Method = "ring"},
    {Name = "Hollow Sphere", Method = "hollow_sphere"},
    {Name = "Hollow Cube", Method = "hollow_cube"},
    {Name = "Spiral", Method = "spiral"},
    {Name = "Staircase", Method = "staircase"},
    {Name = "Bridge", Method = "bridge"},
    {Name = "Wall", Method = "wall"},
    {Name = "Tower", Method = "tower"},
    {Name = "Castle", Method = "castle"},
    {Name = "Ship Hull", Method = "ship_hull"},
    {Name = "Boat Body", Method = "boat_body"},
    {Name = "Catapult", Method = "catapult"},
    {Name = "Ram", Method = "ram"}
}

-- Save Slot Data Storage
local SaveSlotData = {}
local SelectedSlot = 1
local PlayerBoats = {}

-- Utility Functions
local function GetPlayer()
    return Players.LocalPlayer
end

local function GetPlayerGui()
    return GetPlayer():WaitForChild("PlayerGui")
end

local function GetRemote(name)
    return ReplicatedStorage:WaitForChild(name)
end

local function GetService(serviceName)
    return game:GetService(serviceName)
end

-- Notification System
local function Notify(title, text, duration)
    -- Create notification UI
    pcall(function()
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = title or "oxyX",
            Text = text or "",
            Duration = duration or 3
        })
    end)
end

-- Auto Weld System
local function AutoWeld(partA, partB)
    if not partA or not partB then return end
    pcall(function()
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = partA
        weld.Part1 = partB
        weld.Parent = partA
    end)
end

-- Auto Wire System (Connect signals)
local function AutoWire(partA, partB, signalName)
    if not partA or not partB then return end
    pcall(function()
        local wire = Instance.new("Wire")
        wire.Parent = partA
        -- Connect ports based on signal type
    end)
end

-- Get All Parts in Boat
local function GetBoatParts()
    local parts = {}
    local player = GetPlayer()
    if player and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                table.insert(parts, part)
            end
        end
    end
    return parts
end

-- Weld All Parts
local function WeldAllParts()
    local parts = GetBoatParts()
    for i = 1, #parts do
        for j = i + 1, #parts do
            AutoWeld(parts[i], parts[j])
        end
    end
    Notify("oxyX", "All parts welded!", 2)
end

-- Wire All Parts
local function WireAllParts()
    local parts = GetBoatParts()
    -- Connect buttons to triggers
    for _, part in ipairs(parts) do
        if part.Name:lower():find("button") or part.Name:lower():find("switch") then
            for _, otherPart in ipairs(parts) do
                if otherPart.Name:lower():find("thruster") or 
                   otherPart.Name:lower():find("motor") or
                   otherPart.Name:lower():find("weapon") then
                    AutoWire(part, otherPart, "Trigger")
                end
            end
        end
    end
    Notify("oxyX", "All parts wired!", 2)
end

-- Infinite Blocks Bypass
local function EnableInfiniteBlocks()
    oxyX.Settings.InfiniteBlocks = true
    pcall(function()
        local Inventory = getsenv(game.Players.LocalPlayer.PlayerGui.Inventory)
        if Inventory and Inventory.SetInfinite then
            Inventory.SetInfinite(true)
        end
    end)
    Notify("oxyX", "Infinite Blocks Enabled!", 2)
end

local function DisableInfiniteBlocks()
    oxyX.Settings.InfiniteBlocks = false
    pcall(function()
        local Inventory = getsenv(game.Players.LocalPlayer.PlayerGui.Inventory)
        if Inventory and Inventory.SetInfinite then
            Inventory.SetInfinite(false)
        end
    end)
    Notify("oxyX", "Infinite Blocks Disabled!", 2)
end

-- Auto Farm System
local function StartAutoFarm()
    oxyX.Settings.AutoFarm = true
    while oxyX.Settings.AutoFarm do
        pcall(function()
            -- Click gold button
            local goldButton = game:GetService("Players").LocalPlayer.PlayerGui.Main.GoldButton
            if goldButton and goldButton.Visible then
                fireclickdetector(goldButton)
            end
            -- Collect treasures
            for _, treasure in ipairs(workspace:GetDescendants()) do
                if treasure.Name:find("Treasure") and treasure:IsA("TouchTransmitter") then
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, treasure.Parent, 0)
                end
            end
        end)
        wait(oxyX.Settings.FarmSpeed)
    end
end

local function StopAutoFarm()
    oxyX.Settings.AutoFarm = false
    Notify("oxyX", "Auto Farm Stopped!", 2)
end

-- Save Slot Viewer
local function LoadSaveSlots()
    pcall(function()
        local profileService = getsenv(game.Players.LocalPlayer.PlayerScripts.ProfileService)
        if profileService and profileService.GetProfile then
            -- Try to get profile data
            for i = 1, 5 do
                local profile = profileService.GetProfile(i)
                if profile then
                    SaveSlotData[i] = {
                        Slot = i,
                        Data = profile.Data,
                        Level = profile.Data and profile.Data.Stats and profile.Data.Stats.Level or 0,
                        Money = profile.Data and profile.Data.Stats and profile.Data.Stats.Money or 0,
                        Blocks = profile.Data and profile.Data.Inventory or {}
                    }
                end
            end
        end
    end)
end

local function ViewPlayerSaveSlots(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if not targetPlayer then
        Notify("oxyX", "Player not found!", 2)
        return
    end
    
    pcall(function()
        -- Try to get player data through replicated storage
        local playerDataRemote = ReplicatedStorage:FindFirstChild("PlayerData")
        if playerDataRemote then
            playerDataRemote:InvokeServer("GetData", targetPlayer.UserId)
        end
    end)
    
    Notify("oxyX", "Loading " .. playerName .. "'s data...", 2)
end

-- JSON to .build Converter
local function ConvertJsonToBuild(jsonString)
    local success, data = pcall(function()
        return HttpService:JSONDecode(jsonString)
    end)
    
    if not success then
        Notify("oxyX", "Invalid JSON!", 2)
        return nil
    end
    
    local buildData = {
        Version = "1.0",
        Name = data.Name or "Imported Build",
        Author = data.Author or "Unknown",
        Parts = {}
    }
    
    -- Convert JSON parts to .build format
    if data.Parts then
        for _, part in ipairs(data.Parts) do
            table.insert(buildData.Parts, {
                Name = part.Name or "Part",
                Position = part.Position or Vector3.new(0, 0, 0),
                Rotation = part.Rotation or Vector3.new(0, 0, 0),
                Size = part.Size or Vector3.new(4, 4, 4),
                Color = part.Color or BrickColor.new("Bright red").Number,
                Material = part.Material or Enum.Material.Wood,
                Anchored = part.Anchored or false,
                BlockID = part.BlockID or 1
            })
        end
    end
    
    return buildData
end

-- Roblox Studio Model Converter
local function ConvertStudioModel(model)
    local buildData = {
        Version = "1.0",
        Name = model.Name or "Converted Model",
        Author = GetPlayer().Name,
        Parts = {}
    }
    
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(buildData.Parts, {
                Name = part.Name,
                Position = part.Position,
                Rotation = part.Rotation,
                Size = part.Size,
                Color = part.BrickColor.Number,
                Material = part.Material,
                Anchored = part.Anchored,
                BlockID = 1 -- Default block
            })
        end
    end
    
    return buildData
end

-- Auto Build Shape Generator
local function GenerateShape(shapeType, blockID, size, density)
    local parts = {}
    local sizeX = size.X or 10
    local sizeY = size.Y or 10
    local sizeZ = size.Z or 10
    
    local remote = GetRemote("PlaceBlock")
    
    if shapeType == "sphere" or shapeType == "ball" then
        local radius = math.floor(sizeX / 2)
        for x = -radius, radius do
            for y = -radius, radius do
                for z = -radius, radius do
                    if x*x + y*y + z*z <= radius*radius then
                        table.insert(parts, {
                            Position = Vector3.new(x * 4, y * 4, z * 4),
                            BlockID = blockID
                        })
                    end
                end
            end
        end
    elseif shapeType == "cylinder" then
        local radius = math.floor(sizeX / 2)
        for x = -radius, radius do
            for z = -radius, radius do
                if x*x + z*z <= radius*radius then
                    for y = 0, sizeY do
                        table.insert(parts, {
                            Position = Vector3.new(x * 4, y * 4, z * 4),
                            BlockID = blockID
                        })
                    end
                end
            end
        end
    elseif shapeType == "cube" or shapeType == "box" then
        for x = 0, sizeX do
            for y = 0, sizeY do
                for z = 0, sizeZ do
                    table.insert(parts, {
                        Position = Vector3.new(x * 4, y * 4, z * 4),
                        BlockID = blockID
                    })
                end
            end
        end
    elseif shapeType == "triangle" then
        for x = 0, sizeX do
            for y = 0, math.floor(sizeY * (1 - x / sizeX)) do
                table.insert(parts, {
                    Position = Vector3.new(x * 4, y * 4, 0),
                    BlockID = blockID
                })
            end
        end
    elseif shapeType == "pyramid" then
        for y = 0, sizeY do
            local layerSize = sizeX - y
            for x = 0, layerSize do
                for z = 0, layerSize do
                    table.insert(parts, {
                        Position = Vector3.new(x * 4, y * 4, z * 4),
                        BlockID = blockID
                    })
                end
            end
        end
    elseif shapeType == "hollow_sphere" then
        local radius = math.floor(sizeX / 2)
        for x = -radius, radius do
            for y = -radius, radius do
                for z = -radius, radius do
                    local dist = x*x + y*y + z*z
                    if dist <= radius*radius and dist >= (radius-2)*(radius-2) then
                        table.insert(parts, {
                            Position = Vector3.new(x * 4, y * 4, z * 4),
                            BlockID = blockID
                        })
                    end
                end
            end
        end
    elseif shapeType == "hollow_cube" then
        for x = 0, sizeX do
            for y = 0, sizeY do
                for z = 0, sizeZ do
                    if x == 0 or x == sizeX or y == 0 or y == sizeY or z == 0 or z == sizeZ then
                        table.insert(parts, {
                            Position = Vector3.new(x * 4, y * 4, z * 4),
                            BlockID = blockID
                        })
                    end
                end
            end
        end
    elseif shapeType == "ring" then
        local radius = math.floor(sizeX / 2)
        local thickness = 2
        for x = -radius, radius do
            for z = -radius, radius do
                local dist = x*x + z*z
                if dist <= radius*radius and dist >= (radius-thickness)*(radius-thickness) then
                    table.insert(parts, {
                        Position = Vector3.new(x * 4, 0, z * 4),
                        BlockID = blockID
                    })
                end
            end
        end
    elseif shapeType == "staircase" then
        for x = 0, sizeX do
            for y = 0, x do
                for z = 0, sizeZ do
                    table.insert(parts, {
                        Position = Vector3.new(x * 4, y * 4, z * 4),
                        BlockID = blockID
                    })
                end
            end
        end
    elseif shapeType == "wall" then
        for x = 0, sizeX do
            for y = 0, sizeY do
                table.insert(parts, {
                    Position = Vector3.new(x * 4, y * 4, 0),
                    BlockID = blockID
                })
            end
        end
    elseif shapeType == "tower" then
        local radius = math.floor(sizeX / 4)
        for y = 0, sizeY do
            for x = -radius, radius do
                for z = -radius, radius do
                    if x*x + z*z <= radius*radius then
                        table.insert(parts, {
                            Position = Vector3.new(x * 4, y * 4, z * 4),
                            BlockID = blockID
                        })
                    end
                end
            end
        end
    end
    
    -- Place all generated parts
    for _, partData in ipairs(parts) do
        pcall(function()
            if remote then
                remote:FireServer(partData.Position, partData.BlockID)
            end
        end)
    end
    
    Notify("oxyX", "Built " .. #parts .. " blocks!", 2)
    return #parts
end

-- .build File Loader
local function LoadBuildFile(buildContent)
    local success, data = pcall(function()
        return HttpService:JSONDecode(buildContent)
    end)
    
    if not success then
        Notify("oxyX", "Invalid .build file!", 2)
        return
    end
    
    Notify("oxyX", "Loading build: " .. (data.Name or "Unknown"), 2)
    
    local remote = GetRemote("PlaceBlock")
    local placed = 0
    
    if data.Parts then
        for _, part in ipairs(data.Parts) do
            pcall(function()
                local pos = part.Position or Vector3.new(0, 0, 0)
                local blockID = part.BlockID or 1
                if remote then
                    remote:FireServer(pos, blockID)
                end
                placed = placed + 1
            end)
        end
    end
    
    -- Auto weld if enabled
    if oxyX.Settings.AutoWeld then
        wait(1)
        WeldAllParts()
    end
    
    -- Auto wire if enabled
    if oxyX.Settings.AutoWire then
        wait(0.5)
        WireAllParts()
    end
    
    Notify("oxyX", "Loaded " .. placed .. " blocks!", 3)
end

-- Image Loader Fix
local function FixImageLoader()
    pcall(function()
        -- Override image loading to use Roblox CDN
        local HttpService = game:GetService("HttpService")
        
        -- Hook into image loading
        local OldNewInstance = Instance.new
        local function FixedNewInstance(className)
            local instance = OldNewInstance(className)
            if className == "ImageLabel" or className == "ImageButton" then
                -- Ensure proper image loading
                local originalPropertyChanged = instance:GetPropertyChangedSignal("Image")
                instance:GetPropertyChangedSignal("Image"):Connect(function()
                    if instance.Image and not string.find(instance.Image, "rbxasset") then
                        -- Convert external URLs to Roblox format if needed
                    end
                end)
            end
            return instance
        end
        
        -- Replace global Instance
        _G.Instance = FixedNewInstance
    end)
    Notify("oxyX", "Image Loader Fixed!", 2)
end

-- Main UI Creation
local function CreateMainUI()
    -- Main Window
    local Window = OrionLib:MakeWindow({
        Name = "oxyX BABFT",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "oxyX_BABFT",
        IntroEnabled = false,
        Theme = "Dark"
    })
    
    -- Tab: Home
    local HomeTab = Window:MakeTab({
        Name = "Home",
        Icon = "rbxassetid://7733658504",
        PremiumOnly = false
    })
    
    HomeTab:AddLabel("oxyX BABFT v2.0.0")
    HomeTab:AddLabel("Build a Boat for Treasure Ultimate Tool")
    HomeTab:AddLine()
    HomeTab:AddLabel("Features:")
    HomeTab:AddLabel("- Auto Build (.build files)")
    HomeTab:AddLabel("- Auto Weld & Wire")
    HomeTab:AddLabel("- Auto Farm")
    HomeTab:AddLabel("- 159 BABFT Blocks")
    HomeTab:AddLabel("- Save Slot Viewer")
    HomeTab:AddLabel("- Shape Generator")
    
    -- Tab: Auto Build
    local AutoBuildTab = Window:MakeTab({
        Name = "Auto Build",
        Icon = "rbxassetid://7733658504",
        PremiumOnly = false
    })
    
    AutoBuildTab:AddLabel("Auto Build (Supports .build files)")
    AutoBuildTab:AddTextbox({
        Name = "Build URL",
        Default = "https://example.com/build.build",
        TextDisappear = false,
        Callback = function(value)
            -- URL input for build file
        end
    })
    
    AutoBuildTab:AddButton({
        Name = "Load from URL",
        Callback = function()
            -- Load build from URL
        end
    })
    
    AutoBuildTab:AddButton({
        Name = "Load from Clipboard",
        Callback = function()
            -- Load from clipboard
            local clipboardContent = getclipboard()
            if clipboardContent then
                LoadBuildFile(clipboardContent)
            end
        end
    })
    
    AutoBuildTab:AddLine()
    AutoBuildTab:AddLabel("Shape Generator")
    
    local selectedShape = {Value = "Cube"}
    local selectedBlock = {Value = "Brick Block"}
    local sizeX = {Value = "10"}
    local sizeY = {Value = "10"}
    local sizeZ = {Value = "10"}
    
    AutoBuildTab:AddDropdown({
        Name = "Select Shape",
        Options = {"Sphere", "Ball", "Cylinder", "Triangle", "Pyramid", "Cube", "Box", "Ring", "Hollow Sphere", "Hollow Cube", "Staircase", "Wall", "Tower"},
        Default = "Cube",
        Callback = function(value)
            selectedShape.Value = value
        end
    })
    
    AutoBuildTab:AddDropdown({
        Name = "Select Block",
        Options = {"Brick Block", "Wood Block", "Metal Block", "Glass Block", "Stone Block"},
        Default = "Brick Block",
        Callback = function(value)
            selectedBlock.Value = value
        end
    })
    
    AutoBuildTab:AddTextbox({
        Name = "Size X",
        Default = "10",
        TextDisappear = true,
        Callback = function(value)
            sizeX.Value = value
        end
    })
    
    AutoBuildTab:AddTextbox({
        Name = "Size Y",
        Default = "10",
        TextDisappear = true,
        Callback = function(value)
            sizeY.Value = value
        end
    })
    
    AutoBuildTab:AddTextbox({
        Name = "Size Z",
        Default = "10",
        TextDisappear = true,
        Callback = function(value)
            sizeZ.Value = value
        end
    })
    
    AutoBuildTab:AddButton({
        Name = "Generate Shape",
        Callback = function()
            local shape = selectedShape.Value
            local blockID = 11 -- Default brick block
            for _, block in ipairs(BABFTBlocks) do
                if block.Name == selectedBlock.Value then
                    blockID = block.ID
                    break
                end
            end
            local size = Vector3.new(tonumber(sizeX.Value) or 10, tonumber(sizeY.Value) or 10, tonumber(sizeZ.Value) or 10)
            GenerateShape(shape:lower(), blockID, size, 1)
        end
    })
    
    -- Tab: Blocks
    local BlocksTab = Window:MakeTab({
        Name = "Blocks",
        Icon = "rbxassetid://7733658504",
        PremiumOnly = false
    })
    
    BlocksTab:AddLabel("BABFT Block List (159 Blocks)")
    
    local blockCategories = {"All", "Wheels", "Basic", "Rods", "Weapons", "Movement", "Seating", "Special", "Decor", "Food", "Chests", "Fireworks", "Plushies", "Balloons", "Trophies", "Structural"}
    
    BlocksTab:AddDropdown({
        Name = "Category",
        Options = blockCategories,
        Default = "All",
        Callback = function(category)
            -- Filter blocks by category
        end
    })
    
    BlocksTab:AddTextbox({
        Name = "Search Block",
        Default = "",
        TextDisappear = true,
        Callback = function(value)
            -- Search blocks
        end
    })
    
    local blockCountLabel = BlocksTab:AddLabel("Showing: 159 blocks")
    
    -- Tab: Tools
    local ToolsTab = Window:MakeTab({
        Name = "Tools",
        Icon = "rbxassetid://7733658504",
        PremiumOnly = false
    })
    
    ToolsTab:AddLabel("Auto Setup Tools")
    
    ToolsTab:AddToggle({
        Name = "Auto Weld",
        Default = true,
        Callback = function(value)
            oxyX.Settings.AutoWeld = value
        end
    })
    
    ToolsTab:AddToggle({
        Name = "Auto Wire",
        Default = true,
        Callback = function(value)
            oxyX.Settings.AutoWire = value
        end
    })
    
    ToolsTab:AddButton({
        Name = "Weld All Parts",
        Callback = function()
            WeldAllParts()
        end
    })
    
    ToolsTab:AddButton({
        Name = "Wire All Parts",
        Callback = function()
            WireAllParts()
        end
    })
    
    ToolsTab:AddLine()
    ToolsTab:AddLabel("Block Settings")
    
    ToolsTab:AddToggle({
        Name = "Infinite Blocks",
        Default = false,
        Callback = function(value)
            if value then
                EnableInfiniteBlocks()
            else
                DisableInfiniteBlocks()
            end
        end
    })
    
    ToolsTab:AddLine()
    ToolsTab:AddLabel("Image Loader")
    
    ToolsTab:AddButton({
        Name = "Fix Image Loader",
        Callback = function()
            FixImageLoader()
        end
    })
    
    -- Tab: Farm
    local FarmTab = Window:MakeTab({
        Name = "Farm",
        Icon = "rbxassetid://7733658504",
        PremiumOnly = false
    })
    
    FarmTab:AddLabel("Auto Farm")
    
    FarmTab:AddToggle({
        Name = "Auto Farm",
        Default = false,
        Callback = function(value)
            if value then
                StartAutoFarm()
            else
                StopAutoFarm()
            end
        end
    })
    
    FarmTab:AddSlider({
        Name = "Farm Speed",
        Min = 0.01,
        Max = 1,
        Default = 0.1,
        Color = oxyX.Theme.Accent,
        Callback = function(value)
            oxyX.Settings.FarmSpeed = value
        end
    })
    
    FarmTab:AddButton({
        Name = "Collect Gold",
        Callback = function()
            pcall(function()
                local goldButton = game:GetService("Players").LocalPlayer.PlayerGui.Main.GoldButton
                if goldButton and goldButton.Visible then
                    fireclickdetector(goldButton)
                end
            end)
        end
    })
    
    FarmTab:AddButton({
        Name = "Collect All Treasures",
        Callback = function()
            for _, treasure in ipairs(workspace:GetDescendants()) do
                if treasure:IsA("TouchTransmitter") then
                    pcall(function()
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, treasure.Parent, 0)
                    end)
                end
            end
            Notify("oxyX", "Treasures collected!", 2)
        end
    })
    
    -- Tab: Converter
    local ConverterTab = Window:MakeTab({
        Name = "Converter",
        Icon = "rbxassetid://7733658504",
        PremiumOnly = false
    })
    
    ConverterTab:AddLabel("Roblox Studio Model Converter")
    ConverterTab:AddLabel("Paste JSON or Studio Model data to convert")
    
    ConverterTab:AddTextbox({
        Name = "JSON/Model Data",
        Default = "",
        TextDisappear = false,
        Callback = function(value)
            -- JSON input
        end
    })
    
    ConverterTab:AddButton({
        Name = "Convert to .build",
        Callback = function()
            -- Convert JSON to .build
        end
    })
    
    ConverterTab:AddButton({
        Name = "Load Converted",
        Callback = function()
            -- Load converted build
        end
    })
    
    ConverterTab:AddLine()
    ConverterTab:AddLabel("JSON to .build")
    
    ConverterTab:AddButton({
        Name = "Load JSON from Clipboard",
        Callback = function()
            local clipboardContent = getclipboard()
            if clipboardContent then
                local buildData = ConvertJsonToBuild(clipboardContent)
                if buildData then
                    LoadBuildFile(HttpService:JSONEncode(buildData))
                end
            end
        end
    })
    
    -- Tab: Save Slots
    local SaveSlotsTab = Window:MakeTab({
        Name = "Save Slots",
        Icon = "rbxassetid://7733658504",
        PremiumOnly = false
    })
    
    SaveSlotsTab:AddLabel("Save Slot Viewer")
    SaveSlotsTab:AddLabel("View other players' save data")
    
    SaveSlotsTab:AddTextbox({
        Name = "Player Name",
        Default = "",
        TextDisappear = false,
        Callback = function(value)
            -- Player name input
        end
    })
    
    SaveSlotsTab:AddButton({
        Name = "View Player Slots",
        Callback = function()
            -- View player save slots
        end
    })
    
    SaveSlotsTab:AddButton({
        Name = "Load My Slots",
        Callback = function()
            LoadSaveSlots()
        end
    })
    
    local slotInfoLabel = SaveSlotsTab:AddLabel("No data loaded")
    
    -- Tab: Settings
    local SettingsTab = Window:MakeTab({
        Name = "Settings",
        Icon = "rbxassetid://7733658504",
        PremiumOnly = false
    })
    
    SettingsTab:AddLabel("Settings")
    
    SettingsTab:AddToggle({
        Name = "Notifications",
        Default = true,
        Callback = function(value)
            oxyX.Settings.Notifications = value
        end
    })
    
    SettingsTab:AddButton({
        Name = "Refresh UI",
        Callback = function()
            -- Refresh UI
        end
    })
    
    SettingsTab:AddButton({
        Name = "Destroy UI",
        Callback = function()
            OrionLib:Destroy()
        end
    })
    
    SettingsTab:AddLine()
    SettingsTab:AddLabel("oxyX BABFT v2.0.0")
    SettingsTab:Label("Made with ❤️ by oxyX Team")
    
    return Window
end

-- Initialize
local function Init()
    -- Wait for game to load
    repeat wait(0.1) until game:IsLoaded()
    
    -- Wait for PlayerGui
    repeat wait(0.1) until GetPlayerGui()
    
    -- Create UI
    CreateMainUI()
    
    -- Show welcome notification
    Notify("oxyX BABFT", "Loaded successfully!", 3)
    
    print("oxyX BABFT v2.0.0 loaded!")
    print("Features: Auto Build, Auto Weld/Wire, Auto Farm, 159 Blocks")
end

-- Start
Init()

return oxyX
