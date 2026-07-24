--[[
	DevAdminPanel.client.lua
	------------------------------------------------------------
	Local development testing tool for Roblox Studio.
	Provides a ScreenGui with a toggleable panel and buttons that
	each call into a small "module" of debug functions.

	NOTE: This is a LOCAL testing tool only. It manipulates the
	client's own character (BodyVelocity/AssemblyLinearVelocity,
	CFrame, WalkSpeed, etc). It does NOT give server-authoritative
	admin powers, and should be stripped out / gated behind
	RunService:IsStudio() or a whitelist before shipping.
------------------------------------------------------------
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

local LocalPlayer = Players.LocalPlayer

-- Safety: only allow this tool to run in Studio, or extend this
-- check with your own whitelist logic for a dev-only server.
if not RunService:IsStudio() then
	warn("[DevAdminPanel] Disabled outside of Studio.")
	return
end

--------------------------------------------------------------
-- Helper: get the current character + humanoid safely
--------------------------------------------------------------
local function getCharacter()
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local rootPart = character:WaitForChild("HumanoidRootPart")
	return character, humanoid, rootPart
end

--------------------------------------------------------------
-- 7. Dev chat announcement function (TextChatService)
-- Broadcasts local test logs to the chat window (client-side only)
--------------------------------------------------------------
local DevChat = {}

function DevChat.Log(message: string)
	local generalChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
	local tag = "[DEV LOG] "

	if generalChannel then
		-- DisplaySystemMessage shows a local-only message (not sent to other clients)
		generalChannel:DisplaySystemMessage(tag .. message)
	else
		-- Fallback if TextChatService channels aren't set up
		print(tag .. message)
	end
end

--------------------------------------------------------------
-- 1. Fly Mode (BodyVelocity / AssemblyLinearVelocity)
--------------------------------------------------------------
local FlyMode = {}
FlyMode.Enabled = false

local flyVelocity: LinearVelocity? = nil
local flyAttachment: Attachment? = nil
local flyConnection: RBXScriptConnection? = nil
local flySpeed = 50

function FlyMode.Toggle()
	FlyMode.Enabled = not FlyMode.Enabled
	local character, humanoid, rootPart = getCharacter()

	if FlyMode.Enabled then
		humanoid.PlatformStand = false
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)

		-- Use a LinearVelocity constraint (modern replacement for BodyVelocity)
		flyAttachment = Instance.new("Attachment")
		flyAttachment.Parent = rootPart

		flyVelocity = Instance.new("LinearVelocity")
		flyVelocity.Attachment0 = flyAttachment
		flyVelocity.MaxForce = math.huge
		flyVelocity.VectorVelocity = Vector3.new(0, 0, 0)
		flyVelocity.Parent = rootPart

		flyConnection = RunService.RenderStepped:Connect(function()
			local camera = workspace.CurrentCamera
			local moveDir = Vector3.new()

			-- Basic WASD + Space/Shift fly controls
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				moveDir += camera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				moveDir -= camera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				moveDir -= camera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				moveDir += camera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				moveDir += Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				moveDir -= Vector3.new(0, 1, 0)
			end

			if moveDir.Magnitude > 0 then
				moveDir = moveDir.Unit
			end

			flyVelocity.VectorVelocity = moveDir * flySpeed
		end)

		DevChat.Log("Fly mode ENABLED (WASD + Space/Shift, speed=" .. flySpeed .. ")")
	else
		if flyConnection then
			flyConnection:Disconnect()
			flyConnection = nil
		end
		if flyVelocity then
			flyVelocity:Destroy()
			flyVelocity = nil
		end
		if flyAttachment then
			flyAttachment:Destroy()
			flyAttachment = nil
		end
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

		DevChat.Log("Fly mode DISABLED")
	end
end

--------------------------------------------------------------
-- 2. Jump-height / state testing
-- Lets you retrigger the jump/air state on demand for platformer testing
--------------------------------------------------------------
local JumpTester = {}

function JumpTester.SetJumpPower(power: number)
	local _, humanoid = getCharacter()
	-- UseJumpPower must be true for JumpPower to take effect (vs JumpHeight)
	humanoid.UseJumpPower = true
	humanoid.JumpPower = power
	DevChat.Log("JumpPower set to " .. power)
end

function JumpTester.SetJumpHeight(height: number)
	local _, humanoid = getCharacter()
	humanoid.UseJumpPower = false
	humanoid.JumpHeight = height
	DevChat.Log("JumpHeight set to " .. height)
end

-- Forces a fresh jump state even while airborne, useful for testing
-- double-jump / air-control mechanics repeatedly without landing first
function JumpTester.ForceJump()
	local _, humanoid = getCharacter()
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	task.wait() -- allow state to register before re-triggering freefall physics
	humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
	DevChat.Log("Forced mid-air jump state trigger")
