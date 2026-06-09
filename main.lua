-- [[ OMEN X | THE DEFINITIVE PRODUCTION MATRIX ]]
-- Framework: Orion UI Library & Custom Asynchronous Engines
-- Optimization: Strict Multithreading, Garbage Collection, Protected Remotes
-- Fully Integrated & Fixed Threading (2026 Stable Release)

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
    AttackSpeed = 0.02,
    RaidCarrier = false,
    TargetRaid = "Flame",
    AutoAwaken = false,
    FruitSniper = false,
    WebhookURL = "",
    AutoBuyStyles = false,
    TargetStyle = "Godhuman Sequence",
    AutoSanguine = false,
    ConsoleLog = false,
    CdkAutomation = false,
    MirageRadar = false,
    MoonAlign = false,
    SeaEventFarm = false,
    HourlyLogging = false,
    AutoGacha = false,
    AimbotEnabled = false,
    ObservationCycle = false,
    TrashFilters = {["Rocket Fruit"] = true, ["Spin Fruit"] = true}
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

-- Prevent duplicate instances
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("OmenX_Loader") then CoreGui:FindFirstChild("OmenX_Loader"):Destroy() end

-- ============================================================================
-- [[ CINEMATIC PRE-LOADER SCREEN ]]
-- ============================================================================
local LoaderGui = Instance.new("ScreenGui", CoreGui)
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
StatusLabel.Text = "Initializing secure environment... 0%"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 16
StatusLabel.TextColor3 = Color3.fromRGB(160, 32, 240)

task.spawn(function()
    TweenService:Create(GlowLine, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 4)}):Play()
    local milestones = {
        "Decrypting client remote wrappers...",
        "Hooking vector magnitude trackers...",
        "Bypassing runtime script signals...",
        "Assembling functional array modules...",
        "SYSTEM OPERATIONAL!"
    }
    for i = 1, 100 do
        task.wait(0.005)
        if i == 20 then StatusLabel.Text = milestones[1] .. " 20%"
        elseif i == 45 then StatusLabel.Text = milestones[2] .. " 45%"
        elseif i == 65 then StatusLabel.Text = milestones[3] .. " 65%"
        elseif i == 85 then StatusLabel.Text = milestones[4] .. " 85%"
        elseif i == 100 then StatusLabel.Text = milestones[5] .. " 100%"
        elseif i % 10 == 0 then
            StatusLabel.Text = "Caching asset indices... " .. tostring(i) .. "%"
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

task.wait(1.8) -- Optimized loader wait window

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
-- [[ FRAMEWORK INITIALIZATION ]]
-- ============================================================================
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local OmenTheme = {
    SchemeColor = Color3.fromRGB(160, 32, 240),
    Background = Color3.fromRGB(21, 21, 21),
    Header = Color3.fromRGB(15, 15, 15),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(30, 30, 30)
}

local Window = OrionLib:MakeWindow({
    Name = "OMEN X | Elite Automation Matrix",
    HidePremium = true,
    SaveConfig = true,
    ConfigFolder = "OmenX_Data_Vault",
    IntroEnabled = false,
    Theme = OmenTheme
})

-- Force Window Resizing constraints internally
local mainGuiElement = CoreGui:FindFirstChild("Orion")
if mainGuiElement and main
