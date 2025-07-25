﻿function MODULE:EntityTakeDamage(entity, dmgInfo)
    if entity:isDoor() and (entity.liaNextBreach or 0) < CurTime() then
        local handle = entity:LookupBone("handle")
        if handle and dmgInfo:IsBulletDamage() then
            local client = dmgInfo:GetAttacker()
            local position = dmgInfo:GetDamagePosition()
            hook.Run("LockShotAttempt", client, entity, dmgInfo)
            if client:GetEyeTrace().Entity ~= entity or client:GetPos():Distance(position) > 100 then return end
            if IsValid(client) then
                if hook.Run("CanPlayerBustLock", client, entity) == false then return end
                local weapon = client:GetActiveWeapon()
                if IsValid(weapon) and weapon:GetClass() == "weapon_shotgun" then
                    entity:EmitSound("physics/wood/wood_crate_break" .. math.random(1, 5) .. ".wav", 150)
                    entity:blastDoor(client:GetAimVector() * 380)
                    local effect = EffectData()
                    effect:SetStart(position)
                    effect:SetOrigin(position)
                    effect:SetScale(10)
                    util.Effect("GlassImpact", effect, true, true)
                    hook.Run("LockShotBreach", client, entity)
                    hook.Run("LockShotSuccess", client, entity)
                    return
                end
            end

            if IsValid(client) and position:Distance(entity:GetBonePosition(handle)) <= 12 then
                if hook.Run("CanPlayerBustLock", client, entity) == false then return end
                local effect = EffectData()
                effect:SetStart(position)
                effect:SetOrigin(position)
                effect:SetScale(2)
                util.Effect("GlassImpact", effect)
                local name = client:UniqueID() .. CurTime()
                client:SetName(name)
                entity.liaOldSpeed = entity.liaOldSpeed or entity:GetKeyValues().speed or 100
                entity:Fire("setspeed", entity.liaOldSpeed * 3.5)
                entity:Fire("unlock")
                entity:Fire("openawayfrom", name)
                entity:EmitSound("physics/wood/wood_plank_break" .. math.random(1, 4) .. ".wav", 100, 120)
                hook.Run("LockShotBreach", client, entity)
                hook.Run("LockShotSuccess", client, entity)
                entity.liaNextBreach = CurTime() + 1
                timer.Simple(0.5, function() if IsValid(entity) then entity:Fire("setspeed", entity.liaOldSpeed) end end)
            end

            hook.Run("LockShotFailed", client, entity, dmgInfo)
        end
    end
end
