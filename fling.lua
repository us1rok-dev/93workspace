local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MultiFlingGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Локализация
local Language = "EN" -- EN или RU
local Texts = {
    EN = {
        Title = "#93",
        SubTitle = "multi-fling",
        StatusSelect = "Select targets",
        StatusNoTargets = "NO TARGETS SELECTED",
        StatusSelectTargets = "SELECT TARGETS",
        StatusFlinging = "FLINGING",
        StatusTargets = "TARGETS SELECTED",
        Start = "START",
        Stop = "STOP",
        All = "ALL",
        Clear = "CLEAR",
        Auto = "AUTO",
        ErrorSitting = "is sitting",
        ErrorNoParts = "has no valid parts",
        ErrorCharacter = "Character not ready",
        Started = "Started",
        Stopped = "Stopped",
        Flinging = "Flinging",
        FlingStopped = "Fling stopped",
        Loaded = "#93 multi-fling ready",
        Targets = "targets"
    },
    RU = {
        Title = "#93",
        SubTitle = "мульти-флинг",
        StatusSelect = "Выберите цели",
        StatusNoTargets = "ЦЕЛИ НЕ ВЫБРАНЫ",
        StatusSelectTargets = "ВЫБЕРИТЕ ЦЕЛИ",
        StatusFlinging = "ФЛИНГУЮ",
        StatusTargets = "ЦЕЛЕЙ ВЫБРАНО",
        Start = "СТАРТ",
        Stop = "СТОП",
        All = "ВСЕ",
        Clear = "СБРОС",
        Auto = "АВТО",
        ErrorSitting = "сидит",
        ErrorNoParts = "не имеет частей",
        ErrorCharacter = "Персонаж не готов",
        Started = "Запущен",
        Stopped = "Остановлен",
        Flinging = "Флингую",
        FlingStopped = "Флинг остановлен",
        Loaded = "#93 мульти-флинг готов",
        Targets = "целей"
    }
}

local function GetText(key)
    return Texts[Language][key] or Texts["EN"][key]
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 8))
})
UIGradient.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(40, 40, 40)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = GetText("Title")
Title.TextColor3 = Color3.fromRGB(230, 230, 230)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -100, 1, 0)
SubTitle.Position = UDim2.new(0, 65, 0, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = GetText("SubTitle")
SubTitle.TextColor3 = Color3.fromRGB(140, 140, 140)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 16
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TitleBar

-- Кнопка смены языка
local LangButton = Instance.new("TextButton")
LangButton.Position = UDim2.new(1, -70, 0.5, -12)
LangButton.Size = UDim2.new(0, 24, 0, 24)
LangButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LangButton.BorderSizePixel = 0
LangButton.Text = "EN"
LangButton.TextColor3 = Color3.fromRGB(180, 180, 180)
LangButton.Font = Enum.Font.GothamBold
LangButton.TextSize = 13
LangButton.Parent = TitleBar

local LangCorner = Instance.new("UICorner")
LangCorner.CornerRadius = UDim.new(0, 4)
LangCorner.Parent = LangButton

local CloseButton = Instance.new("TextButton")
CloseButton.Position = UDim2.new(1, -40, 0.5, -12)
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseButton.Font = Enum.Font.Gotham
CloseButton.TextSize = 16
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

local StatusContainer = Instance.new("Frame")
StatusContainer.Position = UDim2.new(0, 15, 0, 60)
StatusContainer.Size = UDim2.new(1, -30, 0, 40)
StatusContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
StatusContainer.BorderSizePixel = 0
StatusContainer.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusContainer

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 1, 0)
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = GetText("StatusSelect")
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusContainer

local SelectionFrame = Instance.new("Frame")
SelectionFrame.Position = UDim2.new(0, 15, 0, 110)
SelectionFrame.Size = UDim2.new(1, -30, 0, 200)
SelectionFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
SelectionFrame.BorderSizePixel = 0
SelectionFrame.Parent = MainFrame

local SelectionCorner = Instance.new("UICorner")
SelectionCorner.CornerRadius = UDim.new(0, 8)
SelectionCorner.Parent = SelectionFrame

local PlayerScrollFrame = Instance.new("ScrollingFrame")
PlayerScrollFrame.Position = UDim2.new(0, 0, 0, 0)
PlayerScrollFrame.Size = UDim2.new(1, 0, 1, 0)
PlayerScrollFrame.BackgroundTransparency = 1
PlayerScrollFrame.BorderSizePixel = 0
PlayerScrollFrame.ScrollBarThickness = 3
PlayerScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScrollFrame.Parent = SelectionFrame

local ButtonContainer = Instance.new("Frame")
ButtonContainer.Position = UDim2.new(0, 15, 0, 320)
ButtonContainer.Size = UDim2.new(1, -30, 0, 40)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainFrame

