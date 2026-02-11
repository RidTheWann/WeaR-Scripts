-- WeaR-Scripts - Fish It! Edition
-- Game: Fish It! Roblox

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Config
local Config = {
    AutoFish = false,
    AutoSell = false,
    AutoCast = false,
    InstantCatch = false,
    InfiniteCash = false,
    TeleportToFishZone = false,
    AutoShake = false,
    NoFishEscape = false
}

-- Auto Fish
local function autoFish()
    spawn(function()
        while Config.AutoFish do
            wait(0.1)
            local rod = Character:FindFirstChildOfClass("Tool")
            if rod and rod:FindFirstChild("events") then
                local events = rod.events
                if events:FindFirstChild("cast") then
                    events.cast:FireServer(100, 1)
                end
            end
        end
    end)
end

-- Auto Catch (Instant)
local function instantCatch()
    spawn(function()
        while Config.InstantCatch do
            wait(0.1)
            local rod = Character:FindFirstChildOfClass("Tool")
            if rod and rod:FindFirstChild("events") then
                local events = rod.events
                if events:FindFirstChild("catch") then
                    events.catch:FireServer(100)
                end
            end
        end
    end)
end

-- Auto Shake
local function autoShake()
    spawn(function()
        while Config.AutoShake do
            wait(0.05)
            local rod = Character:FindFirstChildOfClass("Tool")
            if rod and rod:FindFirstChild("events") then
                local events = rod.events
                if events:FindFirstChild("shake") then
                    events.shake:FireServer()
                end
            end
        end
    end)
end

-- Auto Sell
local function autoSell()
    spawn(function()
        while Config.AutoSell do
            wait(5)
            local sellPad = workspace:FindFirstChild("SellPad") or workspace:FindFirstChild("Sell")
            if sellPad and Character:FindFirstChild("HumanoidRootPart") then
                Character.HumanoidRootPart.CFrame = sellPad.CFrame
                wait(1)
            end
        end
    end)
end

-- Teleport to Fish Zone
local function teleportToFishZone()
    local fishZones = workspace:FindFirstChild("FishZones")
    if fishZones and Character:FindFirstChild("HumanoidRootPart") then
        local zone = fishZones:GetChildren()[1]
        if zone then
            Character.HumanoidRootPart.CFrame = zone.CFrame + Vector3.new(0, 5, 0)
        end
    end
end

-- No Fish Escape (Blatant)
local function noFishEscape()
    spawn(function()
        while Config.NoFishEscape do
            wait(0.1)
            local playerGui = Player:FindFirstChild("PlayerGui")
            if playerGui then
                local fishingUI = playerGui:FindFirstChild("FishingUI")
                if fishingUI then
                    local bar = fishingUI:FindFirstChild("Bar")
                    if bar then
                        bar.Position = UDim2.new(0.5, 0, 0.5, 0)
                    end
                end
            end
        end
    end)
end

-- Infinite Cash (Blatant)
local function infiniteCash()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local cashRemote = remotes:FindFirstChild("AddCash")
        if cashRemote then
            cashRemote:FireServer(999999)
        end
    end
end

return {
    Config = Config,
    autoFish = autoFish,
    instantCatch = instantCatch,
    autoShake = autoShake,
    autoSell = autoSell,
    teleportToFishZone = teleportToFishZone,
    noFishEscape = noFishEscape,
    infiniteCash = infiniteCash
}
