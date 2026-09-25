local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local TeleportService=game:GetService("TeleportService")
local HttpService=game:GetService("HttpService")
local RunService=game:GetService("RunService")
local Lighting=game:GetService("Lighting")

local P=Players.LocalPlayer
local PG=P:WaitForChild("PlayerGui")
local PID=game.PlaceId
local JID=game.JobId

local GOLD=Color3.fromRGB(220,175,65)
local ON=Color3.fromRGB(100,255,140)

local SpeedEnabled=false
local CustomSpeed=50
local OriginalSpeed=16
local ESPEnabled=false
local FastModeEnabled=false
local ReduceObjectsEnabled=false

local CurrentCharacter
local CurrentHumanoid
local CurrentRoot
local SpawnCFrame

local HiddenObjects={}
local FastHidden={}
local ESPObjects={}
local ESPConnections={}

local HiddenCount=0
local REDUCE_MAX_SIZE=4.5

local FAST_BATCH_SIZE=40
local FAST_BATCH_DELAY=.01
local REDUCE_BATCH_SIZE=40
local REDUCE_BATCH_DELAY=.01
local FAST_RESTORE_BATCH_SIZE=40
local FAST_RESTORE_BATCH_DELAY=.01
local REDUCE_RESTORE_BATCH_SIZE=40
local REDUCE_RESTORE_BATCH_DELAY=.01

local FastApplying=false
local FastRestoring=false
local ReducingObjects=false
local ReduceRestoring=false

local FastProcessID=0
local FastRestoreID=0
local ReduceProcessID=0
local ReduceRestoreID=0

local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="StelleHub"
ScreenGui.ResetOnSpawn=false
ScreenGui.IgnoreGuiInset=true
ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
ScreenGui.Parent=PG

local Launcher=Instance.new("TextButton")
Launcher.Name="Launcher"
Launcher.Size=UDim2.fromOffset(42,42)
Launcher.Position=UDim2.fromOffset(100,100)
Launcher.Text="✨"
Launcher.TextSize=23
Launcher.Font=Enum.Font.GothamBold
Launcher.TextColor3=GOLD
Launcher.BackgroundColor3=Color3.fromRGB(8,8,10)
Launcher.BackgroundTransparency=.08
Launcher.AutoButtonColor=false
Launcher.Active=true
Launcher.ZIndex=100
Launcher.Parent=ScreenGui

local LauncherCorner=Instance.new("UICorner")
LauncherCorner.CornerRadius=UDim.new(1,0)
LauncherCorner.Parent=Launcher

local LauncherStroke=Instance.new("UIStroke")
LauncherStroke.Color=GOLD
LauncherStroke.Transparency=.4
LauncherStroke.Parent=Launcher

local Hub=Instance.new("Frame")
Hub.Name="Hub"
Hub.Size=UDim2.fromOffset(336,220)
Hub.Position=UDim2.new(.5,-168,.5,-110)
Hub.BackgroundTransparency=1
Hub.Visible=false
Hub.Active=true
Hub.ZIndex=40
Hub.Parent=ScreenGui

local HubScale=Instance.new("UIScale")
HubScale.Parent=Hub

local Panel=Instance.new("Frame")
Panel.Name="Panel"
Panel.Size=UDim2.fromOffset(300,220)
Panel.Position=UDim2.fromOffset(36,0)
Panel.BackgroundColor3=Color3.fromRGB(7,7,9)
Panel.BackgroundTransparency=.04
Panel.Active=true
Panel.ZIndex=45
Panel.Parent=Hub

local PanelCorner=Instance.new("UICorner")
PanelCorner.CornerRadius=UDim.new(0,18)
PanelCorner.Parent=Panel

local PanelStroke=Instance.new("UIStroke")
PanelStroke.Color=GOLD
PanelStroke.Transparency=.45
PanelStroke.Parent=Panel

