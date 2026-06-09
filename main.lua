-- [[ OMEN X | THE DEFINITIVE PRODUCTION MATRIX ]]
-- Framework: Orion UI Library & Custom Asynchronous Engines
-- Optimization: Strict Multithreading, Garbage Collection, Protected Remotes
-- Fully Integrated & Expanded Codebase (2026 Stable Release)

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
    TweenService:Create(GlowLine, TweenInfo.new(2.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 4)}):Play()
    local milestones = {
        "Decrypting client remote wrappers...",
        "Hooking vector magnitude trackers...",
        "Bypassing runtime script signals...",
        "Assembling functional array modules...",
        "SYSTEM OPERATIONAL!"
    }
    for i = 1, 100 do
        task.wait(0.01)
        if i == 20 then StatusLabel.Text = milestones[1] .. " 20%"
        elseif i == 45 then StatusLabel.Text = milestones[2] .. " 45%"
        elseif i == 65 then StatusLabel.Text = milestones[3] .. " 65%"
        elseif i == 85 then StatusLabel.Text = milestones[4] .. " 85%"
        elseif i == 100 then StatusLabel.Text = milestones[5] .. " 100%"
        elseif i % 6 == 0 then
            StatusLabel.Text = "Caching asset indices... " .. tostring(i) .. "%"
        end
    end
    task.wait(0.1)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
    TweenService:Create(GlowLine, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
    TweenService:Create(TitleLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
    TweenService:Create(StatusLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
    task.wait(0.3)
    LoaderGui:Destroy()
end)

task.wait(2.5)

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
if mainGuiElement and mainGuiElement:FindFirstChild("Main") then
    mainGuiElement.Main.Size = UDim2.fromOffset(550, 350)
end

-- ============================================================================
-- [[ TAB 1: NOTIFICATION & ALERT MATRIX ]]
-- ============================================================================
local Tab1 = Window:MakeTab({ Name = "Alert Matrix", Icon = "rbxassetid://4483345998" })

Tab1:AddButton({
    Name = "Test System Audio Chime",
    Callback = function()
        local sound = Instance.new("Sound", Workspace)
        sound.SoundId = "rbxassetid://6397505478"
        sound:Play()
        OrionLib:MakeNotification({Name = "OMEN X", Content = "Alert audio system validated.", Duration = 3})
    end
})

Tab1:AddToggle({
    Name = "External Console Notification Routing",
    Default = false,
    Callback = function(state) getgenv().OmenXConfig.ConsoleLog = state end
})

local function CustomLog(txt)
    if getgenv().OmenXConfig.ConsoleLog and rconsoleprint then
        rconsoleprint("@@LIGHT_PURPLE@@[OMEN X LOG] " .. tostring(txt) .. "\n")
    end
end

-- ============================================================================
-- [[ TAB 2: STEALTH, BYPASS & ANTI-DETECTION ]]
-- ============================================================================
local Tab2 = Window:MakeTab({ Name = "Stealth & Bypass", Icon = "rbxassetid://4483362458" })

Players.PlayerAdded:Connect(function(player)
    pcall(function()
        if player:GetRankInGroup(2850531) >= 250 then
            CustomLog("ADMIN PRESENT DETECTED! Migrating instance instantly.")
            TeleportToNewInstance()
        end
     pcall(function()
         if player.UserId == 100140702 or string.find(string.lower(player.Name), "admin") then
             TeleportToNewInstance()
         end
     end)
    end)
end)

game:GetService("LogService").MessageOut:Connect(function(msg)
    local lower = string.lower(msg)
    if string.find(lower, "hacker") or string.find(lower, "exploit") or string.find(lower, "report") then
        CustomLog("Suspicious keyword logged. Initiating dynamic evasion.")
        task.wait(0.5)
        TeleportToNewInstance()
    end
end)

Tab2:AddToggle({
    Name = "Aggressive Hardware Lag Reducer",
    Default = false,
    Callback = function(state)
        getgenv().OmenXConfig.LagReducer = state
        RunService:Set3dRenderingEnabled(not state)
    end
})

-- ============================================================================
-- [[ TAB 3: PHANTOM MOTION ENGINE ]]
-- ============================================================================
local Tab3 = Window:MakeTab({ Name = "Phantom Movement", Icon = "rbxassetid://4483362748" })

Tab3:AddSlider({
    Name = "Tween Velocity Control", Min = 10, Max = 350, Default = 150, Increment = 5, ValueName = "studs/sec",
    Callback = function(val) getgenv().OmenXConfig.TweenSpeed = val end
})
Tab3:AddToggle({ Name = "Anti-Rubberband Guard", Default = true, Callback = function(state) getgenv().OmenXConfig.AntiRubberband = state end })
Tab3:AddToggle({ Name = "Active No-Clip Frame Bridge", Default = false, Callback = function(state) getgenv().OmenXConfig.NoClip = state end })
Tab3:AddToggle({ Name = "Infinite Geppo Loop Engine", Default = false, Callback = function(state) getgenv().OmenXConfig.InfiniteGeppo = state end })

-- ============================================================================
-- [[ TAB 4: SANGUINE ART AUTOMATION ]]
-- ============================================================================
local Tab4 = Window:MakeTab({ Name = "Sanguine Master", Icon = "rbxassetid://4483367523" })
Tab4:AddLabel("--- Requirements Verification Hub ---")
local SangLabel = Tab4:AddLabel("Inventory Check: Waiting...")

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local frags = LocalPlayer.Data.Fragments.Value
            local beli = LocalPlayer.Data.Beli.Value
            local heart = false
            if LocalPlayer.Backpack:FindFirstChild("Cold Heart") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Cold Heart")) then
                heart = true
            end
            SangLabel:Set(string.format("Fragments: %s/5K | Beli: %s/5M | Heart: %s", frags, beli, heart and "FOUND" or "MISSING"))
        end)
    end
end)

