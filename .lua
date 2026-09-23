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

local G=Instance.new("ScreenGui")
G.Name="StelleHub"
G.ResetOnSpawn=false
G.IgnoreGuiInset=true
G.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
G.Parent=PG

local B=Instance.new("TextButton")
B.Name="Launcher"
B.Size=UDim2.new(0,42,0,42)
B.Position=UDim2.new(0,100,0,100)
B.Text="✨"
B.TextSize=23
B.Font=Enum.Font.GothamBold
B.TextColor3=GOLD
B.BackgroundColor3=Color3.fromRGB(8,8,10)
B.BackgroundTransparency=.08
B.AutoButtonColor=false
B.Active=true
B.ZIndex=100
B.Parent=G

Instance.new("UICorner",B).CornerRadius=UDim.new(1,0)

local BS=Instance.new("UIStroke",B)
BS.Color=GOLD
BS.Transparency=.4
BS.Thickness=1

local Hub=Instance.new("Frame")
Hub.Name="HubContainer"
Hub.Size=UDim2.new(0,336,0,220)
Hub.Position=UDim2.new(.5,-168,.5,-110)
Hub.BackgroundTransparency=1
Hub.Visible=false
Hub.Active=true
Hub.ZIndex=40
Hub.Parent=G

local HubScale=Instance.new("UIScale")
HubScale.Scale=1
HubScale.Parent=Hub

local F=Instance.new("Frame")
F.Name="Panel"
F.Size=UDim2.new(0,300,0,220)
F.Position=UDim2.new(0,36,0,0)
F.BackgroundColor3=Color3.fromRGB(7,7,9)
F.BackgroundTransparency=.04
F.Active=true
F.ZIndex=45
F.Parent=Hub

Instance.new("UICorner",F).CornerRadius=UDim.new(0,18)

local FS=Instance.new("UIStroke",F)
FS.Color=GOLD
FS.Transparency=.45
FS.Thickness=1

local function ModernButton(text,w,h,parent)
	local b=Instance.new("TextButton")
	b.Size=UDim2.new(0,w,0,h)
	b.Text=text
	b.Font=Enum.Font.GothamMedium
	b.TextSize=12
	b.TextColor3=GOLD
	b.BackgroundColor3=Color3.fromRGB(18,18,22)
	b.BackgroundTransparency=.04
	b.AutoButtonColor=false
	b.Active=true
	b.ZIndex=60
	b.Parent=parent

	Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)

	local s=Instance.new("UIStroke",b)
	s.Color=GOLD
	s.Transparency=.65
	s.Thickness=1

	b.MouseEnter:Connect(function()
		b.BackgroundColor3=Color3.fromRGB(28,28,34)
	end)

	b.MouseLeave:Connect(function()
		b.BackgroundColor3=Color3.fromRGB(18,18,22)
	end)

	return b
end

-- Smaller navigation buttons
local back=ModernButton("🔄",32,32,Hub)
back.Position=UDim2.new(0,2,0,34)

local eye=ModernButton("👀",32,32,Hub)
eye.Position=UDim2.new(0,2,0,76)

local fastTab=ModernButton("⚡",32,32,Hub)
fastTab.Position=UDim2.new(0,2,0,118)

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,-20,0,28)
title.Position=UDim2.new(0,10,0,7)
title.Text="Stelle Hub"
title.TextColor3=GOLD
title.Font=Enum.Font.Garamond
title.TextSize=19
title.BackgroundTransparency=1
title.TextXAlignment=Enum.TextXAlignment.Right
title.ZIndex=55
title.Parent=F

local credit=Instance.new("TextLabel")
credit.Size=UDim2.new(1,-20,0,20)
credit.Position=UDim2.new(0,10,1,-27)
credit.Text="by Ian James"
credit.TextColor3=Color3.fromRGB(150,150,155)
credit.Font=Enum.Font.Garamond
credit.TextSize=12
credit.BackgroundTransparency=1
credit.ZIndex=55
credit.Parent=F

local Content=Instance.new("ScrollingFrame")
Content.Name="Content"
Content.Size=UDim2.new(1,-35,1,-65)
Content.Position=UDim2.new(0,25,0,43)
Content.BackgroundTransparency=1
Content.BorderSizePixel=0
Content.ScrollBarThickness=2
Content.ScrollBarImageColor3=GOLD
Content.CanvasSize=UDim2.new(0,0,0,0)
Content.AutomaticCanvasSize=Enum.AutomaticSize.Y
Content.ScrollingDirection=Enum.ScrollingDirection.Y
Content.ZIndex=55
Content.Parent=F