end

--------------------------------------------------------------
-- 3. Character rotation test (CFrame updates)
--------------------------------------------------------------
local RotationTester = {}
local rotationConnection: RBXScriptConnection? = nil
RotationTester.Spinning = false

function RotationTester.ToggleSpin(degreesPerSecond: number)
	RotationTester.Spinning = not RotationTester.Spinning
	local _, _, rootPart = getCharacter()

	if RotationTester.Spinning then
		rotationConnection = RunService.Heartbeat:Connect(function(dt)
			local currentCFrame = rootPart.CFrame
			-- Rotate around the world Y axis to test model orientation handling
			rootPart.CFrame = currentCFrame * CFrame.Angles(0, math.rad(degreesPerSecond) * dt, 0)
		end)
		DevChat.Log("Rotation test ENABLED (" .. degreesPerSecond .. " deg/sec)")
	else
		if rotationConnection then
			rotationConnection:Disconnect()
			rotationConnection = nil
		end
		DevChat.Log("Rotation test DISABLED")
	end
end

-- Snaps the character to a specific facing direction instantly
function RotationTester.SnapTo(lookVector: Vector3)
	local _, _, rootPart = getCharacter()
	rootPart.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + lookVector)
	DevChat.Log("Character snapped to facing " .. tostring(lookVector))
end

--------------------------------------------------------------
-- 4. Tool-animation test (plays a test AnimationTrack + checks distance)
--------------------------------------------------------------
local AnimTester = {}

-- Replace with a real Animation asset id for your test rig
local TEST_ANIMATION_ID = "rbxassetid://0000000000"

function AnimTester.PlayTestAnimation(targetPart: BasePart?)
	local character, humanoid = getCharacter()
	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	local animation = Instance.new("Animation")
	animation.AnimationId = TEST_ANIMATION_ID

	local ok, track = pcall(function()
		return animator:LoadAnimation(animation)
	end)

	if not ok or not track then
		DevChat.Log("Failed to load test animation (check AnimationId)")
		return
	end

	track:Play()
	DevChat.Log("Playing test tool animation")

	-- Example distance check: measure distance from root part to a target
	-- part (e.g. a tool tip or interaction point) while animation plays
	if targetPart then
		local rootPart = character:WaitForChild("HumanoidRootPart")
		local distance = (rootPart.Position - targetPart.Position).Magnitude
		DevChat.Log(string.format("Distance to target part: %.2f studs", distance))
	end

	track.Stopped:Connect(function()
		DevChat.Log("Test animation finished")
	end)
end

--------------------------------------------------------------
-- 5. Physics impulse test (directional velocity vectors)
--------------------------------------------------------------
local ImpulseTester = {}

function ImpulseTester.ApplyImpulse(direction: Vector3, force: number)
	local character, _, rootPart = getCharacter()

	-- ApplyImpulse works directly on the assembly's linear velocity,
	-- good for one-off physics debugging (knockback, launch pads, etc)
	rootPart:ApplyImpulse(direction.Unit * force * rootPart.AssemblyMass)
	DevChat.Log(string.format("Applied impulse dir=%s force=%d", tostring(direction), force))
end

-- Convenience presets for common debug launches
function ImpulseTester.LaunchUp(force: number)
	ImpulseTester.ApplyImpulse(Vector3.new(0, 1, 0), force or 50)
end

function ImpulseTester.LaunchForward(force: number)
	local _, _, rootPart = getCharacter()
	ImpulseTester.ApplyImpulse(rootPart.CFrame.LookVector, force or 50)
end

--------------------------------------------------------------
-- 6. Gravity / environment override (custom movement states)
--------------------------------------------------------------
local GravityTester = {}
local defaultGravity = workspace.Gravity

function GravityTester.SetGravity(value: number)
	workspace.Gravity = value
	DevChat.Log("Workspace gravity set to " .. value)
end

function GravityTester.ResetGravity()
	workspace.Gravity = defaultGravity
	DevChat.Log("Workspace gravity reset to default (" .. defaultGravity .. ")")
end

-- Toggles a low-gravity "moon mode" for testing floaty movement states
local lowGravityActive = false
function GravityTester.ToggleLowGravity()
	lowGravityActive = not lowGravityActive
	if lowGravityActive then
		GravityTester.SetGravity(defaultGravity * 0.2)
	else
		GravityTester.ResetGravity()
	end
end

--------------------------------------------------------------
-- 8. Local part transparency toggle (client-side rendering test)
--------------------------------------------------------------
local TransparencyTester = {}
local transparencyOn = false

