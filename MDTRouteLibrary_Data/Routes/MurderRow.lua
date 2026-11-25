-- Erzeugt von tools/generate-lua.mjs. Nicht von Hand bearbeiten.

local R = MDTRouteLibrary

R:RegisterRoute({
    id = "rio-22356051",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 1, clones = { 5, 4, 6, 2, 1, 8, 3, 9, 7 } },
                { enemy = 3, clones = { 3, 4, 5, 1, 2 } },
                { enemy = 5, clones = { 1 } },
                { enemy = 8, clones = { 6, 3 } },
                { enemy = 2, clones = { 4, 3 } },
                { enemy = 4, clones = { 1 } },
            },
            forces = 116,
            cumulative = 116,
        },
        {
            enemies = {
                { enemy = 8, clones = { 4, 5 } },
                { enemy = 2, clones = { 10, 9, 11, 12 } },
                { enemy = 7, clones = { 1 } },
                { enemy = 1, clones = { 14, 12, 13, 10, 11 } },
                { enemy = 3, clones = { 6, 7 } },
                { enemy = 37, clones = { 3, 4, 1, 2 } },
            },
            forces = 49,
            cumulative = 165,
        },
        {
            enemies = {
                { enemy = 4, clones = { 4 } },
                { enemy = 2, clones = { 6, 5 } },
                { enemy = 1, clones = { 15, 17, 18, 16 } },
                { enemy = 3, clones = { 9, 8 } },
                { enemy = 6, clones = { 5 } },
                { enemy = 39, clones = { 1 } },
            },
            forces = 61,
            cumulative = 226,
        },
        {
            enemies = {
                { enemy = 8, clones = { 1, 2 } },
                { enemy = 2, clones = { 7, 8 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 12,
            cumulative = 238,
            boss = true,
        },
        {
            enemies = {
                { enemy = 10, clones = { 1, 2 } },
                { enemy = 9, clones = { 2, 1, 3, 4, 5, 6 } },
                { enemy = 22, clones = { 1 } },
            },
            forces = 26,
            cumulative = 264,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 6 } },
                { enemy = 11, clones = { 55, 56, 57 } },
                { enemy = 14, clones = { 8, 9, 7 } },
                { enemy = 13, clones = { 7, 6, 5 } },
                { enemy = 12, clones = { 12, 11, 10, 9 } },
            },
            forces = 87,
            cumulative = 351,
        },
        {
            enemies = {
                { enemy = 16, clones = { 1, 4, 9, 2, 5, 8, 6, 7, 19, 21, 20, 18 } },
                { enemy = 15, clones = { 1 } },
                { enemy = 14, clones = { 11, 10 } },
            },
            forces = 47,
            cumulative = 398,
        },
        {
            enemies = {
                { enemy = 12, clones = { 14, 13 } },
                { enemy = 6, clones = { 2 } },
                { enemy = 13, clones = { 12, 10 } },
                { enemy = 17, clones = { 7 } },
            },
            forces = 55,
            cumulative = 453,
        },
        {
            enemies = {
                { enemy = 16, clones = { 13, 10, 12, 11, 16, 14, 15, 17 } },
                { enemy = 18, clones = { 1 } },
                { enemy = 12, clones = { 15, 16 } },
            },
            forces = 48,
            cumulative = 501,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
            },
            forces = 0,
            cumulative = 501,
            boss = true,
        },
        {
            enemies = {
                { enemy = 13, clones = { 1 } },
                { enemy = 12, clones = { 1, 3 } },
                { enemy = 11, clones = { 12, 11, 2, 9, 8, 10, 26, 27, 30, 29, 25, 28 } },
                { enemy = 14, clones = { 4, 3 } },
            },
            forces = 51,
            cumulative = 552,
        },
        {
            enemies = {
                { enemy = 14, clones = { 5, 6 } },
                { enemy = 13, clones = { 4 } },
                { enemy = 11, clones = { 20, 21, 24, 19, 22, 23, 13, 15, 17, 16, 14, 18 } },
            },
            forces = 41,
            cumulative = 593,
        },
        {
            enemies = {
                { enemy = 17, clones = { 5 } },
                { enemy = 12, clones = { 4, 6, 5 } },
                { enemy = 15, clones = { 5 } },
            },
            forces = 65,
            cumulative = 658,
        },
        {
            enemies = {
                { enemy = 24, clones = { 1 } },
            },
            forces = 0,
            cumulative = 658,
            boss = true,
        },
    },
    enemyForces = 658,
    wclReport = "cZdnD2MkfCtK8A1p",
    wclFight = 3,
    title = "+17 · 25:19",
    author = "Protection Warrior",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/22356051-17-murder-row",
    keystoneUrl = "https://keystone.guru/route/murder-row/6n98X9M",
    challengeModeId = 587,
    dungeonEnglishName = "Murder Row",
    mdtDungeonIdx = 160,
    keyLevelMin = 17,
    keyLevel = 17,
    clearSeconds = 1519,
    onTime = true,
    rank = 2285,
    region = "tw",
    bracket = "mid",
    tier = "fast",
    roster = {
        { name = "心靈悸動", class = "Rogue", spec = "Subtlety", role = "dps" },
        { name = "多摩俏妞", class = "Druid", spec = "Balance", role = "dps" },
        { name = "多摩翔", class = "Warrior", spec = "Protection", role = "tank" },
        { name = "福德", class = "Paladin", spec = "Holy", role = "healer" },
        { name = "芙梨蓮", class = "Mage", spec = "Arcane", role = "dps" },
    },
    enemyForcesRequired = 655,
})