local MainContent=Instance.new("Frame")
MainContent.Size=UDim2.new(1,-5,0,145)
MainContent.BackgroundTransparency=1
MainContent.Parent=Content

local EyesContent=Instance.new("Frame")
EyesContent.Size=UDim2.new(1,-5,0,210)
EyesContent.BackgroundTransparency=1
EyesContent.Visible=false
EyesContent.Parent=Content

local FastContent=Instance.new("Frame")
FastContent.Size=UDim2.new(1,-5,0,165)
FastContent.BackgroundTransparency=1
FastContent.Visible=false
FastContent.Parent=Content

local sw=ModernButton("SWITCH SERVER",150,36,MainContent)
sw.Position=UDim2.new(.5,-75,0,15)

local rj=ModernButton("REJOIN",150,36,MainContent)
rj.Position=UDim2.new(.5,-75,0,65)

local esp=ModernButton("ESP  •  OFF",150,34,EyesContent)
esp.Position=UDim2.new(.5,-75,0,5)

local st=Instance.new("TextLabel")
st.Size=UDim2.new(0,150,0,18)
st.Position=UDim2.new(.5,-75,0,47)
st.Text="EDIT SPEED"
st.TextColor3=GOLD
st.Font=Enum.Font.GothamMedium
st.TextSize=11
st.BackgroundTransparency=1
st.Parent=EyesContent

local sb=Instance.new("TextBox")
sb.Size=UDim2.new(0,140,0,32)
sb.Position=UDim2.new(.5,-70,0,68)
sb.PlaceholderText="Enter speed"
sb.PlaceholderColor3=Color3.fromRGB(100,100,105)
sb.TextColor3=GOLD
sb.TextSize=13
sb.Font=Enum.Font.Gotham
sb.BackgroundColor3=Color3.fromRGB(15,15,18)
sb.BackgroundTransparency=.04
sb.ClearTextOnFocus=false
sb.TextXAlignment=Enum.TextXAlignment.Center
sb.Parent=EyesContent

Instance.new("UICorner",sb).CornerRadius=UDim.new(0,10)

local ss=Instance.new("UIStroke",sb)
ss.Color=GOLD
ss.Transparency=.6

local sp=ModernButton("SPEED  •  OFF",150,34,EyesContent)
sp.Position=UDim2.new(.5,-75,0,110)

local spawnButton=ModernButton("TELEPORT TO SPAWN",170,34,EyesContent)
spawnButton.Position=UDim2.new(.5,-85,0,155)

local fastButton=ModernButton("FAST MODE  •  OFF",170,38,FastContent)
fastButton.Position=UDim2.new(.5,-85,0,15)

local reduceButton=ModernButton("REDUCE OBJECTS  •  OFF",170,38,FastContent)
reduceButton.Position=UDim2.new(.5,-85,0,65)

local reduceInfo=Instance.new("TextLabel")
reduceInfo.Size=UDim2.new(0,200,0,20)
reduceInfo.Position=UDim2.new(.5,-100,0,110)
reduceInfo.Text="Hidden: 0 objects"
reduceInfo.TextColor3=Color3.fromRGB(155,155,160)
reduceInfo.Font=Enum.Font.Gotham
reduceInfo.TextSize=10
reduceInfo.BackgroundTransparency=1
reduceInfo.Parent=FastContent

local function ShowPage(page)
	MainContent.Visible=false
	EyesContent.Visible=false
	FastContent.Visible=false

	page.Visible=true
	Content.CanvasPosition=Vector2.new(0,0)
end

local function ShowMain()
	ShowPage(MainContent)
end

local function ShowEyes()
	ShowPage(EyesContent)
end

local function ShowFast()
	ShowPage(FastContent)
end

back.MouseButton1Click:Connect(ShowMain)
eye.MouseButton1Click:Connect(ShowEyes)
fastTab.MouseButton1Click:Connect(ShowFast)

local function GetChar()
	local c=P.Character
	if not c then return end

	local h=c:FindFirstChildOfClass("Humanoid")
	local r=c:FindFirstChild("HumanoidRootPart")

	if h and r then
		return c,h,r
	end
end

local function CharacterAdded(c)
	CurrentCharacter=c

	CurrentHumanoid=c:WaitForChild("Humanoid",10)
	CurrentRoot=c:WaitForChild("HumanoidRootPart",10)

	if not CurrentHumanoid or not CurrentRoot then return end

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
	if CurrentHumanoid
	and CurrentHumanoid.Health>0
	and SpeedEnabled then

		if math.abs(CurrentHumanoid.WalkSpeed-CustomSpeed)>.1 then
			CurrentHumanoid.WalkSpeed=CustomSpeed
		end
	end