local function ModernButton(Text,Width,Height,Parent)
	local Button=Instance.new("TextButton")
	Button.Size=UDim2.fromOffset(Width,Height)
	Button.Text=Text
	Button.Font=Enum.Font.GothamMedium
	Button.TextSize=12
	Button.TextColor3=GOLD
	Button.BackgroundColor3=Color3.fromRGB(18,18,22)
	Button.BackgroundTransparency=.04
	Button.AutoButtonColor=false
	Button.Active=true
	Button.ZIndex=60
	Button.Parent=Parent

	local Corner=Instance.new("UICorner")
	Corner.CornerRadius=UDim.new(0,10)
	Corner.Parent=Button

	local Stroke=Instance.new("UIStroke")
	Stroke.Color=GOLD
	Stroke.Transparency=.65
	Stroke.Parent=Button

	Button.MouseEnter:Connect(function()
		Button.BackgroundColor3=Color3.fromRGB(28,28,34)
	end)

	Button.MouseLeave:Connect(function()
		Button.BackgroundColor3=Color3.fromRGB(18,18,22)
	end)

	return Button
end

local BackButton=ModernButton("🔄",32,32,Hub)
BackButton.Position=UDim2.fromOffset(2,34)

local EyeButton=ModernButton("👀",32,32,Hub)
EyeButton.Position=UDim2.fromOffset(2,76)

local FastTabButton=ModernButton("⚡",32,32,Hub)
FastTabButton.Position=UDim2.fromOffset(2,118)

local BypassTabButton=ModernButton("🔑",32,32,Hub)
BypassTabButton.Position=UDim2.fromOffset(2,160)

local Title=Instance.new("TextLabel")
Title.Size=UDim2.new(1,-20,0,28)
Title.Position=UDim2.fromOffset(10,7)
Title.Text="Stelle Hub"
Title.TextColor3=GOLD
Title.Font=Enum.Font.Garamond
Title.TextSize=19
Title.BackgroundTransparency=1
Title.TextXAlignment=Enum.TextXAlignment.Right
Title.ZIndex=55
Title.Parent=Panel

local Creator=Instance.new("TextLabel")
Creator.Size=UDim2.new(1,-20,0,20)
Creator.Position=UDim2.new(0,10,1,-27)
Creator.Text="by Ian James"
Creator.TextColor3=Color3.fromRGB(150,150,155)
Creator.Font=Enum.Font.Garamond
Creator.TextSize=12
Creator.BackgroundTransparency=1
Creator.ZIndex=55
Creator.Parent=Panel

local ScrollingFrame=Instance.new("ScrollingFrame")
ScrollingFrame.Size=UDim2.new(1,-35,1,-65)
ScrollingFrame.Position=UDim2.fromOffset(25,43)
ScrollingFrame.BackgroundTransparency=1
ScrollingFrame.BorderSizePixel=0
ScrollingFrame.ScrollBarThickness=2
ScrollingFrame.ScrollBarImageColor3=GOLD
ScrollingFrame.AutomaticCanvasSize=Enum.AutomaticSize.Y
ScrollingFrame.ScrollingDirection=Enum.ScrollingDirection.Y
ScrollingFrame.ZIndex=55
ScrollingFrame.Parent=Panel

local MainPage=Instance.new("Frame")
MainPage.Size=UDim2.new(1,-5,0,145)
MainPage.BackgroundTransparency=1
MainPage.Parent=ScrollingFrame

local EyesPage=Instance.new("Frame")
EyesPage.Size=UDim2.new(1,-5,0,210)
EyesPage.BackgroundTransparency=1
EyesPage.Visible=false
EyesPage.Parent=ScrollingFrame

local FastPage=Instance.new("Frame")
FastPage.Size=UDim2.new(1,-5,0,165)
FastPage.BackgroundTransparency=1
FastPage.Visible=false
FastPage.Parent=ScrollingFrame

local BypassPage=Instance.new("Frame")
BypassPage.Size=UDim2.new(1,-5,0,145)
BypassPage.BackgroundTransparency=1
BypassPage.Visible=false
BypassPage.Parent=ScrollingFrame

