local player = game.Players.LocalPlayer
local player_gui = player:WaitForChild("PlayerGui")

local screen_gui = Instance.new("ScreenGui")
screen_gui.Name = "spectrahook"
screen_gui.Parent = player_gui
screen_gui.ResetOnSpawn = false
screen_gui.IgnoreGuiInset = true

local frame = Instance.new("Frame")
frame.Parent = screen_gui
frame.Position = UDim2.new(1, -90, 0, 10)
frame.Size = UDim2.new(0, 60, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0, 0, 0)
stroke.Thickness = 2
stroke.Transparency = 0.7

local button = Instance.new("TextButton")
button.Name = "OpenButton"
button.Parent = frame
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.Position = UDim2.new(0.5, 0, 0.5, 0)
button.Size = UDim2.new(0, 44, 0, 24)
button.Text = "Open"
button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 15
button.BorderSizePixel = 0

Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

local button_hover = Instance.new("UIStroke", button)
button_hover.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
button_hover.Color = Color3.new(1, 1, 1)
button_hover.Thickness = 1
button_hover.Transparency = 1

local dragging = false
local drag_start, start_pos

local function start_drag(input)
    dragging = true
    drag_start = input.Position
    start_pos = frame.Position
end

local function update_drag(input)
    if not dragging then return end
    local delta = input.Position - drag_start
    local size = screen_gui.AbsoluteSize
    local new_x = math.clamp(start_pos.X.Offset + delta.X, 0, size.X - frame.Size.X.Offset)
    local new_y = math.clamp(start_pos.Y.Offset + delta.Y, 0, size.Y - frame.Size.Y.Offset)
    frame.Position = UDim2.new(0, new_x, 0, new_y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        start_drag(input)
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update_drag(input)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

button.MouseEnter:Connect(function()
    button_hover.Transparency = 0.8
    button.BackgroundColor3 = Color3.fromRGB(0, 140, 235)
end)

button.MouseLeave:Connect(function()
    button_hover.Transparency = 1
    button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
end)

button.MouseButton1Click:Connect(function()
    Library:Toggle()
end)
