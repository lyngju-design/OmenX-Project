-- [[ OMEN X | FLUENT PREMIUM AUTOMATION INTERFACE ]]
-- Framework: Fluent UI Library (Next-Gen Windows 11 Aesthetic)
-- Optimization: High-Thread Efficiency, Micro-Yielding Arrays, Lightweight Callbacks
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
    if ui.Name == "Fluent" or ui.Name == "OmenX_Loader" then
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
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)

local GlowLine = Instance.new("Frame", MainFrame)
GlowLine.Size = UDim2.new(0, 0, 0, 3)
GlowLine.BackgroundColor3 = Color3.fromRGB(0, 120, 212) -- Fluent Blue Accent
GlowLine.BorderSizePixel = 0

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.fromOffset(400, 50)
TitleLabel.Position = UDim2.fromScale(0.5, 0.45)
TitleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "OMEN X"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 44
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.fromOffset(400, 30)
StatusLabel.Position = UDim2.fromScale(0.5, 0.53)
StatusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Initializing Fluent UI Architecture... 0%"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)

task.spawn(function()
    TweenService:Create(GlowLine, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 3)}):Play()
    for i = 1, 100 do
        task
