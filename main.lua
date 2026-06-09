-- [[ OMEN X | RAYFIELD PRODUCTION MATRIX ]]
-- Framework: Rayfield UI Library
-- Optimization: Strict Background Threading, Asynchronous Task Spawning, Memory Sanity
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

-- Prevent duplicate UI instances
for _, oldUi in pairs(game:GetService("CoreGui"):GetChildren()) do
    if oldUi.Name == "Rayfield" or oldUi.Name == "OmenX_Loader" then
        oldUi:Destroy()
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
StatusLabel.Text = "Compiling Rayfield Matrix Core... 0%"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 16
StatusLabel.TextColor3 = Color3.fromRGB(160, 32, 240)

task.spawn(function()
    TweenService:Create(GlowLine, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 4)}):Play()
    for i = 1, 100 do
        task.wait(0.005)
        if i == 25 then StatusLabel.Text = "Mapping Rayfield UI elements... 25%"
        elseif i == 50 then StatusLabel.Text = "Isolating asynchronous threading arrays... 50%"
        elseif i == 75 then StatusLabel.Text = "Hooking weapon strike remote tunnels... 75%"
        elseif i == 100 then StatusLabel.Text = "SYSTEM READY! 100%"
        end
    end
    task.wait(0.1