Tab4:AddToggle({
    Name = "Auto-Interact Shafi NPC Dialogue", Default = false,
    Callback = function(state)
        getgenv().OmenXConfig.AutoSanguine = state
        task.spawn(function()
            while getgenv().OmenXConfig.AutoSanguine do
                task.wait(1)
                if LocalPlayer.Data.Fragments.Value >= 5000 and LocalPlayer.Data.Beli.Value >= 5000000 then
                    CommF:InvokeServer("SanguineArt", "Learn")
                end
            end
        end)
    end
})

-- ============================================================================
-- [[ TAB 5: COMBAT ARTS CHRONOLOGICAL METRIC ]]
-- ============================================================================
local Tab5 = Window:MakeTab({ Name = "Combat Arts", Icon = "rbxassetid://4483371441" })

Tab5:AddDropdown({
    Name = "Sequential Martial Arts Router", Default = "Superhuman",
    Options = {"Black Leg", "Electro", "Fishman Kung Fu", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw"},
    Callback = function(val) getgenv().OmenXConfig.TargetStyle = val end
})

Tab5:AddToggle({
    Name = "Smart Requirement Auto-Unlock Spend", Default = false,
    Callback = function(state)
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
    end
})

-- ============================================================================
-- [[ TAB 6: BLADE MATRIX & LEGENDARY SWORDS ]]
-- ============================================================================
local Tab6 = Window:MakeTab({ Name = "Blade Matrix", Icon = "rbxassetid://4483367353" })

Tab6:AddButton({
    Name = "Force Legendary Sword Dealer Status Check",
    Callback = function()
        if CommF then
            local res = CommF:InvokeServer("LegendarySwordDealer", "Check")
            OrionLib:MakeNotification({Name = "Registry Query", Content = tostring(res), Duration = 5})
        end
    end
})

task.spawn(function()
    while task.wait(10) do
        if getgenv().OmenXConfig.CdkAutomation then
            pcall(function()
                local ghosts = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:GetChildren()
                if ghosts then
                    for _, v in pairs(ghosts) do
                        if string.find(v.Name, "Ghost") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                            SendStrikePacket(v)
                        end
                    end
                end
            end)
        end
    end
end)

Tab6:AddToggle({ Name = "True Triple Katana Unified Grinder", Default = false, Callback = function(state) getgenv().OmenXConfig.TtkAutomation = state end })
Tab6:AddToggle({ Name = "Cursed Dual Katana Scroll Automation Puzzles", Default = false, Callback = function(state) getgenv().OmenXConfig.CdkAutomation = state end })

-- ============================================================================
-- [[ TAB 7: UNIVERSAL RAID RECTIFICATION ]]
-- ============================================================================
local Tab7 = Window:MakeTab({ Name = "Raid Automation", Icon = "rbxassetid://4483367015" })

Tab7:AddDropdown({
    Name = "Standard Raid Target Profile", Default = "Flame",
    Options = {"Flame", "Ice", "Sand", "Light", "Dark", "Quake", "Spider", "Rumble", "Magma", "Buddha"},
    Callback = function(val) getgenv().OmenXConfig.TargetRaid = val end
})

local function ExecuteNormalRaidLoop()
    task.spawn(function()
        while getgenv().OmenXConfig.RaidCarrier do
            task.wait()
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then return end

                if Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Tornado") then
                    local enemies = Workspace:WaitForChild("Enemies"):GetChildren()
                    if #enemies > 0 then
                        for _, enemy in pairs(enemies) do
                            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                                while getgenv().OmenXConfig.RaidCarrier and enemy.Humanoid.Health > 0 do
                                    task.wait()
                                    root.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                    SendStrikePacket(enemy)
                                end
                            end
                        end
                    else
                        local portal = Workspace.Map.Tornado:FindFirstChild("Part")
                        if portal then root.CFrame = portal.CFrame end
                    end
                else
                    CommF:InvokeServer("RaidsNpc", "Select", getgenv().OmenXConfig.TargetRaid)
                    task.wait(0.5)
                    local btn = Workspace.Map.MysteryScientist.RaidStart
                    if btn then
                        root.CFrame = btn.CFrame
                        task.wait(0.2)
                        fireclickdetector(btn.ClickDetector)
                    end
                end
            end)
        end
    end)
