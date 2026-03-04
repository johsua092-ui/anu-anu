-- oxyX Loader for Roblox Exploits
-- Compatible with: Xeno Velocity, Fluxus, Hydrogen, Krnl, Delta, Synapse X, etc.

local URL = "https://raw.githubusercontent.com/johsua092-ui/jawajawajawa/refs/heads/main/oxyX_BuildBoat.lua"

local function fetchScript(url)
    -- Try different HTTP methods
    local success, result = pcall(function()
        if http_request then
            return http_request({
                Url = url,
                Method = "GET"
            }).Body
        elseif request then
            return request({
                Url = url,
                Method = "GET"
            }).Body
        elseif syn and syn.request then
            return syn.request({
                Url = url,
                Method = "GET"
            }).Body
        elseif game and game.HttpGet then
            return game.HttpGet(game, url)
        else
            return nil
        end
    end)
    
    if success and result then
        return result
    end
    return nil
end

local scriptBody = fetchScript(URL)

if scriptBody then
    local loadSuccess, loadErr = pcall(function()
        loadstring(scriptBody)()
    end)
    
    if loadSuccess then
        print("oxyX: Script loaded successfully!")
    else
        warn("oxyX: Failed to execute script: " .. tostring(loadErr))
    end
else
    warn("oxyX: Failed to fetch script from GitHub")
end
