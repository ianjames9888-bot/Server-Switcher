local P=game.Players.LocalPlayer
local U=game:GetService("UserInputService")
local T=game:GetService("TweenService")
local TP=game:GetService("TeleportService")
local H=game:GetService("HttpService")
local R=game:GetService("RunService")
local L=game:GetService("Lighting")

local id=game.PlaceId
local jid=game.JobId
local gold=Color3.fromRGB(220,175,65)

--------------------------------------------------
-- GUI
--------------------------------------------------

local G=Instance.new("ScreenGui",P:WaitForChild("PlayerGui"))
G.Name="StelleHub"
G.ResetOnSpawn=false
G.IgnoreGuiInset=true
G.ZIndexBehavior=Enum.ZIndexBehavior.Sibling

--------------------------------------------------
-- ✨ BUTTON
--------------------------------------------------

local B=Instance.new("TextButton",G)
B.Size=UDim2.new(0,42,0,42)
B.Position=UDim2.new(0,100,0,100)
B.Text="✨"
B.TextSize=23
B.Font=Enum.Font.GothamBold
B.TextColor3=gold
B.BackgroundColor3=Color3.fromRGB(8,8,10)
B.BackgroundTransparency=.08
B.AutoButtonColor=false
B.Active=true
B.ZIndex=100

Instance.new("UICorner",B).CornerRadius=UDim.new(1,0)

local BS=Instance.new("UIStroke",B)
BS.Color=gold
BS.Transparency=.45
BS.Thickness=1

--------------------------------------------------
-- HUB
--------------------------------------------------

local F=Instance.new("Frame",G)
F.Size=UDim2.new(0,0,0,0)
F.Position=UDim2.new(.5,0,.5,0)
F.AnchorPoint=Vector2.new(.5,.5)
F.BackgroundColor3=Color3.fromRGB(7,7,9)
F.BackgroundTransparency=.04
F.Visible=false
F.ZIndex=50

Instance.new("UICorner",F).CornerRadius=UDim.new(0,18)

local FS=Instance.new("UIStroke",F)
FS.Color=gold
FS.Transparency=.45
FS.Thickness=1

--------------------------------------------------
-- NORMAL BUTTON CREATOR
--------------------------------------------------

local function bt(t,y,w,h)
	local b=Instance.new("TextButton",F)

	b.Size=UDim2.new(0,w,0,h)
	b.Position=UDim2.new(.5,-w/2,0,y)

	b.Text=t
	b.Font=Enum.Font.GothamMedium
	b.TextSize=12
	b.TextColor3=gold
	b.BackgroundColor3=Color3.fromRGB(18,18,21)
	b.BackgroundTransparency=.05
	b.AutoButtonColor=false
	b.ZIndex=55

	Instance.new("UICorner",b).CornerRadius=UDim.new(0,9)

	local s=Instance.new("UIStroke",b)
	s.Color=gold
	s.Transparency=.7
	s.Thickness=1

	return b
end

--------------------------------------------------
-- SIDE TAB BUTTONS
--------------------------------------------------

-- 🔄 OLD POSITION
local back=Instance.new("TextButton",F)
back.Size=UDim2.new(0,27,0,27)
back.Position=UDim2.new(.5,-160,.5,-95)
back.Text="🔄"
back.Font=Enum.Font.GothamMedium
back.TextSize=12
back.TextColor3=gold
back.BackgroundColor3=Color3.fromRGB(18,18,21)
back.BackgroundTransparency=.05
back.AutoButtonColor=false
back.ZIndex=55

Instance.new("UICorner",back).CornerRadius=UDim.new(0,9)

local backStroke=Instance.new("UIStroke",back)
backStroke.Color=gold
backStroke.Transparency=.7

