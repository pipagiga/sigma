local RS=game:GetService("ReplicatedStorage")
local P=game:GetService("Players").LocalPlayer
local GE=RS:WaitForChild("GameEvents")
local Notif=GE:WaitForChild("Notification")
if typeof(getconnections)=="function" then for _,c in ipairs(getconnections(Notif.OnClientEvent)) do pcall(function() c:Disconnect() end) end end
Notif.OnClientEvent:Connect(function(m) m=tostring(m):lower(); if m:find("not an ingredient") or m:find("cant cook") or m:find("pending trade") then return end end)

local Cook=GE:WaitForChild("FeedNPC_RE")
local function hum() local ch=P.Character or P.CharacterAdded:Wait(); return ch:WaitForChild("Humanoid") end
local function wanted(n) n=n:lower(); return (n:find("soup",1,true) or n:find("smoothie",1,true) or n:find("salad",1,true)) end
local function pick() local bp=P:WaitForChild("Backpack"); local t={} for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") and wanted(v.Name) then t[#t+1]=v end end return (#t>0) and t[math.random(#t)] or nil end

local RUN=true

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(0, 10, 0, 10)
closeBtn.Text = "X"
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Parent = screenGui

closeBtn.MouseButton1Click:Connect(function()
    RUN = false
    screenGui:Destroy()
end)

while RUN do
    local h=hum(); local t=pick()
    if t then
        h:UnequipTools(); task.wait(0.03)
        t.Parent=P.Backpack; task.wait()
        h:EquipTool(t); task.wait(0.03)
        Cook:FireServer("Giant")
    else task.wait(0.03) end
    task.wait(0.03)
end
