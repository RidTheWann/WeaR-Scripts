-- WeaR-Scripts GUI - Fish It! Edition
-- Universal + Fish It! Features + Blatant
-- Version: 1.0

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Config (UI-persisted)
local Config = {
    AutoFish = false,
    AutoSell = false,
    AutoCatch = false,
    AutoShake = false,
    InstaCatch = false,
    AutoFarmBlatant = false,
    ForceLegendary = false,
    AutoEquipBestRod = false,
    AutoBuyBait = false,
    AntiAFK = false,
    EnableBlatant = false,
    Theme = "Neon"
}

-- Persistence (executor-dependent)
local configFile = "WeaR-FishIt-Config.json"
local function saveConfig()
    if writefile and HttpService then
        pcall(function()
            writefile(configFile, HttpService:JSONEncode(Config))
        end)
    end
end

local function loadConfig()
    if readfile and isfile and HttpService then
        local ok, data = pcall(function() return readfile(configFile) end)
        if ok and data then
            local succ, parsed = pcall(function() return HttpService:JSONDecode(data) end)
            if succ and type(parsed) == "table" then
                for k, v in pairs(parsed) do
                    Config[k] = v
                end
            end
        end
    end
end

pcall(loadConfig)

local flying = false
local noclipping = false
local infiniteJumpEnabled = false

-- Anti-AFK
spawn(function()
    while wait(60) do
        if Config.AntiAFK then
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end
end)

-- Universal Functions
local function setWalkSpeed(speed)
    if Humanoid then Humanoid.WalkSpeed = speed end
end

local function setJumpPower(power)
    if Humanoid then Humanoid.JumpPower = power end
end