-- 👀 OLD POSITION
local eye=Instance.new("TextButton",F)
eye.Size=UDim2.new(0,27,0,27)
eye.Position=UDim2.new(.5,-160,.5,-62)
eye.Text="👀"
eye.Font=Enum.Font.GothamMedium
eye.TextSize=12
eye.TextColor3=gold
eye.BackgroundColor3=Color3.fromRGB(18,18,21)
eye.BackgroundTransparency=.05
eye.AutoButtonColor=false
eye.ZIndex=55

Instance.new("UICorner",eye).CornerRadius=UDim.new(0,9)

local eyeStroke=Instance.new("UIStroke",eye)
eyeStroke.Color=gold
eyeStroke.Transparency=.7

--------------------------------------------------
-- ⚡ FAST MODE SIDE BUTTON
-- DIRECTLY BELOW 👀
--------------------------------------------------

local fastTab=Instance.new("TextButton",F)
fastTab.Size=UDim2.new(0,27,0,27)
fastTab.Position=UDim2.new(.5,-160,.5,-29)
fastTab.Text="⚡"
fastTab.Font=Enum.Font.GothamMedium
fastTab.TextSize=12
fastTab.TextColor3=gold
fastTab.BackgroundColor3=Color3.fromRGB(18,18,21)
fastTab.BackgroundTransparency=.05
fastTab.AutoButtonColor=false
fastTab.ZIndex=55

Instance.new("UICorner",fastTab).CornerRadius=UDim.new(0,9)

local fastTabStroke=Instance.new("UIStroke",fastTab)
fastTabStroke.Color=gold
fastTabStroke.Transparency=.7

--------------------------------------------------
-- TITLE
--------------------------------------------------

local title=Instance.new("TextLabel",F)
title.Size=UDim2.new(1,-20,0,28)
title.Position=UDim2.new(0,10,0,7)
title.Text="Stelle Hub"
title.TextColor3=gold
title.Font=Enum.Font.Garamond
title.TextSize=19
title.BackgroundTransparency=1
title.TextXAlignment=Enum.TextXAlignment.Right
title.ZIndex=55

local credit=Instance.new("TextLabel",F)
credit.Size=UDim2.new(1,-20,0,20)
credit.Position=UDim2.new(0,10,1,-27)
credit.Text="by Ian James"
credit.TextColor3=Color3.fromRGB(150,150,155)
credit.Font=Enum.Font.Garamond
credit.TextSize=12
credit.BackgroundTransparency=1
credit.ZIndex=55

--------------------------------------------------
-- MAIN TAB
--------------------------------------------------

local sw=bt("Switch",75,110,35)
local rj=bt("Rejoin",120,110,35)

--------------------------------------------------
-- 👀 TAB
--------------------------------------------------

local esp=bt("ESP: OFF",55,130,36)
esp.Visible=false

local st=Instance.new("TextLabel",F)
st.Size=UDim2.new(0,150,0,22)
st.Position=UDim2.new(.5,-75,0,100)
st.Text="EDIT SPEED"
st.TextColor3=gold
st.Font=Enum.Font.GothamMedium
st.TextSize=13
st.BackgroundTransparency=1
st.Visible=false
st.ZIndex=55

local sb=Instance.new("TextBox",F)
sb.Size=UDim2.new(0,130,0,34)
sb.Position=UDim2.new(.5,-65,0,123)
sb.PlaceholderText="Enter speed"
sb.PlaceholderColor3=Color3.fromRGB(100,100,105)
sb.Text=""
sb.TextColor3=gold
sb.TextSize=13
sb.Font=Enum.Font.Gotham
sb.BackgroundColor3=Color3.fromRGB(15,15,18)
sb.BackgroundTransparency=.05
sb.ClearTextOnFocus=false
sb.TextXAlignment=Enum.TextXAlignment.Center
sb.Visible=false
sb.ZIndex=55

Instance.new("UICorner",sb).CornerRadius=UDim.new(0,9)

local ss=Instance.new("UIStroke",sb)
ss.Color=gold
ss.Transparency=.65

local sp=bt("Speed: OFF",164,130,34)
sp.Visible=false

