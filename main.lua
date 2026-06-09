-- [[ OMEN X | KAVO HIGH-PERFORMANCE MATRIX ]]
-- Framework: Kavo UI Library (Eazvy Archive Edition)
-- Optimization: Thread Isolation, Micro-Yields, Lightweight Core Mapping
-- Fully Integrated & Mobile Optimized Rewrite (2026 Stable Release)

-- ============================================================================
-- [[ METADATA & CONFIGURATION VAULT ]]
-- ============================================================================
getgenv().OmenXConfig = {
    StreamerMode = false,
    TweenSpeed = 150,
    NoClip = false,
    InfiniteGeppo = false,
    AntiRubberband = true,
    LagReducer = false,
    KillAura = false,
    AuraRange = 25,
    AttackSpeed = 0.1,
    RaidCarrier = false,
    TargetRaid = "Flame",
    AutoAwaken = false,
    FruitSniper = false,
    WebhookURL = "",
    AutoBuyStyles = false,
    TargetStyle = "Superhuman",
    AutoSanguine = false,
    ConsoleLog = false,
    CdkAutomation = false,
    MirageRadar = false,
    MoonAlign = false,
    SeaEventFarm = false,
    HourlyLogging = false,
    AutoGacha = false,
    AimbotEnabled = false,
    ObservationCycle = false
}

-- Cache Core Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local CommF = ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("CommF_")

-- Clear previous interface containers safely
for _, ui in pairs(game:GetService("CoreGui"):GetChildren()) do
    if ui.Name == "KavoUILibrary" or ui.Name == "OmenX_Loader" then
        ui:Destroy()
    end
end

-- ============================================================================
-- [[ CINEMATIC PRE-LOADER SCREEN ]]
-- ============================================================================
local LoaderGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
LoaderGui.Name = "OmenX_Loader"
LoaderGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame", LoaderGui)
MainFrame.Size = UDim2.fromScale(1, 1)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

local GlowLine = Instance.new("Frame", MainFrame)
GlowLine.Size = UDim2.new(0, 0, 0, 4)
GlowLine.BackgroundColor3 = Color3.fromRGB(160, 32, 240)
GlowLine.BorderSizePixel = 0

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.fromOffset(400, 50)
TitleLabel.Position = UDim2.fromScale(0.5, 0.45)
TitleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "OMEN X"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 48
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.fromOffset(400, 30)
StatusLabel.Position = UDim2.fromScale(0.5, 0.53)
StatusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Deploying Kavo Core Matrix... 0%"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 16
StatusLabel.TextColor3 = Color3.fromRGB(160, 32, 240)

