local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 360, 0, 220)
Frame.Position = UDim2.new(0.5, -170, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleBar.Parent = Frame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 100, 1, 0)
TitleLabel.Position = UDim2.new(0, 5, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Text = "pedrohub v1.0.1"
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local function createButton(text, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 20, 0, 20)
    btn.Position = pos
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.Parent = TitleBar
    return btn
end

local UpBtn = createButton("↑", UDim2.new(1, -175, 0, 2))
local DownBtn = createButton("↓", UDim2.new(1, -150, 0, 2))
local LeftBtn = createButton("←", UDim2.new(1, -125, 0, 2))
local RightBtn = createButton("→", UDim2.new(1, -100, 0, 2))
local ResetBtn = createButton("🔄", UDim2.new(1, -75, 0, 2))
local PauseButton = createButton("▶️", UDim2.new(1, -50, 0, 2))
local CloseButton = createButton("X", UDim2.new(1, -25, 0, 2))
CloseButton.TextColor3 = Color3.fromRGB(255, 0, 0)

local running = true
local paused = true
local forceReset = false

CloseButton.MouseButton1Click:Connect(function()
    running = false
    ScreenGui:Destroy()
end)

PauseButton.MouseButton1Click:Connect(function()
    paused = not paused
    PauseButton.Text = paused and "▶️" or "⏸️"
end)

ResetBtn.MouseButton1Click:Connect(function()
    forceReset = true
end)

local moveIncrement = 40
UpBtn.MouseButton1Click:Connect(function()
    Frame.Position = Frame.Position - UDim2.new(0,0,0,moveIncrement)
end)
DownBtn.MouseButton1Click:Connect(function()
    Frame.Position = Frame.Position + UDim2.new(0,0,0,moveIncrement)
end)
LeftBtn.MouseButton1Click:Connect(function()
    Frame.Position = Frame.Position - UDim2.new(0,moveIncrement,0,0)
end)
RightBtn.MouseButton1Click:Connect(function()
    Frame.Position = Frame.Position + UDim2.new(0,moveIncrement,0,0)
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -220, 0, 20)
StatusLabel.Position = UDim2.new(0, 5, 0, 25)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Text = "Status: aguardando..."
StatusLabel.Parent = Frame

local IngredLabel = Instance.new("TextLabel")
IngredLabel.Size = UDim2.new(0, 100, 0, 20)
IngredLabel.Position = UDim2.new(0, 5, 0, 50)
IngredLabel.Text = "Ingredientes:"
IngredLabel.TextColor3 = Color3.fromRGB(255,255,255)
IngredLabel.BackgroundTransparency = 1
IngredLabel.TextXAlignment = Enum.TextXAlignment.Left
IngredLabel.Parent = Frame

local IngredientBoxes = {}
for i=1,5 do
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 50, 0, 20)
    box.Position = UDim2.new(0, 5 + (i-1)*55, 0, 75)
    box.Text = ""
    box.ClearTextOnFocus = false
    box.BackgroundColor3 = Color3.fromRGB(70,70,70)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Parent = Frame
    table.insert(IngredientBoxes, box)
end

local KitLabel = Instance.new("TextLabel")
KitLabel.Size = UDim2.new(0, 100, 0, 20)
KitLabel.Position = UDim2.new(0, 5, 0, 105)
KitLabel.Text = "Cooking Kits:"
KitLabel.TextColor3 = Color3.fromRGB(255,255,255)
KitLabel.BackgroundTransparency = 1
KitLabel.TextXAlignment = Enum.TextXAlignment.Left
KitLabel.Parent = Frame

local KitBoxes = {}
for i=1,3 do
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 50, 0, 20)
    box.Position = UDim2.new(0, 5 + (i-1)*55, 0, 130)
    box.Text = ""
    box.ClearTextOnFocus = false
    box.BackgroundColor3 = Color3.fromRGB(70,70,70)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Parent = Frame
    table.insert(KitBoxes, box)
end

local function equipAndSubmit(ingredientName)
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") and string.match(item.Name, "^" .. ingredientName .. " %[.-%]$") then
            item.Parent = player.Character
            local args = {"SubmitHeldPlant", KitBoxes[1].Text}
            ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("CookingPotService_RE"):FireServer(unpack(args))
            return true
        end
    end
    return false
end