local bodyVelocity, bodyGyro
local function toggleFly()
    flying = not flying
    if flying then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Parent = RootPart
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.Parent = RootPart
        
        spawn(function()
            while flying do
                wait()
                local camera = workspace.CurrentCamera
                local direction = Vector3.new(0, 0, 0)
                local flySpeed = 50
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + (camera.CFrame.LookVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - (camera.CFrame.LookVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - (camera.CFrame.RightVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + (camera.CFrame.RightVector * flySpeed)
                end
                
                bodyVelocity.Velocity = direction
                bodyGyro.CFrame = camera.CFrame
            end
        end)
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
end

local function toggleNoclip()
    noclipping = not noclipping
    RunService.Stepped:Connect(function()
        if noclipping then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function toggleESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            if not player.Character:FindFirstChild("Highlight") then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = player.Character
            else
                player.Character:FindFirstChild("Highlight"):Destroy()
            end
        end
    end
end

local function toggleInfiniteJump()
    infiniteJumpEnabled = not infiniteJumpEnabled
end

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Fish It! Functions
local function autoFish()
    Config.AutoFish = not Config.AutoFish
    spawn(function()
        while Config.AutoFish do
            wait(0.5)
            local rod = Character:FindFirstChildOfClass("Tool")
            if rod and rod:FindFirstChild("events") then
                local events = rod.events
                if events:FindFirstChild("cast") then
                    pcall(function() events.cast:FireServer(100, 1) end)
                end
            end
        end
    end)
    saveConfig()
end

local function autoCatch()
    Config.AutoCatch = not Config.AutoCatch
    spawn(function()
        while Config.AutoCatch do
            wait(0.1)
            local playerGui = Player:FindFirstChild("PlayerGui")
            if playerGui then
                local reelUI = playerGui:FindFirstChild("reel")
                if reelUI and reelUI.Enabled then
                    local rod = Character:FindFirstChildOfClass("Tool")
                    if rod and rod:FindFirstChild("events") then
                        local events = rod.events
                        if events:FindFirstChild("reel") then
                            pcall(function() events.reel:FireServer() end)
                        end
                    end
                end
            end
        end
    end)
    saveConfig()
end

local function autoShake()
    Config.AutoShake = not Config.AutoShake
    spawn(function()
        while Config.AutoShake do
            wait(0.01)
            local playerGui = Player:FindFirstChild("PlayerGui")
            if playerGui then
                local shakeUI = playerGui:FindFirstChild("shakeui")
                if shakeUI and shakeUI.Enabled then
                    local rod = Character:FindFirstChildOfClass("Tool")
                    if rod and rod:FindFirstChild("events") then
                        local events = rod.events
                        if events:FindFirstChild("shake") then
                            pcall(function() events.shake:FireServer(2, true) end)
                        end
                    end
                end
            end
        end
    end)
    saveConfig()
end

local function autoSell()
    Config.AutoSell = not Config.AutoSell
    spawn(function()
        while Config.AutoSell do
            wait(3)
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "Sell" or v.Name == "SellPad" or v.Name:find("Sell") then
                    if v:IsA("BasePart") and RootPart then
                        local oldPos = RootPart.CFrame
                        pcall(function()
                            RootPart.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                        end)
                        wait(0.5)
                        pcall(function() RootPart.CFrame = oldPos end)
                        break
                    end
                end
            end
        end
    end)
    saveConfig()
end

local function teleportFishZone()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v.Name:find("Zone") or v.Name:find("Fish") or v.Name:find("Spot")) and v:IsA("BasePart") and RootPart then
            RootPart.CFrame = v.CFrame + Vector3.new(0, 5, 0)
            break
        end
    end
end

local function autoEquipBestRod()
    Config.AutoEquipBestRod = not Config.AutoEquipBestRod
    spawn(function()
        while Config.AutoEquipBestRod do
            wait(5)
            local backpack = Player:FindFirstChild("Backpack")
            if backpack then
                local bestRod = nil
                local bestValue = 0
                for _, item in pairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and (item.Name:find("Rod") or item.Name:find("Pole")) then
                        local value = item:FindFirstChild("Value")
                        if value and value.Value > bestValue then
                            bestValue = value.Value
                            bestRod = item
                        end
                    end
                end
                if bestRod then
                    Humanoid:EquipTool(bestRod)
                end
            end
        end
    end)
    saveConfig()
end

-- Blatant Functions
local function instaCatch()
    if not Config.EnableBlatant then
        notify("Blatant Disabled", "Enable " .. "Blatant Module" .. " first to use Insta-Catch.", 3)
        return
    end
    Config.InstaCatch = not Config.InstaCatch
    spawn(function()
        while Config.InstaCatch do
            wait(0.02)
            local rod = Character:FindFirstChildOfClass("Tool")
            if rod and rod:FindFirstChild("events") then
                local events = rod.events
                pcall(function() events.cast:FireServer(100, 1) end)
                wait(0.04)
                pcall(function() events.shake:FireServer(999, true) end)
                wait(0.04)
                pcall(function() events.reel:FireServer() end)
                wait(0.04)
                pcall(function() if events:FindFirstChild("complete") then events.complete:FireServer() end end)
            end
        end
    end)
    saveConfig()
end

local function autoFarmBlatant()
    if not Config.EnableBlatant then
        notify("Blatant Disabled", "Enable Blatant Module first to use Auto Farm Blatant.", 3)
        return
    end
    Config.AutoFarmBlatant = not Config.AutoFarmBlatant
    spawn(function()
        local lastSell = 0
        while Config.AutoFarmBlatant do
            wait(0.08)
            local rod = Character:FindFirstChildOfClass("Tool")
            if rod and rod:FindFirstChild("events") then
                local events = rod.events
                pcall(function()
                    events.cast:FireServer(100, 1)
                    wait(0.03)
                    if events:FindFirstChild("shake") then events.shake:FireServer(999, true) end
                    wait(0.03)
                    if events:FindFirstChild("reel") then events.reel:FireServer() end
                    wait(0.03)
                    if events:FindFirstChild("complete") then events.complete:FireServer() end
                end)
            end
            if tick() - lastSell > 10 then
                lastSell = tick()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:find("Sell") and v:IsA("BasePart") and RootPart then
                        local oldPos = RootPart.CFrame
                        pcall(function() RootPart.CFrame = v.CFrame + Vector3.new(0,3,0) end)
                        wait(0.3)
                        pcall(function() RootPart.CFrame = oldPos end)
                        break
                    end
                end
            end
        end
    end)
    saveConfig()
end

local function forceLegendary()
    if not Config.EnableBlatant then
        notify("Blatant Disabled", "Enable Blatant Module first to use Force Legendary.", 3)
        return
    end
    Config.ForceLegendary = not Config.ForceLegendary
    spawn(function()
        while Config.ForceLegendary do
            wait(0.15)
            local rod = Character:FindFirstChildOfClass("Tool")
            if rod then
                local values = rod:FindFirstChild("values")
                if values then
                    local luck = values:FindFirstChild("luck") or values:FindFirstChild("Luck")
                    if luck and typeof(luck.Value) == "number" then
                        pcall(function() luck.Value = 999999 end)
                    end
                    local cooldown = values:FindFirstChild("cooldown") or values:FindFirstChild("Cooldown")
                    if cooldown and typeof(cooldown.Value) == "number" then
                        pcall(function() cooldown.Value = 0 end)
                    end
                end
            end
        end
    end)
    saveConfig()
end

local function teleportRareSpots()
    local rareSpots = {"Legendary", "Mythical", "Rare", "Secret", "Hidden", "Special"}
    for _, v in pairs(workspace:GetDescendants()) do
        for _, spot in pairs(rareSpots) do
            if v.Name:find(spot) and v:IsA("BasePart") and RootPart then
                RootPart.CFrame = v.CFrame + Vector3.new(0, 5, 0)
                return
            end
        end
    end
end

-- Blatant module helper: infinite cash
local function infiniteCash()
    if not Config.EnableBlatant then
        notify("Blatant Disabled", "Enable Blatant Module to use Infinite Cash.", 3)
        return
    end
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local cashRemote = remotes:FindFirstChild("AddCash")
        if cashRemote then
            pcall(function() cashRemote:FireServer(999999) end)
        end
    end
end

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WeaRScriptsFishIt"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 580)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -290)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.BorderSizePixel = 0
Title.Text = "⚡ WeaR-Scripts | Fish It! ⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 100, 0, 20)
Version.Position = UDim2.new(0, 10, 0, 55)
Version.BackgroundTransparency = 1
Version.Text = "v1.0 | By WeaR"
Version.TextColor3 = Color3.fromRGB(150, 150, 150)
Version.TextSize = 12
Version.Font = Enum.Font.Gotham
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -85)
ScrollFrame.Position = UDim2.new(0, 10, 0, 80)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 8
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
ScrollFrame.Parent = MainFrame

local function createButton(text, position, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 340, 0, 38)
    btn.Position = UDim2.new(0, 10, 0, position)
    btn.BackgroundColor3 = color or Color3.fromRGB(35, 35, 35)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = ScrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 50)
    stroke.Thickness = 1
    stroke.Parent = btn
    
    local isActive = false
    btn.MouseButton1Click:Connect(function()
        callback()
        isActive = not isActive
        if isActive then
            btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            stroke.Color = Color3.fromRGB(0, 255, 150)
        else
            btn.BackgroundColor3 = color or Color3.fromRGB(35, 35, 35)
            stroke.Color = Color3.fromRGB(50, 50, 50)
        end
    end)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        if not isActive then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color or Color3.fromRGB(35, 35, 35)}):Play()
        end
    end)
    
    return btn
