--[[
    oxyX_BABFT Loader - Loadstring Version
    GitHub: https://raw.githubusercontent.com/johsua092-ui/anu-anu/main/oxyX_BABFT.lua
    
    How to use:
    1. Copy this entire script
    2. Paste into your executor (Xeno Velocity, Fluxus, Hydrogen, Krnl, Delta, etc.)
    3. Script will automatically fetch and run oxyX_BABFT from GitHub
    
    Compatible with:
    - Xeno Velocity
    - Fluxus
    - Hydrogen
    - Krnl
    - Delta
    - And other Roblox executors
]]

-- Configuration
local SCRIPT_URL = "https://raw.githubusercontent.com/johsua092-ui/anu-anu/main/oxyX_BABFT.lua"
local SCRIPT_NAME = "oxyX_BABFT"

-- HTTP Request Functions (Multiple Fallbacks)
local function fetchScript(url)
    local success, result
    
    -- Method 1: http_request (Common in most executors)
    success, result = pcall(function()
        return http_request({
            Url = url,
            Method = "GET"
        })
    end)
    if success and result and result.Body then
        return result.Body
    end
    
    -- Method 2: request (Synapse X, some executors)
    success, result = pcall(function()
        return request({
            Url = url,
            Method = "GET"
        })
    end)
    if success and result and result.Body then
        return result.Body
    end
    
    -- Method 3: syn.request (Synapse X)
    success, result = pcall(function()
        return syn.request({
            Url = url,
            Method = "GET"
        })
    end)
    if success and result and result.Body then
        return result.Body
    end
    
    -- Method 4: game.HttpGet (Native Roblox)
    success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        return result
    end
    
    -- Method 5: game.HttpService (Native Roblox)
    success, result = pcall(function()
        local HttpService = game:GetService("HttpService")
        return HttpService:GetAsync(url)
    end)
    if success and result then
        return result
    end
    
    return nil
end

-- Loadstring Execution
local function executeScript(scriptContent)
    local success, result = pcall(loadstring, scriptContent)
    if success then
        return result()
    else
        error("Failed to load script: " .. tostring(result))
    end
end

-- Main Loader
local function main()
    print("[" .. SCRIPT_NAME .. "] Loading...")
    print("[" .. SCRIPT_NAME .. "] Fetching from: " .. SCRIPT_URL)
    
    local scriptContent = fetchScript(SCRIPT_URL)
    
    if not scriptContent then
        error("[" .. SCRIPT_NAME .. "] Failed to fetch script from GitHub!")
    end
    
    print("[" .. SCRIPT_NAME .. "] Script fetched successfully!")
    print("[" .. SCRIPT_NAME .. "] Executing...")
    
    executeScript(scriptContent)
    
    print("[" .. SCRIPT_NAME .. "] Loaded successfully!")
end

-- Execute
main()
