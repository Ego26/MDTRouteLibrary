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
    rank = 3658,
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
    id = "rio-18788683",
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
                { enemy = 2, clones = { 10, 6 } },
                { enemy = 4, clones = { 6, 8 } },
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
                { enemy = 12, clones = { 2, 1 } },
                { enemy = 10, clones = { 3, 6 } },
                { enemy = 11, clones = { 1 } },
            },
            forces = 53,
            cumulative = 398,
        },
        {
            enemies = {
                { enemy = 8, clones = { 22 } },
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3 } },
            },
            forces = 0,
            cumulative = 398,
            boss = true,
        },
        {
            enemies = {
                { enemy = 12, clones = { 6 } },
                { enemy = 10, clones = { 7 } },
                { enemy = 22, clones = { 2 } },
            },
            forces = 14,
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
                { enemy = 17, clones = { 2, 5, 4, 6, 18, 3 } },
                { enemy = 18, clones = { 1 } },
                { enemy = 16, clones = { 3, 4, 10, 9 } },
                { enemy = 12, clones = { 7 } },
            },
            forces = 52,
            cumulative = 464,
        },
        {
            enemies = {
                { enemy = 17, clones = { 22, 14, 15, 11, 23, 12 } },
                { enemy = 18, clones = { 2 } },
                { enemy = 16, clones = { 5 } },
                { enemy = 10, clones = { 9 } },
            },
            forces = 37,
            cumulative = 501,
        },
        {
            enemies = {
                { enemy = 17, clones = { 7, 8, 10, 9 } },
                { enemy = 19, clones = { 1 } },
                { enemy = 16, clones = { 7, 8 } },
            },
            forces = 40,
            cumulative = 541,
            boss = true,
        },
        {
            enemies = {
                { enemy = 17, clones = { 20 } },
            },
            forces = 0,
            cumulative = 541,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 17, clones = { 13, 16, 19, 21 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 0,
            cumulative = 541,
            boss = true,
        },
    },
    enemyForces = 541,
    wclReport = "JVXZxkh8rTwCNWq6",
    wclFight = 18,
    filled = 2,
    title = "+21 · 27:14",
    author = "Vengeance Demon Hunter",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/18788683-21-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/dxEBjfe",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 21,
    keyLevel = 21,
    clearSeconds = 1634,
    onTime = true,
    rank = 1735,
    region = "world",
    bracket = "high",
    tier = "slow",
    roster = {
        { name = "Qrva", class = "Paladin", spec = "Retribution", role = "dps" },
        { name = "Critcake", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "Alfamyscars", class = "Demon Hunter", spec = "Vengeance", role = "tank" },
        { name = "Spammingg", class = "Rogue", spec = "Assassination", role = "dps" },
        { name = "Laren", class = "Shaman", spec = "Restoration", role = "healer" },
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
    filled = 1,
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
    rank = 649,
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
    filled = 3,
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
    rank = 104,
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
    id = "rio-20930773",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 1, clones = { 1 } },
                { enemy = 2, clones = { 9, 1, 2, 3 } },
                { enemy = 3, clones = { 8, 1, 5 } },
                { enemy = 4, clones = { 3, 1 } },
            },
            forces = 74,
            cumulative = 74,
        },
        {
            enemies = {
                { enemy = 2, clones = { 4, 10 } },
                { enemy = 3, clones = { 4, 6 } },
                { enemy = 6, clones = { 1 } },
                { enemy = 5, clones = { 49, 50, 48 } },
                { enemy = 4, clones = { 6 } },
            },
            forces = 57,
            cumulative = 131,
            boss = true,
        },
        {
            enemies = {
                { enemy = 4, clones = { 8, 9 } },
                { enemy = 2, clones = { 6, 8, 7 } },
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
                { enemy = 10, clones = { 7 } },
                { enemy = 12, clones = { 6 } },
                { enemy = 11, clones = { 4 } },
            },
            forces = 39,
            cumulative = 204,
        },
        {
            enemies = {
                { enemy = 10, clones = { 10 } },
                { enemy = 12, clones = { 9 } },
            },
            forces = 14,
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
                { enemy = 11, clones = { 1 } },
                { enemy = 10, clones = { 6 } },
            },
            forces = 32,
            cumulative = 396,
        },
        {
            enemies = {
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 3, 2 } },
            },
            forces = 0,
            cumulative = 396,
            boss = true,
        },
        {
            enemies = {
                { enemy = 22, clones = { 1 } },
            },
            forces = 0,
            cumulative = 396,
        },
        {
            enemies = {
                { enemy = 17, clones = { 1, 5, 4, 3, 2, 6 } },
                { enemy = 16, clones = { 1, 2, 3, 4 } },
                { enemy = 18, clones = { 1 } },
            },
            forces = 45,
            cumulative = 441,
        },
        {
            enemies = {
                { enemy = 10, clones = { 9 } },
                { enemy = 17, clones = { 23, 14, 15, 18, 22 } },
                { enemy = 18, clones = { 2 } },
                { enemy = 16, clones = { 5, 9, 10 } },
                { enemy = 12, clones = { 7 } },
            },
            forces = 54,
            cumulative = 495,
        },
        {
            enemies = {
                { enemy = 17, clones = { 11, 21, 10, 7 } },
                { enemy = 19, clones = { 1 } },
                { enemy = 16, clones = { 8, 7 } },
            },
            forces = 40,
            cumulative = 535,
            boss = true,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 17, clones = { 9, 12, 13, 16, 8, 20, 19 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 0,
            cumulative = 535,
            boss = true,
        },
    },
    enemyForces = 535,
    wclReport = "vkhCZQAR1fnm4K8x",
    wclFight = 150,
    filled = 1,
    title = "+18 · 21:19",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/20930773-18-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/jaMtxnJ",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 18,
    keyLevel = 18,
    clearSeconds = 1279,
    onTime = true,
    rank = 7362,
    region = "eu",
    bracket = "mid",
    tier = "fast",
    roster = {
        { name = "Zrèox", class = "Mage", spec = "Arcane", role = "dps" },
        { name = "Jookadk", class = "Death Knight", spec = "Blood", role = "tank" },
        { name = "Murasasoeur", class = "Warlock", spec = "Demonology", role = "dps" },
        { name = "Hedasvalorin", class = "Paladin", spec = "Holy", role = "healer" },
        { name = "Nerodhqt", class = "Demon Hunter", spec = "Devourer", role = "dps" },
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
    rank = 2835,
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
    id = "rio-21172658",
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
                { enemy = 5, clones = { 46, 22, 50, 49, 48 } },
                { enemy = 2, clones = { 4, 10, 6, 7 } },
                { enemy = 3, clones = { 4, 6, 9 } },
                { enemy = 4, clones = { 6, 8, 9 } },
                { enemy = 6, clones = { 1 } },
            },
            forces = 86,
            cumulative = 148,
            boss = true,
        },
        {
            enemies = {
                { enemy = 7, clones = { 1 } },
                { enemy = 23, clones = { 1 } },
            },
            forces = 0,
            cumulative = 148,
            boss = true,
        },
        {
            enemies = {
                { enemy = 11, clones = { 4 } },
                { enemy = 10, clones = { 10 } },
                { enemy = 12, clones = { 9 } },
            },
            forces = 39,
            cumulative = 187,
        },
        {
            enemies = {
                { enemy = 12, clones = { 4 } },
                { enemy = 10, clones = { 1 } },
                { enemy = 11, clones = { 3 } },
                { enemy = 14, clones = { 1 } },
            },
            forces = 79,
            cumulative = 266,
            boss = true,
        },
        {
            enemies = {
                { enemy = 10, clones = { 2 } },
                { enemy = 12, clones = { 8 } },
            },
            forces = 14,
            cumulative = 280,
        },
        {
            enemies = {
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 12, clones = { 10, 3 } },
                { enemy = 11, clones = { 2 } },
            },
            forces = 53,
            cumulative = 333,
        },
        {
            enemies = {
                { enemy = 12, clones = { 2, 1 } },
                { enemy = 10, clones = { 3 } },
            },
            forces = 21,
            cumulative = 354,
        },
        {
            enemies = {
                { enemy = 11, clones = { 1 } },
                { enemy = 10, clones = { 6 } },
            },
            forces = 32,
            cumulative = 386,
        },
        {
            enemies = {
                { enemy = 8, clones = { 22 } },
                { enemy = 10, clones = { 7 } },
                { enemy = 12, clones = { 6 } },
                { enemy = 15, clones = { 1 } },
                { enemy = 22, clones = { 2 } },
            },
            forces = 14,
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
                { enemy = 17, clones = { 1, 3, 6, 4, 5, 2, 18, 15 } },
                { enemy = 16, clones = { 1, 2, 4, 3 } },
                { enemy = 18, clones = { 1 } },
            },
            forces = 45,
            cumulative = 445,
        },
        {
            enemies = {
                { enemy = 12, clones = { 7 } },
                { enemy = 16, clones = { 10, 9, 5, 7, 8 } },
                { enemy = 18, clones = { 2 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 17, clones = { 14, 23, 12, 10, 11, 20, 9, 13, 8, 16, 21 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 94,
            cumulative = 539,
            boss = true,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 17, clones = { 19, 22, 7 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 0,
            cumulative = 539,
            boss = true,
        },
    },
    enemyForces = 539,
    wclReport = "Y4a7zQNPCfXM61bZ",
    wclFight = 15,
    title = "+19 · 22:31",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/21172658-19-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/KHhK3gN",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 19,
    keyLevel = 19,
    clearSeconds = 1351,
    onTime = true,
    rank = 10089,
    region = "world",
    bracket = "mid",
    tier = "fast",
    roster = {
        { name = "我不吃牛肉", class = "Warrior", spec = "Arms", role = "dps" },
        { name = "你怎麼敢的呀", class = "Mage", spec = "Arcane", role = "dps" },
        { name = "Maru", class = "Shaman", spec = "Elemental", role = "dps" },
        { name = "艾艾聖", class = "Paladin", spec = "Holy", role = "healer" },
        { name = "Anon1267203E", class = "Death Knight", spec = "Blood", role = "tank" },
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
    rank = 101,
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
    rank = 647,
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
    filled = 2,
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
    rank = 4001,
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
    filled = 1,
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
    rank = 365,
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
    id = "rio-22245310",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 3, clones = { 8, 1, 5, 4 } },
                { enemy = 2, clones = { 9, 1, 3, 2, 4 } },
                { enemy = 1, clones = { 1 } },
                { enemy = 4, clones = { 1, 3 } },
            },
            forces = 84,
            cumulative = 84,
        },
        {
            enemies = {
                { enemy = 2, clones = { 10, 8 } },
                { enemy = 3, clones = { 6 } },
                { enemy = 5, clones = { 22, 49, 50, 48, 18 } },
                { enemy = 4, clones = { 6, 9 } },
                { enemy = 6, clones = { 1 } },
            },
            forces = 59,
            cumulative = 143,
            boss = true,
        },
        {
            enemies = {
                { enemy = 3, clones = { 9 } },
                { enemy = 2, clones = { 7, 6 } },
                { enemy = 4, clones = { 8 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 22,
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
                { enemy = 12, clones = { 8 } },
                { enemy = 10, clones = { 2 } },
            },
            forces = 14,
            cumulative = 311,
        },
        {
            enemies = {
                { enemy = 10, clones = { 5, 4 } },
                { enemy = 11, clones = { 2 } },
                { enemy = 12, clones = { 3, 10 } },
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
                { enemy = 22, clones = { 2, 3 } },
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
                { enemy = 16, clones = { 1, 2, 3, 4 } },
                { enemy = 17, clones = { 3, 6, 4, 2, 5, 1 } },
                { enemy = 18, clones = { 1 } },
                { enemy = 12, clones = { 7 } },
            },
            forces = 52,
            cumulative = 469,
        },
        {
            enemies = {
                { enemy = 17, clones = { 18, 23, 15, 14, 11, 19, 16, 20, 21, 10, 7, 8, 12, 9, 13 } },
                { enemy = 18, clones = { 2 } },
                { enemy = 16, clones = { 5, 7, 8 } },
                { enemy = 10, clones = { 9 } },
                { enemy = 19, clones = { 1 } },
            },
            forces = 77,
            cumulative = 546,
            boss = true,
        },
        {
            enemies = {
                { enemy = 20, clones = { 1 } },
                { enemy = 21, clones = { 1 } },
                { enemy = 17, clones = { 22 } },
            },
            forces = 0,
            cumulative = 546,
            boss = true,
        },
    },
    enemyForces = 546,
    wclReport = "fZTbMgaNdD3LXcjJ",
    wclFight = 1,
    filled = 4,
    title = "+20 · 27:06",
    author = "Blood Death Knight",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/22245310-20-ruby-life-pools",
    keystoneUrl = "https://keystone.guru/route/ruby-life-pools/gl09HO8",
    challengeModeId = 399,
    dungeonEnglishName = "Ruby Life Pools",
    mdtDungeonIdx = 42,
    keyLevelMin = 20,
    keyLevel = 20,
    clearSeconds = 1626,
    onTime = true,
    rank = 6444,
    region = "world",
    bracket = "mid",
    tier = "slow",
    roster = {
        { name = "Încôrêêz", class = "Paladin", spec = "Holy", role = "healer" },
        { name = "Nyxxie", class = "Death Knight", spec = "Blood", role = "tank" },
        { name = "Serahqt", class = "Mage", spec = "Arcane", role = "dps" },
        { name = "Excessu", class = "Shaman", spec = "Elemental", role = "dps" },
        { name = "Jinàloco", class = "Rogue", spec = "Subtlety", role = "dps" },
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
    filled = 1,
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
    rank = 3,
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