--------------------------------------------------
-- FAST MODE CENTER BUTTON
--------------------------------------------------

local fastButton=Instance.new("TextButton",F)
fastButton.Size=UDim2.new(0,140,0,40)
fastButton.Position=UDim2.new(.5,-70,.5,-20)
fastButton.Text="FAST MODE: OFF"
fastButton.Font=Enum.Font.GothamMedium
fastButton.TextSize=12
fastButton.TextColor3=gold
fastButton.BackgroundColor3=Color3.fromRGB(18,18,21)
fastButton.BackgroundTransparency=.05
fastButton.AutoButtonColor=false
fastButton.Visible=false
fastButton.ZIndex=60

Instance.new("UICorner",fastButton).CornerRadius=UDim.new(0,10)

local fastStroke=Instance.new("UIStroke",fastButton)
fastStroke.Color=gold
fastStroke.Transparency=.65

--------------------------------------------------
-- TWEEN
--------------------------------------------------

local function tw(o,p,t)
	T:Create(
		o,
		TweenInfo.new(
			t or .2,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		),
		p
	):Play()
end

local function fade(v,a,t)
	local p={
		TextTransparency=a
	}

	if v:IsA("TextButton") or v:IsA("TextBox") then
		p.BackgroundTransparency=a==1 and 1 or .05
	end

	tw(v,p,t or .18)
end

--------------------------------------------------
-- TAB STATE
--------------------------------------------------

local tab="main"

local function hideNormal()
	sw.Visible=false
	rj.Visible=false

	esp.Visible=false
	st.Visible=false
	sb.Visible=false
	sp.Visible=false
end

local function main()
	tab="main"

	if fastTab:GetAttribute("FastPage") then
		fastButton.Visible=true
		hideNormal()
		return
	end

	fastButton.Visible=false

	sw.Visible=true
	rj.Visible=true

	esp.Visible=false
	st.Visible=false
	sb.Visible=false
	sp.Visible=false

	for _,v in ipairs({
		title,
		credit,
		back,
		eye,
		fastTab,
		sw,
		rj
	}) do
		fade(v,0,.18)
	end
end

local function eyes()
	tab="eyes"

	if fastTab:GetAttribute("FastPage") then
		fastButton.Visible=true
		hideNormal()
		return
	end

	fastButton.Visible=false

	sw.Visible=false
	rj.Visible=false

	esp.Visible=true
	st.Visible=true
	sb.Visible=true
	sp.Visible=true

	for _,v in ipairs({
		title,
		credit,
		back,
		eye,
		fastTab,
		esp,
		st,
		sb,
		sp
	}) do
		fade(v,0,.18)
	end
end

--------------------------------------------------
-- FAST PAGE
--------------------------------------------------

local function fastPage()

	fastTab:SetAttribute("FastPage",true)

	sw.Visible=false
	rj.Visible=false

	esp.Visible=false
	st.Visible=false
	sb.Visible=false
	sp.Visible=false

	fastButton.Visible=true

	for _,v in ipairs({
		title,
		credit,
		back,
		eye,
		fastTab,
		fastButton
	}) do
		fade(v,0,.18)
	end

end

back.MouseButton1Click:Connect(function()

	fastTab:SetAttribute("FastPage",false)
	main()

end)

eye.MouseButton1Click:Connect(function()

	fastTab:SetAttribute("FastPage",false)
	eyes()

end)

fastTab.MouseButton1Click:Connect(fastPage)

--------------------------------------------------
-- SWITCH SERVER
--------------------------------------------------

