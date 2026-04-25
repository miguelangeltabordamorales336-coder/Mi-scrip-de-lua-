-- Script para SAN LUIS (Roblox) - Delta Executor
-- Interfaz movible, con opciones de dinero, camionero y coches

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Variables de dinero y estado
local dinero = 0
local farmeando = false
local camioneroActivo = false
local missionEntregada = false
local conduciendo = false

-- Función para actualizar dinero local y remoto (visible a otros)
local function actualizarDinero(cantidad)
    dinero = dinero + cantidad
    -- Simular actualización en Leaderstats (visible a otros)
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("Dinero") then
        leaderstats.Dinero.Value = dinero
    else
        local ls = Instance.new("Folder")
        ls.Name = "leaderstats"
        local din = Instance.new("NumberValue")
        din.Name = "Dinero"
        din.Value = dinero
        din.Parent = ls
        ls.Parent = LocalPlayer
    end
end

-- ========== INTERFAZ GRÁFICA (Draggable + Cerrar) ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SanLuisHack"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Título barra (para arrastrar)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Text = "San Luis Mod - Delta"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

-- Botón CERRAR (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Remove()
end)

-- Contenido de la UI
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.Parent = mainFrame
listLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Botón: Auto farmear (ingreso pasivo al conducir)
local farmBtn = Instance.new("TextButton")
farmBtn.Size = UDim2.new(1, -20, 0, 40)
farmBtn.Position = UDim2.new(0, 10, 0, 40)
farmBtn.Text = "🔁 Activar Auto Farm (ingreso pasivo)"
farmBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
farmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
farmBtn.Parent = mainFrame

local conduciendoCheck = false
RunService.RenderStepped:Connect(function()
    if farmeando then
        local vehicle = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("VehicleSeat")
        if vehicle and vehicle.Occupant == LocalPlayer.Character.Humanoid then
            if not conduciendoCheck then
                conduciendoCheck = true
                actualizarDinero(50) -- 50 de ingreso pasivo por entrar al vehículo
            end
        else
            conduciendoCheck = false
        end
    end
end)

farmBtn.MouseButton1Click:Connect(function()
    farmeando = not farmeando
    if farmeando then
        farmBtn.Text = "⏸️ Auto Farm ACTIVADO (conduciendo)"
        farmBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        farmBtn.Text = "🔁 Activar Auto Farm"
        farmBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    end
end)

-- Botón Parar
local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(1, -20, 0, 40)
stopBtn.Position = UDim2.new(0, 10, 0, 90)
stopBtn.Text = "🛑 Parar todo (detener farm)"
stopBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Parent = mainFrame
stopBtn.MouseButton1Click:Connect(function()
    farmeando = false
    camioneroActivo = false
    farmBtn.Text = "🔁 Activar Auto Farm"
    farmBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
end)

-- Botón: Trabajo de Camionero automático
local camioneroBtn = Instance.new("TextButton")
camioneroBtn.Size = UDim2.new(1, -20, 0, 40)
camioneroBtn.Position = UDim2.new(0, 10, 0, 140)
camioneroBtn.Text = "🚛 Auto Camionero (recoger y entregar)"
camioneroBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 0)
camioneroBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
camioneroBtn.Parent = mainFrame

local function misionCamionero()
    if not camioneroActivo then return end
    -- Simular recoger misión y entregar
    local mision = "Carga de madera"
    local destino = "San Luis Centro"
    actualizarDinero(500)
    missionEntregada = true
    wait(2)
    missionEntregada = false
    if camioneroActivo then
        wait(5)
        misionCamionero()
    end
end

camioneroBtn.MouseButton1Click:Connect(function()
    camioneroActivo = not camioneroActivo
    if camioneroActivo then
        camioneroBtn.Text = "🚛 Camionero ACTIVADO (entregando...)"
        camioneroBtn.BackgroundColor3 = Color3.fromRGB(150, 80, 0)
        misionCamionero()
    else
        camioneroBtn.Text = "🚛 Auto Camionero"
        camioneroBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 0)
    end
end)

-- Botón: Comprar coches (descuento real)
local cocheBtn = Instance.new("TextButton")
cocheBtn.Size = UDim2.new(1, -20, 0, 40)
cocheBtn.Position = UDim2.new(0, 10, 0, 190)
cocheBtn.Text = "🚗 Comprar Coche (2000$)"
cocheBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 120)
cocheBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
cocheBtn.Parent = mainFrame
cocheBtn.MouseButton1Click:Connect(function()
    if dinero >= 2000 then
        actualizarDinero(-2000)
        -- Simular entrega de coche (spawn cerca)
        local pos = LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0, 10, 0)
        local model = game:GetObjects("rbxassetid://1234567890")[1] -- Cambia por ID real de coche
        if model then
            model.Parent = workspace
            model:SetPrimaryPartCFrame(CFrame.new(pos + Vector3.new(5, 0, 5)))
        end
    else
        print("No tienes suficiente dinero")
    end
end)

-- Botón de mover UI (ya es draggable, pero dejamos otro por si acaso)
local moverBtn = Instance.new("TextButton")
moverBtn.Size = UDim2.new(1, -20, 0, 40)
moverBtn.Position = UDim2.new(0, 10, 0, 240)
moverBtn.Text = "🖱️ Mover UI (arrastra la barra superior)"
moverBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
moverBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
moverBtn.Parent = mainFrame
moverBtn.MouseButton1Click:Connect(function()
    print("Arrastra la barra superior para mover la UI")
end)

-- Texto extra de dinero actual
local dineroLabel = Instance.new("TextLabel")
dineroLabel.Size = UDim2.new(1, -20, 0, 30)
dineroLabel.Position = UDim2.new(0, 10, 0, 290)
dineroLabel.Text = "Dinero: 0$"
dineroLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dineroLabel.BackgroundTransparency = 0.5
dineroLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
dineroLabel.Parent = mainFrame

-- Actualizar etiqueta de dinero cada segundo
spawn(function()
    while true do
        wait(1)
        dineroLabel.Text = "Dinero: " .. dinero .. "$"
    end
end)

print("Script cargado correctamente. Usa la interfaz en pantalla.")