end

-- Helper to set active state from code
local function setButtonActive(btn, active, activeColor)
    if not btn then return end
    local stroke = btn:FindFirstChildOfClass("UIStroke")
    if active then
        btn.BackgroundColor3 = activeColor or Color3.fromRGB(0,200,100)
        if stroke then stroke.Color = Color3.fromRGB(0,255,150) end
        btn:SetAttribute("_active", true)
    else
        btn.BackgroundColor3 = btn:GetAttribute("_defaultColor") or Color3.fromRGB(35,35,35)
        if stroke then stroke.Color = Color3.fromRGB(50,50,50) end
        btn:SetAttribute("_active", false)
    end
end

local function createInput(placeholder, position)
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0, 340, 0, 38)
    input.Position = UDim2.new(0, 10, 0, position)
    input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    input.PlaceholderText = placeholder
    input.Text = ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 14
    input.Font = Enum.Font.Gotham
    input.Parent = ScrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = input
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 50)
    stroke.Thickness = 1
    stroke.Parent = input
    
    input.Focused:Connect(function()
        stroke.Color = Color3.fromRGB(0, 255, 255)
    end)
    
    input.FocusLost:Connect(function()
        stroke.Color = Color3.fromRGB(50, 50, 50)
    end)
    
    return input
end

local function createLabel(text, position, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 340, 0, 30)
    label.Position = UDim2.new(0, 10, 0, position)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(0, 255, 255)
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = ScrollFrame
    
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 2)
    divider.Position = UDim2.new(0, 0, 1, -2)
    divider.BackgroundColor3 = color or Color3.fromRGB(0, 255, 255)
    divider.BorderSizePixel = 0
    divider.Parent = label
    
    return label