sw.MouseButton1Click:Connect(function()

	local s={}

	local ok,d=pcall(function()

		return H:JSONDecode(
			game:HttpGet(
				"https://games.roblox.com/v1/games/"
				..id..
				"/servers/Public?limit=100"
			)
		)

	end)

	if ok and d and d.data then

		for _,v in ipairs(d.data) do

			if v.id~=jid then
				table.insert(s,v.id)
			end

		end

	end

	if #s>0 then

		TP:TeleportToPlaceInstance(
			id,
			s[math.random(1,#s)]
		)

	else

		TP:Teleport(id)

	end

end)

--------------------------------------------------
-- REJOIN
--------------------------------------------------

rj.MouseButton1Click:Connect(function()

	TP:TeleportToPlaceInstance(
		id,
		jid
	)

end)

--------------------------------------------------
-- ESP
--------------------------------------------------

local eo=false
local labels={}
local connections={}

local function removeESP(p)

	if labels[p] then
		labels[p]:Destroy()
		labels[p]=nil
	end

	if connections[p] then
		connections[p]:Disconnect()
		connections[p]=nil
	end

end

local function clear()

	for p in pairs(labels) do
		removeESP(p)
	end

end

local function add(p)

	if labels[p] then
		return
	end

	local l=Instance.new("TextLabel",G)

	l.Name="ESP_"..p.Name
	l.Size=UDim2.new(0,200,0,40)

	l.BackgroundTransparency=1

	l.TextColor3=gold
	l.TextStrokeColor3=Color3.new(0,0,0)
	l.TextStrokeTransparency=0

	l.TextScaled=true
	l.Font=Enum.Font.GothamMedium

	l.ZIndex=20
	l.Visible=false

	labels[p]=l

	connections[p]=R.RenderStepped:Connect(function()

		if not eo or not p.Parent then

			l.Visible=false
			return

		end

		local c=p.Character
		local me=P.Character
		local cam=workspace.CurrentCamera

		if not c or not me or not cam then

			l.Visible=false
			return

		end

		local root=c:FindFirstChild("HumanoidRootPart")
		local my=me:FindFirstChild("HumanoidRootPart")

		if not root or not my then

			l.Visible=false
			return

		end

		local pos,on=
			cam:WorldToViewportPoint(root.Position)

		if on and pos.Z>0 then

			local d=math.floor(
				(my.Position-root.Position).Magnitude
			)

			l.Text=
				p.Name..
				(
					p==P
					and "\nYOU [0]"
					or "\n"..d.." studs"
				)

			l.Position=UDim2.new(
				0,
				pos.X-100,
				0,
				pos.Y-50
			)

			l.Visible=true

		else

			l.Visible=false

		end

	end)

end

esp.MouseButton1Click:Connect(function()

	eo=not eo

	if eo then

		esp.Text="ESP: ON"

		for _,p in ipairs(game.Players:GetPlayers()) do
			add(p)
		end

		tw(
			esp,
			{
				BackgroundColor3=
					Color3.fromRGB(45,35,15)
			},
			.2
		)

	else

		esp.Text="ESP: OFF"

		clear()

		tw(
			esp,
			{
				BackgroundColor3=
					Color3.fromRGB(18,18,21)
			},
			.2
		)

	end

end)

game.Players.PlayerAdded:Connect(function(p)

	if eo then
		add(p)
	end

end)

game.Players.PlayerRemoving:Connect(function(p)

	removeESP(p)

end)

--------------------------------------------------
-- SPEED
--------------------------------------------------

local se=false
local speed=16
local old=nil

sb.FocusLost:Connect(function()

	local n=tonumber(sb.Text)

	if n then

		speed=math.clamp(n,1,500)
		sb.Text=tostring(speed)

	else

		sb.Text=tostring(speed)

	end

end)

sp.MouseButton1Click:Connect(function()

	local n=tonumber(sb.Text)

	if n then

		speed=math.clamp(n,1,500)
		sb.Text=tostring(speed)

	end

	local h=
		P.Character
		and P.Character:FindFirstChildOfClass("Humanoid")

	if not se then

		old=h and h.WalkSpeed or 16

		se=true
		sp.Text="Speed: ON"

		tw(
			sp,
			{
				BackgroundColor3=
					Color3.fromRGB(45,35,15)
			},
			.2
		)

	else

		se=false

		if h and old then
			h.WalkSpeed=old
		end

		sp.Text="Speed: OFF"

		tw(
			sp,
			{
				BackgroundColor3=
					Color3.fromRGB(18,18,21)
			},
			.2
		)

		old=nil

	end

end)

R.Heartbeat:Connect(function()

	if not se then
		return
	end

	local c=P.Character
	local h=
		c and c:FindFirstChildOfClass("Humanoid")

	if h then
		h.WalkSpeed=speed
	end

end)

P.CharacterAdded:Connect(function(c)

	local h=c:WaitForChild("Humanoid",5)

	if h and se then

		old=h.WalkSpeed
		h.WalkSpeed=speed

	end

end)

--------------------------------------------------
-- FAST MODE
--------------------------------------------------

local fastMode=false

local savedTextures={}
local savedEffects={}
local savedLights={}
local savedLightingEffects={}
local savedSkyParent=nil

local function saveTexture(obj)

	if savedTextures[obj]~=nil then
		return
	end

	if obj:IsA("Decal") or obj:IsA("Texture") then

		savedTextures[obj]=obj.Transparency
		obj.Transparency=1

	end

end

local function saveEffect(obj)

	if savedEffects[obj]~=nil then
		return
	end

	if obj:IsA("ParticleEmitter")
		or obj:IsA("Trail")
		or obj:IsA("Beam")
		or obj:IsA("Smoke")
		or obj:IsA("Fire")
		or obj:IsA("Sparkles")
		or obj:IsA("Highlight") then

		savedEffects[obj]=obj.Enabled
		obj.Enabled=false

	end

end

local function saveLight(obj)

	if savedLights[obj]~=nil then
		return
	end

	if obj:IsA("PointLight")
		or obj:IsA("SpotLight")
		or obj:IsA("SurfaceLight") then

		savedLights[obj]=obj.Enabled
		obj.Enabled=false

	end

end

local function saveLightingEffect(obj)

	if savedLightingEffects[obj]~=nil then
		return
	end

	if obj:IsA("BloomEffect")
		or obj:IsA("BlurEffect")
		or obj:IsA("ColorCorrectionEffect")
		or obj:IsA("DepthOfFieldEffect")
		or obj:IsA("SunRaysEffect") then

		savedLightingEffects[obj]=obj.Enabled
		obj.Enabled=false

	end

end

local function applyFastTo(obj)

	saveTexture(obj)
	saveEffect(obj)
	saveLight(obj)
	saveLightingEffect(obj)

end

local function enableFast()

	if fastMode then
		return
	end

	fastMode=true

	-- Workspace visuals
	for _,obj in ipairs(workspace:GetDescendants()) do
		applyFastTo(obj)
	end

	-- Lighting effects
	for _,obj in ipairs(L:GetDescendants()) do
		saveLightingEffect(obj)
	end

	-- Sky
	local sky=L:FindFirstChildOfClass("Sky")

	if sky then
		savedSkyParent=sky.Parent
		sky.Parent=nil
	end

	fastButton.Text="FAST MODE: ON"

	tw(
		fastButton,
		{
			BackgroundColor3=
				Color3.fromRGB(45,35,15)
		},
		.2
	)

end

local function disableFast()

	if not fastMode then
		return
	end

	fastMode=false

	-- Restore textures
	for obj,value in pairs(savedTextures) do

		if obj and obj.Parent then
			pcall(function()
				obj.Transparency=value
			end)
		end

	end

	-- Restore effects
	for obj,value in pairs(savedEffects) do

		if obj and obj.Parent then
			pcall(function()
				obj.Enabled=value
			end)
		end

	end

	-- Restore lights
	for obj,value in pairs(savedLights) do

		if obj and obj.Parent then
			pcall(function()
				obj.Enabled=value
			end)
		end

	end

	-- Restore Lighting effects
	for obj,value in pairs(savedLightingEffects) do

		if obj and obj.Parent then
			pcall(function()
				obj.Enabled=value
			end)
		end

	end

	-- Restore Sky
	if savedSkyParent then

		local sky=nil

		for _,obj in ipairs(L:GetChildren()) do
			if obj:IsA("Sky") then
				sky=obj
				break
			end
		end

		if sky==nil then
			for obj in pairs(savedTextures) do
				if obj:IsA("Sky") then
					sky=obj
					break
				end
			end
		end

	end

	fastButton.Text="FAST MODE: OFF"

	tw(
		fastButton,
		{
			BackgroundColor3=
				Color3.fromRGB(18,18,21)
		},
		.2
	)

	-- Clear saved states for next ON cycle
	savedTextures={}
	savedEffects={}
	savedLights={}
	savedLightingEffects={}
	savedSkyParent=nil

end

fastButton.MouseButton1Click:Connect(function()

	if fastMode then
		disableFast()
	else
		enableFast()
	end

end)

--------------------------------------------------
-- DETECT NEW VISUAL EFFECTS WHILE FAST MODE IS ON
--------------------------------------------------

workspace.DescendantAdded:Connect(function(obj)

	if fastMode then
		task.defer(function()
			if fastMode then
				applyFastTo(obj)
			end
		end)
	end

end)

L.DescendantAdded:Connect(function(obj)

	if fastMode then
		task.defer(function()
			if fastMode then
				saveLightingEffect(obj)
			end
		end)
	end

end)

--------------------------------------------------
-- OPEN / CLOSE
--------------------------------------------------

local open=false
local busy=false

B.MouseButton1Click:Connect(function()

	if busy then
		return
	end

	busy=true

	if not open then

		F.Visible=true
		F.Size=UDim2.new(0,0,0,0)

		for _,v in ipairs({
			title,
			credit,
			back,
			eye,
			fastTab,
			sw,
			rj,
			esp,
			st,
			sb,
			sp,
			fastButton
		}) do

			v.TextTransparency=1

			if v:IsA("TextButton")
				or v:IsA("TextBox") then

				v.BackgroundTransparency=1

			end

		end

		tw(
			F,
			{
				Size=UDim2.new(0,260,0,220)
			},
			.3
		)

		task.wait(.12)

		if fastTab:GetAttribute("FastPage") then
			fastPage()
		elseif tab=="main" then
			main()
		else
			eyes()
		end

		open=true

	else

		for _,v in ipairs({
			title,
			credit,
			back,
			eye,
			fastTab,
			sw,
			rj,
			esp,
			st,
			sb,
			sp,
			fastButton
		}) do

			fade(v,1,.12)

		end

		task.wait(.14)

		tw(
			F,
			{
				Size=UDim2.new(0,0,0,0)
			},
			.28
		)

		task.wait(.28)

		F.Visible=false
		open=false

	end

	busy=false

end)

--------------------------------------------------
-- DRAG
--------------------------------------------------

local function drag(o)

	local d=false
	local start
	local pos
	local move

	o.InputBegan:Connect(function(i)

		if i.UserInputType==
			Enum.UserInputType.Touch
			or i.UserInputType==
			Enum.UserInputType.MouseButton1 then

			d=true
			start=i.Position
			pos=o.Position

			if move then
				move:Disconnect()
			end

			move=U.InputChanged:Connect(function(x)

				if not d then
					return
				end

				if x.UserInputType==
					Enum.UserInputType.Touch
					or x.UserInputType==
					Enum.UserInputType.MouseMovement then

					local z=x.Position-start

					o.Position=UDim2.new(
						pos.X.Scale,
						pos.X.Offset+z.X,
						pos.Y.Scale,
						pos.Y.Offset+z.Y
					)

				end

			end)

			i.Changed:Connect(function()

				if i.UserInputState==
					Enum.UserInputState.End then

					d=false

					if move then
						move:Disconnect()
						move=nil
					end

				end

			end)

		end

	end)

end

drag(B)
drag(F)

B.Visible=true
B.Active=true