local BypassTitle=Instance.new("TextLabel")
BypassTitle.Size=UDim2.new(1,0,0,25)
BypassTitle.Position=UDim2.fromOffset(0,0)
BypassTitle.Text="Bypasser"
BypassTitle.TextColor3=GOLD
BypassTitle.Font=Enum.Font.Garamond
BypassTitle.TextSize=18
BypassTitle.BackgroundTransparency=1
BypassTitle.TextXAlignment=Enum.TextXAlignment.Center
BypassTitle.ZIndex=60
BypassTitle.Parent=BypassPage

local StealEggRow=Instance.new("Frame")
StealEggRow.Size=UDim2.new(1,-10,0,48)
StealEggRow.Position=UDim2.fromOffset(5,32)
StealEggRow.BackgroundColor3=Color3.fromRGB(15,15,18)
StealEggRow.BackgroundTransparency=.04
StealEggRow.ZIndex=60
StealEggRow.Parent=BypassPage

local StealEggCorner=Instance.new("UICorner")
StealEggCorner.CornerRadius=UDim.new(0,10)
StealEggCorner.Parent=StealEggRow

local StealEggStroke=Instance.new("UIStroke")
StealEggStroke.Color=GOLD
StealEggStroke.Transparency=.7
StealEggStroke.Parent=StealEggRow

local StealEggLabel=Instance.new("TextLabel")
StealEggLabel.Size=UDim2.fromOffset(130,48)
StealEggLabel.Position=UDim2.fromOffset(10,0)
StealEggLabel.Text="Steal an Egg"
StealEggLabel.TextColor3=GOLD
StealEggLabel.Font=Enum.Font.GothamMedium
StealEggLabel.TextSize=12
StealEggLabel.BackgroundTransparency=1
StealEggLabel.TextXAlignment=Enum.TextXAlignment.Left
StealEggLabel.ZIndex=61
StealEggLabel.Parent=StealEggRow

local StealEggStatus=Instance.new("TextLabel")
StealEggStatus.Size=UDim2.fromOffset(80,20)
StealEggStatus.Position=UDim2.fromOffset(140,3)
StealEggStatus.Text="● Stopped"
StealEggStatus.TextColor3=Color3.fromRGB(170,170,175)
StealEggStatus.Font=Enum.Font.Gotham
StealEggStatus.TextSize=9
StealEggStatus.BackgroundTransparency=1
StealEggStatus.TextXAlignment=Enum.TextXAlignment.Left
StealEggStatus.ZIndex=61
StealEggStatus.Parent=StealEggRow

local StealEggToggle=ModernButton("OFF",55,30,StealEggRow)
StealEggToggle.Position=UDim2.new(1,-65,.5,-15)
StealEggToggle.ZIndex=62

local SwitchServerButton=ModernButton("SWITCH SERVER",150,36,MainPage)
SwitchServerButton.Position=UDim2.new(.5,-75,0,15)

local RejoinButton=ModernButton("REJOIN",150,36,MainPage)
RejoinButton.Position=UDim2.new(.5,-75,0,65)

local ESPButton=ModernButton("ESP • OFF",150,34,EyesPage)
ESPButton.Position=UDim2.new(.5,-75,0,5)

local SpeedLabel=Instance.new("TextLabel")
SpeedLabel.Size=UDim2.fromOffset(150,18)
SpeedLabel.Position=UDim2.new(.5,-75,0,47)
SpeedLabel.Text="EDIT SPEED"
SpeedLabel.TextColor3=GOLD
SpeedLabel.Font=Enum.Font.GothamMedium
SpeedLabel.TextSize=11
SpeedLabel.BackgroundTransparency=1
SpeedLabel.Parent=EyesPage

local SpeedBox=Instance.new("TextBox")
SpeedBox.Size=UDim2.fromOffset(140,32)
SpeedBox.Position=UDim2.new(.5,-70,0,68)
SpeedBox.PlaceholderText="Enter speed"
SpeedBox.PlaceholderColor3=Color3.fromRGB(100,100,105)
SpeedBox.TextColor3=GOLD
SpeedBox.TextSize=13
SpeedBox.Font=Enum.Font.Gotham
SpeedBox.BackgroundColor3=Color3.fromRGB(15,15,18)
SpeedBox.BackgroundTransparency=.04
SpeedBox.ClearTextOnFocus=false
SpeedBox.TextXAlignment=Enum.TextXAlignment.Center
SpeedBox.Parent=EyesPage

