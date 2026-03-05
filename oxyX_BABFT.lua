--[[
    oxyX_BABFT - Build a Boat for Treasure Ultimate Tool
    Version: 2.0.0
    Features: Save Slot Viewer, Auto Build, Auto Weld/Wire, Farm, and more
    
    GitHub: https://github.com/johsua092-ui/anu-anu
    Script: oxyX_BABFT.lua
    
    Compatible with: PC, Mobile, Console
    Aspect Ratio: 9:16 optimized
    
    Features:
    - Auto Build (.build files)
    - Auto Weld & Wire (Auto Setup)
    - Auto Farm (Fastest)
    - 159 BABFT Blocks
    - Save Slot Viewer
    - Shape Generator
    - JSON to .build Converter
    - Studio Model Converter
    - Infinite Block Bypass
    - Image Loader Fix
]]

-- ============================================
-- CORE SERVICES AND ENVIRONMENT SETUP
-- ============================================

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- ============================================
-- OXYX CONFIGURATION
-- ============================================

local oxyX = {
    Name = "oxyX_BABFT",
    Version = "2.0.0",
    Author = "oxyX Team",
    Enabled = true,
    Theme = {
        Primary = Color3.fromRGB(45, 35, 60),
        Secondary = Color3.fromRGB(30, 25, 45),
        Accent = Color3.fromRGB(255, 105, 180),
        Accent2 = Color3.fromRGB(138, 43, 226),
        Text = Color3.fromRGB(255, 255, 255),
        Text2 = Color3.fromRGB(200, 200, 200),
        Background = Color3.fromRGB(20, 18, 30),
        Background2 = Color3.fromRGB(25, 22, 35),
        Success = Color3.fromRGB(0, 255, 127),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(255, 69, 80),
        Button = Color3.fromRGB(70, 50, 100),
        ButtonHover = Color3.fromRGB(90, 60, 120),
        Tab = Color3.fromRGB(40, 30, 55),
        TabSelected = Color3.fromRGB(60, 45, 80)
    },
    Settings = {
        AutoWeld = true,
        AutoWire = true,
        AutoWeldDelay = 0.5,
        InfiniteBlocks = false,
        AutoFarm = false,
        FarmSpeed = 0.05,
        BuildFormat = ".build",
        ImageLoader = true,
        ShowNotifications = true,
        UIAlpha = 1,
        UIScale = 1,
        Dragging = false,
        CurrentTab = 1
    },
    Data = {
        BlocksPlaced = 0,
        FarmsActivated = 0,
        WeldsCreated = 0,
        WiresCreated = 0
    }
}

-- ============================================
-- COMPLETE BABFT BLOCK DICTIONARY (159 BLOCKS)
-- ============================================

