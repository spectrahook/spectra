-- hello skids!
-- created by liebert
local replicated_storage = game:GetService("ReplicatedStorage")
local collection_service = game:GetService("CollectionService")
local players = game:GetService("Players")
local run_service = game:GetService("RunService")

local lplr = players.LocalPlayer
local current_camera = workspace.CurrentCamera

local hatch = getupvalue(getupvalue(getconnections(replicated_storage.GameEvents.PetEggService.OnClientEvent)[1].Function, 1), 2)
local egg_models = getupvalue(hatch, 1)
local egg_pets = getupvalue(hatch, 2)

local esp_cache = {}
local active_eggs = {}

local function get_object(object_id)
	for _, v in egg_models do
		if v:GetAttribute("OBJECT_UUID") == object_id then
			return v
		end
	end
end

local function update_esp(object_id, pet_name)
	local object = get_object(object_id)
	if not object or not esp_cache[object_id] then return end

	local egg_name = object:GetAttribute("egg_name")
	esp_cache[object_id].Text = `{pet_name}`
end

local function add_esp(object)
	if object:GetAttribute("OWNER") ~= lplr.Name then return end

	local egg_name = object:GetAttribute("egg_name")
	local pet_name = egg_pets[object:GetAttribute("OBJECT_UUID")]

	local object_id = object:GetAttribute("OBJECT_UUID")
	if not object_id then return end

	local label = Drawing.new("Text")
	label.Text = `{pet_name or "?"}`
	label.Size = 18
	label.Color = Color3.new(1, 1, 1)
	label.Outline = true
	label.OutlineColor = Color3.new(0, 0, 0)
	label.Center = true
	label.Visible = false

	esp_cache[object_id] = label
	active_eggs[object_id] = object
end

local function remove_esp(object)
	if object:GetAttribute("OWNER") ~= lplr.Name then return end

	local object_id = object:GetAttribute("OBJECT_UUID")
	if esp_cache[object_id] then
		esp_cache[object_id]:Remove()
		esp_cache[object_id] = nil
	end

	active_eggs[object_id] = nil
end

local function update_all_esp()
	for object_id, object in active_eggs do
		if not object or not object:IsDescendantOf(workspace) then
			active_eggs[object_id] = nil
			if esp_cache[object_id] then
				esp_cache[object_id].Visible = false
			end
			continue
		end

		local label = esp_cache[object_id]
		if label then
			local pos, on_screen = current_camera:WorldToViewportPoint(object:GetPivot().Position)
			if on_screen then
				label.Position = Vector2.new(pos.X, pos.Y)
				label.Visible = true
			else
				label.Visible = false
			end
		end
	end
end

for _, object in collection_service:GetTagged("PetEggServer") do
	task.spawn(add_esp, object)
end

collection_service:GetInstanceAddedSignal("PetEggServer"):Connect(add_esp)
collection_service:GetInstanceRemovedSignal("PetEggServer"):Connect(remove_esp)

local old
old = hookfunction(getconnections(replicated_storage.GameEvents.EggReadyToHatch_RE.OnClientEvent)[1].Function, newcclosure(function(object_id, pet_name)
	update_esp(object_id, pet_name)
	return old(object_id, pet_name)
end))

run_service.PreRender:Connect(update_all_esp)
queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/spectrahook/spectra/refs/heads/main/Utility/Grow%20A%20Garden/GetPetName.lua",true))()')
