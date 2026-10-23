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
    rank = 3490,
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
    id = "rio-14119190",
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
                { enemy = 4, clones = { 6 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 5, clones = { 49, 48, 50 } },
            },
            forces = 57,
            cumulative = 131,
            boss = true,
        },
        {
            enemies = {
                { enemy = 4, clones = { 9 } },
                { enemy = 2, clones = { 7 } },
                { enemy = 3, clones = { 9 } },
            },
            forces = 17,
            cumulative = 148,
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
                { enemy = 23, clones = { 1 } },
            },
            forces = 0,
            cumulative = 160,
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
                { enemy = 12, clones = { 4 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 11, clones = { 3 } },
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
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 412,
        },
        {
            enemies = {
                { enemy = 17, clones = { 1, 6, 4, 3, 5, 2 } },
                { enemy = 16, clones = { 2, 1, 3, 4 } },
                { enemy = 18, clones = { 1 } },
                { enemy = 12, clones = { 7 } },
            },
            forces = 52,
            cumulative = 464,
        },
        {
            enemies = {
                { enemy = 16, clones = { 5, 7, 8 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 18, clones = { 2 } },
                { enemy = 17, clones = { 21, 11, 9, 13, 19, 7, 12, 20, 8, 10 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 77,
            cumulative = 541,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 14, 22, 23, 16, 15 } },
            },
            forces = 0,
            cumulative = 541,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
                { enemy = 17, clones = { 18 } },
            },
            forces = 0,
            cumulative = 541,
            boss = true,
        },
    },
    enemyForces = 541,
    wclReport = "aQKxbjBZhwVWLqJA",
    wclFight = 26,
    title = "+21 · 27:17",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/14119190-21-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/hOlKZnE",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 21,
    keyLevel = 21,
    clearSeconds = 1637,
    onTime = true,
    rank = 1518,
    region = "world",
    bracket = "high",
    tier = "slow",
    roster = {
        { name = "皓月当空", class = "Mage", spec = "Arcane", role = "dps" },
        { name = "小软饱饱", class = "Shaman", spec = "Elemental", role = "dps" },
        { name = "戰临丷", class = "Death Knight", spec = "Blood", role = "tank" },
        { name = "丶小月光", class = "Paladin", spec = "Holy", role = "healer" },
        { name = "生气大王子", class = "Warrior", spec = "Arms", role = "dps" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-16003044",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 1, clones = { 1 } },
                { enemy = 2, clones = { 9, 1, 2, 3, 4, 10, 8 } },
                { enemy = 3, clones = { 8, 1, 4, 6, 5 } },
                { enemy = 4, clones = { 1, 3, 6 } },
                { enemy = 5, clones = { 22, 17, 20, 19, 48, 49, 50 } },
                { enemy = 6, clones = { 1 } },
            },
            forces = 136,
            cumulative = 136,
            boss = true,
        },
        {
            enemies = {
                { enemy = 4, clones = { 8 } },
                { enemy = 2, clones = { 6 } },
            },
            forces = 12,
            cumulative = 148,
        },
        {
            enemies = {
                { enemy = 4, clones = { 9 } },
                { enemy = 2, clones = { 7 } },
                { enemy = 3, clones = { 9 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 17,
            cumulative = 165,
            boss = true,
        },
        {
            enemies = {
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
                { enemy = 12, clones = { 2, 1 } },
                { enemy = 10, clones = { 3, 6 } },
                { enemy = 11, clones = { 1 } },
            },
            forces = 53,
            cumulative = 417,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3, 2 } },
                { enemy = 8, clones = { 22 } },
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
                { enemy = 16, clones = { 2, 1, 3, 4, 10, 9, 5, 8, 7 } },
                { enemy = 17, clones = { 6, 5, 4, 18, 14, 23, 15, 11, 21, 12, 1 } },
                { enemy = 18, clones = { 1, 2 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 139,
            cumulative = 556,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 8, 9, 10 } },
            },
            forces = 0,
            cumulative = 556,
        },
        {
            enemies = {
                { enemy = 17, clones = { 19, 20, 16 } },
            },
            forces = 0,
            cumulative = 556,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
                { enemy = 17, clones = { 13, 22, 7 } },
            },
            forces = 0,
            cumulative = 556,
            boss = true,
        },
    },
    enemyForces = 556,
    wclReport = "bcpvPqr7D9AyMmKf",
    wclFight = 5,
    title = "+19 · 22:33",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/16003044-19-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/u4d4kQX",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 19,
    keyLevel = 19,
    clearSeconds = 1353,
    onTime = true,
    rank = 9161,
    region = "world",
    bracket = "mid",
    tier = "fast",
    roster = {
        { name = "Jonewrld", class = "Rogue", spec = "Assassination", role = "dps" },
        { name = "Olssonx", class = "Shaman", spec = "Restoration", role = "healer" },
        { name = "Flypside", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "Ashkek", class = "Druid", spec = "Feral", role = "dps" },
        { name = "Qldurtms", class = "Death Knight", spec = "Blood", role = "tank" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-16543276",
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
                { enemy = 4, clones = { 6 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 5, clones = { 48, 49, 50 } },
            },
            forces = 57,
            cumulative = 131,
            boss = true,
        },
        {
            enemies = {
                { enemy = 4, clones = { 9, 8 } },
                { enemy = 2, clones = { 7, 6 } },
                { enemy = 3, clones = { 9 } },
            },
            forces = 29,
            cumulative = 160,
        },
        {
            enemies = {
                { enemy = 7, clones = { 1 } },
            },
            forces = 0,
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
                { enemy = 10, clones = { 10 } },
                { enemy = 12, clones = { 9 } },
            },
            forces = 39,
            cumulative = 199,
        },
        {
            enemies = {
                { enemy = 11, clones = { 3 } },
                { enemy = 12, clones = { 4 } },
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
                { enemy = 10, clones = { 7 } },
                { enemy = 8, clones = { 22 } },
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 1 } },
            },
            forces = 7,
            cumulative = 405,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 2 } },
                { enemy = 12, clones = { 6 } },
            },
            forces = 7,
            cumulative = 412,
        },
        {
            enemies = {
                { enemy = 16, clones = { 1, 2, 4, 3, 5, 10, 8, 7, 9 } },
                { enemy = 17, clones = { 6, 4, 18, 15, 14, 23, 10, 9, 7, 11, 1, 5 } },
                { enemy = 18, clones = { 1, 2 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 139,
            cumulative = 551,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 19 } },
            },
            forces = 0,
            cumulative = 551,
        },
        {
            enemies = {
                { enemy = 17, clones = { 22 } },
            },
            forces = 0,
            cumulative = 551,
        },
        {
            enemies = {
                { enemy = 17, clones = { 20, 16 } },
            },
            forces = 0,
            cumulative = 551,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
                { enemy = 17, clones = { 8, 13, 21, 12 } },
            },
            forces = 0,
            cumulative = 551,
            boss = true,
        },
    },
    enemyForces = 551,
    wclReport = "24BPVghWmHJ8CzvD",
    wclFight = 17,
    filled = 4,
    title = "+22 · 27:23",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/16543276-22-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/FDI8WSl",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 22,
    keyLevel = 22,
    clearSeconds = 1643,
    onTime = true,
    rank = 317,
    region = "world",
    bracket = "high",
    tier = "slow",
    roster = {
        { name = "Mageroysong", class = "Mage", spec = "Arcane", role = "dps" },
        { name = "超可爱", class = "Paladin", spec = "Holy", role = "healer" },
        { name = "小软饱饱", class = "Shaman", spec = "Elemental", role = "dps" },
        { name = "戰临丶", class = "Death Knight", spec = "Blood", role = "tank" },
        { name = "生气大王子", class = "Warrior", spec = "Arms", role = "dps" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-18028941",
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
                { enemy = 3, clones = { 4, 6 } },
                { enemy = 2, clones = { 4, 10 } },
                { enemy = 4, clones = { 6 } },
                { enemy = 5, clones = { 22, 49, 50 } },
                { enemy = 6, clones = { 1 } },
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
                { enemy = 2, clones = { 8, 7 } },
                { enemy = 3, clones = { 9 } },
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
                { enemy = 12, clones = { 6 } },
                { enemy = 10, clones = { 7, 10 } },
                { enemy = 11, clones = { 4 } },
            },
            forces = 46,
            cumulative = 211,
        },
        {
            enemies = {
                { enemy = 12, clones = { 4 } },
                { enemy = 11, clones = { 3 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 79,
            cumulative = 290,
            boss = true,
        },
        {
            enemies = {
                { enemy = 12, clones = { 8 } },
                { enemy = 10, clones = { 2 } },
            },
            forces = 14,
            cumulative = 304,
        },
        {
            enemies = {
                { enemy = 12, clones = { 10, 3 } },
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 11, clones = { 2 } },
            },
            forces = 53,
            cumulative = 357,
        },
        {
            enemies = {
                { enemy = 10, clones = { 3, 6 } },
                { enemy = 12, clones = { 1, 2 } },
                { enemy = 11, clones = { 1 } },
            },
            forces = 53,
            cumulative = 410,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3 } },
            },
            forces = 0,
            cumulative = 410,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 2 } },
            },
            forces = 0,
            cumulative = 410,
        },
        {
            enemies = {
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 410,
        },
        {
            enemies = {
                { enemy = 17, clones = { 1, 15, 5, 14, 23, 18, 22, 21, 13, 4, 6 } },
                { enemy = 16, clones = { 2, 1, 4, 3, 5, 9, 8, 10 } },
                { enemy = 18, clones = { 1, 2 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 10, clones = { 9 } },
            },
            forces = 104,
            cumulative = 514,
        },
        {
            enemies = {
                { enemy = 17, clones = { 7, 8 } },
            },
            forces = 0,
            cumulative = 514,
        },
        {
            enemies = {
                { enemy = 19, clones = { 1 } },
                { enemy = 16, clones = { 7 } },
            },
            forces = 35,
            cumulative = 549,
            boss = true,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
                { enemy = 17, clones = { 20, 11, 19, 16 } },
            },
            forces = 0,
            cumulative = 549,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 10, 12, 9 } },
            },
            forces = 0,
            cumulative = 549,
        },
    },
    enemyForces = 549,
    wclReport = "KVYZWzqM7Lghn2bF",
    wclFight = 58,
    filled = 3,
    title = "+19 · 24:31",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/18028941-19-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/TmJyHtm",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 19,
    keyLevel = 19,
    clearSeconds = 1471,
    onTime = true,
    rank = 9600,
    region = "world",
    bracket = "mid",
    tier = "slow",
    roster = {
        { name = "Shindigw-235503701", class = "Rogue", spec = "Assassination", role = "dps" },
        { name = "Youknowthis", class = "Mage", spec = "Arcane", role = "dps" },
        { name = "Ochrdk", class = "Death Knight", spec = "Blood", role = "tank" },
        { name = "Cocozai", class = "Shaman", spec = "Elemental", role = "dps" },
        { name = "Lightiuz", class = "Paladin", spec = "Holy", role = "healer" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-20695740",
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
                { enemy = 3, clones = { 6, 9 } },
                { enemy = 2, clones = { 10, 6, 7 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 4, clones = { 6, 8 } },
                { enemy = 5, clones = { 50, 48, 49 } },
            },
            forces = 69,
            cumulative = 153,
            boss = true,
        },
        {
            enemies = {
                { enemy = 4, clones = { 9 } },
                { enemy = 2, clones = { 8 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 12,
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
                { enemy = 17, clones = { 6, 3, 2, 5, 4, 1 } },
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
                { enemy = 18, clones = { 2 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 17, clones = { 18, 15, 14, 12 } },
            },
            forces = 54,
            cumulative = 516,
        },
        {
            enemies = {
                { enemy = 17, clones = { 8, 10, 11, 20, 9, 13, 21, 7, 16, 19 } },
                { enemy = 19, clones = { 1 } },
                { enemy = 16, clones = { 7, 8 } },
            },
            forces = 40,
            cumulative = 556,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 22, 23 } },
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 0,
            cumulative = 556,
            boss = true,
        },
    },
    enemyForces = 556,
    wclReport = "8fPjdtzM4N6V7ZKh",
    wclFight = 1,
    filled = 1,
    title = "+21 · 24:36",
    author = "Guardian Druid",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/20695740-21-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/UxsoYUx",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 21,
    keyLevel = 21,
    clearSeconds = 1476,
    onTime = true,
    rank = 535,
    region = "world",
    bracket = "high",
    tier = "fast",
    roster = {
        { name = "Exxibae", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "Skollcat", class = "Druid", spec = "Guardian", role = "tank" },
        { name = "Vincentxyz", class = "Shaman", spec = "Elemental", role = "dps" },
        { name = "Cosmickaguya", class = "Death Knight", spec = "Frost", role = "dps" },
        { name = "Headpats", class = "Paladin", spec = "Holy", role = "healer" },
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
    rank = 3046,
    region = "us",
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
    rank = 2,
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
    id = "rio-20996548",
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
                { enemy = 3, clones = { 6 } },
                { enemy = 4, clones = { 6, 8 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 2, clones = { 10, 6 } },
                { enemy = 5, clones = { 50, 49, 48 } },
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
                { enemy = 22, clones = { 3 } },
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
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 412,
        },
        {
            enemies = {
                { enemy = 17, clones = { 5, 2, 1, 3, 4, 6, 23, 18 } },
                { enemy = 16, clones = { 1, 2, 4, 3 } },
                { enemy = 18, clones = { 1 } },
            },
            forces = 45,
            cumulative = 457,
        },
        {
            enemies = {
                { enemy = 12, clones = { 7 } },
                { enemy = 16, clones = { 10, 9, 5, 7, 8 } },
                { enemy = 18, clones = { 2 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 17, clones = { 15, 14, 12, 7, 22 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 94,
            cumulative = 551,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 16, 19 } },
            },
            forces = 0,
            cumulative = 551,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
                { enemy = 17, clones = { 20, 21, 13, 11 } },
            },
            forces = 0,
            cumulative = 551,
            boss = true,
        },
    },
    enemyForces = 551,
    wclReport = "FHZCDGKP2JYjgRap",
    wclFight = 13,
    title = "+20 · 23:56",
    author = "Guardian Druid",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/20996548-20-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/FO7iKpf",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 20,
    keyLevel = 20,
    clearSeconds = 1436,
    onTime = true,
    rank = 2470,
    region = "world",
    bracket = "mid",
    tier = "fast",
    roster = {
        { name = "Poshposh", class = "Rogue", spec = "Subtlety", role = "dps" },
        { name = "Fætterforhud", class = "Shaman", spec = "Restoration", role = "healer" },
        { name = "Gome", class = "Druid", spec = "Guardian", role = "tank" },
        { name = "Argawen", class = "Paladin", spec = "Retribution", role = "dps" },
        { name = "Hasugizzen", class = "Warrior", spec = "Arms", role = "dps" },
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
    rank = 71,
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
    id = "rio-21506669",
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
                { enemy = 2, clones = { 4, 10, 6 } },
                { enemy = 3, clones = { 4, 6 } },
                { enemy = 4, clones = { 6, 8 } },
                { enemy = 5, clones = { 22, 50, 48, 49 } },
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
                { enemy = 10, clones = { 10 } },
                { enemy = 12, clones = { 9 } },
            },
            forces = 39,
            cumulative = 199,
        },
        {
            enemies = {
                { enemy = 11, clones = { 3 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 12, clones = { 4 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 79,
            cumulative = 278,
            boss = true,
        },
        {
            enemies = {
                { enemy = 10, clones = { 2 } },
                { enemy = 12, clones = { 8 } },
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
                { enemy = 8, clones = { 22 } },
                { enemy = 10, clones = { 7 } },
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3 } },
                { enemy = 12, clones = { 6 } },
            },
            forces = 14,
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
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 412,
        },
        {
            enemies = {
                { enemy = 17, clones = { 1, 3, 6, 4, 14, 15, 22, 23, 18, 2, 5 } },
                { enemy = 16, clones = { 2, 1, 3, 4, 10, 9, 5 } },
                { enemy = 18, clones = { 1, 2 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 10, clones = { 9 } },
            },
            forces = 99,
            cumulative = 511,
        },
        {
            enemies = {
                { enemy = 17, clones = { 10, 9, 8, 19, 11, 16, 21, 12, 20, 13, 7 } },
                { enemy = 19, clones = { 1 } },
                { enemy = 16, clones = { 8, 7 } },
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 40,
            cumulative = 551,
            boss = true,
        },
    },
    enemyForces = 551,
    wclReport = "bPaprAc98dkyYXNf",
    wclFight = 15,
    title = "+22 · 24:50",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/21506669-22-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/3ChE0Ne",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 22,
    keyLevel = 22,
    clearSeconds = 1490,
    onTime = true,
    rank = 72,
    region = "world",
    bracket = "high",
    tier = "fast",
    roster = {
        { name = "Bondd", class = "Shaman", spec = "Elemental", role = "dps" },
        { name = "Messerknecht", class = "Rogue", spec = "Subtlety", role = "dps" },
        { name = "Ellesmére", class = "Paladin", spec = "Holy", role = "healer" },
        { name = "Yodadkt", class = "Death Knight", spec = "Blood", role = "tank" },
        { name = "Tankdmg", class = "Warrior", spec = "Arms", role = "dps" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-21519103",
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
                { enemy = 3, clones = { 6 } },
                { enemy = 2, clones = { 10 } },
                { enemy = 4, clones = { 6 } },
                { enemy = 5, clones = { 20, 18, 19, 22 } },
                { enemy = 6, clones = { 1 } },
            },
            forces = 47,
            cumulative = 131,
            boss = true,
        },
        {
            enemies = {
                { enemy = 4, clones = { 9, 8 } },
                { enemy = 2, clones = { 8, 7, 6 } },
                { enemy = 3, clones = { 9 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 34,
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
                { enemy = 12, clones = { 2, 1 } },
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
                { enemy = 17, clones = { 1, 6, 5, 4, 15, 18, 14, 11 } },
                { enemy = 16, clones = { 1, 2, 3, 4, 10, 9, 5 } },
                { enemy = 18, clones = { 1, 2 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 10, clones = { 9 } },
            },
            forces = 99,
            cumulative = 516,
        },
        {
            enemies = {
                { enemy = 17, clones = { 8, 7, 12, 10, 9 } },
                { enemy = 16, clones = { 7, 8 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 40,
            cumulative = 556,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 20 } },
            },
            forces = 0,
            cumulative = 556,
        },
        {
            enemies = {
                { enemy = 17, clones = { 21, 22, 23, 16, 19, 13 } },
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 0,
            cumulative = 556,
            boss = true,
        },
    },
    enemyForces = 556,
    wclReport = "RrWZPXmVyMfa8bvG",
    wclFight = 66,
    title = "+21 · 24:43",
    author = "Brewmaster Monk",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/21519103-21-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/GBMU5Xt",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 21,
    keyLevel = 21,
    clearSeconds = 1483,
    onTime = true,
    rank = 539,
    region = "world",
    bracket = "high",
    tier = "fast",
    roster = {
        { name = "Rockystorm", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "Cosini", class = "Druid", spec = "Feral", role = "dps" },
        { name = "Shamxi", class = "Shaman", spec = "Restoration", role = "healer" },
        { name = "Scoreboard", class = "Rogue", spec = "Subtlety", role = "dps" },
        { name = "Fizzmonk", class = "Monk", spec = "Brewmaster", role = "tank" },
    },
    enemyForcesRequired = 551,
})

R:RegisterRoute({
    id = "rio-21939489",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 3, clones = { 8, 1, 5 } },
                { enemy = 2, clones = { 9, 1, 2, 3 } },
                { enemy = 1, clones = { 1 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 74,
            cumulative = 74,
        },
        {
            enemies = {
                { enemy = 2, clones = { 4, 10, 7 } },
                { enemy = 3, clones = { 4, 6, 9 } },
                { enemy = 4, clones = { 6, 9 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 5, clones = { 49, 48, 50 } },
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
                { enemy = 11, clones = { 4 } },
                { enemy = 10, clones = { 10 } },
                { enemy = 12, clones = { 9 } },
            },
            forces = 39,
            cumulative = 199,
        },
        {
            enemies = {
                { enemy = 11, clones = { 3 } },
                { enemy = 12, clones = { 4, 8 } },
                { enemy = 10, clones = { 1, 2 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 93,
            cumulative = 292,
            boss = true,
        },
        {
            enemies = {
                { enemy = 12, clones = { 10 } },
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 11, clones = { 2 } },
            },
            forces = 46,
            cumulative = 338,
        },
        {
            enemies = {
                { enemy = 12, clones = { 2, 3 } },
                { enemy = 11, clones = { 1 } },
                { enemy = 10, clones = { 6 } },
            },
            forces = 46,
            cumulative = 384,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3, 1 } },
            },
            forces = 0,
            cumulative = 384,
            boss = true,
        },
        {
            enemies = {
                { enemy = 12, clones = { 6 } },
                { enemy = 10, clones = { 7 } },
                { enemy = 22, clones = { 2 } },
                { enemy = 8, clones = { 22 } },
            },
            forces = 14,
            cumulative = 398,
        },
        {
            enemies = {
                { enemy = 17, clones = { 2, 3, 6, 5, 4, 18, 23, 15, 14, 22 } },
                { enemy = 18, clones = { 1, 2 } },
                { enemy = 16, clones = { 3, 9, 10, 5 } },
                { enemy = 12, clones = { 7 } },
                { enemy = 10, clones = { 9 } },
            },
            forces = 84,
            cumulative = 482,
        },
        {
            enemies = {
                { enemy = 17, clones = { 12, 9, 20, 7, 11, 21 } },
                { enemy = 19, clones = { 1 } },
                { enemy = 16, clones = { 7, 8 } },
            },
            forces = 40,
            cumulative = 522,
            boss = true,
        },
        {
            enemies = {
                { enemy = 16, clones = { 4 } },
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
                { enemy = 17, clones = { 16, 19 } },
            },
            forces = 5,
            cumulative = 527,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 10, 13, 8 } },
            },
            forces = 0,
            cumulative = 527,
        },
    },
    enemyForces = 527,
    wclReport = "hTt36afQvcNKwn7M",
    wclFight = 11,
    filled = 1,
    title = "+23 · 26:23",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/21939489-23-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/JWA1nMA",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 23,
    keyLevel = 23,
    clearSeconds = 1583,
    onTime = true,
    rank = 3,
    region = "world",
    bracket = "high",
    tier = "fast",
    roster = {
        { name = "Mjtwarrior", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "我要退休了", class = "Shaman", spec = "Elemental", role = "dps" },
        { name = "裂风酱鹅", class = "Death Knight", spec = "Blood", role = "tank" },
        { name = "胖矮瓜", class = "Paladin", spec = "Holy", role = "healer" },
        { name = "炸猪猪排", class = "Rogue", spec = "Subtlety", role = "dps" },
    },
    enemyForcesRequired = 551,
})