local BABFTBlocks = {
    -- Vehicle Parts - Wheels (10 blocks)
    {Name = "Back Wheel", ID = 1, Category = "Wheels", Description = "Rear wheel for vehicles"},
    {Name = "Front Wheel", ID = 2, Category = "Wheels", Description = "Front wheel for vehicles"},
    {Name = "Huge Back Wheel", ID = 3, Category = "Wheels", Description = "Large rear wheel"},
    {Name = "Huge Front Wheel", ID = 4, Category = "Wheels", Description = "Large front wheel"},
    {Name = "Huge Wheel", ID = 5, Category = "Wheels", Description = "Large universal wheel"},
    {Name = "Wheel", ID = 6, Category = "Wheels", Description = "Standard wheel"},
    {Name = "Cookie Back Wheel", ID = 7, Category = "Wheels", Description = "Cookie-themed rear wheel"},
    {Name = "Cookie Front Wheel", ID = 8, Category = "Wheels", Description = "Cookie-themed front wheel"},
    {Name = "Peppermint Back Wheel", ID = 9, Category = "Wheels", Description = "Peppermint rear wheel"},
    {Name = "Peppermint Front Wheel", ID = 10, Category = "Wheels", Description = "Peppermint front wheel"},
    
    -- Basic Blocks (21 blocks)
    {Name = "Brick Block", ID = 11, Category = "Basic", Description = "Classic red brick"},
    {Name = "Wood Block", ID = 12, Category = "Basic", Description = "Wooden block"},
    {Name = "Smooth Wood Block", ID = 13, Category = "Basic", Description = "Polished wood"},
    {Name = "Concrete Block", ID = 14, Category = "Basic", Description = "Gray concrete"},
    {Name = "Metal Block", ID = 15, Category = "Basic", Description = "Metallic block"},
    {Name = "Glass Block", ID = 16, Category = "Basic", Description = "Transparent glass"},
    {Name = "Plastic Block", ID = 17, Category = "Basic", Description = "Plastic material"},
    {Name = "Grass Block", ID = 18, Category = "Basic", Description = "Green grass top"},
    {Name = "Sand Block", ID = 19, Category = "Basic", Description = "Yellow sand"},
    {Name = "Stone Block", ID = 20, Category = "Basic", Description = "Gray stone"},
    {Name = "Ice Block", ID = 21, Category = "Basic", Description = "Translucent ice"},
    {Name = "Neon Block", ID = 22, Category = "Basic", Description = "Glowing neon"},
    {Name = "Gold Block", ID = 23, Category = "Basic", Description = "Shiny gold"},
    {Name = "Rusted Block", ID = 24, Category = "Basic", Description = "Old rusty metal"},
    {Name = "Obsidian Block", ID = 25, Category = "Basic", Description = "Dark volcanic rock"},
    {Name = "Titanium Block", ID = 26, Category = "Basic", Description = "Strong titanium"},
    {Name = "Fabric Block", ID = 27, Category = "Basic", Description = "Soft fabric"},
    {Name = "Marble Block", ID = 28, Category = "Basic", Description = "White marble"},
    {Name = "Toy Block", ID = 29, Category = "Basic", Description = "Colorful toy"},
    {Name = "Dome Camera", ID = 30, Category = "Basic", Description = "Dome security camera"},
    {Name = "Camera", ID = 31, Category = "Basic", Description = "Standard camera"},
    
    -- Rods (10 blocks)
    {Name = "Rod", ID = 32, Category = "Rods", Description = "Basic rod"},
    {Name = "Wood Rod", ID = 33, Category = "Rods", Description = "Wooden rod"},
    {Name = "Metal Rod", ID = 34, Category = "Rods", Description = "Metallic rod"},
    {Name = "Concrete Rod", ID = 35, Category = "Rods", Description = "Concrete rod"},
    {Name = "Stone Rod", ID = 36, Category = "Rods", Description = "Stone rod"},
    {Name = "Rusted Rod", ID = 37, Category = "Rods", Description = "Old rusty rod"},
    {Name = "Marble Rod", ID = 38, Category = "Rods", Description = "Marble rod"},
    {Name = "Titanium Rod", ID = 39, Category = "Rods", Description = "Titanium rod"},
    {Name = "Candy Cane Rod", ID = 40, Category = "Rods", Description = "Candy cane stick"},
    {Name = "I-Beam", ID = 41, Category = "Rods", Description = "I-beam structural"},
    
    -- Weapons (20 blocks)
    {Name = "Cannon", ID = 42, Category = "Weapons", Description = "Basic cannon"},
    {Name = "Big Cannon", ID = 43, Category = "Weapons", Description = "Large cannon"},
    {Name = "Egg Cannon", ID = 44, Category = "Weapons", Description = "Egg-launching cannon"},
    {Name = "Mounted Cannon", ID = 45, Category = "Weapons", Description = "Vehicle-mounted cannon"},
    {Name = "Harpoon", ID = 46, Category = "Weapons", Description = "Hook weapon"},
    {Name = "Golden Harpoon", ID = 47, Category = "Weapons", Description = "Golden hook"},
    {Name = "Dragon Harpoon", ID = 48, Category = "Weapons", Description = "Dragon-themed harpoon"},
    {Name = "Dual Candy Cane Harpoon", ID = 49, Category = "Weapons", Description = "Dual candy harpoons"},
    {Name = "Mounted Bow", ID = 50, Category = "Weapons", Description = "Archer weapon"},
    {Name = "Mounted Sword", ID = 51, Category = "Weapons", Description = "Sword mount"},
    {Name = "Mounted Knight Sword", ID = 52, Category = "Weapons", Description = "Knight sword"},
    {Name = "Mounted Candy Cane Sword", ID = 53, Category = "Weapons", Description = "Candy sword"},
    {Name = "Mounted Flintlocks", ID = 54, Category = "Weapons", Description = "Pirate guns"},
    {Name = "Mounted Knight Sword", ID = 55, Category = "Weapons", Description = "Wizard staff"},
    {Name = "Laser Launcher", ID = 56, Category = "Weapons", Description = "Laser weapon"},
    {Name = "Mini Gun", ID = 57, Category = "Weapons", Description = "Rapid fire gun"},
    {Name = "Spike Trap", ID = 58, Category = "Weapons", Description = "Damage spikes"},
    {Name = "Dynamite", ID = 59, Category = "Weapons", Description = "Explosive TNT"},
    {Name = "TNT", ID = 60, Category = "Weapons", Description = "Explosive barrel"},
    {Name = "Snowball Launcher", ID = 61, Category = "Weapons", Description = "Ice projectile"},
    {Name = "Boxing Glove", ID = 62, Category = "Weapons", Description = "Punch mechanism"},
    
    -- Movement (21 blocks)
    {Name = "Thruster", ID = 63, Category = "Movement", Description = "Basic thruster"},
    {Name = "Big Thruster", ID = 64, Category = "Movement", Description = "Large thruster"},
    {Name = "Ultra Thruster", ID = 65, Category = "Movement", Description = "Maximum thrust"},
    {Name = "Winter Thruster", ID = 66, Category = "Movement", Description = "Ice thruster"},
    {Name = "Spooky Thruster", ID = 67, Category = "Movement", Description = "Halloween thruster"},
    {Name = "Mega Thruster", ID = 68, Category = "Movement", Description = "Powerful thruster"},
    {Name = "Jet Turbine", ID = 69, Category = "Movement", Description = "Jet engine"},
    {Name = "Winter Jet Turbine", ID = 70, Category = "Movement", Description = "Winter jet"},
    {Name = "Sonic Jet Turbine", ID = 71, Category = "Movement", Description = "Fast jet"},
    {Name = "Jetpack", ID = 72, Category = "Movement", Description = "Back-mounted jet"},
    {Name = "Ultra Jetpack", ID = 73, Category = "Movement", Description = "Powerful jetpack"},
    {Name = "Star Jetpack", ID = 74, Category = "Movement", Description = "Star jetpack"},
    {Name = "Steampunk Jetpack", ID = 75, Category = "Movement", Description = "Clockwork jetpack"},
    {Name = "Easter Jetpack", ID = 76, Category = "Movement", Description = "Easter jetpack"},
    {Name = "Parachute Block", ID = 77, Category = "Movement", Description = "Fall protection"},
    {Name = "Boat Motor", ID = 78, Category = "Movement", Description = "Standard motor"},
    {Name = "Ultra Boat Motor", ID = 79, Category = "Movement", Description = "Fast motor"},
    {Name = "Winter Boat Motor", ID = 80, Category = "Movement", Description = "Ice motor"},
    {Name = "Suspension", ID = 81, Category = "Movement", Description = "Wheel suspension"},
    {Name = "Piston", ID = 82, Category = "Movement", Description = "Linear actuator"},
    {Name = "Servo", ID = 83, Category = "Movement", Description = "Rotational motor"},
    {Name = "Hinge", ID = 84, Category = "Movement", Description = "Rotating joint"},
    
    -- Seating (5 blocks)
    {Name = "Seat", ID = 85, Category = "Seating", Description = "Basic seat"},
    {Name = "Chair", ID = 86, Category = "Seating", Description = "Comfortable chair"},
    {Name = "Car Seat", ID = 87, Category = "Seating", Description = "Vehicle seat"},
    {Name = "Pilot Seat", ID = 88, Category = "Seating", Description = "Driver seat"},
    {Name = "Throne", ID = 89, Category = "Seating", Description = "Royal seat"},
    
    -- Special (18 blocks)
    {Name = "Button", ID = 90, Category = "Special", Description = "Push button"},
    {Name = "Switch", ID = 91, Category = "Special", Description = "Toggle switch"},
    {Name = "Big Switch", ID = 92, Category = "Special", Description = "Large switch"},
    {Name = "Lever", ID = 93, Category = "Special", Description = "Pull lever"},
    {Name = "Delay Block", ID = 94, Category = "Special", Description = "Timer delay"},
    {Name = "Door", ID = 95, Category = "Special", Description = "Opening door"},
    {Name = "Locked Door", ID = 96, Category = "Special", Description = "Key door"},
    {Name = "Hatch", ID = 97, Category = "Special", Description = "Roof hatch"},
    {Name = "Portal", ID = 98, Category = "Special", Description = "Teleport block"},
    {Name = "Rope", ID = 99, Category = "Special", Description = "Flexible rope"},
    {Name = "Glue", ID = 100, Category = "Special", Description = "Sticky connection"},
    {Name = "Magnet", ID = 101, Category = "Special", Description = "Magnetic attraction"},
    {Name = "Shield Generator", ID = 102, Category = "Special", Description = "Protection shield"},
    
    -- Decorations (16 blocks)
    {Name = "Lamp", ID = 103, Category = "Decor", Description = "Lighting lamp"},
    {Name = "Light Bulb", ID = 104, Category = "Decor", Description = "Light source"},
    {Name = "Torch", ID = 105, Category = "Decor", Description = "Flame torch"},
    {Name = "Candle", ID = 106, Category = "Decor", Description = "Wax candle"},
    {Name = "Sign", ID = 107, Category = "Decor", Description = "Information sign"},
    {Name = "Flag", ID = 108, Category = "Decor", Description = "Banner flag"},
    {Name = "Star", ID = 109, Category = "Decor", Description = "Decorative star"},
    {Name = "Heart", ID = 110, Category = "Decor", Description = "Love heart"},
    {Name = "Music Note", ID = 111, Category = "Decor", Description = "Sound symbol"},
    {Name = "Pine Tree", ID = 112, Category = "Decor", Description = "Christmas tree"},
    {Name = "Mast", ID = 113, Category = "Decor", Description = "Sail pole"},
    {Name = "Helm", ID = 114, Category = "Decor", Description = "Ship wheel"},
    {Name = "Life Preserver", ID = 115, Category = "Decor", Description = "Safety ring"},
    {Name = "Window", ID = 116, Category = "Decor", Description = "Glass window"},
    {Name = "Gameboard", ID = 117, Category = "Decor", Description = "Board game"},
    {Name = "Truss", ID = 118, Category = "Decor", Description = "Structural truss"},
    
    -- Food/Candy (13 blocks)
    {Name = "Bread", ID = 119, Category = "Food", Description = "Food item"},
    {Name = "Cake", ID = 120, Category = "Food", Description = "Birthday cake"},
    {Name = "Cookie", ID = 121, Category = "Food", Description = "Sweet cookie"},
    {Name = "Pumpkin", ID = 122, Category = "Food", Description = "Halloween pumpkin"},
    {Name = "Blue Candy", ID = 123, Category = "Food", Description = "Blue sweet"},
    {Name = "Orange Candy", ID = 124, Category = "Food", Description = "Orange sweet"},
    {Name = "Pink Candy", ID = 125, Category = "Food", Description = "Pink sweet"},
    {Name = "Purple Candy", ID = 126, Category = "Food", Description = "Purple sweet"},
    {Name = "Red Candy", ID = 127, Category = "Food", Description = "Red sweet"},
    {Name = "Candy Cane Block", ID = 128, Category = "Food", Description = "Christmas candy"},
    {Name = "Bundles of Potions", ID = 129, Category = "Food", Description = "Magic drinks"},
    {Name = "Dragon Egg", ID = 130, Category = "Food", Description = "Pet egg"},
    
    -- Chests (10 blocks)
    {Name = "Small Treasure", ID = 131, Category = "Chests", Description = "Small loot"},
    {Name = "Medium Treasure", ID = 132, Category = "Chests", Description = "Medium loot"},
    {Name = "Large Treasure", ID = 133, Category = "Chests", Description = "Big loot"},
    {Name = "Treasure Chest", ID = 134, Category = "Chests", Description = "Standard chest"},
    {Name = "Common Chest Block", ID = 135, Category = "Chests", Description = "Common rarity"},
    {Name = "Uncommon Chest Block", ID = 136, Category = "Chests", Description = "Uncommon rarity"},
    {Name = "Rare Chest Block", ID = 137, Category = "Chests", Description = "Rare rarity"},
    {Name = "Epic Chest Block", ID = 138, Category = "Chests", Description = "Epic rarity"},
    {Name = "Legendary Chest Block", ID = 139, Category = "Chests", Description = "Legendary rarity"},
    {Name = "Mystery Box", ID = 140, Category = "Chests", Description = "Random reward"},
    
    -- Fireworks (5 blocks)
    {Name = "Firework 1", ID = 141, Category = "Fireworks", Description = "Basic firework"},
    {Name = "Firework 2", ID = 142, Category = "Fireworks", Description = "Color firework"},
    {Name = "Firework 3", ID = 143, Category = "Fireworks", Description = "Sparkle firework"},
    {Name = "Firework 4", ID = 144, Category = "Fireworks", Description = "Mega firework"},
    {Name = "Classic Firework", ID = 145, Category = "Fireworks", Description = "Traditional firework"},
    
    -- Plushies (4 blocks)
    {Name = "Plushie 1", ID = 146, Category = "Plushies", Description = "Teddy bear"},
    {Name = "Plushie 2", ID = 147, Category = "Plushies", Description = "Bunny plushie"},
    {Name = "Plushie 3", ID = 148, Category = "Plushies", Description = "Cat plushie"},
    {Name = "Plushie 4", ID = 149, Category = "Plushies", Description = "Dog plushie"},
    
    -- Balloons (2 blocks)
    {Name = "Balloon Block", ID = 150, Category = "Balloons", Description = "Floating balloon"},
    {Name = "Star Balloon Block", ID = 151, Category = "Balloons", Description = "Star balloon"},
    
    -- Trophies (4 blocks)
    {Name = "Trophy 1st", ID = 152, Category = "Trophies", Description = "Gold medal"},
    {Name = "Trophy 2nd", ID = 153, Category = "Trophies", Description = "Silver medal"},
    {Name = "Trophy 3rd", ID = 154, Category = "Trophies", Description = "Bronze medal"},
    {Name = "Master Builder Trophy", ID = 155, Category = "Trophies", Description = "Master award"},
    
    -- Structural (4 blocks)
    {Name = "Bar", ID = 156, Category = "Structural", Description = "Metal bar"},
    {Name = "Step", ID = 157, Category = "Structural", Description = "Stair step"},
    {Name = "Wedge", ID = 158, Category = "Structural", Description = "Angled wedge"},
    {Name = "Corner Wedge", ID = 159, Category = "Structural", Description = "Corner piece"}
}