local SpeedBoxCorner=Instance.new("UICorner")
SpeedBoxCorner.CornerRadius=UDim.new(0,10)
SpeedBoxCorner.Parent=SpeedBox

local SpeedBoxStroke=Instance.new("UIStroke")
SpeedBoxStroke.Color=GOLD
SpeedBoxStroke.Transparency=.6
SpeedBoxStroke.Parent=SpeedBox

local SpeedButton=ModernButton("SPEED • OFF",150,34,EyesPage)
SpeedButton.Position=UDim2.new(.5,-75,0,110)

local TeleportButton=ModernButton("TELEPORT TO SPAWN",170,34,EyesPage)
TeleportButton.Position=UDim2.new(.5,-85,0,155)

local FastModeButton=ModernButton("FAST MODE • OFF",170,38,FastPage)
FastModeButton.Position=UDim2.new(.5,-85,0,15)

local ReduceObjectsButton=ModernButton("REDUCE OBJECTS • OFF",170,38,FastPage)
ReduceObjectsButton.Position=UDim2.new(.5,-85,0,65)

local ReduceInfo=Instance.new("TextLabel")
ReduceInfo.Size=UDim2.fromOffset(230,20)
ReduceInfo.Position=UDim2.new(.5,-115,0,110)
ReduceInfo.Text="Hidden: 0 objects"
ReduceInfo.TextColor3=Color3.fromRGB(155,155,160)
ReduceInfo.Font=Enum.Font.Gotham
ReduceInfo.TextSize=10
ReduceInfo.BackgroundTransparency=1
ReduceInfo.Parent=FastPage

local function ShowPage(Page)
	MainPage.Visible=false
	EyesPage.Visible=false
	FastPage.Visible=false
	BypassPage.Visible=false

	Page.Visible=true
	ScrollingFrame.CanvasPosition=Vector2.zero
end

BackButton.MouseButton1Click:Connect(function()
	ShowPage(MainPage)
end)

EyeButton.MouseButton1Click:Connect(function()
	ShowPage(EyesPage)
end)

FastTabButton.MouseButton1Click:Connect(function()
	ShowPage(FastPage)
end)

BypassTabButton.MouseButton1Click:Connect(function()
	ShowPage(BypassPage)
end)

local function CharacterAdded(Character)
	CurrentCharacter=Character
	CurrentHumanoid=Character:WaitForChild("Humanoid",10)
	CurrentRoot=Character:WaitForChild("HumanoidRootPart",10)

	if not CurrentHumanoid or not CurrentRoot then
		return
	end

	OriginalSpeed=CurrentHumanoid.WalkSpeed
	task.wait(.15)
	SpawnCFrame=CurrentRoot.CFrame

	if SpeedEnabled then
		CurrentHumanoid.WalkSpeed=CustomSpeed
	end
end

if P.Character then
	task.spawn(CharacterAdded,P.Character)
end

P.CharacterAdded:Connect(CharacterAdded)

RunService.Heartbeat:Connect(function()
	if SpeedEnabled and CurrentHumanoid and CurrentHumanoid.Parent then
		if CurrentHumanoid.WalkSpeed~=CustomSpeed then
			CurrentHumanoid.WalkSpeed=CustomSpeed
		end
	end
end)

SpeedBox.FocusLost:Connect(function()
	local Number=tonumber(SpeedBox.Text)

	if Number then
		CustomSpeed=math.max(1,math.floor(Number+.5))
		SpeedBox.Text=tostring(CustomSpeed)
	end
end)

SpeedButton.MouseButton1Click:Connect(function()
	SpeedEnabled=not SpeedEnabled

	if SpeedEnabled then
		if CurrentHumanoid then
			CurrentHumanoid.WalkSpeed=CustomSpeed
		end

		SpeedButton.Text="SPEED • ON"
		SpeedButton.TextColor3=ON
	else
		if CurrentHumanoid then
			CurrentHumanoid.WalkSpeed=OriginalSpeed
		end

		SpeedButton.Text="SPEED • OFF"
		SpeedButton.TextColor3=GOLD
	end
end)

