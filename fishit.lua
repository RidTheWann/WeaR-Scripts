-- WeaR-Scripts - Fish It! Edition (Hardened)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Character = Player and (Player.Character or Player.CharacterAdded:Wait()) or nil

-- Config (editable / persisted by GUI)
local Config = {
    AutoFish = false,
    AutoSell = false,
    AutoCast = false,
    InstantCatch = false,
    InfiniteCash = false,
    TeleportToFishZone = false,
    AutoShake = false,
    NoFishEscape = false,
    EnableBlatant = false
}

-- Helpers
local function safeFire(obj, ...)
    if not obj then return false, "no-object" end
    local ok, err = pcall(function() obj:FireServer(...) end)
    return ok, err
end

local function findRod()
    if not Character then return nil end
    return Character:FindFirstChildOfClass("Tool")
end

-- Debounce utilities
local debounce = {}
local function canRun(key, interval)
    interval = interval or 0.1
    if debounce[key] and tick() - debounce[key] < interval then return false end
    debounce[key] = tick()
    return true
end

-- Auto Fish (safe)
local function autoFish()
    spawn(function()
        while Config.AutoFish do
            wait(0.2)
            if canRun("autoFish", 0.15) then
                local rod = findRod()
                if rod and rod:FindFirstChild("events") then
                    local events = rod.events
                    if events:FindFirstChild("cast") then
                        safeFire(events.cast, 100, 1)
                    end
                end
            end
        end
    end)
end

-- Instant Catch (safe)
local function instantCatch()
    spawn(function()
        while Config.InstantCatch do
            wait(0.15)
            if canRun("instantCatch", 0.12) then
                local rod = findRod()
                if rod and rod:FindFirstChild("events") then
                    local events = rod.events
                    if events:FindFirstChild("catch") then
                        safeFire(events.catch, 100)
                    end
                end
            end
        end
    end)
end

-- Auto Shake (safe)
local function autoShake()
    spawn(function()
        while Config.AutoShake do
            wait(0.05)
            if canRun("autoShake", 0.04) then
                local rod = findRod()
                if rod and rod:FindFirstChild("events") then
                    local events = rod.events
                    if events:FindFirstChild("shake") then
                        safeFire(events.shake)
                    end
                end
            end
        end
    end)
end

-- Auto Sell (teleport safely and restore)
local function autoSell()
    spawn(function()
        while Config.AutoSell do
            wait(5)
            if canRun("autoSell", 4.5) then
                local sellPad = workspace:FindFirstChild("SellPad") or workspace:FindFirstChild("Sell")
                if sellPad and Character and Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = Character.HumanoidRootPart
                    local old = hrp.CFrame
                    hrp.CFrame = sellPad.CFrame + Vector3.new(0, 3, 0)
                    wait(0.8)
                    if old then pcall(function() hrp.CFrame = old end) end
                end
            end
        end
    end)
end

-- Teleport to Fish Zone
local function teleportToFishZone()
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    for _, v in pairs(workspace:GetDescendants()) do
        if (v.Name:find("Zone") or v.Name:find("Fish") or v.Name:find("Spot")) and v:IsA("BasePart") then
            pcall(function()
                Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 5, 0)
            end)
            return
        end
    end
end

-- No Fish Escape (safer approach)
local function noFishEscape()
    spawn(function()
        while Config.NoFishEscape do
            wait(0.2)
            local playerGui = Player and Player:FindFirstChild("PlayerGui")
            if playerGui then
                local fishingUI = playerGui:FindFirstChild("FishingUI")
                if fishingUI then
                    local bar = fishingUI:FindFirstChild("Bar")
                    if bar and typeof(bar.Position) == "UDim2" then
                        pcall(function() bar.Position = UDim2.new(0.5, 0, 0.5, 0) end)
                    end
                end
            end
        end
    end)
end

-- Infinite Cash (blatant, opt-in)
local function infiniteCash()
    if not Config.EnableBlatant then return end
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local cashRemote = remotes:FindFirstChild("AddCash")
        if cashRemote then
            safeFire(cashRemote, 999999)
        end
    end
end

-- Exports
return {
    Config = Config,
    autoFish = autoFish,
    instantCatch = instantCatch,
    autoShake = autoShake,
    autoSell = autoSell,
    teleportToFishZone = teleportToFishZone,
    noFishEscape = noFishEscape,
    infiniteCash = infiniteCash,
}
