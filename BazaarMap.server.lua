local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local oldMap = Workspace:FindFirstChild("GeneratedBazaar")
if oldMap then
	oldMap:Destroy()
end

local map = Instance.new("Model")
map.Name = "GeneratedBazaar"
map.Parent = Workspace

local function part(name, size, position, color, material, parent)
	local object = Instance.new("Part")
	object.Name = name
	object.Size = size
	object.Position = position
	object.Anchored = true
	object.Color = color
	object.Material = material or Enum.Material.Concrete
	object.TopSurface = Enum.SurfaceType.Smooth
	object.BottomSurface = Enum.SurfaceType.Smooth
	object.Parent = parent or map
	return object
end

local function label(adornee, text, color)
	local gui = Instance.new("BillboardGui")
	gui.Name = "Sign"
	gui.Adornee = adornee
	gui.Size = UDim2.fromOffset(210, 50)
	gui.StudsOffset = Vector3.new(0, adornee.Size.Y / 2 + 2, 0)
	gui.AlwaysOnTop = true
	gui.Parent = adornee

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.fromScale(1, 1)
	textLabel.BackgroundColor3 = Color3.fromRGB(35, 23, 15)
	textLabel.BackgroundTransparency = 0.12
	textLabel.TextColor3 = color or Color3.fromRGB(255, 238, 179)
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Text = text
	textLabel.Parent = gui
end

local sand = Color3.fromRGB(218, 184, 116)
local darkStone = Color3.fromRGB(67, 48, 39)
local wood = Color3.fromRGB(128, 73, 37)
local red = Color3.fromRGB(155, 48, 40)
local blue = Color3.fromRGB(45, 102, 145)
local gold = Color3.fromRGB(238, 177, 46)

part("BazaarGround", Vector3.new(260, 1, 220), Vector3.new(0, -1, 0), sand)
part("NorthWall", Vector3.new(260, 28, 4), Vector3.new(0, 13, -110), darkStone)
part("SouthWall", Vector3.new(260, 28, 4), Vector3.new(0, 13, 110), darkStone)
part("EastWall", Vector3.new(4, 28, 220), Vector3.new(130, 13, 0), darkStone)
part("WestWall", Vector3.new(4, 28, 220), Vector3.new(-130, 13, 0), darkStone)

local roof = part("MarketCanopy", Vector3.new(250, 2, 210), Vector3.new(0, 42, 0), Color3.fromRGB(86, 48, 41), Enum.Material.Fabric)
roof.Transparency = 0.18

local spawn = Instance.new("SpawnLocation")
spawn.Name = "BazaarSpawn"
spawn.Size = Vector3.new(12, 1, 12)
spawn.Position = Vector3.new(0, 1, 88)
spawn.Anchored = true
spawn.Neutral = true
spawn.Color = gold
spawn.Material = Enum.Material.Neon
spawn.Parent = map
label(spawn, "BAZAAR GATE", Color3.fromRGB(255, 255, 255))

local plaza = part("CentralPlaza", Vector3.new(46, 0.4, 46), Vector3.new(0, 0, 25), Color3.fromRGB(192, 137, 72), Enum.Material.Marble)
label(plaza, "CENTRAL PLAZA", Color3.fromRGB(255, 238, 179))

local districts = {
	{name = "Spice Lane", center = Vector3.new(-78, 0, -52), color = red},
	{name = "Silk Lane", center = Vector3.new(78, 0, -52), color = blue},
	{name = "Lantern Row", center = Vector3.new(-78, 0, 52), color = Color3.fromRGB(184, 74, 154)},
	{name = "Garden Court", center = Vector3.new(78, 0, 52), color = Color3.fromRGB(59, 143, 82)},
}

local districtFolder = Instance.new("Folder")
districtFolder.Name = "Districts"
districtFolder.Parent = map

for districtIndex, district in ipairs(districts) do
	local sign = part(district.name .. "Sign", Vector3.new(18, 1, 4), district.center + Vector3.new(0, 13, 0), district.color, Enum.Material.Wood)
	label(sign, district.name, Color3.fromRGB(255, 255, 255))

	for stallIndex = 1, 6 do
		local side = stallIndex <= 3 and -1 or 1
		local row = ((stallIndex - 1) % 3) - 1
		local stallPosition = district.center + Vector3.new(row * 20, 0, side * 12)
		local stall = Instance.new("Model")
		stall.Name = string.format("%s Stall %d", district.name, stallIndex)
		stall.Parent = districtFolder
		local counter = part("Counter", Vector3.new(13, 3, 5), stallPosition + Vector3.new(0, 1.5, 0), wood, Enum.Material.Wood, stall)
		local canopy = part("Canopy", Vector3.new(15, 1, 8), stallPosition + Vector3.new(0, 8, 0), district.color, Enum.Material.Fabric, stall)
		local postA = part("PostA", Vector3.new(0.7, 8, 0.7), stallPosition + Vector3.new(-6, 4, -3), wood, Enum.Material.Wood, stall)
		local postB = part("PostB", Vector3.new(0.7, 8, 0.7), stallPosition + Vector3.new(6, 4, -3), wood, Enum.Material.Wood, stall)
		local marker = Instance.new("Part")
		marker.Name = "StallMarker"
		marker.Size = Vector3.new(11, 6, 8)
		marker.Position = stallPosition + Vector3.new(0, 3, 0)
		marker.Transparency = 1
		marker.CanCollide = false
		marker.Anchored = true
		marker:SetAttribute("District", district.name)
		marker:SetAttribute("StallNumber", stallIndex)
		marker.Parent = stall
		if stallIndex == 1 then
			label(counter, district.name .. " Market", Color3.fromRGB(255, 238, 179))
		end
	end
end

local fountain = part("Fountain", Vector3.new(14, 2, 14), Vector3.new(0, 1, 25), Color3.fromRGB(98, 145, 173), Enum.Material.Marble)
local fountainWater = part("Water", Vector3.new(9, 0.3, 9), Vector3.new(0, 2.1, 25), Color3.fromRGB(60, 175, 210), Enum.Material.Glass)
label(fountain, "FIND THE RIGHT CLUE", Color3.fromRGB(255, 255, 255))

local info = part("InformationDesk", Vector3.new(12, 3, 8), Vector3.new(-24, 1.5, 25), gold, Enum.Material.Wood)
info:SetAttribute("VendorDesk", true)
label(info, "INFO VENDOR", Color3.fromRGB(48, 30, 15))

local upgrade = part("UpgradeShop", Vector3.new(12, 3, 8), Vector3.new(24, 1.5, 25), Color3.fromRGB(92, 178, 107), Enum.Material.Wood)
upgrade:SetAttribute("UpgradeShop", true)
label(upgrade, "UPGRADE SHOP", Color3.fromRGB(255, 255, 255))

local function createPath(size, position)
	return part("Walkway", size, position, Color3.fromRGB(181, 125, 70), Enum.Material.Cobblestone)
end

createPath(Vector3.new(16, 0.3, 180), Vector3.new(0, 0.1, 0))
createPath(Vector3.new(220, 0.3, 14), Vector3.new(0, 0.1, 0))

for _, player in ipairs(Players:GetPlayers()) do
	player:LoadCharacter()
end
