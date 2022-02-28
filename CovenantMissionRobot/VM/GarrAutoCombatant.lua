local _, T = ...;

local GarrAutoCobatant = {
    FollowerGUID  = nil, -- for compare log and simulation
    Auras         = { },
    Spells        = { },
    MissionID     = 0,
    Role          = 0, -- 1-Meele, 2-Ranged/Physical, 3-Ranged/Magic, 4-Heal/Support, 5-Tank
    Attack        = 0,
    MaxHP         = 0,
    StartHP       = 0,
    CurHP         = 0,
    BoardIndex    = -1,
    Level         = 0,
    DeathSeq      = 0,
    TauntedBy     = nil,
    Untargetable  = false,
    Reflect       = 0,
    Name          = ""
};

function GarrAutoCobatant:New(unitInfo, missionId)
    local obj = {
        FollowerGUID = unitInfo.followerGUID,
        Name         = unitInfo.name,
        Level        = unitInfo.level,
        MaxHP        = unitInfo.maxHealth,
        CurHP        = unitInfo.health,
        StartHP      = unitInfo.health,
        Attack       = unitInfo.attack,
        BoardIndex   = unitInfo.boardIndex,
        Role         = unitInfo.role,
        MissionID    = missionId,
        TauntedBy    = nil,
        Untargetable = false,
        Reflect      = 0,
        DeathSeq     = 0,
        Spells       = { },
        Auras        = { }
    };

    self.__index = self;
    setmetatable(obj, self);

    obj:SetupSpells(unitInfo.autoCombatSpells);

    return obj;
end

function GarrAutoCobatant:Reset()
    self.CurHP = self.StartHP;
    self.TauntedBy = nil;
    self.Untargetable = false;
    self.Reflect = 0;
    self.DeathSeq = 0;
    self.Auras = {};
    for _, spell in ipairs(self.Spells) do
        spell:Reset();
    end
end

function GarrAutoCobatant:SetupSpells(autoCombatSpells)
    -- Auto attack can be 11 (meele) or 15 (range)
    if self.BoardIndex > -1 then
        local firstSpellId = #autoCombatSpells > 0 and autoCombatSpells[1].autoCombatSpellID;
        local autoAttackSpellId = T.GetAutoAttackSpellId(self.Role, self.MissionID, self.BoardIndex, firstSpellId);
        local autoAttackSpellInfo = T.GARR_AUTO_SPELL[autoAttackSpellId];
        autoAttackSpellInfo.Name = 'Auto Attack';
        local autoAttackSpell = T.GarrAutoSpell:New(autoAttackSpellInfo);
        table.insert(self.Spells, autoAttackSpell);
    end

    -- Regular spells
    for i, spell in pairs(autoCombatSpells) do
        local spellInfo = T.GARR_AUTO_SPELL[spell.autoCombatSpellID];
        if spellInfo then
            spellInfo.Name = spell.name;
            local spellObj = T.GarrAutoSpell:New(spellInfo);
            table.insert(self.Spells, spellObj);
        else
            -- todo: assert?
        end
    end
end

function GarrAutoCobatant:IsAlive()
    return self.CurHP > 0;
end

function GarrAutoCobatant:GetAvailableSpells()
    local result = { };

    for _, spell in ipairs(self.Spells) do
        if not spell.IsPassive and spell.CurCD == 0 then
            table.insert(result, spell);
        end
    end

    return result;
end

T.GarrAutoCobatant = GarrAutoCobatant;
T.GetAutoAttackSpellId = GetAutoAttackSpellId;