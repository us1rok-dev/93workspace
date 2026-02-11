local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- Локализация
local Language = "EN" -- EN или RU
local Texts = {
    EN = {
        Title = "#93",
        SubTitle = "flyGUI",
        Fly = "Fly",
        Stop = "Stop",
        Controls = "CONTROLS:",
        ControlsW = "W - Forward",
        ControlsS = "S - Back",
        ControlsA = "A - Left",
        ControlsD = "D - Right",
        ControlsE = "E/Space - Up",
        ControlsQ = "Q/Shift - Down",
        Speed = "Speed",
        Ready = "ready",
        Stopped = "Flight stopped",
        Started = "Flight started"
    },
    RU = {
        Title = "#93",
        SubTitle = "полет",
        Fly = "Полет",
        Stop = "Стоп",
        Controls = "УПРАВЛЕНИЕ:",
        ControlsW = "W - Вперед",
        ControlsS = "S - Назад",
        ControlsA = "A - Влево",
        ControlsD = "D - Вправо",
        ControlsE = "E/Пробел - Вверх",
        ControlsQ = "Q/Shift - Вниз",
        Speed = "Скорость",
        Ready = "готов",
        Stopped = "Полет остановлен",
        Started = "Полет запущен"
    }
}

local function GetText(key)
    return Texts[Language][key] or Texts["EN"][key]
end

-- Переменные для полета
local flyEnabled = false
local flying = false
local flySpeed = 50
local flyBV = nil
local flyBG = nil

-- Функции полета
local function startFly()
    if flying then return end
    flying = true
    
    local character = Player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- BodyVelocity для горизонтального движения
    flyBV = Instance.new("BodyVelocity")
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBV.MaxForce = Vector3.new(10000, 10000, 10000)
    flyBV.P = 10000
    flyBV.Parent = rootPart
    
    -- BodyGyro для управления направлением
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(10000, 10000, 10000)
    flyBG.P = 10000
    flyBG.D = 100
    flyBG.Parent = rootPart
    
    humanoid.PlatformStand = true
    
    local forward = 0
    local backward = 0
    local left = 0
    local right = 0
    local up = 0
    local down = 0
    
    local camera = workspace.CurrentCamera
    
    local function updateFly()
        if not flying or not flyBV or not flyBG then return end
        
        local cf = camera.CFrame
        local lookVector = cf.LookVector
        local rightVector = cf.RightVector
        local upVector = cf.UpVector
        
        local direction = (lookVector * (forward - backward)) + 
                         (rightVector * (right - left)) + 
                         (upVector * (up - down))
        
        if direction.Magnitude > 0 then
            direction = direction.Unit
        end
        
        flyBV.Velocity = direction * flySpeed
        flyBG.CFrame = CFrame.new(rootPart.Position, rootPart.Position + lookVector)
    end
    
    -- Управление
    local connections = {}
    
    connections.inputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.W then
            forward = 1
        elseif input.KeyCode == Enum.KeyCode.S then
            backward = 1
        elseif input.KeyCode == Enum.KeyCode.A then
            left = 1
        elseif input.KeyCode == Enum.KeyCode.D then
            right = 1
        elseif input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.Space then
            up = 1
        elseif input.KeyCode == Enum.KeyCode.Q or input.KeyCode == Enum.KeyCode.LeftShift then
            down = 1
        end
        
        updateFly()
    end)
    
    connections.inputEnded = UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.W then
            forward = 0
        elseif input.KeyCode == Enum.KeyCode.S then
            backward = 0
        elseif input.KeyCode == Enum.KeyCode.A then
            left = 0
        elseif input.KeyCode == Enum.KeyCode.D then
            right = 0
        elseif input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.Space then
            up = 0
        elseif input.KeyCode == Enum.KeyCode.Q or input.KeyCode == Enum.KeyCode.LeftShift then
            down = 0
        end
        
        updateFly()
    end)
    
    -- Обновление каждый кадр
    coroutine.wrap(function()
        while flying do
            updateFly()
            RunService.RenderStepped:Wait()
        end
    end)()
    
    -- Очистка при смерти персонажа
    connections.characterRemoving = character.AncestryChanged:Connect(function()
        stopFly()
    end)
