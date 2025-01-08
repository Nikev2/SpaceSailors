if not game:IsLoaded() then game.Loaded:Wait() end
function SendNotif(title, text, delay)
    game.StarterGui:SetCore("SendNotification", {Title = title,Text = text,Duration = delay})
end
function IsInGateway()
    return game.PlaceId==5515926734
end
function getgenv() --- SynapseX fucking betrayed us and took this exclusive function with them so I interpreted this
    return _G
end
--------Roblox wont add a simple fucking function that helps roblox devs
function GetChildrenOfClass(parent, ClassName)
    local childrenOfClass = {}
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA(ClassName) then
            table.insert(childrenOfClass, child)
        end
    end
    return childrenOfClass
end
---------------------------------------


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
local plr = game.Players.LocalPlayer
local Char = plr.Character
local hum = Char:FindFirstChild("Humanoid")
while task.wait() do  --waits for char to load without using wait i could use character added but its too buggy
    if game.Players.LocalPlayer.Character~=nil then 
        if hum then break end
    end
end

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

if not game:IsLoaded() then game.Loaded:Wait() end
local Planets = {
     ---Added LLAMA update for moon
    [5534753074] = {
        {"LanderAscentStage", "Lunar", " Sample", "Lander2", "GatewayRemote"},
        {"LLAMA", "Lunar", " Sample", "LLAMA", "GatewayRemote"}
    }, 
    [6669650377] = {
        {"UpperStage", "Cererian", " Sample", "CeresLander", "DSTRemote"}
    }, --mars
    [6119982580] = {
        {"MidUpperStage", "Iron", " Oxide", "MarsLander", "DSTRemote"},
        {"AftCargoHold", "Iron", " Oxide", "Aresonius", "DSTRemote"}
    }, --ceres
}
local SpecialLanders={
        [5515926734]={"LLAMA","ToMoonRemote"},
        [6458953928]={"Aresonius","ToMarsRemote"},
        [6669650377]={"none","ToCeresRemote"}
        
}

local Get_Names=function()
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
function GetSpecialLanderName() -- includes its remote
    
    local specialname
    for id,name in pairs(SpecialLanders) do
        if game.PlaceId==id then
            specialname=name
            break
        end
    end
    return specialname
end

function SpecialLanderOwnership()
    local bool
    
    for i,val in pairs(GetChildrenOfClass(Char,"BoolValue")) do
        
       local s,e = (function() return string.find(val.Name,"Access") end)()
       
       if (s or e) then  
            bool=val.Value
       end
        
        
        
    end 
    return bool
end

local Cashout=game:GetService("ReplicatedStorage"):FindFirstChild("Cashout")
if Cashout then 
Cashout:FireServer()
SendNotif('Cashout Success','Cashed out ignore the green button',3)  
end
if not AutoFarm then 
print('auto farm is not enabled')    
return end


function GetSpecialLanderByRemote(RemoteName)
     local specialname
    for id,Name in pairs(SpecialLanders) do
        if Name[2]==RemoteName then
            specialname=Name
        end
    end
    return specialname
end

if not Get_Names() then 
    
    local Pids={ ---I'm too lazy to optimize my code !1!1!
    5534753074, --moon
    6119982580, --mars
    6669650377, --ceres
    
    }

    
    if game.PlaceId==5000143962 then
        TeleportService:Teleport(5515926734)
    end
  
        ---Gives you the finest shit if you own it
        print("lander exists")
        if GetSpecialLanderName()[1]~=nil then --ignore ceres
            ----Teleport to a Random Planet
            local t={}
            
            for id,Table in pairs(SpecialLanders) do

                table.insert(t,Table[2])
            end
            local RemoteName=t[math.random(1,#t)]
            local CustomLander=GetSpecialLanderByRemote(tostring(RemoteName))[1]
            game.ReplicatedStorage[GetSpecialLanderName()[2]]:FireServer(GetSpecialLanderName()[1])
        end
    return
end  
    





local UIS = game:GetService("UserInputService")



function IsMultipleLanderOption()
    if typeof(Get_Names()[1])=="table" then
        return true
    else
        return false
    end
end

function GetLander()
    
    
     
    
    
    for i,l in pairs(GetChildrenOfClass(workspace,"Model")) do

        if _G.lander~=nil and _G.PlanetInstanceNames~=nil then ---Changed lander to global for optimization added PlanetInstanceNames due to old code using it
            break --The Optimization is just 3 fucking lines
        end

        if IsMultipleLanderOption() then -- added this due to the lander shit update
            local LanderOptions=Get_Names()
            for i,LanderOption in pairs(Get_Names()) do
                if l.Name==LanderOption[4] then
                    if l:FindFirstChild("LanderOwner").Value==plr.Name then
                        _G.lander=l -- doesn't use getgenv due to it being newer than synapseX shutdown
                        _G.PlanetInstanceNames=LanderOption
                        break
                    end
                end
            end
            if _G.lander then break end
        end
        
    end
    return _G.lander 
end

function GetTool()
for i,v in pairs(plr.Backpack:GetChildren()) do
   
       if v.Name:sub(1,7) == "Pick Up" then
           return v
          
         
    end   
end
end



function GetNames() -- A way to keep the old code from bitching on how it can't understand the code I decided to spoil it this way.
    return _G.PlanetInstanceNames
end

function GetPrompt() return GetLander()[GetNames()[1]].Deposit.ProximityPrompt end

function CollectSamples()
    local Prompt=GetPrompt()
    local Tool = GetTool()
    local PickUp = Tool.PickUp
    local Amount = Tool.Amount
    local AmountStored = Prompt.Parent.Parent.Parent.ResourceValues.Storage
    local Capacity = AmountStored.Parent.Capacity
    
    repeat
        if GetLander().Name=="Aresonius" then
        hum.Sit=false
        end
        PickUp:FireServer()
        while task.wait() do
            if Collected then break end
        end
        task.wait()
        Collected=false

    until AmountStored.Value>=Capacity.Value           
   
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

function QuickTpToPrompt(prompt)
    if GetLander().Name=="Aresonius" then
        hum.Sit=false
        task.wait()
        Char.HumanoidRootPart.CFrame=prompt.Parent.CFrame
    end
end

local landed=GetLander().Landed

if not landed.Value then --Makes it run if you alredy landed and wanted to execute the script
    landed:GetPropertyChangedSignal("Value"):Wait()
end

SendNotif('Autofarming','started to autofarm',5)
wait(1)

local d1=1
local d2=0

function RockAdded()
    
    local Rock=plr.Backpack:FindFirstChild(GetNames()[2]..GetNames()[3])
    if not Rock then return end
    local function dd1()
            hum:EquipTool(Rock)
            fireproximityprompt(GetPrompt())
            QuickTpToPrompt(GetPrompt())
    end
    -----the new mars lander has two deposits trying to figure it out but for right now its just one
    dd1()
    Collected=true 
end
table.insert(getgenv().Connections,plr.Backpack.ChildAdded:Connect(RockAdded))
CollectSamples()