TeleportButton.MouseButton1Click:Connect(function()
	if CurrentRoot and SpawnCFrame then
		CurrentRoot.CFrame=SpawnCFrame

		if CurrentHumanoid then
			CurrentHumanoid.Health=CurrentHumanoid.MaxHealth
		end

		TeleportButton.Text="SPAWN TELEPORTED"

		task.delay(1,function()
			TeleportButton.Text="TELEPORT TO SPAWN"
		end)
	end
end)

local function RemoveESP()
	for _,Object in pairs(ESPObjects) do
		if Object then
			Object:Destroy()
		end
	end

	table.clear(ESPObjects)

	for _,Connection in pairs(ESPConnections) do
		Connection:Disconnect()
	end

	table.clear(ESPConnections)
end

local function CreateESP(Player)
	if Player==P then
		return
	end

	local function CharacterLoaded(Character)
		if not ESPEnabled then
			return
		end

		local Head=Character:WaitForChild("Head",5)

		if not Head or not ESPEnabled then
			return
		end

		local Billboard=Instance.new("BillboardGui")
		Billboard.Name="StelleESP"
		Billboard.Size=UDim2.fromOffset(150,35)
		Billboard.StudsOffset=Vector3.new(0,3,0)
		Billboard.AlwaysOnTop=true
		Billboard.Parent=Head

		local Label=Instance.new("TextLabel")
		Label.Size=UDim2.fromScale(1,1)
		Label.BackgroundTransparency=1
		Label.TextColor3=Color3.new(1,1,1)
		Label.TextStrokeTransparency=.3
		Label.Font=Enum.Font.GothamBold
		Label.TextSize=11
		Label.Parent=Billboard

		table.insert(ESPObjects,Billboard)

		local Connection=RunService.RenderStepped:Connect(function()
			if not ESPEnabled or not Billboard.Parent then
				return
			end

			if CurrentRoot and Character:FindFirstChild("HumanoidRootPart") then
				local Distance=(CurrentRoot.Position-Character.HumanoidRootPart.Position).Magnitude
				Label.Text=Player.Name.." ["..math.floor(Distance).."]"
			end
		end)

		table.insert(ESPConnections,Connection)
	end

	if Player.Character then
		CharacterLoaded(Player.Character)
	end

	table.insert(ESPConnections,Player.CharacterAdded:Connect(CharacterLoaded))
end

local function EnableESP()
	ESPEnabled=true

	for _,Player in ipairs(Players:GetPlayers()) do
		CreateESP(Player)
	end

	ESPButton.Text="ESP • ON"
	ESPButton.TextColor3=ON
end

local function DisableESP()
	ESPEnabled=false
	RemoveESP()

	ESPButton.Text="ESP • OFF"
	ESPButton.TextColor3=GOLD
end

ESPButton.MouseButton1Click:Connect(function()
	if ESPEnabled then
		DisableESP()
	else
		EnableESP()
	end
end)

Players.PlayerAdded:Connect(function(Player)
	if ESPEnabled then
		CreateESP(Player)
	end
end)

Players.PlayerRemoving:Connect(function()
	if ESPEnabled then
		task.wait()
		RemoveESP()

		for _,Player in ipairs(Players:GetPlayers()) do
			CreateESP(Player)
		end
	end
end)

local function SaveFastObject(Object)
	if FastHidden[Object]~=nil then
		return
	end

	if Object:IsA("Decal") or Object:IsA("Texture") then
		FastHidden[Object]=Object.Transparency
		Object.Transparency=1
	elseif Object:IsA("ParticleEmitter") or Object:IsA("Trail") or Object:IsA("Beam") or Object:IsA("Smoke") or Object:IsA("Fire") or Object:IsA("Sparkles") then
		FastHidden[Object]=Object.Enabled
		Object.Enabled=false
	elseif Object:IsA("Highlight") then
		FastHidden[Object]=Object.Enabled
		Object.Enabled=false
	elseif Object:IsA("PointLight") or Object:IsA("SpotLight") or Object:IsA("SurfaceLight") then
		FastHidden[Object]=Object.Enabled
		Object.Enabled=false
	end