end)

sb.FocusLost:Connect(function()
	local n=tonumber(sb.Text)

	if n then
		CustomSpeed=math.max(1,math.floor(n+.5))
		sb.Text=tostring(CustomSpeed)

		if SpeedEnabled and CurrentHumanoid then
			CurrentHumanoid.WalkSpeed=CustomSpeed
		end
	else
		sb.Text=tostring(CustomSpeed)
	end
end)

sp.MouseButton1Click:Connect(function()
	SpeedEnabled=not SpeedEnabled

	sp.Text=SpeedEnabled
		and "SPEED  •  ON"
		or "SPEED  •  OFF"

	sp.TextColor3=SpeedEnabled and ON or GOLD

	if CurrentHumanoid then
		CurrentHumanoid.WalkSpeed=
			SpeedEnabled and CustomSpeed or OriginalSpeed
	end
end)

spawnButton.MouseButton1Click:Connect(function()
	local c,h,r=GetChar()
	if not c then return end

	SpawnCFrame=SpawnCFrame or r.CFrame

	local start=os.clock()

	local con

	con=RunService.Heartbeat:Connect(function()
		if not h.Parent or os.clock()-start>=2 then
			con:Disconnect()
			return
		end

		if h.Health<h.MaxHealth then
			h.Health=h.MaxHealth
		end
	end)

	c:PivotTo(SpawnCFrame+Vector3.new(0,3,0))

	spawnButton.Text="SPAWN TELEPORTED"
	spawnButton.TextColor3=ON

	task.delay(1,function()
		if spawnButton.Parent then
			spawnButton.Text="TELEPORT TO SPAWN"
			spawnButton.TextColor3=GOLD
		end
	end)
end)

local function RemoveESP(p)
	local d=ESPObjects[p]

	if d then
		if d.Gui then
			d.Gui:Destroy()
		end

		if d.Connection then
			d.Connection:Disconnect()
		end

		ESPObjects[p]=nil
	end
end

local function CreateESP(p)
	if not ESPEnabled then return end

	RemoveESP(p)

	local c=p.Character
	if not c then return end

	local head=c:FindFirstChild("Head")

	if not head then
		head=c:WaitForChild("Head",5)
	end

	if not head then return end

	local gui=Instance.new("BillboardGui")
	gui.Name="StelleESP"
	gui.Adornee=head
	gui.Size=UDim2.new(0,180,0,40)
	gui.StudsOffset=Vector3.new(0,2.5,0)
	gui.AlwaysOnTop=true
	gui.MaxDistance=10000
	gui.Parent=head

	local label=Instance.new("TextLabel")
	label.Size=UDim2.new(1,0,1,0)
	label.BackgroundTransparency=1
	label.Font=Enum.Font.GothamBold
	label.TextSize=12
	label.TextColor3=GOLD
	label.TextStrokeTransparency=.45
	label.Parent=gui

	local connection

	connection=RunService.RenderStepped:Connect(function()
		if not ESPEnabled then return end

		if not p.Parent or not c.Parent then
			RemoveESP(p)
			return
		end

		local myChar=P.Character
		local myRoot=myChar and myChar:FindFirstChild("HumanoidRootPart")
		local theirRoot=c:FindFirstChild("HumanoidRootPart")

		if myRoot and theirRoot then
			local distance=(myRoot.Position-theirRoot.Position).Magnitude

			if p==P then
				label.Text="YOU [0 studs]"
			else
				label.Text=p.Name.." ["..math.floor(distance).." studs]"
			end
		end
	end)

	ESPObjects[p]={
		Gui=gui,
		Connection=connection
	}
end

local function WatchPlayer(p)
	if ESPConnections[p] then
		ESPConnections[p]:Disconnect()
	end

	ESPConnections[p]=p.CharacterAdded:Connect(function()
		if ESPEnabled then
			task.wait(.3)
			CreateESP(p)
		end
	end)

	if ESPEnabled and p.Character then
		task.spawn(CreateESP,p)
	end
end

local function EnableESP()
	ESPEnabled=true

	esp.Text="ESP  •  ON"
	esp.TextColor3=ON

	for _,p in ipairs(Players:GetPlayers()) do
		WatchPlayer(p)
	end
end

local function DisableESP()
	ESPEnabled=false

	esp.Text="ESP  •  OFF"
	esp.TextColor3=GOLD

	for p in pairs(ESPObjects) do
		RemoveESP(p)
	end
end

esp.MouseButton1Click:Connect(function()
	if ESPEnabled then
		DisableESP()
	else
		EnableESP()
	end
end)

Players.PlayerAdded:Connect(function(p)
	WatchPlayer(p)
end)