task.spawn(function()
    TweenService:Create(GlowLine, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 4)}):Play()
    for i = 1, 100 do
        task.wait(0.004)
        if i == 30 then StatusLabel.Text = "Mapping Kavo structural dividers... 30%"
        elseif i == 60 then StatusLabel.Text = "Binding background network channels... 60%"
        elseif i == 90 then StatusLabel.Text = "Injecting combat array loops... 90%"
        elseif i == 100 then StatusLabel.Text = "MATRIX ONLINE! 100%"
        end
    end
    task.wait(0.1)
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
    TweenService:Create(GlowLine, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
    TweenService:Create(TitleLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
    TweenService:Create(StatusLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
    task.wait(0.2)
    LoaderGui:Destroy()
end)

task.wait(1.2)

-- ============================================================================
-- [[ UTILITY MATRIX & SYSTEM FALLBACKS ]]
-- ============================================================================
local function SendStrikePacket(enemy)
    if enemy and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            local args = {
                [1] = enemy.HumanoidRootPart.Position,
                [2] = enemy
            }
            CommF:InvokeServer("Attack", args)
        end)
    end
end

local function TeleportToNewInstance()
    pcall(function()
        local serverList = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, server in pairs(serverList.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end)
end

-- Anti-Rubberband Physical Calculation Engine
local lastPosition = Vector3.zero
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().OmenXConfig.AntiRubberband and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local currentPos = LocalPlayer.Character.HumanoidRootPart.Position
            if lastPosition ~= Vector3.zero and (currentPos - lastPosition).Magnitude > 450 then
                getgenv().OmenXConfig.NoClip = false
                task.wait(0.6)
                getgenv().OmenXConfig.NoClip = true
            end
            lastPosition = currentPos
        end
    end
end)

-- No-Clip Collision Override Pipeline
RunService.Stepped:Connect(function()
    if getgenv().OmenXConfig.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Infinite Geppo Hook Setup
UserInputService.JumpRequest:Connect(function()
    if getgenv().OmenXConfig.InfiniteGeppo and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ============================================================================
-- [[ FRAMEWORK INITIALIZATION (KAVO) ]]
-- ============================================================================
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
-- Dark Theme with explicit electric purple highlights
local Window = Kavo:CreateWindow("OMEN X", "ElectricPurple")

local function CustomLog(txt)
    if getgenv().OmenXConfig.ConsoleLog and rconsoleprint then
        rconsoleprint("@@LIGHT_PURPLE@@[OMEN X LOG] " .. tostring(txt) .. "\n")
    end
end

-- ============================================================================
-- [[ TAB 1: SYSTEM ALERTS & CONFIGS ]]
-- ============================================================================
local Sec1 = Window:NewTab("Alert Matrix")
local Group1 = Sec1:NewSection("System Management Layout")

Group1:NewButton("Test System Audio Chime", "Validates core notification chimes.", function()
    local sound = Instance.new("Sound", Workspace)
    sound.SoundId = "rbxassetid://6397505478"
    sound:Play()
end)

Group1:NewToggle("External Console Notification Routing", "Routes debug strings to terminal.", function(state)
    getgenv().OmenXConfig.ConsoleLog = state
end)

-- ============================================================================
-- [[ TAB 2: STEALTH & BYPASS ]]
-- ============================================================================
local Sec2 = Window:NewTab("Stealth & Bypass")
local Group2 = Sec2:NewSection("Anti-Detection Routing Protocols")

task.spawn(function()
    Players.PlayerAdded:Connect(function(player)
        pcall(function()
            if player:GetRankInGroup(2850531) >= 250 then
                CustomLog("ADMIN PRESENT! Running secure instance migration.")
                TeleportToNewInstance()
            end
            if player.UserId == 100140702 or string.find(string.lower(player.Name), "admin") then
                TeleportToNewInstance()
            end
        end)
    end)
end)

task.spawn(function()
    game:GetService("LogService").MessageOut:Connect(function(msg)
        local lower = string.lower(msg)
        if string.find(lower, "hacker") or string.find(lower, "exploit") or string.find(lower, "report") then
            CustomLog("Suspicious text logged. Changing server instance.")
            task.wait(0.5)
            TeleportToNewInstance()
        end
    end)
end)

Group2:NewToggle("Aggressive Hardware Lag Reducer", "Disables 3D rendering to maximize frame output.", function(state)
    getgenv().OmenXConfig.LagReducer = state
    RunService:Set3dRenderingEnabled(not state)
end)

-- ============================================================================
-- [[ TAB 3: PHANTOM MOTION ENGINE ]]
-- ============================================================================
local Sec3 = Window:NewTab("Phantom Movement")
local Group3 = Sec3:NewSection("Vector Manipulation Settings")

Group3:NewSlider("Tween Velocity Control", "Adjusts the master movement velocity vector.", 350, 10, function(val)
    getgenv().OmenXConfig.TweenSpeed = val
end)
Group3:NewToggle("Anti-Rubberband Guard", "Prevents anti-cheat position pullbacks.", function(state) getgenv().OmenXConfig.AntiRubberband = state end)
Group3:NewToggle("Active No-Clip Frame Bridge", "Passes through solid physical objects seamlessly.", function(state) getgenv().OmenXConfig.NoClip = state end)
Group3:NewToggle("Infinite Geppo Loop Engine", "Enables boundless geppo jump mechanics.", function(state) getgenv().OmenXConfig.InfiniteGeppo = state end)

-- ============================================================================
-- [[ TAB 4: SANGUINE ART ENGINE ]]
-- ============================================================================
local Sec4 = Window:NewTab("Sanguine Master")
local Group4 = Sec4:NewSection("Materials Checklist Matrix")
local SangLabel = Group4:NewLabel("Inventory Check: Waiting on thread update...")

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local frags = LocalPlayer.Data.Fragments.Value
            local beli = LocalPlayer.Data.Beli.Value
            local heart = false
            if LocalPlayer.Backpack:FindFirstChild("Cold Heart") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Cold Heart")) then
                heart = true
            end
            SangLabel:UpdateLabel(string.format("Frags: %s/5K | Beli: %s/5M | Heart: %s", frags, beli, heart and "FOUND" or "MISSING"))
        end)
    end
end)

Group4:NewToggle("Auto-Interact Shafi NPC Dialogue", "Auto-purchases Sanguine Art style when available.", function(state)
    getgenv().OmenXConfig.AutoSanguine = state
    task.spawn(function()
        while getgenv().OmenXConfig.AutoSanguine do
            task.wait(1)
            if LocalPlayer.Data.Fragments.Value >= 5000 and LocalPlayer.Data.Beli.Value >= 5000000 then
                CommF:InvokeServer("SanguineArt", "Learn")
            end
        end
    end)
end)

-- ============================================================================
-- [[ TAB 5: COMBAT ARTS CHRONOLOGY PROGRESSION ]]
-- ============================================================================
local Sec5 = Window:NewTab("Combat Arts")
local Group5 = Sec5:NewSection("Martial Arts Router")

Group5:NewDropdown("Sequential Martial Arts Style", "Select which style to target.", {"Black Leg", "Electro", "Fishman Kung Fu", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw"}, function(val)
    getgenv().OmenXConfig.TargetStyle = val
end)

Group5:NewToggle("Smart Requirement Auto-Unlock Spend", "Automatically spend currency on the selected style.", function(state)
    getgenv().OmenXConfig.AutoBuyStyles = state
    task.spawn(function()
        while getgenv().OmenXConfig.AutoBuyStyles do
            task.wait(1.5)
            pcall(function()
                local target = getgenv().OmenXConfig.TargetStyle
                if target == "Superhuman" then CommF:InvokeServer("BuySuperhuman")
                elseif target == "Death Step" then CommF:InvokeServer("BuyDeathStep")
                elseif target == "Sharkman Karate" then CommF:InvokeServer("BuySharkmanKarate")
                elseif target == "Electric Claw" then CommF:InvokeServer("BuyElectricClaw")
                elseif target == "Black Leg" then CommF:InvokeServer("BuyBlackLeg")
                elseif target == "Electro" then CommF:InvokeServer("BuyElectro")
                elseif target == "Fishman Kung Fu" then CommF:InvokeServer("BuyFishmanKungFu")
                end
            end)
        end
    end)
end)

-- ============================================================================
-- [[ TAB 6: BLADE MATRIX ]]
-- ============================================================================
local Sec6 = Window:NewTab("Blade Matrix")
local Group6 = Sec6:NewSection("Legendary Armaments Pipeline")

Group6:NewButton("Force Legendary Sword Dealer Status Check", "Queries current map spawn status directly.", function()
    if CommF then
        local res = CommF:InvokeServer("LegendarySwordDealer
