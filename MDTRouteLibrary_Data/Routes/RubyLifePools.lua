-- Erzeugt von tools/generate-lua.mjs. Nicht von Hand bearbeiten.

local R = MDTRouteLibrary

R:RegisterRoute({
    id = "rio-14246016",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 1, clones = { 1 } },
                { enemy = 2, clones = { 9, 1, 2, 3, 4 } },
                { enemy = 3, clones = { 8, 1, 4, 5 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 84,
            cumulative = 84,
        },
        {
            enemies = {
                { enemy = 2, clones = { 10, 6, 8, 7 } },
                { enemy = 3, clones = { 6, 9 } },
                { enemy = 4, clones = { 6, 8, 9 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 5, clones = { 50, 18, 49 } },
            },
            forces = 81,
            cumulative = 165,
            boss = true,
        },
        {
            enemies = {
                { enemy = 7, clones = { 1 } },
                { enemy = 23, clones = { 1 } },
            },
            forces = 0,
            cumulative = 165,
            boss = true,
        },
        {
            enemies = {
                { enemy = 8, clones = { 22 } },
                { enemy = 10, clones = { 7, 10 } },
                { enemy = 12, clones = { 6, 9 } },
                { enemy = 11, clones = { 4 } },
            },
            forces = 53,
            cumulative = 218,
        },
        {
            enemies = {
                { enemy = 11, clones = { 3 } },
                { enemy = 12, clones = { 4 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 79,
            cumulative = 297,
            boss = true,
        },
        {
            enemies = {
                { enemy = 10, clones = { 2 } },
                { enemy = 12, clones = { 8 } },
            },
            forces = 14,
            cumulative = 311,
        },
        {
            enemies = {
                { enemy = 12, clones = { 10, 3 } },
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 11, clones = { 2 } },
            },
            forces = 53,
            cumulative = 364,
        },
        {
            enemies = {
                { enemy = 10, clones = { 3, 6 } },
                { enemy = 12, clones = { 2, 1 } },
                { enemy = 11, clones = { 1 } },
            },
            forces = 53,
            cumulative = 417,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3, 2 } },
            },
            forces = 0,
            cumulative = 417,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 417,
        },
        {
            enemies = {
                { enemy = 16, clones = { 1, 2, 4, 3 } },
                { enemy = 17, clones = { 4, 3, 5, 2, 6, 14, 1, 23 } },
                { enemy = 18, clones = { 1 } },
            },
            forces = 45,
            cumulative = 462,
        },
        {
            enemies = {
                { enemy = 12, clones = { 7 } },
                { enemy = 16, clones = { 9, 10, 5 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 18, clones = { 2 } },
                { enemy = 17, clones = { 22, 18, 15 } },
            },
            forces = 54,
            cumulative = 516,
        },
        {
            enemies = {
                { enemy = 19, clones = { 1 } },
                { enemy = 17, clones = { 10, 20, 16, 19, 11, 12, 13, 7, 8, 9 } },
                { enemy = 16, clones = { 7, 8 } },
            },
            forces = 40,
            cumulative = 556,
            boss = true,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
                { enemy = 17, clones = { 21 } },
            },
            forces = 0,
            cumulative = 556,
            boss = true,
        },
    },
    enemyForces = 556,
    wclReport = "jNYa6DWAfPwrM29h",
    wclFight = 1,
    filled = 1,
    title = "+20 · 26:56",
    author = "Guardian Druid",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/14246016-20-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/HOxeV3v",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 20,
    keyLevel = 20,
    clearSeconds = 1616,
    onTime = true,
    rank = 13089,
    region = "world",
    bracket = "mid",
    tier = "slow",
    roster = {
        { name = "Sstylle", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "Healú", class = "Druid", spec = "Guardian", role = "tank" },
        { name = "Bluehealer", class = "Shaman", spec = "Restoration", role = "healer" },
        { name = "Shabakor", class = "Death Knight", spec = "Frost", role = "dps" },
        { name = "Promizeux", class = "Monk", spec = "Windwalker", role = "dps" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-20343121",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 1, clones = { 1 } },
                { enemy = 3, clones = { 8, 1, 4, 5 } },
                { enemy = 2, clones = { 9, 1, 3, 2, 4 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 84,
            cumulative = 84,
        },
        {
            enemies = {
                { enemy = 3, clones = { 6 } },
                { enemy = 2, clones = { 10, 6 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 4, clones = { 6, 8 } },
                { enemy = 5, clones = { 50, 49, 18 } },
            },
            forces = 59,
            cumulative = 143,
            boss = true,
        },
        {
            enemies = {
                { enemy = 3, clones = { 9 } },
                { enemy = 2, clones = { 8, 7 } },
                { enemy = 4, clones = { 9 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 22,
            cumulative = 165,
            boss = true,
        },
        {
            enemies = {
                { enemy = 23, clones = { 1 } },
            },
            forces = 0,
            cumulative = 165,
        },
        {
            enemies = {
                { enemy = 8, clones = { 22 } },
                { enemy = 12, clones = { 6, 9 } },
                { enemy = 10, clones = { 7, 10 } },
                { enemy = 11, clones = { 4 } },
            },
            forces = 53,
            cumulative = 218,
        },
        {
            enemies = {
                { enemy = 11, clones = { 3 } },
                { enemy = 12, clones = { 4 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 79,
            cumulative = 297,
            boss = true,
        },
        {
            enemies = {
                { enemy = 12, clones = { 8 } },
                { enemy = 10, clones = { 2 } },
            },
            forces = 14,
            cumulative = 311,
        },
        {
            enemies = {
                { enemy = 12, clones = { 10, 3 } },
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 11, clones = { 2 } },
            },
            forces = 53,
            cumulative = 364,
        },
        {
            enemies = {
                { enemy = 12, clones = { 1, 2 } },
                { enemy = 10, clones = { 3, 6 } },
                { enemy = 11, clones = { 1 } },
            },
            forces = 53,
            cumulative = 417,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 417,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 3 } },
            },
            forces = 0,
            cumulative = 417,
        },
        {
            enemies = {
                { enemy = 22, clones = { 2 } },
            },
            forces = 0,
            cumulative = 417,
        },
        {
            enemies = {
                { enemy = 17, clones = { 1, 3, 4, 5, 2, 6 } },
                { enemy = 16, clones = { 1, 2, 4, 3 } },
                { enemy = 18, clones = { 1 } },
            },
            forces = 45,
            cumulative = 462,
        },
        {
            enemies = {
                { enemy = 12, clones = { 7 } },
                { enemy = 16, clones = { 10, 9, 5 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 18, clones = { 2 } },
                { enemy = 17, clones = { 23, 15, 14, 18 } },
            },
            forces = 54,
            cumulative = 516,
        },
        {
            enemies = {
                { enemy = 16, clones = { 7, 8 } },
                { enemy = 17, clones = { 9, 8, 7, 10, 13, 11, 12, 19, 21, 20, 16 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 40,
            cumulative = 556,
            boss = true,
        },
        {
            enemies = {
                { enemy = 21, clones = { 1 } },
                { enemy = 20, clones = { 1 } },
                { enemy = 17, clones = { 22 } },
            },
            forces = 0,
            cumulative = 556,
            boss = true,
        },
    },
    enemyForces = 556,
    wclReport = "bxt2LMBWjpQTPd3D",
    wclFight = 1,
    title = "+19 · 23:48",
    author = "Vengeance Demon Hunter",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/20343121-19-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/WtG61HT",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 19,
    keyLevel = 19,
    clearSeconds = 1428,
    onTime = true,
    rank = 19739,
    region = "world",
    bracket = "mid",
    tier = "slow",
    roster = {
        { name = "出門不合裝", class = "Hunter", spec = "Beast Mastery", role = "dps" },
        { name = "我還是大黃呀", class = "Paladin", spec = "Retribution", role = "dps" },
        { name = "AnonD038503", class = "Demon Hunter", spec = "Vengeance", role = "tank" },
        { name = "震懾波", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "橘拉芙", class = "Shaman", spec = "Restoration", role = "healer" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-21062469",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 2, clones = { 9, 1, 3, 2 } },
                { enemy = 1, clones = { 1 } },
                { enemy = 3, clones = { 8, 1, 5 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 74,
            cumulative = 74,
        },
        {
            enemies = {
                { enemy = 2, clones = { 4, 10 } },
                { enemy = 3, clones = { 4, 6 } },
                { enemy = 4, clones = { 6 } },
                { enemy = 1, clones = { 2 } },
            },
            forces = 52,
            cumulative = 126,
        },
        {
            enemies = {
                { enemy = 4, clones = { 8, 9 } },
                { enemy = 2, clones = { 7 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 3, clones = { 9 } },
                { enemy = 5, clones = { 49, 48, 50, 19, 18, 22, 20 } },
            },
            forces = 54,
            cumulative = 180,
            boss = true,
        },
        {
            enemies = {
                { enemy = 2, clones = { 8 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 5,
            cumulative = 185,
            boss = true,
        },
        {
            enemies = {
                { enemy = 23, clones = { 1 } },
            },
            forces = 0,
            cumulative = 185,
        },
        {
            enemies = {
                { enemy = 12, clones = { 6 } },
                { enemy = 10, clones = { 7 } },
                { enemy = 8, clones = { 22 } },
                { enemy = 11, clones = { 4 } },
            },
            forces = 39,
            cumulative = 224,
        },
        {
            enemies = {
                { enemy = 12, clones = { 9, 4 } },
                { enemy = 10, clones = { 10, 1 } },
                { enemy = 11, clones = { 3 } },
            },
            forces = 53,
            cumulative = 277,
        },
        {
            enemies = {
                { enemy = 14, clones = { 1 } },
            },
            forces = 40,
            cumulative = 317,
            boss = true,
        },
        {
            enemies = {
                { enemy = 11, clones = { 2 } },
                { enemy = 10, clones = { 4 } },
                { enemy = 12, clones = { 3 } },
            },
            forces = 39,
            cumulative = 356,
        },
        {
            enemies = {
                { enemy = 12, clones = { 1, 2 } },
                { enemy = 11, clones = { 1 } },
                { enemy = 10, clones = { 6, 3 } },
            },
            forces = 53,
            cumulative = 409,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3, 2 } },
            },
            forces = 0,
            cumulative = 409,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 409,
        },
        {
            enemies = {
                { enemy = 16, clones = { 2, 1, 4, 3 } },
                { enemy = 17, clones = { 1, 5, 6, 2, 4, 3 } },
                { enemy = 18, clones = { 1 } },
            },
            forces = 45,
            cumulative = 454,
        },
        {
            enemies = {
                { enemy = 16, clones = { 9, 10, 5 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 18, clones = { 2 } },
                { enemy = 17, clones = { 18, 15, 22, 14 } },
                { enemy = 10, clones = { 9 } },
            },
            forces = 54,
            cumulative = 508,
        },
        {
            enemies = {
                { enemy = 19, clones = { 1 } },
                { enemy = 16, clones = { 7, 8 } },
                { enemy = 17, clones = { 10, 9, 8, 7, 13 } },
            },
            forces = 40,
            cumulative = 548,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 19, 12, 21, 20, 23, 16, 11 } },
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 0,
            cumulative = 548,
            boss = true,
        },
        {
            enemies = {
                { enemy = 10, clones = { 2 } },
            },
            forces = 7,
            cumulative = 555,
        },
    },
    enemyForces = 555,
    wclReport = "gHTvwZJ7G8cXyknV",
    wclFight = 1,
    filled = 2,
    title = "+18 · 26:27",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/21062469-18-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/CAy3Iai",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 18,
    keyLevel = 18,
    clearSeconds = 1587,
    onTime = true,
    rank = 8206,
    region = "us",
    bracket = "mid",
    tier = "slow",
    roster = {
        { name = "Kariala", class = "Warlock", spec = "Demonology", role = "dps" },
        { name = "Eddárd", class = "Paladin", spec = "Retribution", role = "dps" },
        { name = "Lethalp", class = "Priest", spec = "Holy", role = "healer" },
        { name = "Snowyii-306226138", class = "Shaman", spec = "Elemental", role = "dps" },
        { name = "Corvdkk", class = "Death Knight", spec = "Blood", role = "tank" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-21286160",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 2, clones = { 9, 1, 3, 2 } },
                { enemy = 3, clones = { 8, 1, 5 } },
                { enemy = 1, clones = { 1, 2 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 99,
            cumulative = 99,
        },
        {
            enemies = {
                { enemy = 2, clones = { 10, 8, 7 } },
                { enemy = 3, clones = { 6, 9 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 5, clones = { 50, 21, 18 } },
                { enemy = 4, clones = { 9 } },
            },
            forces = 62,
            cumulative = 161,
            boss = true,
        },
        {
            enemies = {
                { enemy = 7, clones = { 1 } },
                { enemy = 23, clones = { 1 } },
            },
            forces = 0,
            cumulative = 161,
            boss = true,
        },
        {
            enemies = {
                { enemy = 8, clones = { 22 } },
                { enemy = 11, clones = { 4 } },
                { enemy = 10, clones = { 10 } },
                { enemy = 12, clones = { 9 } },
            },
            forces = 39,
            cumulative = 200,
        },
        {
            enemies = {
                { enemy = 11, clones = { 3 } },
                { enemy = 12, clones = { 4 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 79,
            cumulative = 279,
            boss = true,
        },
        {
            enemies = {
                { enemy = 10, clones = { 2 } },
                { enemy = 12, clones = { 8 } },
            },
            forces = 14,
            cumulative = 293,
        },
        {
            enemies = {
                { enemy = 12, clones = { 10, 3 } },
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 11, clones = { 2 } },
            },
            forces = 53,
            cumulative = 346,
        },
        {
            enemies = {
                { enemy = 12, clones = { 2, 1 } },
                { enemy = 10, clones = { 3, 6 } },
                { enemy = 11, clones = { 1 } },
            },
            forces = 53,
            cumulative = 399,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3 } },
            },
            forces = 0,
            cumulative = 399,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 2, 1 } },
                { enemy = 10, clones = { 7 } },
                { enemy = 12, clones = { 6 } },
            },
            forces = 14,
            cumulative = 413,
        },
        {
            enemies = {
                { enemy = 16, clones = { 1, 2, 4, 3, 9, 10, 5, 7, 8 } },
                { enemy = 18, clones = { 1, 2 } },
                { enemy = 17, clones = { 6, 4, 13, 12, 8, 19, 16, 20, 7, 1, 5, 10 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 139,
            cumulative = 552,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 14, 22, 15, 23, 18 } },
            },
            forces = 0,
            cumulative = 552,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
                { enemy = 17, clones = { 9, 11, 21 } },
            },
            forces = 0,
            cumulative = 552,
            boss = true,
        },
    },
    enemyForces = 552,
    wclReport = "dWqBJzGjCZ9hpTvm",
    wclFight = 6,
    filled = 3,
    title = "+22 · 24:40",
    author = "Guardian Druid",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/21286160-22-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/nzrkvXi",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 22,
    keyLevel = 22,
    clearSeconds = 1480,
    onTime = true,
    rank = 361,
    region = "world",
    bracket = "high",
    tier = "fast",
    roster = {
        { name = "Pookiexo", class = "Shaman", spec = "Restoration", role = "healer" },
        { name = "Tånya", class = "Druid", spec = "Guardian", role = "tank" },
        { name = "Exxibae", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "Shadarek", class = "Demon Hunter", spec = "Havoc", role = "dps" },
        { name = "Yenvenger", class = "Paladin", spec = "Retribution", role = "dps" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-21952999",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 2, clones = { 9, 1, 3, 2 } },
                { enemy = 1, clones = { 1 } },
                { enemy = 3, clones = { 8, 1, 5 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 74,
            cumulative = 74,
        },
        {
            enemies = {
                { enemy = 1, clones = { 2 } },
                { enemy = 4, clones = { 6 } },
                { enemy = 3, clones = { 6 } },
                { enemy = 2, clones = { 10 } },
            },
            forces = 42,
            cumulative = 116,
        },
        {
            enemies = {
                { enemy = 4, clones = { 8 } },
                { enemy = 2, clones = { 6 } },
            },
            forces = 12,
            cumulative = 128,
        },
        {
            enemies = {
                { enemy = 4, clones = { 9 } },
                { enemy = 2, clones = { 7, 8 } },
                { enemy = 3, clones = { 9 } },
                { enemy = 5, clones = { 48, 50, 49 } },
                { enemy = 6, clones = { 1 } },
            },
            forces = 52,
            cumulative = 180,
            boss = true,
        },
        {
            enemies = {
                { enemy = 7, clones = { 1 } },
                { enemy = 23, clones = { 1 } },
            },
            forces = 0,
            cumulative = 180,
            boss = true,
        },
        {
            enemies = {
                { enemy = 12, clones = { 6, 9 } },
                { enemy = 10, clones = { 7, 10 } },
                { enemy = 11, clones = { 4 } },
            },
            forces = 53,
            cumulative = 233,
        },
        {
            enemies = {
                { enemy = 11, clones = { 3 } },
                { enemy = 12, clones = { 4 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 79,
            cumulative = 312,
            boss = true,
        },
        {
            enemies = {
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 12, clones = { 10, 3 } },
                { enemy = 11, clones = { 2 } },
            },
            forces = 53,
            cumulative = 365,
        },
        {
            enemies = {
                { enemy = 12, clones = { 1, 2 } },
                { enemy = 10, clones = { 3, 6 } },
                { enemy = 11, clones = { 1 } },
            },
            forces = 53,
            cumulative = 418,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3 } },
            },
            forces = 0,
            cumulative = 418,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 2 } },
            },
            forces = 0,
            cumulative = 418,
        },
        {
            enemies = {
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 418,
        },
        {
            enemies = {
                { enemy = 16, clones = { 2, 1, 4, 3 } },
                { enemy = 17, clones = { 3, 5, 6, 2, 4, 1 } },
                { enemy = 18, clones = { 1 } },
            },
            forces = 45,
            cumulative = 463,
        },
        {
            enemies = {
                { enemy = 12, clones = { 7 } },
                { enemy = 16, clones = { 10, 9, 5 } },
                { enemy = 18, clones = { 2 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 17, clones = { 22, 18, 14, 23, 15 } },
            },
            forces = 54,
            cumulative = 517,
        },
        {
            enemies = {
                { enemy = 17, clones = { 16, 8, 12, 21, 19, 7, 11, 20, 13, 10, 9 } },
                { enemy = 16, clones = { 8, 7 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 40,
            cumulative = 557,
            boss = true,
        },
        {
            enemies = {
                { enemy = 21, clones = { 1 } },
                { enemy = 20, clones = { 1 } },
            },
            forces = 0,
            cumulative = 557,
            boss = true,
        },
    },
    enemyForces = 557,
    wclReport = "XBfqmcwTk84nG1Kx",
    wclFight = 24,
    title = "+14 · 18:23",
    author = "Brewmaster Monk",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/21952999-14-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/kywoVFw",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 14,
    keyLevel = 14,
    clearSeconds = 1103,
    onTime = true,
    rank = 5210,
    region = "kr",
    bracket = "low",
    tier = "fast",
    roster = {
        { name = "라군님", class = "Warlock", spec = "Demonology", role = "dps" },
        { name = "Rushe", class = "Shaman", spec = "Elemental", role = "dps" },
        { name = "불페라신성기사", class = "Shaman", spec = "Restoration", role = "healer" },
        { name = "실수한고라니", class = "Mage", spec = "Arcane", role = "dps" },
        { name = "농구있넹축구싶냐", class = "Monk", spec = "Brewmaster", role = "tank" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-22174878",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 1, clones = { 1 } },
                { enemy = 2, clones = { 9, 1, 2, 3 } },
                { enemy = 3, clones = { 8, 1, 5 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 74,
            cumulative = 74,
        },
        {
            enemies = {
                { enemy = 2, clones = { 4, 10, 6 } },
                { enemy = 3, clones = { 4, 6 } },
                { enemy = 4, clones = { 6, 8 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 5, clones = { 50, 19, 18 } },
            },
            forces = 69,
            cumulative = 143,
            boss = true,
        },
        {
            enemies = {
                { enemy = 4, clones = { 9 } },
                { enemy = 2, clones = { 7, 8 } },
                { enemy = 3, clones = { 9 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 22,
            cumulative = 165,
            boss = true,
        },
        {
            enemies = {
                { enemy = 12, clones = { 6 } },
                { enemy = 10, clones = { 7 } },
                { enemy = 11, clones = { 4 } },
            },
            forces = 39,
            cumulative = 204,
        },
        {
            enemies = {
                { enemy = 11, clones = { 3 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 12, clones = { 4 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 79,
            cumulative = 283,
            boss = true,
        },
        {
            enemies = {
                { enemy = 10, clones = { 2 } },
                { enemy = 12, clones = { 8 } },
            },
            forces = 14,
            cumulative = 297,
        },
        {
            enemies = {
                { enemy = 12, clones = { 10, 3 } },
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 11, clones = { 2 } },
            },
            forces = 53,
            cumulative = 350,
        },
        {
            enemies = {
                { enemy = 10, clones = { 3, 6 } },
                { enemy = 12, clones = { 1, 2 } },
                { enemy = 11, clones = { 1 } },
            },
            forces = 53,
            cumulative = 403,
        },
        {
            enemies = {
                { enemy = 12, clones = { 9 } },
                { enemy = 10, clones = { 10 } },
                { enemy = 8, clones = { 22 } },
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3 } },
            },
            forces = 14,
            cumulative = 417,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 2 } },
            },
            forces = 0,
            cumulative = 417,
        },
        {
            enemies = {
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 417,
        },
        {
            enemies = {
                { enemy = 17, clones = { 5, 4, 14, 15, 22, 23, 20, 12 } },
                { enemy = 18, clones = { 1, 2 } },
                { enemy = 16, clones = { 3, 4, 10, 9, 5, 8, 7 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 129,
            cumulative = 546,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 10, 8 } },
            },
            forces = 0,
            cumulative = 546,
        },
        {
            enemies = {
                { enemy = 17, clones = { 13, 18, 6, 19, 7, 16, 11, 21, 9, 1 } },
                { enemy = 16, clones = { 2, 1 } },
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 10,
            cumulative = 556,
            boss = true,
        },
    },
    enemyForces = 556,
    wclReport = "4LmhbtG97M1fvjD2",
    wclFight = 16,
    title = "+22 · 27:17",
    author = "Guardian Druid",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/22174878-22-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/dVwnnqz",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 22,
    keyLevel = 22,
    clearSeconds = 1637,
    onTime = true,
    rank = 1142,
    region = "world",
    bracket = "high",
    tier = "slow",
    roster = {
        { name = "Padflash", class = "Mage", spec = "Arcane", role = "dps" },
        { name = "Eroka", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "Vegevi", class = "Druid", spec = "Guardian", role = "tank" },
        { name = "Noxpunk", class = "Paladin", spec = "Holy", role = "healer" },
        { name = "Zorthar", class = "Shaman", spec = "Enhancement", role = "dps" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-22398787",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 1, clones = { 1 } },
                { enemy = 3, clones = { 8, 1, 5 } },
                { enemy = 2, clones = { 9, 1, 3, 2 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 74,
            cumulative = 74,
        },
        {
            enemies = {
                { enemy = 2, clones = { 4, 10, 7 } },
                { enemy = 3, clones = { 4, 6, 9 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 4, clones = { 6, 9 } },
                { enemy = 5, clones = { 22, 19, 18 } },
            },
            forces = 74,
            cumulative = 148,
            boss = true,
        },
        {
            enemies = {
                { enemy = 4, clones = { 8 } },
                { enemy = 2, clones = { 6 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 12,
            cumulative = 160,
            boss = true,
        },
        {
            enemies = {
                { enemy = 8, clones = { 22 } },
                { enemy = 12, clones = { 6, 9 } },
                { enemy = 10, clones = { 7, 10 } },
                { enemy = 11, clones = { 4 } },
            },
            forces = 53,
            cumulative = 213,
        },
        {
            enemies = {
                { enemy = 12, clones = { 4, 8 } },
                { enemy = 11, clones = { 3 } },
                { enemy = 10, clones = { 1, 2 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 93,
            cumulative = 306,
            boss = true,
        },
        {
            enemies = {
                { enemy = 12, clones = { 10, 3 } },
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 11, clones = { 2 } },
            },
            forces = 53,
            cumulative = 359,
        },
        {
            enemies = {
                { enemy = 12, clones = { 2, 1 } },
                { enemy = 10, clones = { 3, 6 } },
                { enemy = 11, clones = { 1 } },
            },
            forces = 53,
            cumulative = 412,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3, 1 } },
            },
            forces = 0,
            cumulative = 412,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 2 } },
            },
            forces = 0,
            cumulative = 412,
        },
        {
            enemies = {
                { enemy = 17, clones = { 1, 3, 2, 5, 4, 6, 22 } },
                { enemy = 16, clones = { 1, 2, 3, 4 } },
                { enemy = 18, clones = { 1 } },
            },
            forces = 45,
            cumulative = 457,
        },
        {
            enemies = {
                { enemy = 17, clones = { 18, 14, 15, 23, 13, 8, 9, 12, 7, 19, 10, 11, 20, 21 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 16, clones = { 9, 10, 5, 8, 7 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 18, clones = { 2 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 94,
            cumulative = 551,
            boss = true,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
                { enemy = 17, clones = { 16 } },
            },
            forces = 0,
            cumulative = 551,
            boss = true,
        },
    },
    enemyForces = 551,
    wclReport = "JK9Zz7kaxXMbjNDL",
    wclFight = 5,
    title = "+23 · 25:23",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/22398787-23-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/gmS901q",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 23,
    keyLevel = 23,
    clearSeconds = 1523,
    onTime = true,
    rank = 21,
    region = "world",
    bracket = "high",
    tier = "fast",
    roster = {
        { name = "神奇的阿诺", class = "Death Knight", spec = "Blood", role = "tank" },
        { name = "孤独咩", class = "Shaman", spec = "Elemental", role = "dps" },
        { name = "快乐阳阳", class = "Paladin", spec = "Holy", role = "healer" },
        { name = "Rosebankk", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "狗神丿男人", class = "Rogue", spec = "Subtlety", role = "dps" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-24224290",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 2, clones = { 9, 1, 3, 2 } },
                { enemy = 1, clones = { 1 } },
                { enemy = 3, clones = { 8, 1, 5 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 74,
            cumulative = 74,
        },
        {
            enemies = {
                { enemy = 3, clones = { 4, 6 } },
                { enemy = 2, clones = { 4, 10, 6 } },
                { enemy = 4, clones = { 6, 8 } },
                { enemy = 6, clones = { 1 } },
            },
            forces = 69,
            cumulative = 143,
            boss = true,
        },
        {
            enemies = {
                { enemy = 2, clones = { 7 } },
                { enemy = 3, clones = { 9 } },
                { enemy = 4, clones = { 9 } },
                { enemy = 5, clones = { 50, 49, 48 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 17,
            cumulative = 160,
            boss = true,
        },
        {
            enemies = {
                { enemy = 23, clones = { 1 } },
            },
            forces = 0,
            cumulative = 160,
        },
        {
            enemies = {
                { enemy = 11, clones = { 4 } },
                { enemy = 12, clones = { 9 } },
                { enemy = 10, clones = { 10 } },
            },
            forces = 39,
            cumulative = 199,
        },
        {
            enemies = {
                { enemy = 12, clones = { 4 } },
                { enemy = 11, clones = { 3 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 79,
            cumulative = 278,
            boss = true,
        },
        {
            enemies = {
                { enemy = 12, clones = { 8 } },
                { enemy = 10, clones = { 2 } },
            },
            forces = 14,
            cumulative = 292,
        },
        {
            enemies = {
                { enemy = 12, clones = { 10, 3 } },
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 11, clones = { 2 } },
            },
            forces = 53,
            cumulative = 345,
        },
        {
            enemies = {
                { enemy = 12, clones = { 1, 2 } },
                { enemy = 10, clones = { 3, 6 } },
                { enemy = 11, clones = { 1 } },
            },
            forces = 53,
            cumulative = 398,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 1, 3 } },
            },
            forces = 0,
            cumulative = 398,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 2 } },
            },
            forces = 0,
            cumulative = 398,
        },
        {
            enemies = {
                { enemy = 8, clones = { 22 } },
                { enemy = 12, clones = { 6 } },
                { enemy = 10, clones = { 7 } },
            },
            forces = 14,
            cumulative = 412,
        },
        {
            enemies = {
                { enemy = 17, clones = { 1, 2, 3, 5, 6, 4 } },
                { enemy = 16, clones = { 1, 2, 4, 3 } },
                { enemy = 18, clones = { 1 } },
            },
            forces = 45,
            cumulative = 457,
        },
        {
            enemies = {
                { enemy = 12, clones = { 7 } },
                { enemy = 16, clones = { 10, 9, 5 } },
                { enemy = 18, clones = { 2 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 17, clones = { 22, 15, 14, 18, 23 } },
            },
            forces = 54,
            cumulative = 511,
        },
        {
            enemies = {
                { enemy = 19, clones = { 1 } },
                { enemy = 16, clones = { 7, 8 } },
                { enemy = 17, clones = { 7, 20, 13, 8, 16, 12, 9, 11 } },
            },
            forces = 40,
            cumulative = 551,
            boss = true,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
                { enemy = 17, clones = { 21, 19, 10 } },
            },
            forces = 0,
            cumulative = 551,
            boss = true,
        },
    },
    enemyForces = 551,
    wclReport = "dakQXwYcCftG17Vv",
    wclFight = 34,
    filled = 1,
    title = "+23 · 24:58",
    author = "Brewmaster Monk",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/24224290-23-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/joH54z9",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 23,
    keyLevel = 23,
    clearSeconds = 1498,
    onTime = true,
    rank = 15,
    region = "world",
    bracket = "high",
    tier = "fast",
    roster = {
        { name = "Xhanon", class = "Shaman", spec = "Restoration", role = "healer" },
        { name = "Monksea", class = "Monk", spec = "Brewmaster", role = "tank" },
        { name = "Farover", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "Tomelvis", class = "Rogue", spec = "Outlaw", role = "dps" },
        { name = "Murtaz", class = "Druid", spec = "Feral", role = "dps" },
    },
    enemyForcesRequired = 551,
})
