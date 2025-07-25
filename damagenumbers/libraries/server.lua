﻿function MODULE:PostEntityTakeDamage(ent, dmgInfo, tookDamage)
    if not tookDamage or not ent:IsPlayer() then return end
    local atk = dmgInfo:GetAttacker()
    if not IsValid(atk) or not atk:IsPlayer() then return end
    local dmg = math.ceil(dmgInfo:GetDamage())
    net.Start("expDamageNumbers")
    net.WriteEntity(ent)
    net.WriteUInt(dmg, 32)
    net.Send({ent, atk})
    hook.Run("DamageNumbersSent", atk, ent, dmg)
end

local networkStrings = {"expDamageNumbers"}
for _, netString in ipairs(networkStrings) do
    util.AddNetworkString(netString)
end
