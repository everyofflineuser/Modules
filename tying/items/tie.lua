﻿ITEM.name = "Restraints"
ITEM.desc = "A pair of ties used in the process of restraining individuals by binding their hands."
ITEM.model = "models/items/crossbowrounds.mdl"
ITEM.functions.use = {
    name = L("use"),
    onRun = function(item)
        local client = item.player
        local target = client:getTracedEntity()
        if IsValid(target) and target:GetClass() == "prop_ragdoll" and IsValid(target:getNetVar("player")) then target = target:getNetVar("player") end
        if not IsValid(target) or not (target:IsPlayer() and target:getChar()) then
            client:notifyLocalized("needAimPlayer")
            return false
        end

        if target:isStaffOnDuty() then
            target:notifyLocalized("staffRestrained", client:Name())
            client:notifyLocalized("cantRestrainStaff")
            return false
        end

        if target:IsHandcuffed() then
            client:notifyLocalized("alreadyCuffed")
            return false
        end

        target:setAction("@beingTied", 3)
        client:setAction("@tying", 3, function()
            local ete = client:getTracedEntity()
            if IsValid(ete) and ete == target then
                HandcuffPlayer(target)
                lia.log.add(client, "tie", target)
                item:remove()
            end
        end)
        return false
    end,
    onCanRun = function(item) return not IsValid(item.entity) end
}