end

-- Universal Section
createLabel("⚙️ UNIVERSAL FEATURES", 5)
local speedInput = createInput("⚡ Speed (Default: 16)", 40)
local setSpeedBtn = createButton("▶ Set Speed", 83, function()
    setWalkSpeed(tonumber(speedInput.Text) or 16)
end)

local jumpInput = createInput("👍 Jump Power (Default: 50)", 126)
local setJumpBtn = createButton("▶ Set Jump Power", 169, function()
    setJumpPower(tonumber(jumpInput.Text) or 50)
end)

local flyBtn = createButton("✈️ Toggle Fly (WASD)", 212, toggleFly)
local noclipBtn = createButton("👻 Toggle Noclip", 255, toggleNoclip)
local espBtn = createButton("👁️ Toggle ESP", 298, toggleESP)
local infJumpBtn = createButton("⬆️ Toggle Infinite Jump", 341, toggleInfiniteJump)

-- Fish It! Section
createLabel("🎯 FISH IT! FEATURES", 384, Color3.fromRGB(100, 200, 255))
local autoFishBtn = createButton("🎣 Auto Fish", 419, autoFish)
local autoShakeBtn = createButton("💨 Auto Shake", 462, autoShake)
local autoCatchBtn = createButton("🐟 Auto Catch", 505, autoCatch)
local autoSellBtn = createButton("💰 Auto Sell", 548, autoSell)
local autoEquipBtn = createButton("📍 Auto Equip Best Rod", 591, autoEquipBestRod)
local tpFishZoneBtn = createButton("🎯 TP to Fish Zone", 634, teleportFishZone)

-- Blatant Section
createLabel("⚠️ BLATANT (HIGH RISK!)", 677, Color3.fromRGB(255, 100, 100))
local blatantToggleBtn = createButton("Enable Blatant Module (Required)", 712, function()
    Config.EnableBlatant = not Config.EnableBlatant
    if Config.EnableBlatant then
        notify("⚠️ Blatant Enabled", "Blatant features are HIGH RISK. Use a alt account.", 4)
    else
        notify("Blatant Disabled", "Blatant features turned off.", 2)
    end
    saveConfig()
end, Color3.fromRGB(200, 40, 40))
-- Mark toggle visually
if Config.EnableBlatant then
    blatantToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
end
local instaCatchBtn = createButton("⚡ Insta-Catch (No Minigame)", 712, instaCatch, Color3.fromRGB(50, 20, 20))
local autoFarmBlatantBtn = createButton("🚀 Auto Farm Blatant (Super Fast)", 755, autoFarmBlatant, Color3.fromRGB(50, 20, 20))
local forceLegendBtn = createButton("🌟 Force Legendary Fish", 798, forceLegendary, Color3.fromRGB(50, 20, 20))
local tpRareBtn = createButton("🗺️ TP to Rare Spots", 841, teleportRareSpots, Color3.fromRGB(50, 20, 20))
local infiniteCashBtn = createButton("💸 Infinite Cash (Blatant)", 884, infiniteCash, Color3.fromRGB(50,20,20))

-- Misc Section
createLabel("🔧 MISC", 884, Color3.fromRGB(150, 150, 150))
local antiAFKBtn = createButton("🚫 Anti-AFK", 919, function()
    Config.AntiAFK = not Config.AntiAFK
end)

-- Apply persisted toggles visually
pcall(function()
    -- Set visual states for all known buttons from loaded Config
    local mapping = {
        AutoFish = autoFishBtn,
        AutoShake = autoShakeBtn,
        AutoCatch = autoCatchBtn,
        AutoSell = autoSellBtn,
        AutoEquipBestRod = autoEquipBtn,
        AutoFarmBlatant = autoFarmBlatantBtn,
        InstaCatch = instaCatchBtn,
        ForceLegendary = forceLegendBtn,
        EnableBlatant = blatantToggleBtn,
        AntiAFK = antiAFKBtn
    }
    for key, btn in pairs(mapping) do
        if Config[key] and btn then
            setButtonActive(btn, true)
        end
        if btn and not btn:GetAttribute("_defaultColor") then
            btn:SetAttribute("_defaultColor", btn.BackgroundColor3)
        end
    end
end)

