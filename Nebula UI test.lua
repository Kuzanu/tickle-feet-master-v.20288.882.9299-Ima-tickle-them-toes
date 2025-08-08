-- Nebula UI Test
local Nebula = {}
Nebula.__index = Nebula

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// Create Window
function Nebula:CreateWindow(props)
    local self = setmetatable({}, Nebula)
    
    -- ScreenGui
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Parent = PlayerGui
    self.Gui.ResetOnSpawn = false
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 500, 0, 300)
    self.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.Gui
    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 8)
    
    -- Draggable
    if props.Draggable then
        local dragging, dragStart, startPos
        self.MainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = self.MainFrame.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        self.MainFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TopBar.Parent = self.MainFrame
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = props.Title .. " | v" .. props.Version .. " - " .. props.Subtitle
    Title.TextColor3 = Color3.new(1,1,1)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.Parent = TopBar

    -- Minimize Button
    local MiniButton = Instance.new("ImageButton")
    MiniButton.Size = UDim2.new(0, 24, 0, 24)
    MiniButton.Position = UDim2.new(1, -28, 0.5, -12)
    MiniButton.BackgroundTransparency = 1
    MiniButton.Image = props.MiniButtonIcon or "rbxassetid://0"
    MiniButton.Parent = TopBar

    MiniButton.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = not self.MainFrame.Visible
    end)

    return self
end

--// Create Tab
function Nebula:CreateTab(name)
    local Tab = {}
    Tab.__index = Tab
    setmetatable(Tab, {__index = self})

    -- Container
    Tab.Frame = Instance.new("Frame")
    Tab.Frame.Size = UDim2.new(1, 0, 1, -30)
    Tab.Frame.Position = UDim2.new(0, 0, 0, 30)
    Tab.Frame.BackgroundTransparency = 1
    Tab.Frame.Parent = self.MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = name
    Title.TextColor3 = Color3.new(1,1,1)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = Tab.Frame

    return Tab
end

--// Create Toggle
function Nebula.CreateToggle(self, props)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.BackgroundTransparency = 1
    Frame.Parent = self.Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Text = props.Title .. " - " .. props.Description
    Label.TextColor3 = Color3.new(1,1,1)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0, 50, 0, 24)
    ToggleFrame.Position = UDim2.new(1, -50, 0.5, -12)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    ToggleFrame.Parent = Frame
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 20, 0, 20)
    Knob.Position = UDim2.new(0, 2, 0.5, -10)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = ToggleFrame
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local state = props.State == "on"
    if state then
        Knob.Position = UDim2.new(1, -22, 0.5, -10)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end

    local function toggleFunc()
        state = not state
        if state then
            TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}):Play()
        else
            TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        end
        if props.Function then props.Function(state) end
    end

    ToggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            toggleFunc()
        end
    end)
end

--// Create Button
function Nebula.CreateButton(self, props)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 120, 0, 30)
    Btn.Text = props.Title
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Btn.Parent = self.Frame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseButton1Click:Connect(function()
        if props.Function then props.Function() end
    end)
end

--// Create Slider
function Nebula.CreateSlider(self, props)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 40)
    Frame.BackgroundTransparency = 1
    Frame.Parent = self.Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0.5, 0)
    Label.Text = props.Title
    Label.TextColor3 = Color3.new(1,1,1)
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, 0, 0, 6)
    SliderBack.Position = UDim2.new(0, 0, 0.7, 0)
    SliderBack.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    SliderBack.Parent = Frame
    Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(1, 0)

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    SliderFill.Parent = SliderBack
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor(props.Min + (props.Max - props.Min) * pos)
            if props.Function then props.Function(value) end
        end
    end)
end

return Nebula