end

local function SetFastStatus(Status)
	FastModeButton.Text="FAST MODE • "..Status
end

local function RestoreFastMode()
	FastProcessID+=1
	FastModeEnabled=false
	FastApplying=false
	FastRestoring=true
	FastRestoreID+=1

	local Objects={}

	for Object,Value in pairs(FastHidden) do
		table.insert(Objects,{Object,Value})
	end

	local Total=#Objects

	if Total==0 then
		table.clear(FastHidden)
		FastRestoring=false
		FastModeButton.Text="FAST MODE • OFF"
		FastModeButton.TextColor3=GOLD
		return
	end

	local RestoreID=FastRestoreID

	FastModeButton.TextColor3=GOLD
	FastModeButton.Text="RESTORING • 0%"

	task.spawn(function()
		for Index,Data in ipairs(Objects) do
			if RestoreID~=FastRestoreID then
				return
			end

			local Object=Data[1]
			local Value=Data[2]

			if Object and Object.Parent then
				if Object:IsA("Decal") or Object:IsA("Texture") then
					Object.Transparency=Value
				else
					Object.Enabled=Value
				end
			end

			if Index%FAST_RESTORE_BATCH_SIZE==0 or Index==Total then
				local Progress=math.floor((Index/Total)*100)

				if Progress>100 then
					Progress=100
				end

				FastModeButton.Text="RESTORING • "..Progress.."%"
				task.wait(FAST_RESTORE_BATCH_DELAY)
			end
		end

		if RestoreID==FastRestoreID then
			table.clear(FastHidden)
			FastRestoring=false
			FastModeButton.Text="FAST MODE • OFF"
			FastModeButton.TextColor3=GOLD
		end
	end)
end

local function ApplyFastMode()
	if FastApplying or FastRestoring then
		return
	end

	FastProcessID+=1
	local ProcessID=FastProcessID

	FastApplying=true
	FastModeEnabled=true

	SetFastStatus("0%")

	task.spawn(function()
		local Objects=workspace:GetDescendants()
		local Total=#Objects

		if Total==0 then
			SetFastStatus("100%")
			task.wait(.1)

			if FastModeEnabled and ProcessID==FastProcessID then
				SetFastStatus("DONE ✓")
			end

			FastApplying=false
			return
		end

		for Index,Object in ipairs(Objects) do
			if not FastModeEnabled or ProcessID~=FastProcessID then
				FastApplying=false
				return
			end

			if not CurrentCharacter or not Object:IsDescendantOf(CurrentCharacter) then
				SaveFastObject(Object)
			end

			if Index%FAST_BATCH_SIZE==0 or Index==Total then
				local Progress=math.floor((Index/Total)*100)

				if Progress>100 then
					Progress=100
				end

				SetFastStatus(Progress.."%")
				task.wait(FAST_BATCH_DELAY)
			end
		end

		SetFastStatus("100%")
		task.wait(.1)

		if FastModeEnabled and ProcessID==FastProcessID then
			SetFastStatus("DONE ✓")
		end

		FastApplying=false
	end)
end

FastModeButton.MouseButton1Click:Connect(function()
	if FastRestoring then
		return
	end

	if FastModeEnabled then
		RestoreFastMode()
	else
		FastModeButton.TextColor3=ON
		ApplyFastMode()
	end
end)

local function IsReduceObject(Object)
	if not Object:IsA("BasePart") then
		return false
	end

	if CurrentCharacter and Object:IsDescendantOf(CurrentCharacter) then
		return false
	end

	if Object:IsA("SpawnLocation") then
		return false
	end

	local Size=Object.Size

	return Size.X<=REDUCE_MAX_SIZE and Size.Y<=REDUCE_MAX_SIZE and Size.Z<=REDUCE_MAX_SIZE
end

local function HideObject(Object)
	if HiddenObjects[Object]~=nil then
		return
	end

	HiddenObjects[Object]=Object.LocalTransparencyModifier
	Object.LocalTransparencyModifier=1
	HiddenCount+=1
end