-- Themes, Profiles, Export/Import UI will extend the canvas size
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1550)

-- Draggable (Already handled by MainFrame.Draggable = true)

-- Notification System
local function notify(title, text, duration)
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "Notification"
    NotifGui.Parent = PlayerGui
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 300, 0, 80)
    NotifFrame.Position = UDim2.new(1, -320, 1, 100)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = NotifGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = NotifFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Thickness = 2
    stroke.Parent = NotifFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = NotifFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0, 40)
    textLabel.Position = UDim2.new(0, 10, 0, 30)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    textLabel.Parent = NotifFrame
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -320, 1, -100)}):Play()
    
    wait(duration or 3)
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -320, 1, 100)}):Play()
    wait(0.5)
    NotifGui:Destroy()
end

-- Welcome notification
notify("⚡ WeaR-Scripts", "Fish It! loaded successfully!", 3)

-- Keybinds: Toggle GUI and quick feature keys
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    elseif input.KeyCode == Enum.KeyCode.F then
        autoFish()
        setButtonActive(autoFishBtn, Config.AutoFish)
        notify("AutoFish", (Config.AutoFish and "Enabled" or "Disabled"), 1.5)
    elseif input.KeyCode == Enum.KeyCode.G then
        autoSell()
        setButtonActive(autoSellBtn, Config.AutoSell)
        notify("AutoSell", (Config.AutoSell and "Enabled" or "Disabled"), 1.5)
    end
end)

-- Themes & Profiles
local themes = {
    Neon = {
        background = Color3.fromRGB(20,20,20),
        accent = Color3.fromRGB(0,255,255),
        title = Color3.fromRGB(0,255,255),
        stroke = Color3.fromRGB(0,255,255)
    },
    Dark = {
        background = Color3.fromRGB(12,12,12),
        accent = Color3.fromRGB(200,200,200),
        title = Color3.fromRGB(200,200,200),
        stroke = Color3.fromRGB(80,80,80)
    },
    Ocean = {
        background = Color3.fromRGB(8,30,50),
        accent = Color3.fromRGB(60,180,200),
        title = Color3.fromRGB(180,230,240),
        stroke = Color3.fromRGB(60,180,200)
    }
}

local function applyTheme(name)
    local t = themes[name]
    if not t then return end
    MainFrame.BackgroundColor3 = t.background
    UIStroke.Color = t.stroke
    Title.TextColor3 = t.title
    Version.TextColor3 = t.accent
    Config.Theme = name
    saveConfig()
end

local function applyConfig(newConfig)
    if type(newConfig) ~= "table" then return end
    for k, v in pairs(newConfig) do
        if Config[k] ~= nil then
            Config[k] = v
        end
    end
    -- update visuals for known toggles
    local mapping = {
        AutoFish = autoFishBtn,
        AutoShake = autoShakeBtn,
        AutoCatch = autoCatchBtn,
        AutoSell = autoSellBtn,
        AutoEquipBestRod = autoEquipBtn,
        AutoFarmBlatant = autoFarmBlatantBtn,
        InstaCatch = instaCatchBtn,
        ForceLegendary = forceLegendBtn,
        EnableBlatant = blatantToggleBtn,
        AntiAFK = antiAFKBtn
    }
    for key, btn in pairs(mapping) do
        if btn then
            setButtonActive(btn, Config[key])
        end
    end
    if newConfig.Theme then applyTheme(newConfig.Theme) end
    saveConfig()
end

-- Profile management (save/load/delete)
local function saveProfileByName(name)
    if not name or name:match("^%s*$") then
        notify("Profile Error", "Please enter a valid profile name.", 2)
        return
    end
    if writefile and HttpService then
        local file = "WeaR-profile-" .. name .. ".json"
        pcall(function()
            writefile(file, HttpService:JSONEncode(Config))
            notify("Profile Saved", "Saved profile: " .. name, 2)
        end)
    else
        notify("Unavailable", "writefile not supported by your executor.", 3)
    end