local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(0.5, -5, 1, 0)
StartButton.Position = UDim2.new(0, 0, 0, 0)
StartButton.BackgroundColor3 = Color3.fromRGB(35, 125, 85)
StartButton.BorderSizePixel = 0
StartButton.Text = GetText("Start")
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.GothamBold
StartButton.TextSize = 14
StartButton.Parent = ButtonContainer

local StartCorner = Instance.new("UICorner")
StartCorner.CornerRadius = UDim.new(0, 6)
StartCorner.Parent = StartButton

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(0.5, -5, 1, 0)
StopButton.Position = UDim2.new(0.5, 5, 0, 0)
StopButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
StopButton.BorderSizePixel = 0
StopButton.Text = GetText("Stop")
StopButton.TextColor3 = Color3.fromRGB(200, 200, 200)
StopButton.Font = Enum.Font.GothamBold
StopButton.TextSize = 14
StopButton.Parent = ButtonContainer

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 6)
StopCorner.Parent = StopButton

local ControlContainer = Instance.new("Frame")
ControlContainer.Position = UDim2.new(0, 15, 0, 370)
ControlContainer.Size = UDim2.new(1, -30, 0, 30)
ControlContainer.BackgroundTransparency = 1
ControlContainer.Parent = MainFrame

local SelectAllButton = Instance.new("TextButton")
SelectAllButton.Size = UDim2.new(0.33, -4, 1, 0)
SelectAllButton.Position = UDim2.new(0, 0, 0, 0)
SelectAllButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SelectAllButton.BorderSizePixel = 0
SelectAllButton.Text = GetText("All")
SelectAllButton.TextColor3 = Color3.fromRGB(180, 180, 180)
SelectAllButton.Font = Enum.Font.Gotham
SelectAllButton.TextSize = 13
SelectAllButton.Parent = ControlContainer

local AllCorner = Instance.new("UICorner")
AllCorner.CornerRadius = UDim.new(0, 4)
AllCorner.Parent = SelectAllButton

local DeselectAllButton = Instance.new("TextButton")
DeselectAllButton.Size = UDim2.new(0.33, -4, 1, 0)
DeselectAllButton.Position = UDim2.new(0.335, 2, 0, 0)
DeselectAllButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
DeselectAllButton.BorderSizePixel = 0
DeselectAllButton.Text = GetText("Clear")
DeselectAllButton.TextColor3 = Color3.fromRGB(180, 180, 180)
DeselectAllButton.Font = Enum.Font.Gotham
DeselectAllButton.TextSize = 13
DeselectAllButton.Parent = ControlContainer

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 4)
ClearCorner.Parent = DeselectAllButton

local AutoSelectButton = Instance.new("TextButton")
AutoSelectButton.Size = UDim2.new(0.33, -4, 1, 0)
AutoSelectButton.Position = UDim2.new(0.67, 2, 0, 0)
AutoSelectButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
AutoSelectButton.BorderSizePixel = 0
AutoSelectButton.Text = GetText("Auto")
AutoSelectButton.TextColor3 = Color3.fromRGB(180, 180, 180)
AutoSelectButton.Font = Enum.Font.Gotham
AutoSelectButton.TextSize = 13
AutoSelectButton.Parent = ControlContainer

local AutoCorner = Instance.new("UICorner")
AutoCorner.CornerRadius = UDim.new(0, 4)
AutoCorner.Parent = AutoSelectButton

local AutoIndicator = Instance.new("Frame")
AutoIndicator.Size = UDim2.new(0, 6, 0, 6)
AutoIndicator.Position = UDim2.new(1, -12, 0.5, -3)
AutoIndicator.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
AutoIndicator.BorderSizePixel = 0
AutoIndicator.Parent = AutoSelectButton

local AutoIndicatorCorner = Instance.new("UICorner")
AutoIndicatorCorner.CornerRadius = UDim.new(1, 0)
AutoIndicatorCorner.Parent = AutoIndicator

local SelectedTargets = {}
local PlayerCheckboxes = {}
local FlingActive = false
local AutoSelectActive = false
local AutoSelectConnection = nil

getgenv().OldPos = nil
getgenv().FPDH = workspace.FallenPartsDestroyHeight

-- Функция обновления всего текста интерфейса
local function UpdateUIText()
    Title.Text = GetText("Title")
    SubTitle.Text = GetText("SubTitle")
    LangButton.Text = Language
    StartButton.Text = GetText("Start")
    StopButton.Text = GetText("Stop")
    SelectAllButton.Text = GetText("All")
    DeselectAllButton.Text = GetText("Clear")
    AutoSelectButton.Text = GetText("Auto")
    UpdateStatus()
