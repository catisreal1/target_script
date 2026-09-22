-- Tự động dọn dẹp UI cũ của Rayfield hoặc script cũ nếu có
if game.CoreGui:FindFirstChild("Rayfield") then game.CoreGui.Rayfield:Destroy() end
if game.CoreGui:FindFirstChild("SmartHunterTSB") then game.CoreGui.SmartHunterTSB:Destroy() end

-- TẢI VÀ KHỞI TẠO RAYFIELD UI (BẢN SIU CẤP)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🔥 SIU CẤP TARGET HUNTER - TSB ⚡",
   LoadingTitle = "ĐANG KHỞI ĐỘNG HỆ THỐNG SĂN MỒI...",
   LoadingSubtitle = "By Game Thủ Sĩu Cấp",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
})

-- Tạo Tab Đi Săn
local MainTab = Window:CreateTab("🔫 Đi Săn Siêu Tốc", nil)

-- Ô nhập tên mục tiêu
local targetInputName = ""
MainTab:CreateInput({
   Name = "Tên mục tiêu",
   PlaceholderText = "Nhập tên @name của thk mà m muốn săn...",
   RemoveTextOnFocus = false,
   Callback = function(text)
      targetInputName = text:gsub("%s+", "")
   end,
})

-- Label hiển thị trạng thái
local StatusLabel = MainTab:CreateLabel("Trạng thái: chờ nó vô server khc")

-- Biến cho tính năng Siu Cấp (Auto-Track)
local autoTrackEnabled = false

MainTab:CreateToggle({
   Name = "⚡ Bật Auto-Track (Tự động bám đuổi ngầm)",
   CurrentValue = false,
   Flag = "AutoTrackToggle",
   Callback = function(Value)
      autoTrackEnabled = Value
      if Value then
         Rayfield:Notify({Title = "⚡ Auto-Track", Content = "Đã bật chế độ tự động săn ngầm!", Duration = 3})
      else
         Rayfield:Notify({Title = "⚡ Auto-Track", Content = "Đã tắt chế độ tự động săn!", Duration = 3})
      end
   end,
})

-- Dịch vụ hệ thống
local TS, Players = game:GetService("TeleportService"), game:GetService("Players")
local LocalPlayer, CurrentGameId = Players.LocalPlayer, game.PlaceId

-- Hàm cập nhật trạng thái kèm thông báo Rayfield
local function updateStatus(statusText)
    StatusLabel:Set("Trạng thái: " .. statusText)
    Rayfield:Notify({
        Title = "🎯 Target Hunter",
        Content = statusText,
        Duration = 3
    })
end

-- Hàm xử lý logic đi săn chung
local function executeHunt()
   if not targetInputName or targetInputName == "" then
      updateStatus("nhập tên vào k thì làm sao tìm đc")
      return false
   end
   
   local success, targetUserId = pcall(function()
      return Players:GetUserIdFromNameAsync(targetInputName)
   end)
   
   if not success or not targetUserId then
      updateStatus("deck thấy thk nào tên như vậy")
      return false
   end
   
   local locateSuccess, _, placeId, instanceId = pcall(function()
      return TS:GetPlayerPlaceInstanceAsync(targetUserId)
   end)
   
   if locateSuccess and instanceId then
      if placeId == CurrentGameId then
         updateStatus("ok thk này đg chs tsb qua xử đi")
         task.wait(0.5)
         pcall(function()
            TS:TeleportToPlaceInstance(placeId, instanceId, LocalPlayer)
         end)
         return true
      else
         updateStatus("nó chán tsb rồi, qua game khác chơi kìa, kệ mẹ nó đi")
         return false
      end
   else
      updateStatus("❌ Nó đã Offline hoặc trong svv r")
      return false
   end
end

-- Nút kích hoạt thủ công
MainTab:CreateButton({
   Name = "⚔️ KÍCH HOẠT ĐUỔI THEO (Thủ Công)",
   Callback = function()
      executeHunt()
   end,
})

-- Vòng lặp chạy ngầm cho tính năng Auto-Track siêu cấp
task.spawn(function()
   while true do
      if autoTrackEnabled and targetInputName ~= "" then
         pcall(function()
            executeHunt()
         end)
         task.wait(5) -- Cứ mỗi 5 giây quét lại một lần tự động
      else
         task.wait(1)
      end
   end
end)

-- Thông báo khi load xong script
Rayfield:Notify({
   Title = "Thành Công!",
   Content = "Bản Siu Cấp kèm Auto-Track đã sẵn sàng!",
   Duration = 4
})