local function allIngredientsInsidePot(insidePotFrame)
    local insideNames = {}
    for _, child in ipairs(insidePotFrame:GetChildren()) do
        insideNames[child.Name:lower()] = true
    end
    local anyIngredient = false
    for _, box in ipairs(IngredientBoxes) do
        local ingredient = box.Text:lower()
        if ingredient ~= "" then
            anyIngredient = true
            if not insideNames[ingredient] then
                return false, true
            end
        end
    end
    if not anyIngredient then
        StatusLabel.Text = "pedrácio hubulus não vê nenhum ingrediente"
        return false, false
    end
    return true, true
end

local function findPlayerFarm()
    for idx, farm in ipairs(workspace.Farm:GetChildren()) do
        local sign = farm:FindFirstChild("Sign")
        if sign then
            local core = sign:FindFirstChild("Core_Part")
            if core then
                local sg = core:FindFirstChildWhichIsA("SurfaceGui")
                if sg then
                    local playerLabel = sg:FindFirstChild("Player") and sg.Player:FindFirstChildWhichIsA("TextLabel")
                    if playerLabel and string.find(playerLabel.Text, player.Name) then
                        print("✅ Farm do jogador encontrada:", farm.Name, "Índice:", idx)
                        return farm, idx
                    end
                end
            end
        end
    end
    return nil, nil
end

local function findCookingKit(farm)
    local children = farm:WaitForChild("Important"):WaitForChild("Cosmetic_Physical"):GetChildren()
    for idx, child in ipairs(children) do
        local isKit = child:FindFirstChild("Cooking Kit")
        if isKit then
            return isKit, idx
        end
    end
    return nil, nil
end

local function processIngredients()
    task.spawn(function()
        while running do
            if paused then
                StatusLabel.Text = "pedrácio hubulus tá afim de rodar, mas pausarão ele..."
                task.wait(0.5)
                continue
            end
            if forceReset then
                forceReset = false
            end
            StatusLabel.Text = "pedrácio hubulus está em busca da plot do player"
            local farm, farmIndex = findPlayerFarm()
            if not farm then
                StatusLabel.Text = "pedrácio hubulus não encontrou a plot do player, tentando novamente..."
                task.wait(2)
                continue
            end
            StatusLabel.Text = "pedrácio hubulus está em busca do cooking kit"
            local cp, cpIndex = findCookingKit(farm)
            if not cp then
                StatusLabel.Text = "pedrácio hubulus não encontrou o cooking pot, tentando novamente..."
                task.wait(2)
                continue
            end
            StatusLabel.Text = "pedrácio hubulus está checando o tempo de cuzudo"
            local timeLabel
            local ok, result = pcall(function()
                return cp.CookTimeDisplay.Face.SurfaceGui.TimeDisplayFrame.TimeLabel
            end)
            if ok then
                timeLabel = result
            else
                StatusLabel.Text = "pedrácio hubulus não conseguiu checar o tempo de cuzudo"
                task.wait(2)
                continue
            end
            local timeText = timeLabel.Text
            StatusLabel.Text = "pedrácio hubulus checou e faltam "..timeText.." para terminar de cuzur"
            if string.find(timeText, "00:00") then
                StatusLabel.Text = "pedrácio hubulus tá afim de cuzar"
            elseif string.find(timeText, "Ready") then
                StatusLabel.Text = "pedrácio hubulus notou que a comida está pronta a comida está pronta"
                local args = {"GetFoodFromPot", KitBoxes[1].Text}
                ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("CookingPotService_RE"):FireServer(unpack(args))
            else
                StatusLabel.Text = "pedrácio hubulus fica no aguardo enquanto a comida cuzui"
                local args = {"CookBest", KitBoxes[1].Text}
                ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("CookingPotService_RE"):FireServer(unpack(args))
                task.wait(5)
                continue
            end
            StatusLabel.Text = "pedrácio hubulus tá enviando os ingredientes pra cuzer"
            for _, box in ipairs(IngredientBoxes) do
                local ingredient = box.Text
                if ingredient ~= "" then
                    local success = equipAndSubmit(ingredient)
                    if success then
                        task.wait(1)
                    end
                end
            end
            local insidePotFrame = cp.IngredientsBoard.IngredientListPart.CookingIngredientGui.Background.InsidePotFrame
            local allOk, anyIngredient = allIngredientsInsidePot(insidePotFrame)
            if not anyIngredient then
                task.wait(1)
                continue
            end
            if allOk then
                StatusLabel.Text = "pedrácio hubulus decidiu que é hora de cuzar"
                local args = {"CookBest", KitBoxes[1].Text}
                ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("CookingPotService_RE"):FireServer(unpack(args))
                task.wait(2)
            else
                StatusLabel.Text = "pedrácio hubulus sentiu falta de alguma coisa, tentando novamente..."
                task.wait(1)
            end
        end
    end)
end

processIngredients()
