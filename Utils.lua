local UserInputService = game:GetService("UserInputService")

local Utils = {}

function Utils.applyCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius
    c.Parent = parent
    return c
end

function Utils.applyStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Parent = parent
    return s
end

function Utils.applyListLayout(parent, padding)
    local l = Instance.new("UIListLayout")
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Padding = UDim.new(0, padding)
    l.Parent = parent
    return l
end

function Utils.applyPadding(parent, left, top)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, left)
    p.PaddingTop = UDim.new(0, top)
    p.Parent = parent
    return p
end

function Utils.makeDraggable(handle, target)
    local dragToggle, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function Utils.enableDragScroll(scrollFrame)
    local dragStart, startOffset
    scrollFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            startOffset = scrollFrame.CanvasPosition
        end
    end)
    scrollFrame.InputChanged:Connect(function(input)
        if dragStart and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = dragStart - input.Position
            scrollFrame.CanvasPosition = startOffset + Vector2.new(0, delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragStart, startOffset = nil, nil
        end
    end)
end

function Utils.new(className, properties)
    local obj = Instance.new(className)
    for k, v in pairs(properties) do
        obj[k] = v
    end
    return obj
end

return Utils