end

-- Функция переключения языка
local function ToggleLanguage()
    if Language == "EN" then
        Language = "RU"
    else
        Language = "EN"
    end
    UpdateUIText()
    Message(GetText("Title"), "Language: " .. Language, 1.5)
end

LangButton.MouseButton1Click:Connect(ToggleLanguage)

local function RefreshPlayerList()
    for _, child in pairs(PlayerScrollFrame:GetChildren()) do
        child:Destroy()
    end
    PlayerCheckboxes = {}
    
    local PlayerList = Players:GetPlayers()
    table.sort(PlayerList, function(a, b) return a.Name:lower() < b.Name:lower() end)
    
    local yPosition = 5
    for _, player in ipairs(PlayerList) do
        if player ~= Player then
            local PlayerEntry = Instance.new("Frame")
            PlayerEntry.Size = UDim2.new(1, -10, 0, 36)
            PlayerEntry.Position = UDim2.new(0, 5, 0, yPosition)
            PlayerEntry.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            PlayerEntry.BorderSizePixel = 0
            PlayerEntry.Parent = PlayerScrollFrame
            
            local EntryCorner = Instance.new("UICorner")
            EntryCorner.CornerRadius = UDim.new(0, 6)
            EntryCorner.Parent = PlayerEntry
            
            local Checkbox = Instance.new("Frame")
            Checkbox.Size = UDim2.new(0, 18, 0, 18)
            Checkbox.Position = UDim2.new(0, 10, 0.5, -9)
            Checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Checkbox.BorderSizePixel = 0
            Checkbox.Parent = PlayerEntry
            
            local CheckboxCorner = Instance.new("UICorner")
            CheckboxCorner.CornerRadius = UDim.new(0, 4)
            CheckboxCorner.Parent = Checkbox
            
            local Checkmark = Instance.new("TextLabel")
            Checkmark.Size = UDim2.new(1, 0, 1, 0)
            Checkmark.BackgroundTransparency = 1
            Checkmark.Text = "●"
            Checkmark.TextColor3 = Color3.fromRGB(75, 215, 155)
            Checkmark.TextSize = 14
            Checkmark.Font = Enum.Font.GothamBold
            Checkmark.Visible = SelectedTargets[player.Name] ~= nil
            Checkmark.Parent = Checkbox
            
            local NameLabel = Instance.new("TextLabel")
            NameLabel.Size = UDim2.new(1, -60, 1, 0)
            NameLabel.Position = UDim2.new(0, 35, 0, 0)
            NameLabel.BackgroundTransparency = 1
            NameLabel.Text = player.Name
            NameLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
            NameLabel.TextSize = 14
            NameLabel.Font = Enum.Font.Gotham
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            NameLabel.Parent = PlayerEntry
            
            local ClickArea = Instance.new("TextButton")
            ClickArea.Size = UDim2.new(1, 0, 1, 0)
            ClickArea.BackgroundTransparency = 1
            ClickArea.Text = ""
            ClickArea.ZIndex = 2
            ClickArea.Parent = PlayerEntry
            
            ClickArea.MouseButton1Click:Connect(function()
                if SelectedTargets[player.Name] then
                    SelectedTargets[player.Name] = nil
                    Checkmark.Visible = false
                    Checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                else
                    SelectedTargets[player.Name] = player
                    Checkmark.Visible = true
                    Checkbox.BackgroundColor3 = Color3.fromRGB(35, 125, 85)
                end
                UpdateStatus()
            end)
            
            PlayerCheckboxes[player.Name] = {
                Entry = PlayerEntry,
                Checkmark = Checkmark,
                Checkbox = Checkbox
            }
            
            yPosition = yPosition + 41
        end
    end
    
    PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPosition + 5)
end

local function CountSelectedTargets()
    local count = 0
    for _ in pairs(SelectedTargets) do
        count = count + 1
    end
    return count
end

local function UpdateStatus()
    local count = CountSelectedTargets()
    if FlingActive then
        StatusLabel.Text = "⦿ " .. GetText("StatusFlinging") .. " " .. count .. " " .. GetText("Targets")
        StatusLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
    else
        if count == 0 then
            StatusLabel.Text = "⦿ " .. GetText("StatusNoTargets")
        else
            StatusLabel.Text = "⦿ " .. count .. " " .. GetText("StatusTargets")
        end
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

local function ToggleAllPlayers(select)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player then
            local checkboxData = PlayerCheckboxes[player.Name]
            if checkboxData then
                if select then
                    SelectedTargets[player.Name] = player
                    checkboxData.Checkmark.Visible = true
                    checkboxData.Checkbox.BackgroundColor3 = Color3.fromRGB(35, 125, 85)
                else
                    SelectedTargets[player.Name] = nil
                    checkboxData.Checkmark.Visible = false
                    checkboxData.Checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                end
            end
        end
    end
    UpdateStatus()