local function SetReduceStatus(Status)
	ReduceObjectsButton.Text="REDUCE • "..Status
	ReduceInfo.Text="Hidden: "..HiddenCount
end

local function ApplyReduceObjects()
	if ReducingObjects or ReduceRestoring then
		return
	end

	ReduceProcessID+=1
	local ProcessID=ReduceProcessID

	ReducingObjects=true
	ReduceObjectsEnabled=true
	HiddenCount=0
	table.clear(HiddenObjects)

	SetReduceStatus("0%")

	task.spawn(function()
		local Objects=workspace:GetDescendants()
		local Total=#Objects

		if Total==0 then
			SetReduceStatus("100%")
			task.wait(.1)

			if ReduceObjectsEnabled and ProcessID==ReduceProcessID then
				SetReduceStatus("DONE ✓")
			end

			ReducingObjects=false
			return
		end

		for Index,Object in ipairs(Objects) do
			if not ReduceObjectsEnabled or ProcessID~=ReduceProcessID then
				ReducingObjects=false
				return
			end

			if IsReduceObject(Object) then
				HideObject(Object)
			end

			if Index%REDUCE_BATCH_SIZE==0 or Index==Total then
				local Progress=math.floor((Index/Total)*100)

				if Progress>100 then
					Progress=100
				end

				SetReduceStatus(Progress.."%")
				task.wait(REDUCE_BATCH_DELAY)
			end
		end

		if not ReduceObjectsEnabled or ProcessID~=ReduceProcessID then
			ReducingObjects=false
			return
		end

		SetReduceStatus("100%")
		task.wait(.1)

		if ReduceObjectsEnabled and ProcessID==ReduceProcessID then
			SetReduceStatus("DONE ✓")
		end

		ReducingObjects=false
	end)
end

local function RestoreReduceObjects()
	ReduceProcessID+=1
	ReduceObjectsEnabled=false
	ReducingObjects=false
	ReduceRestoring=true
	ReduceRestoreID+=1

	local Objects={}

	for Object,Value in pairs(HiddenObjects) do
		table.insert(Objects,{Object,Value})
	end

	local Total=#Objects

	if Total==0 then
		table.clear(HiddenObjects)
		HiddenCount=0
		ReduceRestoring=false
		ReduceObjectsButton.Text="REDUCE OBJECTS • OFF"
		ReduceObjectsButton.TextColor3=GOLD
		ReduceInfo.Text="Hidden: 0 objects"
		return
	end

	local RestoreID=ReduceRestoreID

	ReduceObjectsButton.TextColor3=GOLD
	ReduceObjectsButton.Text="RESTORING • 0%"
	ReduceInfo.Text="Hidden: "..HiddenCount

	task.spawn(function()
		for Index,Data in ipairs(Objects) do
			if RestoreID~=ReduceRestoreID then
				return
			end

			local Object=Data[1]
			local Value=Data[2]

			if Object and Object.Parent then
				Object.LocalTransparencyModifier=Value
			end

			if Index%REDUCE_RESTORE_BATCH_SIZE==0 or Index==Total then
				local Progress=math.floor((Index/Total)*100)

				if Progress>100 then
					Progress=100
				end

				ReduceObjectsButton.Text="RESTORING • "..Progress.."%"
				ReduceInfo.Text="Restoring "..Progress.."%"
				task.wait(REDUCE_RESTORE_BATCH_DELAY)
			end
		end

		if RestoreID==ReduceRestoreID then
			table.clear(HiddenObjects)
			HiddenCount=0
			ReduceRestoring=false
			ReduceObjectsButton.Text="REDUCE OBJECTS • OFF"
			ReduceObjectsButton.TextColor3=GOLD
			ReduceInfo.Text="Hidden: 0 objects"
		end
	end)
end

ReduceObjectsButton.MouseButton1Click:Connect(function()
	if ReduceRestoring then
		return
	end

	if ReduceObjectsEnabled then
		RestoreReduceObjects()
	else
		ReduceObjectsButton.TextColor3=ON
		ApplyReduceObjects()
	end
end)