Players.PlayerRemoving:Connect(function(p)
	RemoveESP(p)

	if ESPConnections[p] then
		ESPConnections[p]:Disconnect()
		ESPConnections[p]=nil
	end
end)

local function SaveFastObject(o)
	if FastHidden[o]~=nil then return end

	if o:IsA("Decal") or o:IsA("Texture") then
		FastHidden[o]={
			Type="Texture",
			Transparency=o.Transparency
		}

		o.Transparency=1
	end

	if o:IsA("ParticleEmitter")
	or o:IsA("Trail")
	or o:IsA("Beam")
	or o:IsA("Smoke")
	or o:IsA("Fire")
	or o:IsA("Sparkles")
	or o:IsA("Highlight") then

		FastHidden[o]={
			Type="Enabled",
			Enabled=o.Enabled
		}

		o.Enabled=false
	end

	if o:IsA("PointLight")
	or o:IsA("SpotLight")
	or o:IsA("SurfaceLight") then

		FastHidden[o]={
			Type="Enabled",
			Enabled=o.Enabled
		}

		o.Enabled=false
	end
end

local function ApplyFastMode()
	if not FastModeEnabled then return end

	for _,o in ipairs(workspace:GetDescendants()) do
		if CurrentCharacter and o:IsDescendantOf(CurrentCharacter) then
			continue
		end

		if o:IsA("Decal")
		or o:IsA("Texture")
		or o:IsA("ParticleEmitter")
		or o:IsA("Trail")
		or o:IsA("Beam")
		or o:IsA("Smoke")
		or o:IsA("Fire")
		or o:IsA("Sparkles")
		or o:IsA("Highlight")
		or o:IsA("PointLight")
		or o:IsA("SpotLight")
		or o:IsA("SurfaceLight") then

			SaveFastObject(o)
		end
	end

	for _,o in ipairs(Lighting:GetChildren()) do
		if o:IsA("BloomEffect")
		or o:IsA("BlurEffect")
		or o:IsA("ColorCorrectionEffect")
		or o:IsA("SunRaysEffect")
		or o:IsA("DepthOfFieldEffect") then

			if FastHidden[o]==nil then
				FastHidden[o]={
					Type="Enabled",
					Enabled=o.Enabled
				}

				o.Enabled=false
			end
		end
	end
end

local function RestoreFastMode()
	for o,d in pairs(FastHidden) do
		if o and o.Parent then
			pcall(function()
				if d.Type=="Texture" then
					o.Transparency=d.Transparency
				else
					o.Enabled=d.Enabled
				end
			end)
		end
	end

	table.clear(FastHidden)
end

fastButton.MouseButton1Click:Connect(function()
	FastModeEnabled=not FastModeEnabled

	fastButton.Text=
		FastModeEnabled
		and "FAST MODE  •  ON"
		or "FAST MODE  •  OFF"

	fastButton.TextColor3=
		FastModeEnabled and ON or GOLD

	if FastModeEnabled then
		ApplyFastMode()
	else
		RestoreFastMode()
	end
end)

local function Important(o)
	if not o:IsA("BasePart") then return true end
	if CurrentCharacter and o:IsDescendantOf(CurrentCharacter) then return true end
	if o:IsA("SpawnLocation") then return true end
	if o:IsDescendantOf(workspace.Terrain) then return true end

	local s=o.Size

	if s.X>REDUCE_MAX_SIZE
	or s.Y>REDUCE_MAX_SIZE
	or s.Z>REDUCE_MAX_SIZE then
		return true
	end

	return false
end

local function UpdateHiddenCount()
	HiddenCount=0

	for o in pairs(HiddenObjects) do
		if o and o.Parent and o:IsA("BasePart") then
			HiddenCount+=1
		end
	end

	reduceInfo.Text="Hidden: "..HiddenCount.." objects"
end

local function HideObject(o)
	if not ReduceObjectsEnabled then return end
	if Important(o) then return end
	if HiddenObjects[o] then return end

	HiddenObjects[o]={
		Transparency=o.LocalTransparencyModifier
	}

	o.LocalTransparencyModifier=1

	HiddenCount+=1
end

local function ReduceObjects()
	HiddenCount=0

	for _,o in ipairs(workspace:GetDescendants()) do
		HideObject(o)
	end

	UpdateHiddenCount()
end

local function RestoreObjects()
	for o,d in pairs(HiddenObjects) do
		if o and o.Parent then
			pcall(function()
				o.LocalTransparencyModifier=d.Transparency
			end)
		end
	end

	table.clear(HiddenObjects)

	HiddenCount=0
	reduceInfo.Text="Hidden: 0 objects"