end

local function ToggleAutoSelect()
    AutoSelectActive = not AutoSelectActive
    
    if AutoSelectActive then
        AutoSelectButton.BackgroundColor3 = Color3.fromRGB(35, 125, 85)
        AutoSelectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        AutoIndicator.BackgroundColor3 = Color3.fromRGB(75, 215, 155)
        
        AutoSelectConnection = RunService.Heartbeat:Connect(function()
            if AutoSelectActive then
                ToggleAllPlayers(true)
                task.wait(0.15)
            end
        end)
    else
        AutoSelectButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        AutoSelectButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        AutoIndicator.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
        
        if AutoSelectConnection then
            AutoSelectConnection:Disconnect()
            AutoSelectConnection = nil
        end
    end
end

AutoSelectButton.MouseButton1Click:Connect(ToggleAutoSelect)

local function Message(Title, Text, Time)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = Title,
        Text = Text,
        Duration = Time or 5
    })
end

local function SkidFling(TargetPlayer)
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character
    if not TCharacter then return end
    
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle
    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end
    if TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessory and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end
    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        
        if THumanoid and THumanoid.Sit then
            return Message(GetText("Title"), TargetPlayer.Name .. " " .. GetText("ErrorSitting"), 2)
        end
        
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end
        
        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        
        local SFBasePart = function(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0
            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                end
            until Time + TimeToWait < tick() or not FlingActive
        end
        
        workspace.FallenPartsDestroyHeight = 0/0
        
        local BV = Instance.new("BodyVelocity")
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        if TRootPart then
            SFBasePart(TRootPart)
        elseif THead then
            SFBasePart(THead)
        elseif Handle then
            SFBasePart(Handle)
        else
            return Message(GetText("Title"), TargetPlayer.Name .. " " .. GetText("ErrorNoParts"), 2)
        end
        
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid
        
        if getgenv().OldPos then
            repeat
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                Humanoid:ChangeState("GettingUp")
                for _, part in pairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Velocity, part.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end
                task.wait()
            until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
            workspace.FallenPartsDestroyHeight = getgenv().FPDH
        end
    else
        return Message(GetText("Title"), GetText("ErrorCharacter"), 2)
    end
end

local function StartFling()
    if FlingActive then return end
    
    local count = CountSelectedTargets()
    if count == 0 then
        StatusLabel.Text = "⦿ " .. GetText("StatusNoTargets")
        wait(1)
        StatusLabel.Text = "⦿ " .. GetText("StatusSelectTargets")
        return
    end
    
    FlingActive = true
    StartButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    StopButton.BackgroundColor3 = Color3.fromRGB(35, 125, 85)
    StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    UpdateStatus()
    Message(GetText("Started"), GetText("Flinging") .. " " .. count .. " " .. GetText("Targets"), 2)
    
    spawn(function()
        while FlingActive do
            local validTargets = {}
            
            for name, player in pairs(SelectedTargets) do
                if player and player.Parent then
                    validTargets[name] = player
                else
                    SelectedTargets[name] = nil
                    local checkbox = PlayerCheckboxes[name]
                    if checkbox then
                        checkbox.Checkmark.Visible = false
                        checkbox.Checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    end
                end
            end
            
            for _, player in pairs(validTargets) do
                if FlingActive then
                    SkidFling(player)
                    wait(0.1)
                else
                    break
                end
            end
            
            UpdateStatus()
            wait(0.5)
        end
    end)
end

local function StopFling()
    if not FlingActive then return end
    FlingActive = false
    StartButton.BackgroundColor3 = Color3.fromRGB(35, 125, 85)
    StopButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    StopButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    UpdateStatus()
    Message(GetText("Stopped"), GetText("FlingStopped"), 2)
end

StartButton.MouseButton1Click:Connect(StartFling)
StopButton.MouseButton1Click:Connect(StopFling)
SelectAllButton.MouseButton1Click:Connect(function() ToggleAllPlayers(true) end)
DeselectAllButton.MouseButton1Click:Connect(function() ToggleAllPlayers(false) end)
CloseButton.MouseButton1Click:Connect(function()
    StopFling()
    if AutoSelectActive then
        ToggleAutoSelect()
    end
    ScreenGui:Destroy()
end)

Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(function(player)
    if SelectedTargets[player.Name] then
        SelectedTargets[player.Name] = nil
    end
    RefreshPlayerList()
    UpdateStatus()
end)

RefreshPlayerList()
UpdateStatus()
Message(GetText("Title"), GetText("Loaded"), 3)