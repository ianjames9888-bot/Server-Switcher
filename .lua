local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local placeId = game.PlaceId
local currentJobId = game.JobId

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- ✨ BUTTON
local button = Instance.new("TextButton")
button.Parent = gui
button.Size = UDim2.new(0,40,0,40)
button.Position = UDim2.new(0,100,0,100)
button.BackgroundColor3 = Color3.fromRGB(0,0,0)
button.BackgroundTransparency = 0.2
button.Text = "✨"
button.TextSize = 24
button.Font = Enum.Font.GothamBold
button.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",button).CornerRadius = UDim.new(1,0)

-- FRAME
local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,0,0,0)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BackgroundTransparency = 0.2
frame.Visible = false
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,20)

-- STYLE
local function style(btn)
	btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextTransparency = 1
	btn.BackgroundTransparency = 1
	Instance.new("UICorner",btn)
end

-- SIDE BUTTONS
local leftTop = Instance.new("TextButton",frame)
leftTop.Size = UDim2.new(0,25,0,25)
leftTop.Position = UDim2.new(0,-30,0,10)
leftTop.Text = "🔄"
style(leftTop)

local leftBottom = Instance.new("TextButton",frame)
leftBottom.Size = UDim2.new(0,25,0,25)
leftBottom.Position = UDim2.new(0,-30,0,40)
leftBottom.Text = "👀"
style(leftBottom)

-- TITLE
local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,-10,0,25)
title.Position = UDim2.new(0,0,0,5)
title.BackgroundTransparency = 1
title.Text = "Stelle Hub"
title.TextColor3 = Color3.fromRGB(170,0,255)
title.Font = Enum.Font.Garamond
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Right
title.TextTransparency = 1

-- CREDIT
local credit = Instance.new("TextLabel",frame)
credit.Size = UDim2.new(1,-10,0,20)
credit.Position = UDim2.new(0,5,1,-25)
credit.BackgroundTransparency = 1
credit.Text = "by Ian James"
credit.TextColor3 = Color3.fromRGB(200,200,200)
credit.Font = Enum.Font.Garamond
credit.TextSize = 12
credit.TextXAlignment = Enum.TextXAlignment.Left
credit.TextTransparency = 1

-- MAIN BUTTONS
local switchBtn = Instance.new("TextButton",frame)
switchBtn.Size = UDim2.new(0,100,0,35)
switchBtn.Position = UDim2.new(0.5,-50,0.4,-17)
switchBtn.Text = "Switch"
style(switchBtn)

local rejoinBtn = Instance.new("TextButton",frame)
rejoinBtn.Size = UDim2.new(0,100,0,35)
rejoinBtn.Position = UDim2.new(0.5,-50,0.65,-17)
rejoinBtn.Text = "Rejoin"
style(rejoinBtn)

local espToggle = Instance.new("TextButton",frame)
espToggle.Size = UDim2.new(0,120,0,40)
espToggle.Position = UDim2.new(0.5,-60,0.5,-20)
espToggle.Text = "ESP: OFF"
espToggle.Visible = false
style(espToggle)

-- FADE SYSTEM
local buttons = {switchBtn,rejoinBtn,leftTop,leftBottom,espToggle}
local texts = {title,credit}

local function fadeIn()
	for _,b in ipairs(buttons) do
		TweenService:Create(b,TweenInfo.new(0.25),{
			TextTransparency=0,
			BackgroundTransparency=0
		}):Play()
	end
	for _,t in ipairs(texts) do
		TweenService:Create(t,TweenInfo.new(0.25),{
			TextTransparency=0
		}):Play()
	end
end

local function fadeOut()
	for _,b in ipairs(buttons) do
		TweenService:Create(b,TweenInfo.new(0.25),{
			TextTransparency=1,
			BackgroundTransparency=1
		}):Play()
	end
	for _,t in ipairs(texts) do
		TweenService:Create(t,TweenInfo.new(0.25),{
			TextTransparency=1
		}):Play()
	end
end

-- TAB SWITCH
leftBottom.MouseButton1Click:Connect(function()
	switchBtn.Visible=false
	rejoinBtn.Visible=false
	espToggle.Visible=true
	fadeIn()
end)

