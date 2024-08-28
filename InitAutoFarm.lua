function SendNotif(title, text, delay)
    game.StarterGui:SetCore("SendNotification", {Title = title,Text = text,Duration = delay})
end

function getgenv()
    return _G
end
if getgenv().Connections==nil then
getgenv().Connections={}
else
    for _,Connection in pairs(getgenv().Connections) do 
        Connection:Disconnect()
    end 
    getgenv().Connections={}
end
local TeleportService = game:GetService("TeleportService")
local Collected=false
local FileName="SS.JSON"
local DefaultData={
    AutoFarm=false
}
local MainData
local AutoFarm
local http=game:GetService("HttpService")
if game.GameId~=1722988797 then
    print("this isnt space sailors")
    return
end
if not isfile(FileName) then
    local data=http:JSONEncode(DefaultData)
    writefile(FileName,data)
    local a=readfile(FileName)
    data=http:JSONDecode(a)
    MainData=data
else
    local a=readfile(FileName)
    local data=http:JSONDecode(a)
    MainData=data
    AutoFarm=MainData.AutoFarm
end
print(MainData.AutoFarm)
if not game:IsLoaded() then game.Loaded:Wait() end
local Planets = {
    [5534753074] = {"LanderAscentStage", "Lunar", " Sample", "Lander", "GatewayRemote"},
    [6669650377] = {"UpperStage", "Cererian", " Sample", "CeresLander", "DSTRemote"},
    [6119982580] = {"MidUpperStage", "Iron", " Oxide", "MarsLander", "DSTRemote"},
}

function GetNames()
    local PlaceId = game.PlaceId
    local rval
    for i, v in pairs(Planets) do
        if PlaceId == i then
            rval = v
        end
    end
    if rval == nil then
        return false
    else
        return rval
    end
end
local Cashout=game:GetService("ReplicatedStorage"):FindFirstChild("Cashout")
if Cashout then 
Cashout:FireServer()
SendNotif('Cashout Success','Cashed out ignore the green button',3)  
end
if not AutoFarm then 
print('auto farm is not enabled')    
return end
if not GetNames() then 
wait(3)
local t={
5534753074,
6669650377,
6119982580,
}
local id=t[math.random(1,#t)]
TeleportService:Teleport(id)    
return 
end


local UIS = game:GetService("UserInputService")
local plr = game.Players.LocalPlayer
local Char = plr.Character
local hum = Char:FindFirstChild("Humanoid")
while task.wait() do
    if hum then break end
end
function GetLander()
    local PlanetName=GetNames()[4]
    local l
    for i,v in pairs(workspace:GetChildren()) do
        if v.Name==PlanetName then
            if v.LanderOwner.Value==plr.Name then
                l=v
            end
        end
    end
    return l
end

function GetTool()
for i,v in pairs(plr.Backpack:GetChildren()) do
   
       if v.Name:sub(1,7) == "Pick Up" then
           return v
          
         
    end   
end
end

function GetPrompt()
  
    
for i,v in pairs(Workspace:GetChildren()) do
if v:FindFirstChild("LanderOwner") then
    if v:FindFirstChild("LanderOwner").Value == plr.Name  then
           
        return v[GetNames()[1]].Deposit.ProximityPrompt 
       
    end    
end    
end

end

function CollectSamples()
    local Prompt=GetPrompt()
    local Tool = GetTool()
    local PickUp = Tool.PickUp
    local Amount = Tool.Amount
    local AmountStored = Prompt.Parent.Parent.Parent.ResourceValues.Storage
    local Capacity = AmountStored.Parent.Capacity
    
    repeat
    
    PickUp:FireServer()
    while task.wait() do
        if Collected then break end
    end
    task.wait()
    Collected=false
    until AmountStored.Value==Capacity.Value           
   
    game:GetService("ReplicatedStorage")[GetNames()[5]]:FireServer(plr.Name)
end
local plr=game.Players.LocalPlayer
local Warp
for i,v in pairs(game.ReplicatedStorage:GetDescendants()) do
    if v.Name=="WarpLandRemote" then
        Warp=v.Parent:FindFirstChild(v.Name)
        break
    else 
    Warp=false
    end
end
if Warp then
Warp:FireServer(plr.Name)
end
SendNotif('Waiting to land','autofarm will begin when you land',5)
local landed=GetLander().Landed
landed:GetPropertyChangedSignal("Value"):Wait()
SendNotif('Autofarming','started to begin autofarming',5)
wait(3)
function RockAdded()
local Rock=plr.Backpack:FindFirstChild(GetNames()[2]..GetNames()[3])
if not Rock then return end
hum:EquipTool(Rock)
fireproximityprompt(GetPrompt())
Collected=true
end
table.insert(getgenv().Connections,plr.Backpack.ChildAdded:Connect(RockAdded))
CollectSamples()


