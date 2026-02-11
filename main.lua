-- WeaR-Scripts
-- Main Script


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Add safe wrappers and debounces for public methods
local debounce = {}
local function canRun(key, interval)
    interval = interval or 0.05
    if debounce[key] and tick() - debounce[key] < interval then return false end
    debounce[key] = tick()
    return true
end

-- Configuration
local Config = {
    WalkSpeed = 16,
    JumpPower = 50,
    Fly = false,
    Noclip = false,
    ESP = false,
    InfiniteJump = false
}

-- WalkSpeed
local function setWalkSpeed(speed)
    if Humanoid and canRun("setspeed", 0.01) then
        pcall(function() Humanoid.WalkSpeed = speed end)
    end
end

-- JumpPower
local function setJumpPower(power)
    if Humanoid and canRun("setjump", 0.01) then
        pcall(function() Humanoid.JumpPower = power end)
    end
end

-- Fly
local flying = false
local flySpeed = 50
local bodyVelocity, bodyGyro

local function startFly()
    flying = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = RootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.Parent = RootPart
    
    repeat
        wait()
        local camera = workspace.CurrentCamera
        local direction = Vector3.new(0, 0, 0)
        
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
        
        pcall(function()
            bodyVelocity.Velocity = direction
            bodyGyro.CFrame = camera.CFrame
        end)
    until not flying
end

local function stopFly()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    pcall(function() bodyVelocity = nil; bodyGyro = nil end)
end

-- Noclip
local noclipping = false
local function noclip()
    noclipping = true
    RunService.Stepped:Connect(function()
        if noclipping then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
    pcall(function() noclipping = true end)
end

-- ESP
local function createESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Parent = player.Character
        end
    end
    pcall(function() Config.ESP = true end)
end

-- Infinite Jump
local infiniteJumpEnabled = false
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Commands
local function executeCommand(cmd, value)
    if cmd == "speed" then
        setWalkSpeed(tonumber(value) or 16)
    elseif cmd == "jump" then
        setJumpPower(tonumber(value) or 50)
    elseif cmd == "fly" then
        if Config.Fly then
            stopFly()
            Config.Fly = false
        else
            Config.Fly = true
            startFly()
        end
    elseif cmd == "noclip" then
        Config.Noclip = not Config.Noclip
        if Config.Noclip then
            noclip()
        else
            noclipping = false
        end
    elseif cmd == "esp" then
        Config.ESP = not Config.ESP
        if Config.ESP then
            createESP()
        end
    elseif cmd == "infjump" then
        infiniteJumpEnabled = not infiniteJumpEnabled
    end
end

-- Export functions
return {
    setWalkSpeed = setWalkSpeed,
    setJumpPower = setJumpPower,
    startFly = startFly,
    stopFly = stopFly,
    executeCommand = executeCommand,
    Config = Config
}