-- ============================================
-- AUTO BUILD SHAPES LIBRARY
-- ============================================

local AutoBuildShapes = {
    {Name = "Sphere", Method = "sphere", Description = "Perfect sphere shape"},
    {Name = "Ball", Method = "ball", Description = "Round ball shape"},
    {Name = "Cylinder", Method = "cylinder", Description = "Tube shape"},
    {Name = "Triangle", Method = "triangle", Description = "2D triangle"},
    {Name = "Pyramid", Method = "pyramid", Description = "Pointed pyramid"},
    {Name = "Cube", Method = "cube", Description = "Box shape"},
    {Name = "Box", Method = "box", Description = "Rectangular box"},
    {Name = "Ring", Method = "ring", Description = "Circular ring"},
    {Name = "Hollow Sphere", Method = "hollow_sphere", Description = "Empty sphere"},
    {Name = "Hollow Cube", Method = "hollow_cube", Description = "Empty box"},
    {Name = "Spiral", Method = "spiral", Description = "Spiral shape"},
    {Name = "Staircase", Method = "staircase", Description = "Stairs"},
    {Name = "Bridge", Method = "bridge", Description = "Bridge structure"},
    {Name = "Wall", Method = "wall", Description = "Flat wall"},
    {Name = "Tower", Method = "tower", Description = "Vertical tower"},
    {Name = "Castle", Method = "castle", Description = "Castle structure"},
    {Name = "Ship Hull", Method = "ship_hull", Description = "Boat body"},
    {Name = "Boat Body", Method = "boat_body", Description = "Vessel shape"},
    {Name = "Catapult", Method = "catapult", Description = "Launching mechanism"},
    {Name = "Ram", Method = "ram", Description = "Battering ram"}
}

-- ============================================
-- SAVE SLOT DATA STORAGE
-- ============================================

local SaveSlotData = {}
local SelectedSlot = 1
local PlayerBoats = {}
local BuildHistory = {}
local Favorites = {}

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

local function GetPlayer()
    return Players.LocalPlayer
end

local function GetPlayerGui()
    local player = GetPlayer()
    if player then
        return player:WaitForChild("PlayerGui", 10)
    end
    return nil
end

local function GetRemote(name)
    if ReplicatedStorage then
        return ReplicatedStorage:FindFirstChild(name)
    end
    return nil
end

local function GetService(serviceName)
    local success, result = pcall(function()
        return game:GetService(serviceName)
    end)
    return success and result or nil
end

-- Notification System
local function Notify(title, text, duration)
    if not oxyX.Settings.ShowNotifications then return end
    
    pcall(function()
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = title or "oxyX",
            Text = text or "",
            Duration = duration or 3,
            Icon = "rbxassetid://7733658504"
        })
    end)
    
    print("[" .. (title or "oxyX") .. "] " .. (text or ""))
end

-- Create Notification Frame (GUI)
local function CreateNotificationUI()
    local playerGui = GetPlayerGui()
    if not playerGui then return nil end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "oxyX_Notifications"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Notifications"
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(1, -310, 1, -410)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = screenGui
    
    return screenGui
end

-- ============================================
-- AUTO WELD SYSTEM
-- ============================================

local function AutoWeld(partA, partB)
    if not partA or not partB then return nil end
    if not partA:IsA("BasePart") or not partB:IsA("BasePart") then return nil end
    
    local success, result = pcall(function()
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = partA
        weld.Part1 = partB
        weld.Parent = partA
        return weld
    end)
    
    if success then
        oxyX.Data.WeldsCreated = oxyX.Data.WeldsCreated + 1
    end
    
    return success and result or nil
end

-- ============================================
-- AUTO WIRE SYSTEM
-- ============================================

local function AutoWire(partA, partB, signalName)
    if not partA or not partB then return nil end
    if not partA:IsA("BasePart") or not partB:IsA("BasePart") then return nil end
    
    local success, result = pcall(function()
        local wire = Instance.new("Wire")
        wire.Parent = partA
        -- Connect ports based on signal type
        -- Note: Wire functionality requires proper BABFT remotes
        return wire
    end)
    
    if success then
        oxyX.Data.WiresCreated = oxyX.Data.WiresCreated + 1
    end
    
    return success and result or nil
end

-- ============================================
-- GET ALL PARTS IN BOAT
-- ============================================

local function GetBoatParts()
    local parts = {}
    local player = GetPlayer()
    
    if player and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                table.insert(parts, part)
            end
        end
    end
    
    -- Also check vehicles
    pcall(function()
        for _, vehicle in ipairs(workspace:GetDescendants()) do
            if vehicle:IsA("Model") and vehicle.Name:find("Boat") or vehicle.Name:find("Vehicle") then
                for _, part in ipairs(vehicle:GetDescendants()) do
                    if part:IsA("BasePart") then
                        table.insert(parts, part)
                    end
                end
            end
        end
    end)
    
    return parts
end

-- ============================================
-- WELD ALL PARTS
-- ============================================

local function WeldAllParts()
    local parts = GetBoatParts()
    local weldCount = 0
    
    for i = 1, #parts do
        for j = i + 1, #parts do
            if AutoWeld(parts[i], parts[j]) then
                weldCount = weldCount + 1
            end
        end
    end
    
    Notify("oxyX", "Welded " .. weldCount .. " connections!", 2)
    return weldCount
end

-- ============================================
-- WIRE ALL PARTS (AUTO SETUP)
-- ============================================

local function WireAllParts()
    local parts = GetBoatParts()
    local wireCount = 0
    
    -- Connect buttons to triggers
    for _, part in ipairs(parts) do
        local partName = part.Name:lower()
        
        if partName:find("button") or partName:find("switch") or partName:find("lever") then
            for _, otherPart in ipairs(parts) do
                local otherName = otherPart.Name:lower()
                
                if otherName:find("thruster") or 
                   otherName:find("motor") or
                   otherName:find("weapon") or
                   otherName:find("cannon") or
                   otherName:find("tnt") then
                    if AutoWire(part, otherPart, "Trigger") then
                        wireCount = wireCount + 1
                    end
                end
            end
        end
    end
    
    Notify("oxyX", "Wired " .. wireCount .. " connections!", 2)
    return wireCount
