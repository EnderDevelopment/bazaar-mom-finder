local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("BazaarRemotes")
local requestTip = remotes:WaitForChild("RequestTip")
local buyUpgrade = remotes:WaitForChild("BuyUpgrade")
local requestStatus = remotes:WaitForChild("RequestStatus")
local statusUpdate = remotes:WaitForChild("StatusUpdate")

local gui = Instance.new("ScreenGui")
gui.Name = "BazaarHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local function makeLabel(name, size, position, textSize)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Size = size
	label.Position = position
	label.BackgroundColor3 = Color3.fromRGB(35, 23, 15)
	label.BackgroundTransparency = 0.12
	label.TextColor3 = Color3.fromRGB(255, 238, 179)
	label.TextSize = textSize
	label.Font = Enum.Font.Gotham
	label.TextWrapped = true
	label.Parent = gui
	return label
end

local title = makeLabel("Title", UDim2.fromOffset(360, 46), UDim2.fromOffset(18, 18), 24)
title.Text = "BIG BAZAAR | FIND MOM"
title.Font = Enum.Font.GothamBold

local coins = makeLabel("Coins", UDim2.fromOffset(180, 38), UDim2.fromOffset(18, 70), 19)
coins.TextXAlignment = Enum.TextXAlignment.Left
local clue = makeLabel("Clue", UDim2.fromOffset(360, 76), UDim2.fromOffset(18, 116), 17)
clue.TextXAlignment = Enum.TextXAlignment.Left
clue.TextYAlignment = Enum.TextYAlignment.Center

local message = makeLabel("Message", UDim2.fromOffset(360, 56), UDim2.fromOffset(18, 196), 15)
message.TextXAlignment = Enum.TextXAlignment.Left

local panel = Instance.new("Frame")
panel.Name = "UpgradePanel"
panel.Size = UDim2.fromOffset(260, 238)
panel.Position = UDim2.new(1, -278, 0, 18)
panel.BackgroundColor3 = Color3.fromRGB(35, 23, 15)
panel.BackgroundTransparency = 0.08
panel.Parent = gui

local panelTitle = Instance.new("TextLabel")
panelTitle.Size = UDim2.new(1, -20, 0, 34)
panelTitle.Position = UDim2.fromOffset(10, 8)
panelTitle.BackgroundTransparency = 1
panelTitle.Text = "UPGRADE SHOP"
panelTitle.TextColor3 = Color3.fromRGB(255, 238, 179)
panelTitle.TextSize = 21
panelTitle.Font = Enum.Font.GothamBold
panelTitle.Parent = panel

local function makeButton(name, text, y)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(1, -20, 0, 44)
	button.Position = UDim2.fromOffset(10, y)
	button.BackgroundColor3 = Color3.fromRGB(92, 178, 107)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 16
	button.Font = Enum.Font.GothamBold
	button.Text = text
	button.AutoButtonColor = true
	button.Parent = panel
	return button
end

local tipButton = makeButton("TipButton", "Ask Vendor Tip (+20)", 50)
local directoryButton = makeButton("DirectoryButton", "Directory - 25", 100)
local lensButton = makeButton("LensButton", "Crowd Lens - 75", 150)
local scannerButton = makeButton("ScannerButton", "Beacon Scanner - 175", 200)

tipButton.Activated:Connect(function()
	requestTip:FireServer()
end)
directoryButton.Activated:Connect(function()
	buyUpgrade:FireServer("Directory")
end)
lensButton.Activated:Connect(function()
	buyUpgrade:FireServer("Lens")
end)
scannerButton.Activated:Connect(function()
	buyUpgrade:FireServer("Scanner")
end)

statusUpdate.OnClientEvent:Connect(function(data)
	coins.Text = string.format("Coins: %d", data.coins or 0)
	clue.Text = "Clue: " .. (data.clue or "Loading...")
	message.Text = data.message or ""
	if data.found then
		message.TextColor3 = Color3.fromRGB(133, 255, 157)
		message.Text = "FOUND: Mom is safe. Great work!"
	end
end)

requestStatus:FireServer()
