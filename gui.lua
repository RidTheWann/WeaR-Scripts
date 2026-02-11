-- WeaR-Scripts GUI
-- Simple GUI Interface

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WeaRScripts"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.BorderSizePixel = 0
Title.Text = "WeaR-Scripts"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Create Button Function
local function createButton(text, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 260, 0, 35)
    btn.Position = UDim2.new(0, 20, 0, position)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.Gotham
    btn.Parent = MainFrame
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Create Input Function
local function createInput(placeholder, position)
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0, 260, 0, 35)
    input.Position = UDim2.new(0, 20, 0, position)
    input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    input.PlaceholderText = placeholder
    input.Text = ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 16
    input.Font = Enum.Font.Gotham
    input.Parent = MainFrame
    return input
end

-- Load Main Script (embedded)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local flying = false
local noclipping = false
local infiniteJumpEnabled = false

local function setWalkSpeed(speed)
    if Humanoid then Humanoid.WalkSpeed = speed end
end

local function setJumpPower(power)
    if Humanoid then Humanoid.JumpPower = power end
end

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
    
    spawn(function()
        repeat
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
        until not flying
    end)
end

local function stopFly()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
end

local function toggleNoclip()
    noclipping = not noclipping
    if noclipping then
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

local WeaR = {
    setWalkSpeed = setWalkSpeed,
    setJumpPower = setJumpPower,
    startFly = startFly,
    stopFly = stopFly,
    toggleNoclip = toggleNoclip,
    toggleESP = toggleESP,
    toggleInfiniteJump = toggleInfiniteJump
}

-- Speed Input & Button
local speedInput = createInput("Speed (default: 16)", 60)
createButton("Set Speed", 100, function()
    local speed = tonumber(speedInput.Text) or 16
    WeaR.setWalkSpeed(speed)
end)

-- Jump Input & Button
local jumpInput = createInput("Jump Power (default: 50)", 145)
createButton("Set Jump Power", 185, function()
    local jump = tonumber(jumpInput.Text) or 50
    WeaR.setJumpPower(jump)
end)

-- Toggle Buttons
createButton("Toggle Fly", 230, function()
    if flying then
        WeaR.stopFly()
    else
        WeaR.startFly()
    end
end)

createButton("Toggle Noclip", 275, function()
    WeaR.toggleNoclip()
end)

createButton("Toggle ESP", 320, function()
    WeaR.toggleESP()
end)

createButton("Toggle Infinite Jump", 365, function()
    WeaR.toggleInfiniteJump()
end)

-- Make draggable
local dragging, dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
