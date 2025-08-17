local Players = game:GetService("Players") 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 370, 0, 250)
Frame.Position = UDim2.new(0.5, -185, 0, 100)
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
TitleLabel.Text = "pedrohub v1.0.2"
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

local UpBtn = createButton("↑", UDim2.new(1, -225, 0, 2))
local DownBtn = createButton("↓", UDim2.new(1, -200, 0, 2))
local LeftBtn = createButton("←", UDim2.new(1, -175, 0, 2))
local RightBtn = createButton("→", UDim2.new(1, -150, 0, 2))
local ForceBtn = createButton("🔄", UDim2.new(1, -125, 0, 2))
local PauseButton = createButton("▶️", UDim2.new(1, -100, 0, 2))
local CloseButton = createButton("X", UDim2.new(1, -75, 0, 2))
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

ForceBtn.MouseButton1Click:Connect(function()
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
end
)
RightBtn.MouseButton1Click:Connect(function()
    Frame.Position = Frame.Position + UDim2.new(0,moveIncrement,0,0)
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -240, 0, 20)
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
local IngredientLimits = {}
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

    local limitBox = Instance.new("TextBox")
    limitBox.Size = UDim2.new(0, 25, 0, 20)
    limitBox.Position = UDim2.new(0, 5 + (i-1)*55, 0, 95)
    limitBox.Text = "999"
    limitBox.ClearTextOnFocus = false
    limitBox.BackgroundColor3 = Color3.fromRGB(100,100,100)
    limitBox.TextColor3 = Color3.fromRGB(255,255,255)
    limitBox.Parent = Frame
    table.insert(IngredientLimits, limitBox)
end

local KitLabel = Instance.new("TextLabel")
KitLabel.Size = UDim2.new(0, 100, 0, 20)
KitLabel.Position = UDim2.new(0, 5, 0, 125)
KitLabel.Text = "Cooking Kits:"
KitLabel.TextColor3 = Color3.fromRGB(255,255,255)
KitLabel.BackgroundTransparency = 1
KitLabel.TextXAlignment = Enum.TextXAlignment.Left
KitLabel.Parent = Frame

local KitBoxes = {}
for i=1,3 do
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 50, 0, 20)
    box.Position = UDim2.new(0, 5 + (i-1)*55, 0, 150)
    box.Text = ""
    box.ClearTextOnFocus = false
    box.BackgroundColor3 = Color3.fromRGB(70,70,70)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Parent = Frame
    table.insert(KitBoxes, box)
end

local function equipAndSubmit(ingredientName, limitValue)
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            local numberStr = string.match(item.Name, "%[(%d*%.?%d*)")
            local numberVal = tonumber(numberStr) or 0
            if string.find(item.Name, ingredientName.."%[") then
                item.Parent = player.Character
                local args = {"SubmitHeldPlant", KitBoxes[1].Text}
                ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("CookingPotService_RE"):FireServer(unpack(args))
                return true
            end
        end
    end
    return false
end
