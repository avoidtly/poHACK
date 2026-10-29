-- poHACK | Hitbox Expander | Blox Fruits
-- paste and inject, works on all players

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local HITBOX_SIZE = Vector3.new(20, 20, 20) -- change this to make it bigger or smaller

local function expandHitbox(character)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name == "HumanoidRootPart" then
            part.Size = HITBOX_SIZE
            part.Transparency = 0.7 -- so you can see it, set to 1 to hide
        end
    end
end

-- expand all current players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= lp then
        if player.Character then
            expandHitbox(player.Character)
        end
        player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            expandHitbox(char)
        end)
    end
end

-- catch new players joining
Players.PlayerAdded:Connect(function(player)
    if player ~= lp then
        player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            expandHitbox(char)
        end)
    end
end)

print("[poHACK] hitbox expander active — size: " .. tostring(HITBOX_SIZE))