end

local function loadProfileByName(name)
    if not name or name:match("^%s*$") then
        notify("Profile Error", "Please enter a valid profile name.", 2)
        return
    end
    if readfile and isfile and HttpService then
        local file = "WeaR-profile-" .. name .. ".json"
        if not isfile(file) then notify("Load Failed", "Profile not found: "..name, 2); return end
        local ok, data = pcall(function() return readfile(file) end)
        if ok and data then
            local succ, parsed = pcall(function() return HttpService:JSONDecode(data) end)
            if succ and type(parsed) == "table" then
                applyConfig(parsed)
                notify("Profile Loaded", "Loaded profile: "..name, 2)
                return
            end
        end
        notify("Load Failed", "Unable to parse profile.", 2)
    else
        notify("Unavailable", "readfile not supported by your executor.", 3)
    end
end

local function deleteProfileByName(name)
    if not name or name:match("^%s*$") then
        notify("Profile Error", "Please enter a valid profile name.", 2)
        return
    end
    if isfile and delfile then
        local file = "WeaR-profile-" .. name .. ".json"
        if not isfile(file) then notify("Delete Failed", "Profile not found: "..name, 2); return end
        pcall(function() delfile(file) end)
        notify("Profile Deleted", "Deleted: "..name, 2)
    else
        notify("Unavailable", "delfile not supported by your executor.", 3)
    end
end

-- Export / Import
local function exportConfigToFile()
    if writefile and HttpService then
        local ok = pcall(function() writefile("WeaR-export-config.json", HttpService:JSONEncode(Config)) end)
        if ok then notify("Exported", "Config exported to WeaR-export-config.json", 2)
        else notify("Export Failed", "Unable to write file.", 2) end
    else
        notify("Unavailable", "writefile not supported.", 3)
    end
end

local function exportConfigToClipboard()
    if setclipboard and HttpService then
        pcall(function() setclipboard(HttpService:JSONEncode(Config)) end)
        notify("Exported", "Config copied to clipboard.", 2)
    else
        notify("Unavailable", "setclipboard not supported.", 3)
    end
end

local function importConfigFromText(jsonText)
    if not jsonText or jsonText:match("^%s*$") then notify("Import Error", "Paste JSON into the import box.", 2); return end
    if HttpService then
        local succ, parsed = pcall(function() return HttpService:JSONDecode(jsonText) end)
        if succ and type(parsed) == "table" then
            applyConfig(parsed)
            notify("Imported", "Config imported from text.", 2)
            return
        end
    end
    notify("Import Failed", "Invalid JSON.", 2)
end

local function importConfigFromFile()
    if readfile and isfile and HttpService then
        local file = "WeaR-export-config.json"
        if not isfile(file) then notify("Import Failed", "File not found: "..file, 2); return end
        local ok, data = pcall(function() return readfile(file) end)
        if ok and data then importConfigFromText(data); return end
        notify("Import Failed", "Unable to read file.", 2)
    else
        notify("Unavailable", "readfile not supported.", 3)
    end
end

-- UI: Themes & Profiles
createLabel("🎨 THEMES & PROFILES", 952, Color3.fromRGB(180,180,255))
createButton("Theme: Neon", 995, function() applyTheme("Neon") end)
createButton("Theme: Dark", 1038, function() applyTheme("Dark") end)
createButton("Theme: Ocean", 1081, function() applyTheme("Ocean") end)

local profileInput = createInput("Profile name (e.g. myprofile)", 1124)
createButton("Save Profile", 1167, function() saveProfileByName(profileInput.Text) end)
createButton("Load Profile", 1210, function() loadProfileByName(profileInput.Text) end)
createButton("Delete Profile", 1253, function() deleteProfileByName(profileInput.Text) end)

createButton("Export Config to File", 1296, exportConfigToFile)
createButton("Export Config to Clipboard", 1339, exportConfigToClipboard)
local importBox = createInput("Paste JSON here to import", 1382)
createButton("Import from Text", 1425, function() importConfigFromText(importBox.Text) end)
createButton("Import from File (WeaR-export-config.json)", 1468, importConfigFromFile)
