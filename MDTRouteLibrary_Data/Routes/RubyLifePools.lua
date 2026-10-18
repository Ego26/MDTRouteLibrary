-- Erzeugt von tools/generate-lua.mjs. Nicht von Hand bearbeiten.

local R = MDTRouteLibrary

R:RegisterRoute({
    id = "rio-11163732",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 1, clones = { 1 } },
                { enemy = 2, clones = { 9, 1, 3, 2 } },
                { enemy = 3, clones = { 8, 1, 5 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 74,
            cumulative = 74,
        },
        {
            enemies = {
                { enemy = 3, clones = { 4, 6 } },
                { enemy = 2, clones = { 4, 10 } },
                { enemy = 1, clones = { 2 } },
                { enemy = 4, clones = { 6 } },
                { enemy = 5, clones = { 7, 13, 16, 11, 10 } },
            },
            forces = 52,
            cumulative = 126,
        },
        {
            enemies = {
                { enemy = 6, clones = { 1 } },
                { enemy = 5, clones = { 50, 48, 49 } },
                { enemy = 4, clones = { 8 } },
                { enemy = 2, clones = { 6 } },
            },
            forces = 42,
            cumulative = 168,
            boss = true,
        },
        {
            enemies = {
                { enemy = 4, clones = { 9 } },
                { enemy = 2, clones = { 8 } },
            },
            forces = 12,
            cumulative = 180,
        },
        {
            enemies = {
                { enemy = 3, clones = { 9 } },
                { enemy = 2, clones = { 7 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 10,
            cumulative = 190,
            boss = true,
        },
        {
            enemies = {
                { enemy = 23, clones = { 1 } },
            },
            forces = 0,
            cumulative = 190,
        },
        {
            enemies = {
                { enemy = 10, clones = { 7 } },
                { enemy = 8, clones = { 22 } },
                { enemy = 12, clones = { 6 } },
                { enemy = 11, clones = { 4 } },
            },
            forces = 39,
            cumulative = 229,
        },
        {
            enemies = {
                { enemy = 12, clones = { 9, 4 } },
                { enemy = 10, clones = { 10, 1 } },
                { enemy = 11, clones = { 3 } },
            },
            forces = 53,
            cumulative = 282,
        },
        {
            enemies = {
                { enemy = 10, clones = { 2 } },
                { enemy = 12, clones = { 8 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 54,
            cumulative = 336,
            boss = true,
        },
        {
            enemies = {
                { enemy = 11, clones = { 2 } },
                { enemy = 12, clones = { 3, 2, 1 } },
                { enemy = 10, clones = { 4, 3 } },
            },
            forces = 60,
            cumulative = 396,
        },
        {
            enemies = {
                { enemy = 11, clones = { 1 } },
                { enemy = 10, clones = { 6 } },
            },
            forces = 32,
            cumulative = 428,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 428,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 3 } },
            },
            forces = 0,
            cumulative = 428,
        },
        {
            enemies = {
                { enemy = 22, clones = { 2 } },
            },
            forces = 0,
            cumulative = 428,
        },
        {
            enemies = {
                { enemy = 17, clones = { 1, 3, 4, 5, 2, 6 } },
                { enemy = 16, clones = { 1, 2, 4, 3 } },
                { enemy = 18, clones = { 1 } },
            },
            forces = 45,
            cumulative = 473,
        },
        {
            enemies = {
                { enemy = 17, clones = { 14, 22, 23, 15, 21, 18, 11, 12, 13 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 16, clones = { 10, 9, 5, 8, 7 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 18, clones = { 2 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 94,
            cumulative = 567,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 10, 9, 8, 7 } },
            },
            forces = 0,
            cumulative = 567,
        },
        {
            enemies = {
                { enemy = 17, clones = { 20, 16, 19 } },
            },
            forces = 0,
            cumulative = 567,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 0,
            cumulative = 567,
            boss = true,
        },
    },
    enemyForces = 567,
    wclReport = "9PrVBJGNjpHgWfv8",
    wclFight = 11,
    title = "+14 · 20:20",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/11163732-14-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/uxDbqJK",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 14,
    keyLevel = 14,
    clearSeconds = 1220,
    onTime = true,
    rank = 2974,
    region = "tw",
    bracket = "low",
    tier = "fast",
    roster = {
        { name = "芙蓉雨", class = "Druid", spec = "Feral", role = "dps" },
        { name = "功夫鼠", class = "Hunter", spec = "Beast Mastery", role = "dps" },
        { name = "肉嚕仔", class = "Monk", spec = "Windwalker", role = "dps" },
        { name = "鐵花飛", class = "Death Knight", spec = "Blood", role = "tank" },
        { name = "燈火", class = "Paladin", spec = "Holy", role = "healer" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-11270554",
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
                { enemy = 2, clones = { 4, 10 } },
                { enemy = 3, clones = { 4, 6 } },
                { enemy = 4, clones = { 6 } },
                { enemy = 5, clones = { 17, 22, 48, 49, 50 } },
                { enemy = 6, clones = { 1 } },
            },
            forces = 57,
            cumulative = 131,
            boss = true,
        },
        {
            enemies = {
                { enemy = 2, clones = { 7, 8, 6 } },
                { enemy = 3, clones = { 9 } },
                { enemy = 4, clones = { 9, 8 } },
            },
            forces = 34,
            cumulative = 165,
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
                { enemy = 10, clones = { 7, 10 } },
                { enemy = 8, clones = { 22 } },
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
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 12, clones = { 10, 3 } },
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
                { enemy = 22, clones = { 3, 1 } },
            },
            forces = 0,
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
                { enemy = 17, clones = { 1, 6, 3, 2, 5, 4 } },
                { enemy = 16, clones = { 2, 1, 3, 4 } },
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
                { enemy = 17, clones = { 23, 15, 14, 18 } },
            },
            forces = 54,
            cumulative = 516,
        },
        {
            enemies = {
                { enemy = 17, clones = { 8, 13, 7, 10, 9, 12, 11, 20, 19, 16, 22, 21 } },
                { enemy = 19, clones = { 1 } },
                { enemy = 16, clones = { 8, 7 } },
            },
            forces = 40,
            cumulative = 556,
            boss = true,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 0,
            cumulative = 556,
            boss = true,
        },
    },
    enemyForces = 556,
    wclReport = "TbkA6Rp9J4L1YdtX",
    wclFight = 7,
    filled = 1,
    title = "+18 · 23:40",
    author = "Guardian Druid",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/11270554-18-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/CRNlvAF",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 18,
    keyLevel = 18,
    clearSeconds = 1420,
    onTime = true,
    rank = 18457,
    region = "world",
    bracket = "mid",
    tier = "slow",
    roster = {
        { name = "Shadovworrio", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "Baralan", class = "Shaman", spec = "Restoration", role = "healer" },
        { name = "Vespionr", class = "Rogue", spec = "Assassination", role = "dps" },
        { name = "Azortharion", class = "Hunter", spec = "Beast Mastery", role = "dps" },
        { name = "Snakeshift", class = "Druid", spec = "Guardian", role = "tank" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-12947296",
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
                { enemy = 5, clones = { 2, 52, 3, 1, 51 } },
            },
            forces = 42,
            cumulative = 116,
        },
        {
            enemies = {
                { enemy = 6, clones = { 1 } },
                { enemy = 4, clones = { 8, 9 } },
                { enemy = 2, clones = { 6, 8 } },
                { enemy = 5, clones = { 19, 18, 48, 49, 50 } },
            },
            forces = 54,
            cumulative = 170,
            boss = true,
        },
        {
            enemies = {
                { enemy = 2, clones = { 7 } },
                { enemy = 3, clones = { 9 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 10,
            cumulative = 180,
            boss = true,
        },
        {
            enemies = {
                { enemy = 23, clones = { 1 } },
            },
            forces = 0,
            cumulative = 180,
        },
        {
            enemies = {
                { enemy = 8, clones = { 22 } },
                { enemy = 12, clones = { 6 } },
                { enemy = 10, clones = { 7 } },
                { enemy = 11, clones = { 4 } },
            },
            forces = 39,
            cumulative = 219,
        },
        {
            enemies = {
                { enemy = 10, clones = { 10 } },
                { enemy = 12, clones = { 9 } },
            },
            forces = 14,
            cumulative = 233,
        },
        {
            enemies = {
                { enemy = 11, clones = { 3 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 12, clones = { 4 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 79,
            cumulative = 312,
            boss = true,
        },
        {
            enemies = {
                { enemy = 12, clones = { 8 } },
                { enemy = 10, clones = { 2 } },
            },
            forces = 14,
            cumulative = 326,
        },
        {
            enemies = {
                { enemy = 11, clones = { 2 } },
                { enemy = 10, clones = { 4 } },
                { enemy = 12, clones = { 3 } },
            },
            forces = 39,
            cumulative = 365,
        },
        {
            enemies = {
                { enemy = 11, clones = { 1 } },
                { enemy = 10, clones = { 3, 6 } },
            },
            forces = 39,
            cumulative = 404,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 1, 3 } },
            },
            forces = 0,
            cumulative = 404,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 2 } },
            },
            forces = 0,
            cumulative = 404,
        },
        {
            enemies = {
                { enemy = 17, clones = { 1, 2, 5, 6, 4, 18, 23, 15, 14, 22, 11, 3 } },
                { enemy = 16, clones = { 1, 2, 4, 3, 10, 9, 8, 5, 7 } },
                { enemy = 18, clones = { 1, 2 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 139,
            cumulative = 543,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 8, 9, 10, 12, 7 } },
            },
            forces = 0,
            cumulative = 543,
        },
        {
            enemies = {
                { enemy = 17, clones = { 19, 20, 16, 13, 21 } },
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 0,
            cumulative = 543,
            boss = true,
        },
    },
    enemyForces = 543,
    wclReport = "BTcLKJ1r8VxCwPbj",
    wclFight = 47,
    filled = 2,
    title = "+20 · 27:11",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/12947296-20-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/pbnXpuJ",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 20,
    keyLevel = 20,
    clearSeconds = 1631,
    onTime = true,
    rank = 3946,
    region = "world",
    bracket = "high",
    tier = "slow",
    roster = {
        { name = "Micelino", class = "Rogue", spec = "Outlaw", role = "dps" },
        { name = "Darthtalon", class = "Shaman", spec = "Restoration", role = "healer" },
        { name = "Zzet", class = "Druid", spec = "Feral", role = "dps" },
        { name = "Tankierzog", class = "Death Knight", spec = "Blood", role = "tank" },
        { name = "Zodiakx", class = "Warrior", spec = "Arms", role = "dps" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-20480921",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 2, clones = { 9, 1, 3, 2, 4 } },
                { enemy = 3, clones = { 8, 1, 4, 5 } },
                { enemy = 1, clones = { 1 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 84,
            cumulative = 84,
        },
        {
            enemies = {
                { enemy = 3, clones = { 6 } },
                { enemy = 2, clones = { 10, 8 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 4, clones = { 6 } },
                { enemy = 5, clones = { 49, 50, 48 } },
            },
            forces = 52,
            cumulative = 136,
            boss = true,
        },
        {
            enemies = {
                { enemy = 4, clones = { 8, 9 } },
                { enemy = 2, clones = { 6, 7 } },
                { enemy = 3, clones = { 9 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 29,
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
                { enemy = 12, clones = { 6, 9 } },
                { enemy = 10, clones = { 7, 10 } },
                { enemy = 8, clones = { 22 } },
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
                { enemy = 11, clones = { 2 } },
                { enemy = 12, clones = { 3 } },
                { enemy = 10, clones = { 4 } },
            },
            forces = 39,
            cumulative = 350,
        },
        {
            enemies = {
                { enemy = 10, clones = { 5 } },
                { enemy = 12, clones = { 10 } },
            },
            forces = 14,
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
                { enemy = 22, clones = { 3 } },
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
                { enemy = 22, clones = { 2 } },
            },
            forces = 0,
            cumulative = 417,
        },
        {
            enemies = {
                { enemy = 17, clones = { 1, 2, 3, 18, 5, 6, 4, 15, 21, 23, 14 } },
                { enemy = 16, clones = { 1, 2, 4, 3, 9, 10, 5 } },
                { enemy = 18, clones = { 1, 2 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 10, clones = { 9 } },
            },
            forces = 99,
            cumulative = 516,
        },
        {
            enemies = {
                { enemy = 17, clones = { 8, 11, 13, 20, 19, 12 } },
                { enemy = 19, clones = { 1 } },
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
                { enemy = 17, clones = { 16, 22 } },
            },
            forces = 0,
            cumulative = 556,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 7, 10, 9 } },
            },
            forces = 0,
            cumulative = 556,
        },
    },
    enemyForces = 556,
    wclReport = "4g6KNwZkxtq1mPLD",
    wclFight = 10,
    title = "+21 · 27:20",
    author = "Brewmaster Monk",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/20480921-21-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/GspKdM8",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 21,
    keyLevel = 21,
    clearSeconds = 1640,
    onTime = true,
    rank = 884,
    region = "world",
    bracket = "high",
    tier = "slow",
    roster = {
        { name = "Daosh", class = "Monk", spec = "Brewmaster", role = "tank" },
        { name = "Aleasamna", class = "Druid", spec = "Feral", role = "dps" },
        { name = "Yükí", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "Sebás", class = "Shaman", spec = "Restoration", role = "healer" },
        { name = "Ortyy", class = "Rogue", spec = "Assassination", role = "dps" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-20682735",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 3, clones = { 8, 1, 5 } },
                { enemy = 2, clones = { 9, 1, 3, 2 } },
                { enemy = 1, clones = { 1, 2 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 99,
            cumulative = 99,
        },
        {
            enemies = {
                { enemy = 3, clones = { 6, 9 } },
                { enemy = 2, clones = { 10, 8, 7 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 5, clones = { 48, 49, 50 } },
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
                { enemy = 10, clones = { 3, 6 } },
                { enemy = 12, clones = { 1 } },
                { enemy = 11, clones = { 1 } },
            },
            forces = 46,
            cumulative = 392,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3, 1 } },
            },
            forces = 0,
            cumulative = 392,
            boss = true,
        },
        {
            enemies = {
                { enemy = 10, clones = { 7 } },
                { enemy = 12, clones = { 6 } },
                { enemy = 22, clones = { 2 } },
            },
            forces = 14,
            cumulative = 406,
        },
        {
            enemies = {
                { enemy = 16, clones = { 1, 2, 3, 4, 10, 9, 5 } },
                { enemy = 17, clones = { 3, 4, 6, 5, 1, 2 } },
                { enemy = 18, clones = { 1, 2 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 10, clones = { 9 } },
            },
            forces = 99,
            cumulative = 505,
        },
        {
            enemies = {
                { enemy = 16, clones = { 8, 7 } },
                { enemy = 19, clones = { 1 } },
                { enemy = 17, clones = { 12, 7, 11, 10, 9, 8, 13, 21, 14, 15, 23 } },
            },
            forces = 40,
            cumulative = 545,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 16, 18, 22, 20, 19 } },
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 0,
            cumulative = 545,
            boss = true,
        },
    },
    enemyForces = 545,
    wclReport = "ZGHAPM7aXqT2bgfN",
    wclFight = 17,
    title = "+21 · 23:07",
    author = "Guardian Druid",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/20682735-21-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/PvB4pPc",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 21,
    keyLevel = 21,
    clearSeconds = 1387,
    onTime = true,
    rank = 249,
    region = "world",
    bracket = "high",
    tier = "fast",
    roster = {
        { name = "Pookiexo", class = "Shaman", spec = "Restoration", role = "healer" },
        { name = "Melee", class = "Paladin", spec = "Retribution", role = "dps" },
        { name = "Tånya", class = "Druid", spec = "Guardian", role = "tank" },
        { name = "Exxibae", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "Shadarek", class = "Demon Hunter", spec = "Havoc", role = "dps" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-20862995",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 3, clones = { 8, 1, 5 } },
                { enemy = 1, clones = { 1 } },
                { enemy = 2, clones = { 9, 1, 2, 3 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 74,
            cumulative = 74,
        },
        {
            enemies = {
                { enemy = 3, clones = { 4, 6 } },
                { enemy = 2, clones = { 4, 10 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 4, clones = { 6 } },
                { enemy = 5, clones = { 50, 21, 18 } },
            },
            forces = 57,
            cumulative = 131,
            boss = true,
        },
        {
            enemies = {
                { enemy = 4, clones = { 8 } },
                { enemy = 2, clones = { 6 } },
            },
            forces = 12,
            cumulative = 143,
        },
        {
            enemies = {
                { enemy = 4, clones = { 9 } },
                { enemy = 2, clones = { 7 } },
                { enemy = 3, clones = { 9 } },
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
                { enemy = 10, clones = { 7, 10 } },
                { enemy = 8, clones = { 22 } },
                { enemy = 12, clones = { 6, 9 } },
                { enemy = 11, clones = { 4 } },
            },
            forces = 53,
            cumulative = 213,
        },
        {
            enemies = {
                { enemy = 11, clones = { 3 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 12, clones = { 4 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 79,
            cumulative = 292,
            boss = true,
        },
        {
            enemies = {
                { enemy = 12, clones = { 8 } },
                { enemy = 10, clones = { 2 } },
            },
            forces = 14,
            cumulative = 306,
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
                { enemy = 10, clones = { 3, 6 } },
                { enemy = 12, clones = { 1, 2 } },
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
                { enemy = 17, clones = { 1, 3, 2, 5, 4, 6 } },
                { enemy = 16, clones = { 2, 1, 4, 3, 10, 9 } },
                { enemy = 18, clones = { 1 } },
                { enemy = 12, clones = { 7 } },
            },
            forces = 62,
            cumulative = 474,
        },
        {
            enemies = {
                { enemy = 10, clones = { 9 } },
                { enemy = 18, clones = { 2 } },
                { enemy = 16, clones = { 5 } },
                { enemy = 17, clones = { 15, 14, 23 } },
            },
            forces = 37,
            cumulative = 511,
        },
        {
            enemies = {
                { enemy = 17, clones = { 20, 16, 11, 10, 9, 7, 8, 13, 12, 21, 19 } },
                { enemy = 16, clones = { 7, 8 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 40,
            cumulative = 551,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 22, 18 } },
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 0,
            cumulative = 551,
            boss = true,
        },
    },
    enemyForces = 551,
    wclReport = "QBv3HNyrtqxbXhYc",
    wclFight = 8,
    title = "+21 · 24:45",
    author = "Protection Warrior",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/20862995-21-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/zdo0A3T",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 21,
    keyLevel = 21,
    clearSeconds = 1485,
    onTime = true,
    rank = 256,
    region = "world",
    bracket = "high",
    tier = "fast",
    roster = {
        { name = "Bobas", class = "Warrior", spec = "Protection", role = "tank" },
        { name = "Cynx", class = "Paladin", spec = "Holy", role = "healer" },
        { name = "Dabnel", class = "Monk", spec = "Windwalker", role = "dps" },
        { name = "Azunazx", class = "Mage", spec = "Arcane", role = "dps" },
        { name = "Cheeklord", class = "Warrior", spec = "Arms", role = "dps" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-20887916",
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
                { enemy = 5, clones = { 3, 51, 2, 1, 52, 50, 49, 48 } },
                { enemy = 4, clones = { 6 } },
                { enemy = 3, clones = { 6 } },
                { enemy = 2, clones = { 10 } },
                { enemy = 6, clones = { 1 } },
            },
            forces = 47,
            cumulative = 131,
            boss = true,
        },
        {
            enemies = {
                { enemy = 2, clones = { 7, 6 } },
                { enemy = 3, clones = { 9 } },
                { enemy = 4, clones = { 9, 8 } },
            },
            forces = 29,
            cumulative = 160,
        },
        {
            enemies = {
                { enemy = 7, clones = { 1 } },
                { enemy = 23, clones = { 1 } },
            },
            forces = 0,
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
                { enemy = 11, clones = { 3 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 12, clones = { 4 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 79,
            cumulative = 292,
            boss = true,
        },
        {
            enemies = {
                { enemy = 10, clones = { 2 } },
            },
            forces = 7,
            cumulative = 299,
        },
        {
            enemies = {
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 12, clones = { 10, 3 } },
                { enemy = 11, clones = { 2 } },
            },
            forces = 53,
            cumulative = 352,
        },
        {
            enemies = {
                { enemy = 12, clones = { 1, 2 } },
                { enemy = 10, clones = { 3, 6 } },
                { enemy = 11, clones = { 1 } },
            },
            forces = 53,
            cumulative = 405,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3, 2 } },
            },
            forces = 0,
            cumulative = 405,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 405,
        },
        {
            enemies = {
                { enemy = 17, clones = { 4, 6, 5, 23, 14, 18, 15, 22, 1 } },
                { enemy = 16, clones = { 2, 1, 4, 3, 9, 10, 5 } },
                { enemy = 18, clones = { 1, 2 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 10, clones = { 9 } },
            },
            forces = 99,
            cumulative = 504,
        },
        {
            enemies = {
                { enemy = 19, clones = { 1 } },
                { enemy = 16, clones = { 7, 8 } },
                { enemy = 17, clones = { 11, 16, 19, 21, 20, 13 } },
            },
            forces = 40,
            cumulative = 544,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 7, 10, 9, 12, 8 } },
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 0,
            cumulative = 544,
            boss = true,
        },
    },
    enemyForces = 544,
    wclReport = "KCyPh9vxQ6qN7rjm",
    wclFight = 11,
    filled = 1,
    title = "+18 · 21:52",
    author = "Guardian Druid",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/20887916-18-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/ALH6L6m",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 18,
    keyLevel = 18,
    clearSeconds = 1312,
    onTime = true,
    rank = 18050,
    region = "world",
    bracket = "mid",
    tier = "fast",
    roster = {
        { name = "Blindsurgeon", class = "Rogue", spec = "Assassination", role = "dps" },
        { name = "Jci", class = "Evoker", spec = "Preservation", role = "healer" },
        { name = "Cadius", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "Kiiwidruid", class = "Druid", spec = "Guardian", role = "tank" },
        { name = "Taoshaman", class = "Shaman", spec = "Elemental", role = "dps" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-20924443",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 1, clones = { 1 } },
                { enemy = 2, clones = { 9, 1, 3, 2, 4 } },
                { enemy = 3, clones = { 8, 1, 4, 5 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 84,
            cumulative = 84,
        },
        {
            enemies = {
                { enemy = 4, clones = { 6, 8 } },
                { enemy = 3, clones = { 6 } },
                { enemy = 2, clones = { 10, 6 } },
                { enemy = 6, clones = { 1 } },
            },
            forces = 59,
            cumulative = 143,
            boss = true,
        },
        {
            enemies = {
                { enemy = 4, clones = { 9 } },
                { enemy = 2, clones = { 7 } },
                { enemy = 3, clones = { 9 } },
                { enemy = 5, clones = { 50, 21, 48 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 17,
            cumulative = 160,
            boss = true,
        },
        {
            enemies = {
                { enemy = 12, clones = { 6, 9 } },
                { enemy = 10, clones = { 7, 10 } },
                { enemy = 11, clones = { 4 } },
            },
            forces = 53,
            cumulative = 213,
        },
        {
            enemies = {
                { enemy = 11, clones = { 3 } },
                { enemy = 12, clones = { 4 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 79,
            cumulative = 292,
            boss = true,
        },
        {
            enemies = {
                { enemy = 10, clones = { 2 } },
                { enemy = 12, clones = { 8 } },
            },
            forces = 14,
            cumulative = 306,
        },
        {
            enemies = {
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 12, clones = { 10, 3 } },
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
                { enemy = 22, clones = { 3, 2 } },
            },
            forces = 0,
            cumulative = 412,
            boss = true,
        },
        {
            enemies = {
                { enemy = 8, clones = { 22 } },
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 412,
        },
        {
            enemies = {
                { enemy = 17, clones = { 3, 6, 5, 4, 2, 15 } },
                { enemy = 18, clones = { 1 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 16, clones = { 4, 3 } },
            },
            forces = 42,
            cumulative = 454,
        },
        {
            enemies = {
                { enemy = 18, clones = { 2 } },
                { enemy = 16, clones = { 5, 8, 7 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 19, clones = { 1 } },
                { enemy = 17, clones = { 18, 22, 14, 23 } },
            },
            forces = 77,
            cumulative = 531,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 16 } },
            },
            forces = 0,
            cumulative = 531,
        },
        {
            enemies = {
                { enemy = 16, clones = { 1, 2 } },
                { enemy = 17, clones = { 19, 9, 20, 21, 11, 12, 7, 8, 13, 1, 10 } },
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 10,
            cumulative = 541,
            boss = true,
        },
    },
    enemyForces = 541,
    wclReport = "PxT8jFWVK4HyCZv1",
    wclFight = 10,
    title = "+22 · 25:05",
    author = "Guardian Druid",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/20924443-22-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/OOQqY0G",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 22,
    keyLevel = 22,
    clearSeconds = 1505,
    onTime = true,
    rank = 23,
    region = "world",
    bracket = "high",
    tier = "fast",
    roster = {
        { name = "Tacokekw", class = "Rogue", spec = "Assassination", role = "dps" },
        { name = "Âra", class = "Paladin", spec = "Retribution", role = "dps" },
        { name = "Pjdruid", class = "Druid", spec = "Guardian", role = "tank" },
        { name = "Driptinus", class = "Shaman", spec = "Restoration", role = "healer" },
        { name = "Doxorsw", class = "Warrior", spec = "Arms", role = "dps" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-20990037",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 1, clones = { 1 } },
                { enemy = 2, clones = { 9, 1, 2, 3 } },
                { enemy = 3, clones = { 8, 1 } },
                { enemy = 4, clones = { 1 } },
            },
            forces = 62,
            cumulative = 62,
        },
        {
            enemies = {
                { enemy = 2, clones = { 4, 10, 7 } },
                { enemy = 3, clones = { 4, 6, 9 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 5, clones = { 19, 22, 17 } },
                { enemy = 4, clones = { 8, 6 } },
            },
            forces = 74,
            cumulative = 136,
            boss = true,
        },
        {
            enemies = {
                { enemy = 4, clones = { 9 } },
                { enemy = 2, clones = { 6 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 12,
            cumulative = 148,
            boss = true,
        },
        {
            enemies = {
                { enemy = 23, clones = { 1 } },
            },
            forces = 0,
            cumulative = 148,
        },
        {
            enemies = {
                { enemy = 8, clones = { 22 } },
                { enemy = 12, clones = { 6, 9 } },
                { enemy = 10, clones = { 7, 10 } },
                { enemy = 11, clones = { 4 } },
            },
            forces = 53,
            cumulative = 201,
        },
        {
            enemies = {
                { enemy = 12, clones = { 4, 8 } },
                { enemy = 10, clones = { 1, 2 } },
                { enemy = 11, clones = { 3 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 93,
            cumulative = 294,
            boss = true,
        },
        {
            enemies = {
                { enemy = 12, clones = { 10 } },
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 11, clones = { 2 } },
            },
            forces = 46,
            cumulative = 340,
        },
        {
            enemies = {
                { enemy = 12, clones = { 2, 3, 1 } },
                { enemy = 11, clones = { 1 } },
                { enemy = 10, clones = { 3, 6 } },
            },
            forces = 60,
            cumulative = 400,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3, 2 } },
            },
            forces = 0,
            cumulative = 400,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 400,
        },
        {
            enemies = {
                { enemy = 16, clones = { 1, 2, 3, 4, 10, 9, 5 } },
                { enemy = 17, clones = { 1, 3, 4, 2, 5, 6, 18, 15, 23, 22, 14, 9 } },
                { enemy = 18, clones = { 1, 2 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 10, clones = { 9 } },
            },
            forces = 99,
            cumulative = 499,
        },
        {
            enemies = {
                { enemy = 17, clones = { 19, 16, 20, 11, 13, 21 } },
                { enemy = 19, clones = { 1 } },
                { enemy = 16, clones = { 7, 8 } },
            },
            forces = 40,
            cumulative = 539,
            boss = true,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
                { enemy = 17, clones = { 7, 8, 12, 10 } },
            },
            forces = 0,
            cumulative = 539,
            boss = true,
        },
    },
    enemyForces = 539,
    wclReport = "Cya4mBzn9kWdJ2K6",
    wclFight = 1,
    title = "+23 · 25:44",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/20990037-23-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/Rn51PBs",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 23,
    keyLevel = 23,
    clearSeconds = 1544,
    onTime = true,
    rank = 1,
    region = "world",
    bracket = "high",
    tier = "fast",
    roster = {
        { name = "神奇的阿诺", class = "Death Knight", spec = "Blood", role = "tank" },
        { name = "孤独咩", class = "Shaman", spec = "Elemental", role = "dps" },
        { name = "Rosebankk", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "叶落初冬", class = "Rogue", spec = "Subtlety", role = "dps" },
        { name = "会挽弓如满月", class = "Paladin", spec = "Holy", role = "healer" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-21242523",
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
                { enemy = 2, clones = { 4, 10 } },
                { enemy = 3, clones = { 4, 6 } },
                { enemy = 4, clones = { 6 } },
                { enemy = 5, clones = { 22 } },
                { enemy = 6, clones = { 1 } },
            },
            forces = 57,
            cumulative = 131,
            boss = true,
        },
        {
            enemies = {
                { enemy = 3, clones = { 9 } },
                { enemy = 4, clones = { 9, 8 } },
                { enemy = 2, clones = { 7, 8, 6 } },
                { enemy = 5, clones = { 49, 50 } },
            },
            forces = 34,
            cumulative = 165,
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
                { enemy = 12, clones = { 6, 9 } },
                { enemy = 10, clones = { 7, 10 } },
                { enemy = 11, clones = { 4 } },
            },
            forces = 53,
            cumulative = 218,
        },
        {
            enemies = {
                { enemy = 12, clones = { 4 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 11, clones = { 3 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 79,
            cumulative = 297,
            boss = true,
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
                { enemy = 12, clones = { 2, 1 } },
                { enemy = 10, clones = { 3, 6 } },
                { enemy = 11, clones = { 1 } },
            },
            forces = 53,
            cumulative = 403,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3, 2 } },
            },
            forces = 0,
            cumulative = 403,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 403,
        },
        {
            enemies = {
                { enemy = 16, clones = { 1, 2, 3, 4, 10, 9, 5 } },
                { enemy = 17, clones = { 5, 6, 4, 15, 14, 18, 23, 22, 1 } },
                { enemy = 18, clones = { 1, 2 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 10, clones = { 9 } },
            },
            forces = 99,
            cumulative = 502,
        },
        {
            enemies = {
                { enemy = 17, clones = { 10, 11, 12, 7, 8, 9 } },
                { enemy = 19, clones = { 1 } },
                { enemy = 16, clones = { 7, 8 } },
            },
            forces = 40,
            cumulative = 542,
            boss = true,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
                { enemy = 17, clones = { 19, 16, 20, 21, 13 } },
            },
            forces = 0,
            cumulative = 542,
            boss = true,
        },
    },
    enemyForces = 542,
    wclReport = "hHZ8KbRArqL27wyg",
    wclFight = 8,
    filled = 1,
    title = "+19 · 23:10",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/21242523-19-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/9zMmNPF",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 19,
    keyLevel = 19,
    clearSeconds = 1390,
    onTime = true,
    rank = 6396,
    region = "world",
    bracket = "mid",
    tier = "fast",
    roster = {
        { name = "Shampal", class = "Paladin", spec = "Holy", role = "healer" },
        { name = "Foxwhiskey", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "Hexoxo", class = "Shaman", spec = "Elemental", role = "dps" },
        { name = "Legiongrubok", class = "Death Knight", spec = "Blood", role = "tank" },
        { name = "Amerigo", class = "Rogue", spec = "Subtlety", role = "dps" },
    },
    enemyForcesRequired = 551,
})