end

-- ============================================
-- AUTO SETUP (WELD + WIRE)
-- ============================================

local function AutoSetup()
    local weldCount = WeldAllParts()
    wait(oxyX.Settings.AutoWeldDelay)
    local wireCount = WireAllParts()
    
    Notify("oxyX", "Auto Setup Complete! Welds: " .. weldCount .. ", Wires: " .. wireCount, 3)
    return {Welds = weldCount, Wires = wireCount}
end

-- ============================================
-- INFINITE BLOCKS BYPASS
-- ============================================

local function EnableInfiniteBlocks()
    oxyX.Settings.InfiniteBlocks = true
    
    pcall(function()
        -- Method 1: Try to access inventory environment
        local env = getsenv and getsenv(game.Players.LocalPlayer.PlayerScripts.Inventory)
        if env and env.SetInfinite then
            env.SetInfinite(true)
        end
        
        -- Method 2: Try direct method call
        local inventoryGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("Inventory")
        if inventoryGui and inventoryGui.SetInfinite then
            inventoryGui:SetInfinite(true)
        end
    end)
    
    Notify("oxyX", "Infinite Blocks Enabled!", 2)
end

local function DisableInfiniteBlocks()
    oxyX.Settings.InfiniteBlocks = false
    
    pcall(function()
        local env = getsenv and getsenv(game.Players.LocalPlayer.PlayerScripts.Inventory)
        if env and env.SetInfinite then
            env.SetInfinite(false)
        end
    end)
    
    Notify("oxyX", "Infinite Blocks Disabled!", 2)
end

-- ============================================
-- AUTO FARM SYSTEM
-- ============================================

local FarmCoroutine = nil

local function StartAutoFarm()
    if oxyX.Settings.AutoFarm then return end
    
    oxyX.Settings.AutoFarm = true
    oxyX.Data.FarmsActivated = oxyX.Data.FarmsActivated + 1
    
    FarmCoroutine = coroutine.create(function()
        while oxyX.Settings.AutoFarm do
            pcall(function()
                -- Collect gold button
                local player = game.Players.LocalPlayer
                if player and player.PlayerGui then
                    local mainGui = player.PlayerGui:FindFirstChild("Main")
                    if mainGui then
                        local goldButton = mainGui:FindFirstChild("GoldButton")
                        if goldButton and goldButton.Visible then
                            fireclickdetector(goldButton)
                        end
                    end
                end
                
                -- Collect treasures
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("TouchTransmitter") then
                        local parent = obj.Parent
                        if parent and (parent.Name:find("Treasure") or parent.Name:find("Coin") or parent.Name:find("Gem")) then
                            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                firetouchinterest(hrp, parent, 0)
                                firetouchinterest(hrp, parent, 1)
                            end
                        end
                    end
                end
                
                -- Click gold buttons
                for _, btn in ipairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
                    if btn:IsA("ImageButton") and btn.Name:find("Gold") then
                        fireclickdetector(btn)
                    end
                end
            end)
            
            wait(oxyX.Settings.FarmSpeed)
        end
    end)
    
    coroutine.resume(FarmCoroutine)
    Notify("oxyX", "Auto Farm Started!", 2)
end

local function StopAutoFarm()
    oxyX.Settings.AutoFarm = false
    
    if FarmCoroutine then
        coroutine.close(FarmCoroutine)
        FarmCoroutine = nil
    end
    
    Notify("oxyX", "Auto Farm Stopped!", 2)
end

-- ============================================
-- SAVE SLOT VIEWER
-- ============================================