R:RegisterRoute({
    id = "rio-23556900",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 3, clones = { 4, 2, 1, 3 } },
                { enemy = 5, clones = { 1 } },
                { enemy = 1, clones = { 1, 2, 8, 4, 9, 3, 7, 5 } },
                { enemy = 2, clones = { 3, 4 } },
                { enemy = 4, clones = { 1 } },
            },
            forces = 102,
            cumulative = 102,
        },
        {
            enemies = {
                { enemy = 3, clones = { 5, 8, 9 } },
                { enemy = 1, clones = { 6, 17, 15, 18, 16 } },
                { enemy = 8, clones = { 6, 3 } },
                { enemy = 4, clones = { 4 } },
                { enemy = 2, clones = { 6, 5 } },
                { enemy = 39, clones = { 1 } },
                { enemy = 6, clones = { 5 } },
            },
            forces = 75,
            cumulative = 177,
        },
        {
            enemies = {
                { enemy = 8, clones = { 5, 4 } },
                { enemy = 2, clones = { 10, 9, 12, 11 } },
                { enemy = 1, clones = { 11, 10, 12, 13, 14 } },
                { enemy = 3, clones = { 6, 7 } },
                { enemy = 7, clones = { 1 } },
                { enemy = 37, clones = { 1, 2, 4, 3 } },
            },
            forces = 49,
            cumulative = 226,
        },
        {
            enemies = {
                { enemy = 2, clones = { 7, 8 } },
                { enemy = 21, clones = { 1 } },
                { enemy = 8, clones = { 1, 2 } },
            },
            forces = 12,
            cumulative = 238,
            boss = true,
        },
        {
            enemies = {
                { enemy = 9, clones = { 2, 1, 4, 6, 5, 3 } },
                { enemy = 22, clones = { 1 } },
                { enemy = 10, clones = { 1 } },
            },
            forces = 19,
            cumulative = 257,
            boss = true,
        },
        {
            enemies = {
                { enemy = 11, clones = { 55, 56 } },
                { enemy = 14, clones = { 9, 8, 10, 11 } },
                { enemy = 13, clones = { 7 } },
                { enemy = 16, clones = { 2, 1, 5, 4, 8, 7, 6, 9 } },
                { enemy = 15, clones = { 1 } },
            },
            forces = 64,
            cumulative = 321,
        },
        {
            enemies = {
                { enemy = 12, clones = { 13, 14 } },
                { enemy = 17, clones = { 7 } },
                { enemy = 16, clones = { 20, 21, 13, 10, 12, 11, 18, 19 } },
                { enemy = 13, clones = { 10, 12 } },
            },
            forces = 57,
            cumulative = 378,
        },
        {
            enemies = {
                { enemy = 16, clones = { 15, 14, 16, 17 } },
                { enemy = 12, clones = { 16, 15 } },
                { enemy = 18, clones = { 1 } },
            },
            forces = 44,
            cumulative = 422,
        },
        {
            enemies = {
                { enemy = 6, clones = { 4 } },
                { enemy = 20, clones = { 1 } },
            },
            forces = 6,
            cumulative = 428,
            boss = true,
        },
        {
            enemies = {
                { enemy = 12, clones = { 1, 3 } },
                { enemy = 13, clones = { 1 } },
                { enemy = 14, clones = { 3, 4 } },
                { enemy = 11, clones = { 25, 27, 29, 28, 26, 30 } },
            },
            forces = 39,
            cumulative = 467,
        },
        {
            enemies = {
                { enemy = 11, clones = { 11, 9, 2, 8, 12, 10 } },
            },
            forces = 12,
            cumulative = 479,
        },
        {
            enemies = {
                { enemy = 12, clones = { 4, 6, 5 } },
                { enemy = 15, clones = { 5 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 11, clones = { 36, 35, 32, 45, 44, 31, 38, 42, 41, 33, 34, 39 } },
            },
            forces = 70,
            cumulative = 549,
        },
        {
            enemies = {
                { enemy = 11, clones = { 52, 51, 53, 49, 50, 54 } },
            },
            forces = 12,
            cumulative = 561,
        },
        {
            enemies = {
                { enemy = 11, clones = { 46, 40, 43, 48, 47, 37 } },
            },
            forces = 12,
            cumulative = 573,
        },
        {
            enemies = {
                { enemy = 11, clones = { 23, 19, 20, 24, 22, 21 } },
            },
            forces = 12,
            cumulative = 585,
        },
        {
            enemies = {
                { enemy = 11, clones = { 15, 17, 14, 16, 18, 13 } },
            },
            forces = 12,
            cumulative = 597,
        },
        {
            enemies = {
                { enemy = 19, clones = { 7 } },
                { enemy = 12, clones = { 8, 7 } },
                { enemy = 13, clones = { 2, 3 } },
            },
            forces = 59,
            cumulative = 656,
        },
        {
            enemies = {
                { enemy = 24, clones = { 1 } },
            },
            forces = 0,
            cumulative = 656,
            boss = true,
        },
    },
    enemyForces = 656,
    wclReport = "1AWhVvdLbpy2gPak",
    wclFight = 59,
    title = "+24 · 31:18",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/23556900-24-murder-row",
    keystoneUrl = "https://keystone.guru/route/murder-row/9QdWJTJ",
    challengeModeId = 587,
    dungeonEnglishName = "Murder Row",
    mdtDungeonIdx = 160,
    keyLevelMin = 24,
    keyLevel = 24,
    clearSeconds = 1878,
    onTime = true,
    rank = 2,
    region = "world",
    bracket = "high",
    tier = "fast",
    roster = {
        { name = "斗篷小王子", class = "Rogue", spec = "Subtlety", role = "dps" },
        { name = "奶什么球", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "白白月光", class = "Paladin", spec = "Holy", role = "healer" },
        { name = "大人间失格", class = "Death Knight", spec = "Blood", role = "tank" },
        { name = "一期一会", class = "Shaman", spec = "Elemental", role = "dps" },
    },
    enemyForcesRequired = 655,
})
