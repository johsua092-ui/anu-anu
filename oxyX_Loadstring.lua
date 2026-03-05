-- oxyX_BABFT Loadstring Loader
-- Compatible with: Xeno Velocity, Fluxus, Hydrogen, Krnl, Delta, Synapse X, etc.

local URL = "https://raw.githubusercontent.com/johsua092-ui/anu-anu/refs/heads/main/oxyX_BABFT.lua"

local function fetchScript(url)
    -- Method 1: http_request (Common)
    if http_request then
        local success, result = pcall(function()
            return http_request({
                Method = "GET",
                Url = url
            })
        end)
        if success and result.Body then
            return result.Body
        end
    end
    
    -- Method 2: request (Fluxus, Hydrogen)
    if request then
        local success, result = pcall(function()
            return request({
                Method = "GET",
                Url = url
            })
        end)
        if success and result.Body then
            return result.Body
        end
    end
    
    -- Method 3: syn.request (Synapse X)
    if syn and syn.request then
        local success, result = pcall(function()
            return syn.request({
                Method = "GET",
                Url = url
            })
        end)
        if success and result.Body then
            return result.Body
        end
    end
    
    -- Method 4: game.HttpGet (Native Roblox)
    local HttpService = game:GetService("HttpService")
    local success, result = pcall(function()
        return HttpService:GetAsync(url)
    end)
    if success then
        return result
    end
    
    -- Method 5: HttpGetAsync (Alternative)
    local success, result = pcall(function()
        return HttpService:GetAsync(url)
    end)
    if success then
        return result
    end
    
    return nil
end

-- Fetch and execute
local scriptBody = fetchScript(URL)

if scriptBody then
    local loadstring = loadstring or load
    if loadstring then
        local success, err = pcall(function()
            loadstring(scriptBody)()
        end)
        if not success then
            warn("[oxyX] Error executing script: " .. tostring(err))
        end
    else
        warn("[oxyX] loadstring not available")
    end
else
    warn("[oxyX] Failed to fetch script from: " .. URL)
end