workspace.DescendantAdded:Connect(function(Object)
	if FastModeEnabled and not FastRestoring then
		task.defer(function()
			if FastModeEnabled and not FastRestoring then
				SaveFastObject(Object)
			end
		end)
	end

	if ReduceObjectsEnabled and not ReduceRestoring and IsReduceObject(Object) then
		task.defer(function()
			if ReduceObjectsEnabled and not ReduceRestoring and IsReduceObject(Object) then
				HideObject(Object)
				ReduceInfo.Text="Hidden: "..HiddenCount
			end
		end)
	end
end)

local function SwitchServer()
	local Success,Data=pcall(function()
		return HttpService:JSONDecode(
			game:HttpGet(
				"https://games.roblox.com/v1/games/"..
				PID..
				"/servers/Public?sortOrder=Asc&limit=100"
			)
		)
	end)

	if not Success or not Data or not Data.data then
		return
	end

	for _,Server in ipairs(Data.data) do
		if Server.id~=JID and Server.playing<Server.maxPlayers then
			TeleportService:TeleportToPlaceInstance(PID,Server.id,P)
			return
		end
	end
end

SwitchServerButton.MouseButton1Click:Connect(SwitchServer)

RejoinButton.MouseButton1Click:Connect(function()
	TeleportService:TeleportToPlaceInstance(PID,JID,P)
end)

local StealEggEnabled=false

local function StartStealEgg()
	--==================================================
	local shothook
shothook = hookmetamethod(game, "_namecall", function(self, ...)
	local args = {...}
	local method = getnamecallmethod()

	local blockedNames = {
		["RE/RigSync/AskRigWipe"] = true,
		["RE/RigSync/CorrectionBegan"] = true,
		["RE/RigSync/Primed"] = true,
		["RE/RigSync/ProbeSatchel"] = true,
		["RE/RigSync/Reconcile"] = true,
		["RE/RigSync/Refresh"] = true,
		["RE/RigSync/SeedSatchel"] = true
	}
 
	if blockedNames[tostring(self)] and (method == "FireServer" or method == "FireClient") then
		return nil
			end
			
	return shothook(self, table.unpack(args))
end)
	--==================================================
end

local function StopStealEgg()
	--==================================================
	-- RESTORE THE STATE FROM BEFORE IT WAS TURNED ON
	--
	-- Put the cleanup/restoration for your script here.
	--==================================================
end

StealEggToggle.MouseButton1Click:Connect(function()
	StealEggEnabled=not StealEggEnabled

	if StealEggEnabled then
		StealEggToggle.Text="ON"
		StealEggToggle.TextColor3=ON

		StealEggStatus.Text="● Running"
		StealEggStatus.TextColor3=ON

		StartStealEgg()
	else
		StealEggToggle.Text="OFF"
		StealEggToggle.TextColor3=GOLD

		StealEggStatus.Text="● Stopped"
		StealEggStatus.TextColor3=Color3.fromRGB(170,170,175)

		StopStealEgg()
	end
end)

local function MakeDraggable(Object)
	local Dragging=false
	local DragStart
	local StartPosition

	Object.InputBegan:Connect(function(Input)
		if Input.UserInputType==Enum.UserInputType.MouseButton1 or Input.UserInputType==Enum.UserInputType.Touch then
			Dragging=true
			DragStart=Input.Position
			StartPosition=Object.Position

			Input.Changed:Connect(function()
				if Input.UserInputState==Enum.UserInputState.End then
					Dragging=false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(Input)
		if not Dragging then
			return
		end

		if Input.UserInputType~=Enum.UserInputType.MouseMovement and Input.UserInputType~=Enum.UserInputType.Touch then
			return
		end

		local Delta=Input.Position-DragStart

		Object.Position=UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset+Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset+Delta.Y
		)
	end)
end

MakeDraggable(Launcher)
MakeDraggable(Hub)

Launcher.MouseButton1Click:Connect(function()
	Hub.Visible=not Hub.Visible

	if Hub.Visible then
		HubScale.Scale=.85

		TweenService:Create(
			HubScale,
			TweenInfo.new(.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
			{Scale=1}
		):Play()
	end
end)

ShowPage(MainPage)
SpeedBox.Text=tostring(CustomSpeed)