end

local function stopFly()
    flying = false
    
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    
    if flyBV then
        flyBV:Destroy()
        flyBV = nil
    end
    
    if flyBG then
        flyBG:Destroy()
        flyBG = nil
    end
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 180)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
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

local ButtonContainer = Instance.new("Frame")
ButtonContainer.Position = UDim2.new(0, 15, 0, 60)
ButtonContainer.Size = UDim2.new(1, -30, 0, 105)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainFrame

local FlingButton = Instance.new("TextButton")
FlingButton.Size = UDim2.new(1, 0, 0, 40)
FlingButton.Position = UDim2.new(0, 0, 0, 0)
FlingButton.BackgroundColor3 = Color3.fromRGB(35, 125, 85)
FlingButton.BorderSizePixel = 0
FlingButton.Text = GetText("Fly")
FlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingButton.Font = Enum.Font.GothamBold
FlingButton.TextSize = 16
FlingButton.Parent = ButtonContainer

local FlingCorner = Instance.new("UICorner")
FlingCorner.CornerRadius = UDim.new(0, 6)
FlingCorner.Parent = FlingButton

-- Информация об управлении
local ControlsLabel = Instance.new("TextLabel")
ControlsLabel.Size = UDim2.new(1, 0, 0, 60)
ControlsLabel.Position = UDim2.new(0, 0, 0, 45)
ControlsLabel.BackgroundTransparency = 1
ControlsLabel.Text = GetText("Controls") .. "\n" ..
                    GetText("ControlsW") .. "  " .. GetText("ControlsS") .. "  " .. GetText("ControlsA") .. "  " .. GetText("ControlsD") .. "\n" ..
                    GetText("ControlsE") .. "  " .. GetText("ControlsQ")
ControlsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
ControlsLabel.Font = Enum.Font.Gotham
ControlsLabel.TextSize = 11
ControlsLabel.TextXAlignment = Enum.TextXAlignment.Left
ControlsLabel.TextYAlignment = Enum.TextYAlignment.Top
ControlsLabel.TextWrapped = true
ControlsLabel.Parent = ButtonContainer

-- Функция обновления текста интерфейса
local function UpdateUIText()
    Title.Text = GetText("Title")
    SubTitle.Text = GetText("SubTitle")
    LangButton.Text = Language
    
    if flying then
        FlingButton.Text = GetText("Stop")
    else
        FlingButton.Text = GetText("Fly")
    end
    
    ControlsLabel.Text = GetText("Controls") .. "\n" ..
                        GetText("ControlsW") .. "  " .. GetText("ControlsS") .. "  " .. GetText("ControlsA") .. "  " .. GetText("ControlsD") .. "\n" ..
                        GetText("ControlsE") .. "  " .. GetText("ControlsQ")
end

-- Функция переключения языка
local function ToggleLanguage()
    if Language == "EN" then
        Language = "RU"
    else
        Language = "EN"
    end
    UpdateUIText()
    
    -- Уведомление о смене языка
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = GetText("Title"),
        Text = "Language: " .. Language,
        Duration = 1.5
    })
end

LangButton.MouseButton1Click:Connect(ToggleLanguage)

-- Логика кнопки полета
FlingButton.MouseButton1Click:Connect(function()
    if not flying then
        startFly()
        FlingButton.Text = GetText("Stop")
        FlingButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
        
        -- Уведомление о старте
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = GetText("Title"),
            Text = GetText("Started"),
            Duration = 1.5
        })
    else
        stopFly()
        FlingButton.Text = GetText("Fly")
        FlingButton.BackgroundColor3 = Color3.fromRGB(35, 125, 85)
        
        -- Уведомление об остановке
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = GetText("Title"),
            Text = GetText("Stopped"),
            Duration = 1.5
        })
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    stopFly() -- Останавливаем полет при закрытии GUI
    ScreenGui:Destroy()
end)

-- Автоматическая остановка при смерти
Player.CharacterAdded:Connect(function()
    if flying then
        stopFly()
        FlingButton.Text = GetText("Fly")
        FlingButton.BackgroundColor3 = Color3.fromRGB(35, 125, 85)
    end
end)

-- Инициализация
UpdateUIText()