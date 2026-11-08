local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local map = Workspace:WaitForChild("GeneratedBazaar", 20)
if not map then
	error("GeneratedBazaar was not created by BazaarMap.server.lua")
end
map:SetAttribute("VirtualCrowdSize", 100000)

local remotes = ReplicatedStorage:FindFirstChild("BazaarRemotes") or Instance.new("Folder")
remotes.Name = "BazaarRemotes"
remotes.Parent = ReplicatedStorage

local function remote(name)
	local event = remotes:FindFirstChild(name) or Instance.new("RemoteEvent")
	event.Name = name
	event.Parent = remotes
	return event
end

local requestTip = remote("RequestTip")
local buyUpgrade = remote("BuyUpgrade")
local requestStatus = remote("RequestStatus")
local statusUpdate = remote("StatusUpdate")

local districts = {"Spice Lane", "Silk Lane", "Lantern Row", "Garden Court"}
local markers = {}
for _, object in ipairs(map:GetDescendants()) do
	if object.Name == "StallMarker" then
		table.insert(markers, object)
	end
end

local targetMarker = markers[math.random(1, #markers)]
local targetDistrict = targetMarker:GetAttribute("District")
local targetStall = targetMarker:GetAttribute("StallNumber")
local targetModel = Instance.new("Model")
targetModel.Name = "MomsShopper"
targetModel.Parent = map

local body = Instance.new("Part")
body.Name = "Body"
body.Size = Vector3.new(2.2, 4, 1.2)
body.Position = targetMarker.Position + Vector3.new(0, 3.2, 0)
body.Anchored = true
body.CanCollide = false
body.Color = Color3.fromRGB(210, 111, 137)
body.Parent = targetModel

local head = Instance.new("Part")
head.Name = "Head"
head.Shape = Enum.PartType.Ball
head.Size = Vector3.new(1.8, 1.8, 1.8)
head.Position = targetMarker.Position + Vector3.new(0, 6.1, 0)
head.Anchored = true
head.CanCollide = false
head.Color = Color3.fromRGB(245, 190, 145)
head.Parent = targetModel

local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Talk"
prompt.ObjectText = "Shopper"
prompt.HoldDuration = 1
prompt.MaxActivationDistance = 10
prompt.Parent = body

local tag = Instance.new("BillboardGui")
tag.Size = UDim2.fromOffset(180, 42)
tag.StudsOffset = Vector3.new(0, 3, 0)
tag.AlwaysOnTop = true
tag.Adornee = head
tag.Parent = targetModel
local tagText = Instance.new("TextLabel")
tagText.Size = UDim2.fromScale(1, 1)
tagText.BackgroundColor3 = Color3.fromRGB(35, 23, 15)
tagText.TextColor3 = Color3.fromRGB(255, 238, 179)
tagText.TextScaled = true
tagText.Font = Enum.Font.GothamBold
tagText.Text = "SHOPPER"
tagText.Parent = tag

local playerData = {}
local upgradeCosts = {Directory = 25, Lens = 75, Scanner = 175}
local tipCooldown = 20

local function getData(player)
	if not playerData[player] then
		playerData[player] = {coins = 0, upgrades = {Directory = false, Lens = false, Scanner = false}, lastTip = 0, found = false}
	end
	return playerData[player]
end

local function clueFor(data)
	if data.upgrades.Scanner then
		return string.format("Beacon: Mom is at %s, stall %d. Look for the pink shopper.", targetDistrict, targetStall)
	elseif data.upgrades.Lens then
		return string.format("Lens reading: Mom is somewhere in %s.", targetDistrict)
	elseif data.upgrades.Directory then
		return string.format("Directory entry: Mom is in one of the four bazaar districts. Start with %s.", districts[1])
	end
	return "Ask the information vendor, then visit the upgrade shop to narrow the search."
end

local function sendStatus(player, message)
	local data = getData(player)
	statusUpdate:FireClient(player, {coins = data.coins, clue = clueFor(data), message = message, found = data.found})
end

requestStatus.OnServerEvent:Connect(function(player)
	sendStatus(player, "Search the bazaar and follow your clue.")
end)

requestTip.OnServerEvent:Connect(function(player)
	local data = getData(player)
	local now = os.clock()
	if now - data.lastTip < tipCooldown then
		sendStatus(player, string.format("The vendor needs %.0f more seconds before another tip.", tipCooldown - (now - data.lastTip)))
		return
	end
	data.lastTip = now
	data.coins += 20
	sendStatus(player, "Vendor tip earned: +20 coins. Visit the Upgrade Shop.")
end)

buyUpgrade.OnServerEvent:Connect(function(player, upgradeName)
	if typeof(upgradeName) ~= "string" or not upgradeCosts[upgradeName] then
		return
	end
	local data = getData(player)
	if data.upgrades[upgradeName] then
		sendStatus(player, "You already own this upgrade.")
		return
	end
	local cost = upgradeCosts[upgradeName]
	if data.coins < cost then
		sendStatus(player, string.format("You need %d coins for the %s.", cost, upgradeName))
		return
	end
	data.coins -= cost
	data.upgrades[upgradeName] = true
	sendStatus(player, "Upgrade purchased. Your clue is more precise.")
end)

prompt.Triggered:Connect(function(player)
	local data = getData(player)
	if data.upgrades.Scanner then
		data.found = true
		sendStatus(player, "You found Mom! The bazaar search is complete.")
	else
		sendStatus(player, "This shopper is not ready to confirm your search. Buy the Beacon Scanner first.")
	end
end)

Players.PlayerAdded:Connect(function(player)
	getData(player)
	player.CharacterAdded:Connect(function()
		task.wait(1)
		sendStatus(player, "Welcome to the Big Bazaar. Find Mom.")
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	playerData[player] = nil
end)

for _, player in ipairs(Players:GetPlayers()) do
	getData(player)
end