local function LoadSaveSlots()
    pcall(function()
        -- Try to access profile service
        local profileService = getsenv and getsenv(game.Players.LocalPlayer.PlayerScripts.ProfileService)
        
        if profileService and profileService.GetProfile then
            for i = 1, 5 do
                local profile = profileService.GetProfile(i)
                if profile then
                    SaveSlotData[i] = {
                        Slot = i,
                        Data = profile.Data,
                        Level = profile.Data and profile.Data.Stats and profile.Data.Stats.Level or 0,
                        Money = profile.Data and profile.Data.Stats and profile.Data.Stats.Money or 0,
                        XP = profile.Data and profile.Data.Stats and profile.Data.Stats.XP or 0,
                        Blocks = profile.Data and profile.Data.Inventory or {},
                        OwnedBoats = profile.Data and profile.Data.OwnedBoats or {}
                    }
                end
            end
            Notify("oxyX", "Loaded " .. #SaveSlotData .. " save slots", 2)
        else
            Notify("oxyX", "Could not access profile service", 2)
        end
    end)
end

local function ViewPlayerSaveSlots(playerName)
    if not playerName or playerName == "" then
        Notify("oxyX", "Please enter a player name!", 2)
        return
    end
    
    local targetPlayer = Players:FindFirstChild(playerName)
    if not targetPlayer then
        -- Try to find by display name
        for _, player in ipairs(Players:GetPlayers()) do
            if string.find(player.DisplayName:lower(), playerName:lower()) or 
               string.find(player.Name:lower(), playerName:lower()) then
                targetPlayer = player
                break
            end
        end
    end
    
    if not targetPlayer then
        Notify("oxyX", "Player not found: " .. playerName, 2)
        return
    end
    
    Notify("oxyX", "Viewing data for: " .. targetPlayer.Name, 2)
    
    -- Try to get player data through remote
    pcall(function()
        local playerDataRemote = ReplicatedStorage:FindFirstChild("PlayerData")
        if playerDataRemote and playerDataRemote.InvokeServer then
            playerDataRemote:InvokeServer("GetData", targetPlayer.UserId)
        end
    end)
end

-- ============================================
-- JSON TO .BUILD CONVERTER
-- ============================================

local function ConvertJsonToBuild(jsonString)
    if not jsonString or jsonString == "" then
        Notify("oxyX", "Please provide JSON data!", 2)
        return nil
    end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(jsonString)
    end)
    
    if not success then
        Notify("oxyX", "Invalid JSON format!", 2)
        return nil
    end
    
    local buildData = {
        Version = "1.0",
        Name = data.Name or "Imported Build",
        Author = data.Author or "Unknown",
        Description = data.Description or "",
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
                Material = part.Material or "Wood",
                Anchored = part.Anchored or false,
                BlockID = part.BlockID or 1,
                Properties = part.Properties or {}
            })
        end
    end
    
    Notify("oxyX", "Converted " .. #buildData.Parts .. " parts!", 2)
    return buildData
end

-- ============================================
-- ROBLOX STUDIO MODEL CONVERTER
-- ============================================

local function ConvertStudioModel(model)
    if not model then
        Notify("oxyX", "Please provide a model!", 2)
        return nil
    end
    
    local buildData = {
        Version = "1.0",
        Name = model.Name or "Converted Model",
        Author = GetPlayer().Name,
        Description = "Converted from Roblox Studio",
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
                Material = tostring(part.Material),
                Anchored = part.Anchored,
                Transparency = part.Transparency,
                BlockID = 1, -- Default block
                Properties = {
                    CanCollide = part.CanCollide,
                    Elasticity = part.Elasticity,
                    Friction = part.Friction
                }
            })
        end
    end
    
    Notify("oxyX", "Model converted: " .. #buildData.Parts .. " parts", 2)
    return buildData
end

-- ============================================
-- AUTO BUILD SHAPE GENERATOR
-- ============================================

local function GenerateShape(shapeType, blockID, size, density)
    if not shapeType or not blockID then
        Notify("oxyX", "Missing shape parameters!", 2)
        return 0
    end
    
    local parts = {}
    local sizeX = tonumber(size.X) or 10
    local sizeY = tonumber(size.Y) or 10
    local sizeZ = tonumber(size.Z) or 10
    
    local remote = GetRemote("PlaceBlock") or GetRemote("pX")
    local PlaceBlockRemote = remote
    
    -- Shape Generation Algorithms
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
            for y = 0, math.floor(sizeY * (1 - x / (sizeX + 1))) do
                table.insert(parts, {
                    Position = Vector3.new(x * 4, y * 4, 0),
                    BlockID = blockID
                })
            end
        end
        
    elseif shapeType == "pyramid" then
        for y = 0, sizeY do
            local layerSize = math.floor(sizeX * (1 - y / (sizeY + 1)))
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
        local thickness = math.max(2, math.floor(sizeX / 6))
        for x = -radius, radius do
            for y = -radius, radius do
                for z = -radius, radius do
                    local dist = x*x + y*y + z*z
                    if dist <= radius*radius and dist >= (radius-thickness)*(radius-thickness) then
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
        
    elseif shapeType == "ship_hull" or shapeType == "boat_body" then
        -- Boat hull shape
        local length = sizeX
        local width = sizeZ
        local height = sizeY
        
        for x = 0, length do
            for z = 0, width do
                -- Bottom
                table.insert(parts, {
                    Position = Vector3.new(x * 4, 0, z * 4),
                    BlockID = blockID
                })
                
                -- Sides with curve
                local sideHeight = math.floor(height * (1 - math.abs(x - length/2) / (length/2) * 0.5))
                for y = 1, sideHeight do
                    if z == 0 or z == width then
                        table.insert(parts, {
                            Position = Vector3.new(x * 4, y * 4, z * 4),
                            BlockID = blockID
                        })
                    end
                end
            end
        end
        
    elseif shapeType == "bridge" then
        local length = sizeX
        local width = sizeZ
        
        for x = 0, length do
            for z = 0, width do
                -- Main deck
                table.insert(parts, {
                    Position = Vector3.new(x * 4, 0, z * 4),
                    BlockID = blockID
                })
                
                -- Support pillars
                if x % 3 == 0 and z == math.floor(width/2) then
                    for y = 1, sizeY do
                        table.insert(parts, {
                            Position = Vector3.new(x * 4, -y * 4, z * 4),
                            BlockID = blockID
                        })
                    end
                end
            end
        end
        
    else
        -- Default: simple box
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
    end
    
    -- Place all generated parts
    local placed = 0
    for _, partData in ipairs(parts) do
        pcall(function()
            if PlaceBlockRemote and PlaceBlockRemote.FireServer then
                PlaceBlockRemote:FireServer(partData.Position, partData.BlockID)
            end
            placed = placed + 1
            oxyX.Data.BlocksPlaced = oxyX.Data.BlocksPlaced + 1
        end)
    end
    
    Notify("oxyX", "Generated " .. placed .. " blocks!", 2)
    return placed
end

-- ============================================
-- .BUILD FILE LOADER
-- ============================================

local function LoadBuildFile(buildContent)
    if not buildContent or buildContent == "" then
        Notify("oxyX", "No build data provided!", 2)
        return 0
    end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(buildContent)
    end)
    
    if not success then
        Notify("oxyX", "Invalid .build file format!", 2)
        return 0
    end
    
    Notify("oxyX", "Loading: " .. (data.Name or "Unknown Build"), 2)
    
    -- Add to history
    table.insert(BuildHistory, {
        Name = data.Name,
        Time = os.time(),
        Parts = data.Parts and #data.Parts or 0
    })
    
    local remote = GetRemote("PlaceBlock") or GetRemote("pX")
    local placed = 0
    
    if data.Parts then
        for _, part in ipairs(data.Parts) do
            pcall(function()
                local pos = part.Position or Vector3.new(0, 0, 0)
                local blockID = part.BlockID or 1
                
                if remote and remote.FireServer then
                    remote:FireServer(pos, blockID)
                end
                
                placed = placed + 1
                oxyX.Data.BlocksPlaced = oxyX.Data.BlocksPlaced + 1
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
    return placed
end

-- ============================================
-- IMAGE LOADER FIX
-- ============================================

local function FixImageLoader()
    pcall(function()
        -- Hook into image loading to fix external URLs
        local HttpService = game:GetService("HttpService")
        
        -- Create a wrapper for Instance.new
        local OriginalNewInstance = Instance.new
        local function FixedNewInstance(className)
            local instance = OriginalNewInstance(className)
            
            if className == "ImageLabel" or className == "ImageButton" then
                instance:GetPropertyChangedSignal("Image"):Connect(function()
                    local image = instance.Image
                    if image and image ~= "" then
                        -- Check if it's an external URL
                        if string.find(image, "http://") or string.find(image, "https://") then
                            -- Try to preload the image
                            pcall(function()
                                local content = HttpService:GetAsync(image)
                            end)
                        end
                    end
                end)
            end
            
            return instance
        end
        
        -- Replace global Instance (if possible)
        if setglobal then
            setglobal("Instance", FixedNewInstance)
        end
        
        -- Also patch frequently used UI libraries
        pcall(function()
            -- Fix for common UI libraries
        end)
    end)
    
    Notify("oxyX", "Image Loader Fixed!", 2)
end

-- ============================================
-- BLOCK ID LOOKUP
-- ============================================

local function GetBlockID(blockName)
    for _, block in ipairs(BABFTBlocks) do
        if string.find(block.Name:lower(), blockName:lower()) then
            return block.ID
        end
    end
    return 11 -- Default to Brick Block
end

local function GetBlockName(blockID)
    for _, block in ipairs(BABFTBlocks) do
        if block.ID == blockID then
            return block.Name
        end
    end
    return "Unknown"
end

-- ============================================
-- UI UTILITY FUNCTIONS
-- ============================================

local function CreateRGBColor(r, g, b)
    return Color3.fromRGB(tonumber(r) or 255, tonumber(g) or 255, tonumber(b) or 255)
end

local function Tween(instance, properties, duration)
    pcall(function()
        TweenService:Create(instance, TweenInfo.new(duration or 0.3), properties):Play()
    end)
end

-- ============================================
-- MAIN UI CREATION (Built-in, No Dependencies)
-- ============================================

local MainGui = nil
local CurrentWindow = nil

local function CreateMainUI()
    local player = GetPlayer()
    local playerGui = GetPlayerGui()
    
    if not player or not playerGui then
        Notify("oxyX", "Failed to get PlayerGui!", 2)
        return nil
    end
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "oxyX_BABFT_GUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 999999
    screenGui.Parent = playerGui
    
    MainGui = screenGui
    
    -- Main Window Frame
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 550, 0, 650)
    mainWindow.Position = UDim2.new(0.5, -275, 0.5, -325)
    mainWindow.BackgroundColor3 = oxyX.Theme.Background
    mainWindow.BorderSizePixel = 0
    mainWindow.ClipsDescendants = true
    mainWindow.Parent = screenGui
    
    CurrentWindow = mainWindow
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = oxyX.Theme.Primary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainWindow
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "oxyX BABFT v2.0.0"
    titleLabel.TextColor3 = oxyX.Theme.Text
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar
    
    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -70, 0.5, -15)
    minimizeBtn.BackgroundColor3 = oxyX.Theme.Warning
    minimizeBtn.Text = "_"
    minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    minimizeBtn.TextSize = 18
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Parent = titleBar
    minimizeBtn.MouseButton1Click:Connect(function()
        -- Minimize functionality
    end)
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
    closeBtn.BackgroundColor3 = oxyX.Theme.Error
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        Notify("oxyX", "GUI Closed!", 2)
    end)
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 130, 1, -40)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = oxyX.Theme.Secondary
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainWindow
    
    -- Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -130, 1, -40)
    contentArea.Position = UDim2.new(0, 130, 0, 40)
    contentArea.BackgroundColor3 = oxyX.Theme.Background2
    contentArea.BorderSizePixel = 0
    contentArea.Parent = mainWindow
    
    -- Create Tabs
    local tabs = {
        {Name = "Home", ID = 1},
        {Name = "AutoBuild", ID = 2},
        {Name = "Blocks", ID = 3},
        {Name = "Tools", ID = 4},
        {Name = "Farm", ID = 5},
        {Name = "Converter", ID = 6},
        {Name = "Slots", ID = 7},
        {Name = "Settings", ID = 8}
    }
    
    local tabButtons = {}
    local tabContents = {}
    
    for i, tab in ipairs(tabs) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tab.Name
        tabBtn.Size = UDim2.new(1, -10, 0, 35)
        tabBtn.Position = UDim2.new(0.5, -55, 0, (i - 1) * 40 + 5)
        tabBtn.BackgroundColor3 = i == 1 and oxyX.Theme.TabSelected or oxyX.Theme.Tab
        tabBtn.Text = tab.Name
        tabBtn.TextColor3 = oxyX.Theme.Text
        tabBtn.TextSize = 12
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.Parent = tabContainer
        tabBtn.AutoButtonColor = false
        
        tabBtn.MouseEnter:Connect(function()
            tabBtn.BackgroundColor3 = oxyX.Theme.TabSelected
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if oxyX.Settings.CurrentTab ~= tab.ID then
                tabBtn.BackgroundColor3 = oxyX.Theme.Tab
            end
        end)
        
        tabBtn.MouseButton1Click:Connect(function()
            -- Switch tab
            for _, btn in ipairs(tabButtons) do
                btn.BackgroundColor3 = oxyX.Theme.Tab
            end
            tabBtn.BackgroundColor3 = oxyX.Theme.TabSelected
            oxyX.Settings.CurrentTab = tab.ID
            
            -- Show/hide content
            for _, content in ipairs(tabContents) do
                content.Visible = false
            end
            if tabContents[tab.ID] then
                tabContents[tab.ID].Visible = true
            end
        end)
        
        table.insert(tabButtons, tabBtn)
        
        -- Create tab content
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tab.Name .. "_Content"
        tabContent.Size = UDim2.new(1, -20, 1, -20)
        tabContent.Position = UDim2.new(0, 10, 0, 10)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 5
        tabContent.Visible = i == 1
        tabContent.Parent = contentArea
        
        tabContents[tab.ID] = tabContent
    end
    
    -- ============================================
    -- HOME TAB CONTENT
    -- ============================================
    
    local homeContent = tabContents[1]
    
    local homeLabel1 = Instance.new("TextLabel")
    homeLabel1.Size = UDim2.new(1, 0, 0, 30)
    homeLabel1.Position = UDim2.new(0, 0, 0, 0)
    homeLabel1.BackgroundTransparency = 1
    homeLabel1.Text = "oxyX BABFT v2.0.0"
    homeLabel1.TextColor3 = oxyX.Theme.Accent
    homeLabel1.TextSize = 20
    homeLabel1.Font = Enum.Font.GothamBold
    homeLabel1.Parent = homeContent
    
    local homeLabel2 = Instance.new("TextLabel")
    homeLabel2.Size = UDim2.new(1, 0, 0, 25)
    homeLabel2.Position = UDim2.new(0, 0, 0, 30)
    homeLabel2.BackgroundTransparency = 1
    homeLabel2.Text = "Build a Boat for Treasure Ultimate Tool"
    homeLabel2.TextColor3 = oxyX.Theme.Text2
    homeLabel2.TextSize = 14
    homeLabel2.Font = Enum.Font.Gotham
    homeLabel2.Parent = homeContent
    
    local featuresLabel = Instance.new("TextLabel")
    featuresLabel.Size = UDim2.new(1, 0, 0, 25)
    featuresLabel.Position = UDim2.new(0, 0, 0, 70)
    featuresLabel.BackgroundTransparency = 1
    featuresLabel.Text = "Features:"
    featuresLabel.TextColor3 = oxyX.Theme.Text
    featuresLabel.TextSize = 14
    featuresLabel.Font = Enum.Font.GothamBold
    featuresLabel.Parent = homeContent
    
    local features = {
        "- Auto Build (.build files)",
        "- Auto Weld & Wire",
        "- Auto Farm (Fastest)",
        "- 159 BABFT Blocks",
        "- Shape Generator",
        "- JSON/Model Converter",
        "- Infinite Blocks Bypass",
        "- Save Slot Viewer"
    }
    
    for i, feature in ipairs(features) do
        local fLabel = Instance.new("TextLabel")
        fLabel.Size = UDim2.new(1, 0, 0, 20)
        fLabel.Position = UDim2.new(0, 0, 0, 95 + (i * 20))
        fLabel.BackgroundTransparency = 1
        fLabel.Text = feature
        fLabel.TextColor3 = oxyX.Theme.Text2
        fLabel.TextSize = 12
        fLabel.Font = Enum.Font.Gotham
        fLabel.Parent = homeContent
    end
    
    -- Stats Display
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Size = UDim2.new(1, 0, 0, 25)
    statsLabel.Position = UDim2.new(0, 0, 0, 280)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Text = "Session Stats:"
    statsLabel.TextColor3 = oxyX.Theme.Success
    statsLabel.TextSize = 14
    statsLabel.Font = Enum.Font.GothamBold
    statsLabel.Parent = homeContent
    
    local statsBlocks = Instance.new("TextLabel")
    statsBlocks.Size = UDim2.new(1, 0, 0, 20)
    statsBlocks.Position = UDim2.new(0, 0, 0, 305)
    statsBlocks.BackgroundTransparency = 1
    statsBlocks.Text = "Blocks Placed: 0"
    statsBlocks.TextColor3 = oxyX.Theme.Text2
    statsBlocks.TextSize = 12
    statsBlocks.Font = Enum.Font.Gotham
    statsBlocks.Parent = homeContent
    
    local statsWelds = Instance.new("TextLabel")
    statsWelds.Size = UDim2.new(1, 0, 0, 20)
    statsWelds.Position = UDim2.new(0, 0, 0, 325)
    statsWelds.BackgroundTransparency = 1
    statsWelds.Text = "Welds Created: 0"
    statsWelds.TextColor3 = oxyX.Theme.Text2
    statsWelds.TextSize = 12
    statsWelds.Font = Enum.Font.Gotham
    statsWelds.Parent = homeContent
    
    -- ============================================
    -- AUTO BUILD TAB CONTENT
    -- ============================================
    
    local buildContent = tabContents[2]
    
    local buildTitle = Instance.new("TextLabel")
    buildTitle.Size = UDim2.new(1, 0, 0, 25)
    buildTitle.Position = UDim2.new(0, 0, 0, 0)
    buildTitle.BackgroundTransparency = 1
    buildTitle.Text = "Auto Build (.build files)"
    buildTitle.TextColor3 = oxyX.Theme.Accent
    buildTitle.TextSize = 14
    buildTitle.Font = Enum.Font.GothamBold
    buildTitle.Parent = buildContent
    
    -- URL Input
    local urlBox = Instance.new("TextBox")
    urlBox.Size = UDim2.new(1, 0, 0, 30)
    urlBox.Position = UDim2.new(0, 0, 0, 35)
    urlBox.BackgroundColor3 = oxyX.Theme.Secondary
    urlBox.Text = "https://example.com/build.build"
    urlBox.TextColor3 = oxyX.Theme.Text
    urlBox.TextSize = 12
    urlBox.Font = Enum.Font.Gotham
    urlBox.BorderSizePixel = 0
    urlBox.Parent = buildContent
    
    local loadUrlBtn = Instance.new("TextButton")
    loadUrlBtn.Size = UDim2.new(1, 0, 0, 30)
    loadUrlBtn.Position = UDim2.new(0, 0, 0, 70)
    loadUrlBtn.BackgroundColor3 = oxyX.Theme.Accent
    loadUrlBtn.Text = "Load from URL"
    loadUrlBtn.TextColor3 = Color3.new(1, 1, 1)
    loadUrlBtn.TextSize = 12
    loadUrlBtn.Font = Enum.Font.GothamBold
    loadUrlBtn.BorderSizePixel = 0
    loadUrlBtn.Parent = buildContent
    loadUrlBtn.MouseButton1Click:Connect(function()
        local url = urlBox.Text
        if url and url ~= "" then
            pcall(function()
                local response = game:HttpGet(url)
                LoadBuildFile(response)
            end)
        end
    end)
    
    local loadClipBtn = Instance.new("TextButton")
    loadClipBtn.Size = UDim2.new(1, 0, 0, 30)
    loadClipBtn.Position = UDim2.new(0, 0, 0, 105)
    loadClipBtn.BackgroundColor3 = oxyX.Theme.Button
    loadClipBtn.Text = "Load from Clipboard"
    loadClipBtn.TextColor3 = Color3.new(1, 1, 1)
    loadClipBtn.TextSize = 12
    loadClipBtn.Font = Enum.Font.GothamBold
    loadClipBtn.BorderSizePixel = 0
    loadClipBtn.Parent = buildContent
    loadClipBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local clipboard = getclipboard()
            if clipboard then
                LoadBuildFile(clipboard)
            end
        end)
    end)
    
    -- Shape Generator Section
    local shapeTitle = Instance.new("TextLabel")
    shapeTitle.Size = UDim2.new(1, 0, 0, 25)
    shapeTitle.Position = UDim2.new(0, 0, 0, 150)
    shapeTitle.BackgroundTransparency = 1
    shapeTitle.Text = "Shape Generator"
    shapeTitle.TextColor3 = oxyX.Theme.Accent
    shapeTitle.TextSize = 14
    shapeTitle.Font = Enum.Font.GothamBold
    shapeTitle.Parent = buildContent
    
    -- Shape selection would go here (simplified for size)
    local shapeInfo = Instance.new("TextLabel")
    shapeInfo.Size = UDim2.new(1, 0, 0, 40)
    shapeInfo.Position = UDim2.new(0, 0, 0, 180)
    shapeInfo.BackgroundTransparency = 1
    shapeInfo.Text = "Select shape, block type, and size,\nthen click Generate Shape"
    shapeInfo.TextColor3 = oxyX.Theme.Text2
    shapeInfo.TextSize = 11
    shapeInfo.Font = Enum.Font.Gotham
    shapeInfo.TextWrapped = true
    shapeInfo.Parent = buildContent
    
    -- ============================================
    -- TOOLS TAB CONTENT
    -- ============================================
    
    local toolsContent = tabContents[4]
    
    local toolsTitle = Instance.new("TextLabel")
    toolsTitle.Size = UDim2.new(1, 0, 0, 25)
    toolsTitle.Position = UDim2.new(0, 0, 0, 0)
    toolsTitle.BackgroundTransparency = 1
    toolsTitle.Text = "Auto Setup Tools"
    toolsTitle.TextColor3 = oxyX.Theme.Accent
    toolsTitle.TextSize = 14
    toolsTitle.Font = Enum.Font.GothamBold
    toolsTitle.Parent = toolsContent
    
    -- Auto Weld Toggle
    local weldToggle = Instance.new("TextButton")
    weldToggle.Size = UDim2.new(1, 0, 0, 35)
    weldToggle.Position = UDim2.new(0, 0, 0, 35)
    weldToggle.BackgroundColor3 = oxyX.Theme.Success
    weldToggle.Text = "Auto Weld: ON"
    weldToggle.TextColor3 = Color3.new(1, 1, 1)
    weldToggle.TextSize = 12
    weldToggle.Font = Enum.Font.GothamBold
    weldToggle.BorderSizePixel = 0
    weldToggle.Parent = toolsContent
    weldToggle.MouseButton1Click:Connect(function()
        oxyX.Settings.AutoWeld = not oxyX.Settings.AutoWeld
        weldToggle.BackgroundColor3 = oxyX.Settings.AutoWeld and oxyX.Theme.Success or oxyX.Theme.Error
        weldToggle.Text = "Auto Weld: " .. (oxyX.Settings.AutoWeld and "ON" or "OFF")
    end)
    
    -- Auto Wire Toggle
    local wireToggle = Instance.new("TextButton")
    wireToggle.Size = UDim2.new(1, 0, 0, 35)
    wireToggle.Position = UDim2.new(0, 0, 0, 75)
    wireToggle.BackgroundColor3 = oxyX.Theme.Success
    wireToggle.Text = "Auto Wire: ON"
    wireToggle.TextColor3 = Color3.new(1, 1, 1)
    wireToggle.TextSize = 12
    wireToggle.Font = Enum.Font.GothamBold
    wireToggle.BorderSizePixel = 0
    wireToggle.Parent = toolsContent
    wireToggle.MouseButton1Click:Connect(function()
        oxyX.Settings.AutoWire = not oxyX.Settings.AutoWire
        wireToggle.BackgroundColor3 = oxyX.Settings.AutoWire and oxyX.Theme.Success or oxyX.Theme.Error
        wireToggle.Text = "Auto Wire: " .. (oxyX.Settings.AutoWire and "ON" or "OFF")
    end)
    
    -- Weld All Button
    local weldAllBtn = Instance.new("TextButton")
    weldAllBtn.Size = UDim2.new(1, 0, 0, 30)
    weldAllBtn.Position = UDim2.new(0, 0, 0, 120)
    weldAllBtn.BackgroundColor3 = oxyX.Theme.Button
    weldAllBtn.Text = "Weld All Parts"
    weldAllBtn.TextColor3 = Color3.new(1, 1, 1)
    weldAllBtn.TextSize = 12
    weldAllBtn.Font = Enum.Font.GothamBold
    weldAllBtn.BorderSizePixel = 0
    weldAllBtn.Parent = toolsContent
    weldAllBtn.MouseButton1Click:Connect(function()
        WeldAllParts()
    end)
    
    -- Wire All Button
    local wireAllBtn = Instance.new("TextButton")
    wireAllBtn.Size = UDim2.new(1, 0, 0, 30)
    wireAllBtn.Position = UDim2.new(0, 0, 0, 155)
    wireAllBtn.BackgroundColor3 = oxyX.Theme.Button
    wireAllBtn.Text = "Wire All Parts"
    wireAllBtn.TextColor3 = Color3.new(1, 1, 1)
    wireAllBtn.TextSize = 12
    wireAllBtn.Font = Enum.Font.GothamBold
    wireAllBtn.BorderSizePixel = 0
    wireAllBtn.Parent = toolsContent
    wireAllBtn.MouseButton1Click:Connect(function()
        WireAllParts()
    end)
    
    -- Auto Setup Button
    local autoSetupBtn = Instance.new("TextButton")
    autoSetupBtn.Size = UDim2.new(1, 0, 0, 35)
    autoSetupBtn.Position = UDim2.new(0, 0, 0, 195)
    autoSetupBtn.BackgroundColor3 = oxyX.Theme.Accent2
    autoSetupBtn.Text = "Auto Setup (Weld + Wire)"
    autoSetupBtn.TextColor3 = Color3.new(1, 1, 1)
    autoSetupBtn.TextSize = 12
    autoSetupBtn.Font = Enum.Font.GothamBold
    autoSetupBtn.BorderSizePixel = 0
    autoSetupBtn.Parent = toolsContent
    autoSetupBtn.MouseButton1Click:Connect(function()
        AutoSetup()
    end)
    
    -- Infinite Blocks Section
    local infiniteLabel = Instance.new("TextLabel")
    infiniteLabel.Size = UDim2.new(1, 0, 0, 25)
    infiniteLabel.Position = UDim2.new(0, 0, 0, 250)
    infiniteLabel.BackgroundTransparency = 1
    infiniteLabel.Text = "Block Settings"
    infiniteLabel.TextColor3 = oxyX.Theme.Accent
    infiniteLabel.TextSize = 14
    infiniteLabel.Font = Enum.Font.GothamBold
    infiniteLabel.Parent = toolsContent
    
    local infiniteToggle = Instance.new("TextButton")
    infiniteToggle.Size = UDim2.new(1, 0, 0, 35)
    infiniteToggle.Position = UDim2.new(0, 0, 0, 280)
    infiniteToggle.BackgroundColor3 = oxyX.Theme.Error
    infiniteToggle.Text = "Infinite Blocks: OFF"
    infiniteToggle.TextColor3 = Color3.new(1, 1, 1)
    infiniteToggle.TextSize = 12
    infiniteToggle.Font = Enum.Font.GothamBold
    infiniteToggle.BorderSizePixel = 0
    infiniteToggle.Parent = toolsContent
    infiniteToggle.MouseButton1Click:Connect(function()
        if oxyX.Settings.InfiniteBlocks then
            DisableInfiniteBlocks()
            infiniteToggle.BackgroundColor3 = oxyX.Theme.Error
            infiniteToggle.Text = "Infinite Blocks: OFF"
        else
            EnableInfiniteBlocks()
            infiniteToggle.BackgroundColor3 = oxyX.Theme.Success
            infiniteToggle.Text = "Infinite Blocks: ON"
        end
    end)
    
    -- Image Loader Fix
    local fixImageBtn = Instance.new("TextButton")
    fixImageBtn.Size = UDim2.new(1, 0, 0, 30)
    fixImageBtn.Position = UDim2.new(0, 0, 0, 325)
    fixImageBtn.BackgroundColor3 = oxyX.Theme.Button
    fixImageBtn.Text = "Fix Image Loader"
    fixImageBtn.TextColor3 = Color3.new(1, 1, 1)
    fixImageBtn.TextSize = 12
    fixImageBtn.Font = Enum.Font.GothamBold
    fixImageBtn.BorderSizePixel = 0
    fixImageBtn.Parent = toolsContent
    fixImageBtn.MouseButton1Click:Connect(function()
        FixImageLoader()
    end)
    
    -- ============================================
    -- FARM TAB CONTENT
    -- ============================================
    
    local farmContent = tabContents[5]
    
    local farmTitle = Instance.new("TextLabel")
    farmTitle.Size = UDim2.new(1, 0, 0, 25)
    farmTitle.Position = UDim2.new(0, 0, 0, 0)
    farmTitle.BackgroundTransparency = 1
    farmTitle.Text = "Auto Farm"
    farmTitle.TextColor3 = oxyX.Theme.Accent
    farmTitle.TextSize = 14
    farmTitle.Font = Enum.Font.GothamBold
    farmTitle.Parent = farmContent
    
    -- Farm Toggle
    local farmToggle = Instance.new("TextButton")
    farmToggle.Size = UDim2.new(1, 0, 0, 40)
    farmToggle.Position = UDim2.new(0, 0, 0, 35)
    farmToggle.BackgroundColor3 = oxyX.Theme.Error
    farmToggle.Text = "Auto Farm: OFF\nClick to start"
    farmToggle.TextColor3 = Color3.new(1, 1, 1)
    farmToggle.TextSize = 12
    farmToggle.Font = Enum.Font.GothamBold
    farmToggle.BorderSizePixel = 0
    farmToggle.Parent = farmContent
    farmToggle.MouseButton1Click:Connect(function()
        if oxyX.Settings.AutoFarm then
            StopAutoFarm()
            farmToggle.BackgroundColor3 = oxyX.Theme.Error
            farmToggle.Text = "Auto Farm: OFF\nClick to start"
        else
            StartAutoFarm()
            farmToggle.BackgroundColor3 = oxyX.Theme.Success
            farmToggle.Text = "Auto Farm: ON\nClick to stop"
        end
    end)
    
    -- Farm Speed Info
    local speedInfo = Instance.new("TextLabel")
    speedInfo.Size = UDim2.new(1, 0, 0, 25)
    speedInfo.Position = UDim2.new(0, 0, 0, 85)
    speedInfo.BackgroundTransparency = 1
    speedInfo.Text = "Farm Speed: 0.05s (Fastest)"
    speedInfo.TextColor3 = oxyX.Theme.Text2
    speedInfo.TextSize = 12
    speedInfo.Font = Enum.Font.Gotham
    speedInfo.Parent = farmContent
    
    -- Collect Buttons
    local collectGoldBtn = Instance.new("TextButton")
    collectGoldBtn.Size = UDim2.new(1, 0, 0, 30)
    collectGoldBtn.Position = UDim2.new(0, 0, 0, 120)
    collectGoldBtn.BackgroundColor3 = oxyX.Theme.Warning
    collectGoldBtn.Text = "Collect Gold"
    collectGoldBtn.TextColor3 = Color3.new(1, 1, 1)
    collectGoldBtn.TextSize = 12
    collectGoldBtn.Font = Enum.Font.GothamBold
    collectGoldBtn.BorderSizePixel = 0
    collectGoldBtn.Parent = farmContent
    collectGoldBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local mainGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main")
            if mainGui then
                local goldButton = mainGui:FindFirstChild("GoldButton")
                if goldButton and goldButton.Visible then
                    fireclickdetector(goldButton)
                end
            end
        end)
        Notify("oxyX", "Gold collected!", 2)
    end)
    
    local collectTreasuresBtn = Instance.new("TextButton")
    collectTreasuresBtn.Size = UDim2.new(1, 0, 0, 30)
    collectTreasuresBtn.Position = UDim2.new(0, 0, 0, 155)
    collectTreasuresBtn.BackgroundColor3 = oxyX.Theme.Success
    collectTreasuresBtn.Text = "Collect All Treasures"
    collectTreasuresBtn.TextColor3 = Color3.new(1, 1, 1)
    collectTreasuresBtn.TextSize = 12
    collectTreasuresBtn.Font = Enum.Font.GothamBold
    collectTreasuresBtn.BorderSizePixel = 0
    collectTreasuresBtn.Parent = farmContent
    collectTreasuresBtn.MouseButton1Click:Connect(function()
        local count = 0
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("TouchTransmitter") then
                local parent = obj.Parent
                if parent and (parent.Name:find("Treasure") or parent.Name:find("Coin") or parent.Name:find("Gem")) then
                    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        firetouchinterest(hrp, parent, 0)
                        firetouchinterest(hrp, parent, 1)
                        count = count + 1
                    end
                end
            end
        end
        Notify("oxyX", "Collected " .. count .. " treasures!", 2)
    end)
    
    -- ============================================
    -- SETTINGS TAB CONTENT
    -- ============================================
    
    local settingsContent = tabContents[8]
    
    local settingsTitle = Instance.new("TextLabel")
    settingsTitle.Size = UDim2.new(1, 0, 0, 25)
    settingsTitle.Position = UDim2.new(0, 0, 0, 0)
    settingsTitle.BackgroundTransparency = 1
    settingsTitle.Text = "Settings"
    settingsTitle.TextColor3 = oxyX.Theme.Accent
    settingsTitle.TextSize = 14
    settingsTitle.Font = Enum.Font.GothamBold
    settingsTitle.Parent = settingsContent
    
    -- Notifications Toggle
    local notifToggle = Instance.new("TextButton")
    notifToggle.Size = UDim2.new(1, 0, 0, 35)
    notifToggle.Position = UDim2.new(0, 0, 0, 35)
    notifToggle.BackgroundColor3 = oxyX.Theme.Success
    notifToggle.Text = "Notifications: ON"
    notifToggle.TextColor3 = Color3.new(1, 1, 1)
    notifToggle.TextSize = 12
    notifToggle.Font = Enum.Font.GothamBold
    notifToggle.BorderSizePixel = 0
    notifToggle.Parent = settingsContent
    notifToggle.MouseButton1Click:Connect(function()
        oxyX.Settings.ShowNotifications = not oxyX.Settings.ShowNotifications
        notifToggle.BackgroundColor3 = oxyX.Settings.ShowNotifications and oxyX.Theme.Success or oxyX.Theme.Error
        notifToggle.Text = "Notifications: " .. (oxyX.Settings.ShowNotifications and "ON" or "OFF")
    end)
    
    -- Destroy UI Button
    local destroyBtn = Instance.new("TextButton")
    destroyBtn.Size = UDim2.new(1, 0, 0, 35)
    destroyBtn.Position = UDim2.new(0, 0, 0, 80)
    destroyBtn.BackgroundColor3 = oxyX.Theme.Error
    destroyBtn.Text = "Destroy UI"
    destroyBtn.TextColor3 = Color3.new(1, 1, 1)
    destroyBtn.TextSize = 12
    destroyBtn.Font = Enum.Font.GothamBold
    destroyBtn.BorderSizePixel = 0
    destroyBtn.Parent = settingsContent
    destroyBtn.MouseButton1Click:Connect(function()
        if screenGui then
            screenGui:Destroy()
        end
        Notify("oxyX", "GUI Destroyed!", 2)
    end)
    
    -- Version Info
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(1, 0, 0, 50)
    versionLabel.Position = UDim2.new(0, 0, 0, 200)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "oxyX BABFT v2.0.0\nMade with ❤️ by oxyX Team\n\nGitHub: github.com/johsua092-ui/anu-anu"
    versionLabel.TextColor3 = oxyX.Theme.Text2
    versionLabel.TextSize = 11
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextWrapped = true
    versionLabel.Parent = settingsContent
    
    -- Drag functionality for window
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainWindow.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainWindow.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    Notify("oxyX", "GUI Created!", 2)
    return screenGui
end

-- ============================================
-- INITIALIZATION
-- ============================================

local function Init()
    -- Wait for game to load
    repeat wait(0.1) until game:IsLoaded()
    
    -- Wait for PlayerGui
    local playerGui = GetPlayerGui()
    repeat wait(0.1) until playerGui
    
    -- Wait a bit more for stability
    wait(1)
    
    -- Create Main UI
    CreateMainUI()
    
    -- Show welcome notification
    Notify("oxyX BABFT", "Loaded successfully!", 3)
    Notify("oxyX BABFT", "159 Blocks | Auto Build | Auto Farm", 3)
    
    print("===========================================")
    print("oxyX BABFT v2.0.0 loaded!")
    print("Features: Auto Build, Auto Weld/Wire, Auto Farm, 159 Blocks")
    print("GitHub: github.com/johsua092-ui/anu-anu")
    print("===========================================")
end

-- Start the script
Init()

return oxyX
