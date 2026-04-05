local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local placeId = game.PlaceId
local currentJobId = game.JobId

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- 🎸 SMALL SPARKLE BUTTON
local button = Instance.new("TextButton")
button.Parent = gui
button.Size = UDim2.new(0, 40, 0, 40)
button.Position = UDim2.new(0, 100, 0, 100)
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.BackgroundTransparency = 0.2
button.Text = "✨"
button.TextScaled = false       -- Turn off scaling
button.TextSize = 24            -- Smaller sparkle
button.Font = Enum.Font.GothamBold
button.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)

-- FRAME
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.2
frame.Visible = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)

-- TITLE
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Switch Server"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.Garamond
title.TextSize = 16
title.TextTransparency = 1

-- SWITCH BUTTON
local switchBtn = Instance.new("TextButton")
switchBtn.Parent = frame
switchBtn.Size = UDim2.new(0, 100, 0, 35)
switchBtn.Position = UDim2.new(0.5, -50, 0.4, -17)
switchBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
switchBtn.Text = "Switch"
switchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
switchBtn.Font = Enum.Font.Garamond
switchBtn.TextSize = 14
switchBtn.TextTransparency = 1
switchBtn.BackgroundTransparency = 1
Instance.new("UICorner", switchBtn).CornerRadius = UDim.new(0, 15)

-- REJOIN BUTTON
local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Parent = frame
rejoinBtn.Size = UDim2.new(0, 100, 0, 35)
rejoinBtn.Position = UDim2.new(0.5, -50, 0.65, -17)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
rejoinBtn.Text = "Rejoin"
rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinBtn.Font = Enum.Font.Garamond
rejoinBtn.TextSize = 14
rejoinBtn.TextTransparency = 1
rejoinBtn.BackgroundTransparency = 1
Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0, 15)

-- DRAG BUTTON
local dragBtn = Instance.new("TextButton")
dragBtn.Parent = frame
dragBtn.Size = UDim2.new(0, 20, 0, 20)
dragBtn.Position = UDim2.new(1, -30, 0, 5)
dragBtn.Text = "+"
dragBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
dragBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", dragBtn).CornerRadius = UDim.new(1, 0)

-- OPEN UI
local function openUI()
    frame.Visible = true
    frame.Size = UDim2.new(0, 0, 0, 0)
    title.TextTransparency = 1
    switchBtn.TextTransparency = 1
    rejoinBtn.TextTransparency = 1
    switchBtn.BackgroundTransparency = 1
    rejoinBtn.BackgroundTransparency = 1

    TweenService:Create(frame, TweenInfo.new(0.25), {Size = UDim2.new(0, 260, 0, 180)}):Play()
    task.wait(0.15)

    TweenService:Create(title, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    TweenService:Create(switchBtn, TweenInfo.new(0.2), {TextTransparency = 0, BackgroundTransparency = 0}):Play()
    TweenService:Create(rejoinBtn, TweenInfo.new(0.2), {TextTransparency = 0, BackgroundTransparency = 0}):Play()
end

-- CLOSE UI
local function closeUI()
    TweenService:Create(title, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
    TweenService:Create(switchBtn, TweenInfo.new(0.15), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
    TweenService:Create(rejoinBtn, TweenInfo.new(0.15), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
    task.wait(0.15)

    local t = TweenService:Create(frame, TweenInfo.new(0.25), {Size = UDim2.new(0, 0, 0, 0)})
    t:Play()
    t.Completed:Wait()
    frame.Visible = false
end

-- TOGGLE
local opened = false
button.MouseButton1Click:Connect(function()
    if not opened then
        openUI()
        opened = true
    else
        closeUI()
        opened = false
    end
end)

-- RANDOM SERVER
switchBtn.MouseButton1Click:Connect(function()
    local servers = {}
    local success, data = pcall(function()
        return HttpService:JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100")
        )
    end)

    if success and data and data.data then
        for _, v in ipairs(data.data) do
            if v.id ~= currentJobId then
                table.insert(servers, v.id)
            end
        end
    end

    if #servers > 0 then
        local randomId = servers[math.random(1, #servers)]
        TeleportService:TeleportToPlaceInstance(placeId, randomId)
    else
        TeleportService:Teleport(placeId)
    end
end)

-- REJOIN SAME SERVER
rejoinBtn.MouseButton1Click:Connect(function()
    local success = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, currentJobId)
    end)
    if not success then
        task.wait(1)
        TeleportService:TeleportToPlaceInstance(placeId, currentJobId)
    end
end)

-- DRAG SYSTEM
local function makeDraggable(obj, handle)
    handle = handle or obj
    local dragging, dragInput, startPos, startObjPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = input.Position
            startObjPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - startPos
            obj.Position = UDim2.new(
                startObjPos.X.Scale,
                startObjPos.X.Offset + delta.X,
                startObjPos.Y.Scale,
                startObjPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(button)
makeDraggable(frame, dragBtn)