end

reduceButton.MouseButton1Click:Connect(function()
	ReduceObjectsEnabled=not ReduceObjectsEnabled

	reduceButton.Text=
		ReduceObjectsEnabled
		and "REDUCE OBJECTS  •  ON"
		or "REDUCE OBJECTS  •  OFF"

	reduceButton.TextColor3=
		ReduceObjectsEnabled and ON or GOLD

	if ReduceObjectsEnabled then
		ReduceObjects()
	else
		RestoreObjects()
	end
end)

workspace.DescendantAdded:Connect(function(o)
	if ReduceObjectsEnabled then
		task.defer(function()
			HideObject(o)
			UpdateHiddenCount()
		end)
	end

	if FastModeEnabled then
		task.defer(function()
			ApplyFastMode()
		end)
	end
end)

local Switching=false

local function SwitchServer()
	if Switching then return end

	Switching=true
	sw.Text="SEARCHING..."

	local ok,data=pcall(function()
		return HttpService:JSONDecode(
			game:HttpGet(
				"https://games.roblox.com/v1/games/"
				..PID..
				"/servers/Public?sortOrder=Asc&limit=100"
			)
		)
	end)

	if ok and data and data.data then
		for _,server in ipairs(data.data) do
			if server.id~=JID
			and server.playing<server.maxPlayers then

				sw.Text="SWITCHING..."
				sw.TextColor3=ON

				TeleportService:TeleportToPlaceInstance(
					PID,
					server.id,
					P
				)

				return
			end
		end
	end

	sw.Text="NO SERVER"

	task.delay(1.5,function()
		if sw.Parent then
			sw.Text="SWITCH SERVER"
			sw.TextColor3=GOLD
		end

		Switching=false
	end)
end

sw.MouseButton1Click:Connect(SwitchServer)

local Rejoining=false

rj.MouseButton1Click:Connect(function()
	if Rejoining then return end

	Rejoining=true
	rj.Text="REJOINING..."
	rj.TextColor3=ON

	task.wait(.2)

	pcall(function()
		TeleportService:TeleportToPlaceInstance(
			PID,
			JID,
			P
		)
	end)

	task.delay(3,function()
		Rejoining=false

		if rj.Parent then
			rj.Text="REJOIN"
			rj.TextColor3=GOLD
		end
	end)
end)

local Open=false

local function OpenHub()
	Open=true
	Hub.Visible=true
	HubScale.Scale=0

	TweenService:Create(
		HubScale,
		TweenInfo.new(
			.22,
			Enum.EasingStyle.Back,
			Enum.EasingDirection.Out
		),
		{Scale=1}
	):Play()
end

local function CloseHub()
	Open=false

	TweenService:Create(
		HubScale,
		TweenInfo.new(
			.16,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.In
		),
		{Scale=0}
	):Play()

	task.delay(.17,function()
		if not Open then
			Hub.Visible=false
		end
	end)
end

-- ✨ Launcher is now draggable
local function MakeLauncherDraggable(o)
	local dragging=false
	local dragStart
	local startPos

	o.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1
		or input.UserInputType==Enum.UserInputType.Touch then

			dragging=true
			dragStart=input.Position
			startPos=o.Position

			input.Changed:Connect(function()
				if input.UserInputState==Enum.UserInputState.End then
					dragging=false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if not dragging then return end

		if input.UserInputType~=Enum.UserInputType.MouseMovement
		and input.UserInputType~=Enum.UserInputType.Touch then
			return
		end

		local delta=input.Position-dragStart

		o.Position=UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset+delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset+delta.Y
		)
	end)
end

MakeLauncherDraggable(B)

B.MouseButton1Click:Connect(function()
	if Open then
		CloseHub()
	else
		OpenHub()
	end
end)

local function MakeDraggable(o)
	local dragging=false
	local dragStart
	local startPos

	o.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1
		or input.UserInputType==Enum.UserInputType.Touch then

			dragging=true
			dragStart=input.Position
			startPos=Hub.Position

			input.Changed:Connect(function()
				if input.UserInputState==Enum.UserInputState.End then
					dragging=false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if not dragging then return end

		if input.UserInputType~=Enum.UserInputType.MouseMovement
		and input.UserInputType~=Enum.UserInputType.Touch then
			return
		end

		local delta=input.Position-dragStart

		Hub.Position=UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset+delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset+delta.Y
		)
	end)
end

MakeDraggable(F)
MakeDraggable(back)
MakeDraggable(eye)
MakeDraggable(fastTab)

sb.Text=tostring(CustomSpeed)
ShowMain()

print("Stelle Hub loaded successfully.")