leftTop.MouseButton1Click:Connect(function()
	switchBtn.Visible=true
	rejoinBtn.Visible=true
	espToggle.Visible=false
	fadeIn()
end)

-- SERVER SWITCH
switchBtn.MouseButton1Click:Connect(function()
	local servers={}
	local success,data=pcall(function()
		return HttpService:JSONDecode(
			game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100")
		)
	end)

	if success and data and data.data then
		for _,v in ipairs(data.data) do
			if v.id ~= currentJobId then
				table.insert(servers,v.id)
			end
		end
	end

	if #servers > 0 then
		local randomId = servers[math.random(1,#servers)]
		TeleportService:TeleportToPlaceInstance(placeId,randomId)
	else
		TeleportService:Teleport(placeId)
	end
end)

rejoinBtn.MouseButton1Click:Connect(function()
	TeleportService:TeleportToPlaceInstance(placeId,currentJobId)
end)

-- ESP SYSTEM
local espEnabled=false
local espObjects={}

local function hideESP()
	for _,v in ipairs(espObjects) do
		if v then
			v.Enabled = false
		end
	end
end

local function showESP()
	for _,v in ipairs(espObjects) do
		if v then
			v.Enabled = true
		end
	end
end

local function createESP(plr)
	local function setup(char)
		local head=char:WaitForChild("Head")

		local bb=Instance.new("BillboardGui")
		bb.Parent=head
		bb.Size=UDim2.new(0,120,0,40)
		bb.StudsOffset=Vector3.new(0,2.5,0)
		bb.AlwaysOnTop=true

		local name=Instance.new("TextLabel",bb)
		name.Size=UDim2.new(1,0,0.5,0)
		name.BackgroundTransparency=1
		name.TextScaled=true

		local dist=Instance.new("TextLabel",bb)
		dist.Size=UDim2.new(1,0,0.5,0)
		dist.Position=UDim2.new(0,0,0.5,0)
		dist.BackgroundTransparency=1
		dist.TextScaled=true

		table.insert(espObjects,bb)

		RunService.RenderStepped:Connect(function()
			if not espEnabled then return end
			if not player.Character then return end

			local myRoot=player.Character:FindFirstChild("HumanoidRootPart")
			if not myRoot then return end

			local distance=0
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				distance=(myRoot.Position-plr.Character.HumanoidRootPart.Position).Magnitude
			end

			name.Text=plr.Name
			if plr==player then
				dist.Text="YOU [0]"
			else
				dist.Text=math.floor(distance).." studs"
			end
		end)
	end

	if plr.Character then setup(plr.Character) end
	plr.CharacterAdded:Connect(setup)
end

espToggle.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled

	if espEnabled then
		espToggle.Text="ESP: ON"
		showESP()
		for _,p in ipairs(game.Players:GetPlayers()) do
			createESP(p)
		end
	else
		espToggle.Text="ESP: OFF"
		hideESP()
	end
end)

-- OPEN/CLOSE
local opened=false
button.MouseButton1Click:Connect(function()
	if not opened then
		frame.Visible=true
		TweenService:Create(frame,TweenInfo.new(0.25),{
			Size=UDim2.new(0,260,0,180)
		}):Play()
		task.delay(0.25,fadeIn)
		opened=true
	else
		fadeOut()
		task.wait(0.25)
		TweenService:Create(frame,TweenInfo.new(0.25),{
			Size=UDim2.new(0,0,0,0)
		}):Play()
		task.wait(0.25)
		frame.Visible=false
		opened=false
	end
end)

-- DRAG SYSTEM
local function makeDraggable(obj)
	local dragging=false
	local dragInput,startPos,startObjPos

	obj.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			dragging=true
			startPos=input.Position
			startObjPos=obj.Position
			input.Changed:Connect(function()
				if input.UserInputState==Enum.UserInputState.End then
					dragging=false
				end
			end)
		end
	end)

	obj.InputChanged:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
			dragInput=input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input==dragInput then
			local delta=input.Position-startPos
			obj.Position=UDim2.new(
				startObjPos.X.Scale,
				startObjPos.X.Offset+delta.X,
				startObjPos.Y.Scale,
				startObjPos.Y.Offset+delta.Y
			)
		end
	end)
end

makeDraggable(button)
makeDraggable(frame)
