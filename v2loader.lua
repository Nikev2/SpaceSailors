if not game:IsLoaded() then game.Loaded:Wait() end
if game.GameId~=1722988797 then
    error("this isnt space sailors code wont run")
    return
end
local http=game:GetService("HttpService")
if not game:IsLoaded() then game.Loaded:Wait() end
local Init=function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/Nikev2/SpaceSailors/refs/heads/main/v2.lua'))()
end
local FileName="SS.JSON"
local AutoFarm
if not isfile(FileName) then
    Init()
end
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/7yhx/kwargs_Ui_Library/main/source.lua"))()
local MainData
local a=readfile(FileName)
local data=http:JSONDecode(a)
MainData=data
AutoFarm=MainData.AutoFarm
function SaveData()
    local data=http:JSONEncode(MainData)
    delfile(FileName)
    writefile(FileName,data)
    MainData=http:JSONDecode(readfile(FileName))
    Init()
end


local UI = Lib:Create{
   Theme = "Dark", -- or any other theme
   Size = UDim2.new(0, 555, 0, 400) -- default
}
local Main = UI:Tab{
   Name = "Space Sailors"
}
local Divider = Main:Divider{
   Name = "Auto Farm"
}
local QuitDivider = Main:Divider{
   Name = "Quit"
}
local autofarm=Divider:Toggle{
    Name="Auto Farm",
    Description="Don't spam it if disabled rejoin or wait for the current auto farm to complete",
    State=AutoFarm,
    Callback=function(state)
        if state then
            MainData.AutoFarm=true
            SaveData()
        else
            MainData.AutoFarm=false
            SaveData()
        end
        
    end
}
local Quit = QuitDivider:Button{
   Name = "Close Ui",
   Callback = function()
       UI:Quit{
           Message = "Destroyed", -- closing message
           Length = 1 -- seconds the closing message shows for
       }
   end
}
Init()
