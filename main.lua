
if game.CoreGui:FindFirstChild("SmartHunterTSB") then
    game.CoreGui.SmartHunterTSB:Destroy()
end


local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name, ScreenGui.ResetOnSpawn = "SmartHunterTSB", false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name, MainFrame.Size, MainFrame.Position = "MainFrame", UDim2.new(0, 260, 0, 190), UDim2.new(0.05, 0, 0.35, 0)
MainFrame.BackgroundColor3, MainFrame.BorderSizePixel, MainFrame.Active, MainFrame.Draggable = Color3.fromRGB(20, 20, 20), 0, true, true


local Title = Instance.new("TextLabel", MainFrame)
Title.Size, Title.BackgroundColor3, Title.BorderSizePixel = UDim2.new(1, 0, 0, 35), Color3.fromRGB(150, 0, 0), 0
Title.Font, Title.Text, Title.TextColor3, Title.TextSize = Enum.Font.SourceSansBold, "target hunter", Color3.new(1, 1, 1), 14


local InputTarget = Instance.new("TextBox", MainFrame)
InputTarget.Size, InputTarget.Position, InputTarget.BackgroundColor3, InputTarget.BorderSizePixel = UDim2.new(0.9, 0, 0, 35), UDim2.new(0.05, 0, 0.25, 0), Color3.fromRGB(45, 45, 45), 0
InputTarget.Font, InputTarget.PlaceholderText, InputTarget.Text, InputTarget.TextColor3, InputTarget.TextSize = Enum.Font.SourceSans, "Nhập tên @name của thk mà m muốn săn", "", Color3.new(1, 1, 1), 13


local ActionBtn = Instance.new("TextButton", MainFrame)
ActionBtn.Size, ActionBtn.Position, ActionBtn.BackgroundColor3, ActionBtn.BorderSizePixel = UDim2.new(0.9, 0, 0, 40), UDim2.new(0.05, 0, 0.5, 0), Color3.fromRGB(180, 0, 0), 0
ActionBtn.Font, ActionBtn.Text, ActionBtn.TextColor3, ActionBtn.TextSize = Enum.Font.SourceSansBold, "ok đg tra đợi chút", Color3.new(1, 1, 1), 14


local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size, StatusLabel.Position, StatusLabel.BackgroundTransparency = UDim2.new(0.9, 0, 0, 30), UDim2.new(0.05, 0, 0.75, 0), true
StatusLabel.Font, StatusLabel.Text, StatusLabel.TextColor3, StatusLabel.TextSize = Enum.Font.SourceSansItalic, "chờ nó vô server khc", Color3.fromRGB(160, 160, 160), 12


local TS, Players = game:GetService("TeleportService"), game:GetService("Players")
local LocalPlayer, CurrentGameId = Players.LocalPlayer, game.PlaceId


local function setButtonState(text, color, statusText, statusColor)
    ActionBtn.Text = text
    ActionBtn.BackgroundColor3 = color
    StatusLabel.Text = statusText
    if statusColor then StatusLabel.TextColor3 = statusColor end
end

ActionBtn.MouseButton1Click:Connect(function()
    local targetName = InputTarget.Text:gsub("%s+", "")
    if targetName == "" then
        StatusLabel.Text = "nhập tên vào k thì làm sao tìm đc"
        return
    end
    
    setButtonState("ĐANG tìm , đợi đi", Color3.fromRGB(100, 100, 100), "🔍 Đang check đợi chút")
    
    local success, targetUserId = pcall(function()
        return Players:GetUserIdFromNameAsync(targetName)
    end)
    
    if not success or not targetUserId then
        setButtonState("ok r", Color3.fromRGB(180, 0, 0), "deck thấy thk nào tên như vậy")
        return
    end
    
    StatusLabel.Text = "đg check thk kia chs game gì"
    
    local locateSuccess, _, placeId, instanceId = pcall(function()
        return TS:GetPlayerPlaceInstanceAsync(targetUserId)
    end)
    
    if locateSuccess and instanceId then
        if placeId == CurrentGameId then
            setButtonState("sắp tele", Color3.fromRGB(46, 125, 50), " ok thk này đg chs tsb qua xử đi")
            task.wait(0.5)
            pcall(function()
                TS:TeleportToPlaceInstance(placeId, instanceId, LocalPlayer)
            end)
        else
            setButtonState("fail r", Color3.fromRGB(40, 40, 40), "thk đó chs game khc r", Color3.fromRGB(255, 150, 0))
            task.spawn(function()
                task.wait(3)
                setButtonState("wait", Color3.fromRGB(180, 0, 0), "Đang chờ mục tiêu...", Color3.fromRGB(160, 160, 160))
            end)
        end
    else
        setButtonState("đg check sv", Color3.fromRGB(180, 0, 0), "❌ Nó đã Offline hoặc trong svv r")
    end
end)