--// You may be wondering if this is obfuscated, and as you can see, it isn't.
local BF_USERNAME = getgenv().BoyfriendUsername
local TP_DISTANCE = getgenv().TeleportDistance
local GF_WALKSPEED = getgenv().GirlfriendWalkSpeed
local GF_RIGHT_OFFSET = getgenv().GirlfriendRightOffset
local GF_FRONT_OFFSET = getgenv().GirlfriendFrontOffset
local GF_AGE = getgenv().GirlfriendAge
local GF_NAME = getgenv().GirlfriendName

getgenv().BoyfriendUsername = nil
getgenv().TeleportDistance = nil
getgenv().GirlfriendWalkSpeed = nil
getgenv().GirlfriendRightOffset = nil
getgenv().GirlfriendFrontOffset = nil
getgenv().GirlfriendAge = nil
getgenv().GirlfriendName = nil

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidrootpart = character:WaitForChild("HumanoidRootPart") or character.PrimaryPart
local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function()
    character = player.Character
    humanoidrootpart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
end)

if character:FindFirstChild'UpperTorso' then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "NOTIFICATION",
        Text = "R15 not supported!",
        Duration = 5
    })
    return
end

local BF = game:GetService("Players"):WaitForChild(BF_USERNAME, 10)

if not BF then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "NOTIFICATION",
        Text = "Boyfriend not found!",
        Duration = 5
    })
    return
end

BF_USERNAME = nil

local isChatLegacy = game:GetService('TextChatService').ChatVersion == Enum.ChatVersion.LegacyChatService
local chatRemote = game:GetService('ReplicatedStorage'):FindFirstChild("SayMessageRequest", true)
local textChannels = game:GetService('TextChatService'):FindFirstChild("TextChannels")
local RBXGeneral = textChannels and textChannels:FindFirstChild("RBXGeneral") or nil
local chatChannel = not isChatLegacy and RBXGeneral

local function chat(str)
    if isChatLegacy then
        chatRemote:FireServer(str, "All")
    else
        chatChannel:SendAsync(str)
    end
end

local Greetings = {
    "Hi!",
    "Hey, how are you?",
    "Hello!",
    "What's up?",
    "Good to see you!",
}

local Age = {
    "I am X years old!",
    "I'm X.",
    "I am X.",
    "X is my age.",
    "X years of wisdom!",
}

local HowAreYouReplies = {
    "I'm doing well, thanks!",
    "Pretty good, how about you?",
    "I'm okay, just busy!",
    "Feeling great, thank you!",
    "Not too bad, and you?"
}

local Name = {
    "I'm X.",
    "You can call me X.",
    "I go by X.",
    "X is what they call me."
}

local FineResponses = {
    "Glad to hear that!",
    "That's great!",
    "Awesome!",
    "Good to know!",
    "Happy to hear it!"
}

local OkayResponses = {
    "Okay!",
    "Alright!",
    "Sure thing!",
    "Got it!"
}

local hugging = false
local following = false

BF.Chatted:Connect(function(msg)
    if msg:lower():find("hug") then
        if msg:lower():find('stop') then
            hugging = false
            chat(OkayResponses[math.random(1, #OkayResponses)])
        else
            hugging = true
            chat(OkayResponses[math.random(1, #OkayResponses)])
        end

    elseif msg:lower():find("follow") then
        if msg:lower():find('stop') then
            following = false
            chat(OkayResponses[math.random(1, #OkayResponses)])
        else
            following = true
            chat(OkayResponses[math.random(1, #OkayResponses)])
        end

    elseif msg:lower():find("hi") or msg:lower():find("hello") or msg:lower():find("hey") then
        chat(Greetings[math.random(1, #Greetings)])

    elseif msg:lower():find("old") and msg:lower():find("you") then
        chat(string.gsub(Age[math.random(1, #Age)], "X", GF_AGE))

    elseif (msg:lower():find("who") and msg:lower():find("you")) or msg:lower():find("name") then
        chat(string.gsub(Name[math.random(1, #Name)], "X", GF_NAME))

    elseif msg:lower():find("how") and (msg:lower():find("you") or msg:lower():find("u")) then
        chat(HowAreYouReplies[math.random(1, #HowAreYouReplies)])

    elseif msg:lower():find("fine") or msg:lower():find("alright") or msg:lower():find("great") then
        chat(FineResponses[math.random(1, #FineResponses)])
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if humanoid then
        local bfCharacter = BF.Character
        if bfCharacter and bfCharacter:FindFirstChild("HumanoidRootPart") then
            if bfCharacter.Humanoid.Jump then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end

            local bfPosition = bfCharacter.HumanoidRootPart.Position
            local offsetPosition = bfPosition + (bfCharacter.HumanoidRootPart.CFrame.LookVector * GF_FRONT_OFFSET) + (bfCharacter.HumanoidRootPart.CFrame.RightVector * GF_RIGHT_OFFSET)
            local distance = (humanoidrootpart.Position - bfPosition).Magnitude
            if distance > TP_DISTANCE then
                humanoidrootpart.CFrame = CFrame.new(offsetPosition)
            elseif not hugging and following then
                humanoid:MoveTo(offsetPosition)
                humanoid.WalkSpeed = GF_WALKSPEED
                for _, anim in pairs(humanoid:GetPlayingAnimationTracks()) do
                    if anim.Animation.AnimationId == "rbxassetid://283545583" then
                        for _,v in pairs(player.Character.Humanoid:GetPlayingAnimationTracks()) do
                            v:Stop()
                        end
                    end
                end
            elseif hugging then
                local alreadyPlayed = false
                for _, anim in pairs(humanoid:GetPlayingAnimationTracks()) do
                    if anim.Animation.AnimationId == "rbxassetid://283545583" then
                        alreadyPlayed = true
                    end
                end
                if not alreadyPlayed then
                    local Anim_1 = Instance.new("Animation")
                    Anim_1.AnimationId = "rbxassetid://283545583"
                    local Anim_2 = Instance.new("Animation")
                    Anim_2.AnimationId = "rbxassetid://225975820"
                    local track_1 = humanoid:LoadAnimation(Anim_1)
                    local track_2 = humanoid:LoadAnimation(Anim_2)
                    track_1:Play()
                    track_2:Play()
                end
                humanoidrootpart.CFrame = CFrame.new(bfPosition + (bfCharacter.HumanoidRootPart.CFrame.LookVector * 1), bfPosition)
            end
        end
    end
end)