function TransparencyTester.ToggleCharacterTransparency()
	local character = getCharacter()
	transparencyOn = not transparencyOn

	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			-- LocalTransparencyModifier only affects this client's rendering,
			-- it does not replicate or touch the real Transparency property
			part.LocalTransparencyModifier = transparencyOn and 0.7 or 0
		end
	end

	DevChat.Log("Character transparency test: " .. (transparencyOn and "ON" or "OFF"))
end

--------------------------------------------------------------
-- 9. WalkSpeed / JumpPower profiling
--------------------------------------------------------------
local MovementProfiler = {}

function MovementProfiler.SetWalkSpeed(speed: number)
	local _, humanoid = getCharacter()
	humanoid.WalkSpeed = speed
	DevChat.Log("WalkSpeed set to " .. speed)
end

function MovementProfiler.SetJumpPower(power: number)
	local _, humanoid = getCharacter()
	humanoid.UseJumpPower = true
	humanoid.JumpPower = power
	DevChat.Log("JumpPower set to " .. power)
end

function MovementProfiler.ResetDefaults()
	local _, humanoid = getCharacter()
	humanoid.WalkSpeed = 16
	humanoid.UseJumpPower = true
	humanoid.JumpPower = 50
	DevChat.Log("Movement profile reset to Roblox defaults")
end

--------------------------------------------------------------
-- UI CONSTRUCTION
--------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DevAdminPanel"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Toggle button that shows/hides the main panel
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 120, 0, 36)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Dev Panel"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 18
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 460)
mainFrame.Position = UDim2.new(0, 10, 0, 54)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Visible = false -- starts hidden, toggled by the button above
mainFrame.Parent = screenGui

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = mainFrame

local uiPadding = Instance.new("UIPadding")
uiPadding.PadTop = UDim.new(0, 8)
uiPadding.PadLeft = UDim.new(0, 8)
uiPadding.PadRight = UDim.new(0, 8)
uiPadding.Parent = mainFrame

-- Toggle panel visibility
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

--------------------------------------------------------------
-- Helper to spawn a labeled test button and wire it to a function
--------------------------------------------------------------
local function createButton(labelText: string, order: number, callback: () -> ())
	local button = Instance.new("TextButton")
	button.Name = labelText:gsub("%s+", "")
	button.Size = UDim2.new(1, 0, 0, 34)
	button.LayoutOrder = order
	button.Text = labelText
	button.Font = Enum.Font.SourceSans
	button.TextSize = 16
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Parent = mainFrame

	-- Each button's click event calls straight into its matching
	-- debug module function above -- this is the "UI <-> logic" bridge
	button.MouseButton1Click:Connect(callback)

	return button
end

--------------------------------------------------------------
-- Wire up buttons to each debug tool
--------------------------------------------------------------

-- 1. Fly Mode
createButton("Toggle Fly Mode", 1, function()
	FlyMode.Toggle()
end)

-- 2. Jump Testing
createButton("Force Mid-Air Jump", 2, function()
	JumpTester.ForceJump()
end)
createButton("Set JumpPower 100", 3, function()
	JumpTester.SetJumpPower(100)
end)

-- 3. Rotation Testing
createButton("Toggle Spin Test", 4, function()
	RotationTester.ToggleSpin(90) -- 90 degrees/sec
end)

-- 4. Tool Animation Test
createButton("Play Test Animation", 5, function()
	AnimTester.PlayTestAnimation(workspace:FindFirstChild("TestTargetPart"))
end)

-- 5. Physics Impulse Test
createButton("Launch Up", 6, function()
	ImpulseTester.LaunchUp(60)
end)
createButton("Launch Forward", 7, function()
	ImpulseTester.LaunchForward(60)
end)

-- 6. Gravity Override
createButton("Toggle Low Gravity", 8, function()
	GravityTester.ToggleLowGravity()
end)
createButton("Reset Gravity", 9, function()
	GravityTester.ResetGravity()
end)

-- 7. Dev Chat Announcement (manual test log trigger)
createButton("Send Test Log", 10, function()
	DevChat.Log("Manual test log triggered at " .. os.clock())
end)

-- 8. Transparency Toggle
createButton("Toggle Transparency", 11, function()
	TransparencyTester.ToggleCharacterTransparency()
end)

-- 9. Movement Profiling
createButton("WalkSpeed 50", 12, function()
	MovementProfiler.SetWalkSpeed(50)
end)
createButton("Reset Movement", 13, function()
	MovementProfiler.ResetDefaults()
end)

--------------------------------------------------------------
-- Initial log so devs know the panel loaded correctly
--------------------------------------------------------------
DevChat.Log("DevAdminPanel loaded. Press 'Dev Panel' button to open.")