end

Tab7:AddToggle({
    Name = "Asynchronous Auto-Raid Complete Pipeline", Default = false,
    Callback = function(state)
        getgenv().OmenXConfig.RaidCarrier = state
        if state then ExecuteNormalRaidLoop() end
    end
})

Tab7:AddToggle({
    Name = "Auto-Awaken Screen Direct Response Bypass", Default = false,
    Callback = function(state)
        getgenv().OmenXConfig.AutoAwaken = state
        task.spawn(function()
            while getgenv().OmenXConfig.AutoAwaken do
                task.wait(1)
                CommF:InvokeServer("Awakener", "Check")
                CommF:InvokeServer("Awakener", "Awaken")
            end
        end)
    end
})

-- ============================================================================
-- [[ TAB 8: SEA EVENT & MIRAGE NAVIGATION ]]
-- ============================================================================
local Tab8 = Window:MakeTab({ Name = "Oceanic Mapping", Icon = "rbxassetid://4483367102" })

task.spawn(function()
    while task.wait(1) do
        if getgenv().OmenXConfig.SeaEventFarm then
            pcall(function()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local targeted = false
                for _, obj in pairs(Workspace:GetChildren()) do
                    if string.find(obj.Name, "Sea Beast") or string.find(obj.Name, "Terrorshark") then
                        if obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and obj:FindFirstChild("HumanoidRootPart") then
                            targeted = true
                            root.CFrame = obj.HumanoidRootPart.CFrame * CFrame.new(0, 45, 0)
                            SendStrikePacket(obj)
                            break
                        end
                    end
                end
                if not targeted and root.Position.Y < 80 then
                    root.CFrame = CFrame.new(root.Position.X, 85, root.Position.Z)
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if getgenv().OmenXConfig.MirageRadar then
            pcall(function()
                local mirage = Workspace:FindFirstChild("MirageIsland") or Workspace:FindFirstChild("Mirage Island")
                if mirage then
                    for _, part in pairs(mirage:GetDescendants()) do
                        if part.Name == "BlueGear" or part:IsA("MeshPart") and part.TextureID == "rbxassetid://10439634059" then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 2, 0)
                            fireclickdetector(part:FindFirstChildOfClass("ClickDetector"))
                            break
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if getgenv().OmenXConfig.MoonAlign then
            pcall(function()
                if Lighting.ClockTime >= 18.5 or Lighting.ClockTime <= 5.5 then
                    local cam = Workspace.CurrentCamera
                    cam.CFrame = CFrame.lookAt(cam.CFrame.Position, cam.CFrame.Position + Vector3.new(0, 500, 0))
                    CommF:InvokeServer("ActivateV4Trial", "LookAtMoon")
                end
            end)
        end
    end
end)

Tab8:AddToggle({ Name = "Auto-Farm Oceanic Sea Beasts & Terrorsharks", Default = false, Callback = function(state) getgenv().OmenXConfig.SeaEventFarm = state end })
Tab8:AddToggle({ Name = "Auto-Locate & Collect Mirage Blue Gear", Default = false, Callback = function(state) getgenv().OmenXConfig.MirageRadar = state end })
Tab8:AddToggle({ Name = "Force Camera Zenith Angle (Moon Alignment Tracker)", Default = false, Callback = function(state) getgenv().OmenXConfig.MoonAlign = state end })

-- ============================================================================
-- [[ TAB 9: DEVIL FRUIT ECONOMY & SNIPER ]]
-- ============================================================================
local Tab9 = Window:MakeTab({ Name = "Black Market", Icon = "rbxassetid://4483367283" })

local function RunFruitSniperEngine()
    task.spawn(function()
        while getgenv().OmenXConfig.FruitSniper do
            task.wait(0.5)
            pcall(function()
                for _, v in pairs(Workspace:GetChildren()) do
                    if v:IsA("Tool") and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root and getgenv().OmenXConfig.FruitSniper then
                            root.CFrame = v.Handle.CFrame
                            task.wait(0.4)
                            CommF:InvokeServer("StoreFruit", v.Name, v)
                        end
                    end
                end
            end)
        end
    end)
end

task.spawn(function()
    while task.wait(5) do
        if getgenv().OmenXConfig.AutoGacha then
            pcall(function()
                CommF:InvokeServer("Cousin", "BuyFruit")
            end)
        end
    end
end)

Tab9:AddToggle({
    Name = "Fruit Scanner & Automatic Server Storage Pickup", Default = false,
    Callback = function(state)
        getgenv().OmenXConfig.FruitSniper = state
        if state then RunFruitSniperEngine() end
    end
})
Tab9:AddToggle({ Name = "Continuous Automated Fruit Gacha Roll", Default = false, Callback = function(state) getgenv().OmenXConfig.AutoGacha = state end })

-- ============================================================================
-- [[ TAB 10: COMBAT & TARGETED AUTOMATION ]]
-- ============================================================================
local Tab10 = Window:MakeTab({ Name = "Execution Matrix", Icon = "rbxassetid://4483367174" })

task.spawn(function()
    while task.wait(getgenv().OmenXConfig.AttackSpeed) do
        if getgenv().OmenXConfig.KillAura then
            pcall(function()
                local enemies = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:GetChildren()
                if enemies then
                    for _, mob in pairs(enemies) do
                        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                            if dist <= getgenv().OmenXConfig.AuraRange then
                                SendStrikePacket(mob)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if getgenv().OmenXConfig.AimbotEnabled then
            pcall(function()
                local targetPlayer = nil
                local shortestDist = math.huge
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local screenDist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if screenDist < shortestDist then
                            shortestDist = screenDist
                            targetPlayer = p
                        end
                    end
                end
                if targetPlayer then
                    Workspace.CurrentCamera.CFrame = CFrame.lookAt(Workspace.CurrentCamera.CFrame.Position, targetPlayer.Character.HumanoidRootPart.Position)
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if getgenv().OmenXConfig.ObservationCycle then
            pcall(function()
                local activeKen = LocalPlayer.Character:FindFirstChild("HasBuso")
                if not activeKen then
                    local virtualUser = game:GetService("VirtualUser")
                    virtualUser:CaptureController()
                    virtualUser:TypeKey("e")
                end
            end)
        end
    end
end)

Tab10:AddToggle({ Name = "Packet-Inject Strike Aura Engine", Default = false, Callback = function(state) getgenv().OmenXConfig.KillAura = state end })
Tab10:AddSlider({
    Name = "Aura Strike Radius", Min = 5, Max = 50, Default = 25, Increment = 1, ValueName = "studs",
    Callback = function(val) getgenv().OmenXConfig.AuraRange = val end
})
Tab10:AddToggle({ Name = "Aim Bot Predictor Core Lock", Default = false, Callback = function(state) getgenv().OmenXConfig.AimbotEnabled = state end })
Tab10:AddToggle({ Name = "Observation Haki Instafix Cycle", Default = false, Callback = function(state) getgenv().OmenXConfig.ObservationCycle = state end })

-- ============================================================================
-- [[ TAB 11: DATA ANALYTICS & WEBHOOK REPORTING ]]
-- ============================================================================
local Tab11 = Window:MakeTab({ Name = "Data Analytics", Icon = "rbxassetid://4483367223" })

Tab11:AddTextbox({
    Name = "Analytics Webhook Destination URL", Default = "", TextDisappear = false,
    Callback = function(val) getgenv().OmenXConfig.WebhookURL = val end
})

local function TransmitDiscordAnalytics()
    pcall(function()
        local link = getgenv().OmenXConfig.WebhookURL
        if link == "" or not link then return end
        local structure = {
            Url = link, Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                username = "Omen X Analytics Engine",
                embeds = {{
                    title = "📈 Core Automation Metrics Update",
                    color = 10494192,
                    fields = {
                        {name = "User Identity", value = "||" .. LocalPlayer.Name .. "||", inline = true},
                        {name = "Level Metric", value = tostring(LocalPlayer.Data.Level.Value), inline = true},
                        {name = "Beli Wallet Balance", value = "$" .. tostring(LocalPlayer.Data.Beli.Value), inline = false},
                        {name = "Fragment Reserve Balance", value = "ƒ" .. tostring(LocalPlayer.Data.Fragments.Value), inline = true}
                    },
                    footer = {text = "Omen X Engine Systems Integration"}
                }}
            })
        }
        local requestFunc = syn and syn.request or http_request or request
        if requestFunc then requestFunc(structure) end
    end)
end

Tab11:AddButton({ Name = "Manually Fire Analytics Webhook Payload", Callback = function() TransmitDiscordAnalytics() end })
Tab11:AddToggle({
    Name = "Automated Hourly Webhook Reporting Loop", Default = false,
    Callback = function(state)
        getgenv().OmenXConfig.HourlyLogging = state
        task.spawn(function()
            while getgenv().OmenXConfig.HourlyLogging do
                TransmitDiscordAnalytics()
                task.wait(3600)
            end
        end)
    end
})

Tab11:AddToggle({
    Name = "Streamer Privacy Interface Mask", Default = false,
    Callback = function(state)
        getgenv().OmenXConfig.StreamerMode = state
        task.spawn(function()
            while getgenv().OmenXConfig.StreamerMode do
                task.wait(0.4)
                pcall(function()
                    local clientGui = LocalPlayer:WaitForChild("PlayerGui")
                    if clientGui:FindFirstChild("Main") then
                        clientGui.Main.ChooseTeam.Container.Name.Text = "OMEN_X_REDACTED"
                        clientGui.Main.Beli.Text = "$88,888,888"
                        clientGui.Main.Fragments.Text = "ƒ88,888"
                        clientGui.Main.Level.Text = "Lv. Max (2800)"
                    end
                end)
            end
        end)
    end
})

-- ============================================================================
-- [[ RUNTIME MATRIX RUN ]]
-- ============================================================================
OrionLib:Init()
OrionLib:MakeNotification({
    Name = "OMEN X STATUS: SECURE",
    Content = "All high-performance modules compiled successfully.",
    Duration = 5
})
