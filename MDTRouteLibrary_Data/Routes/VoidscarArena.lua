-- Erzeugt von tools/generate-lua.mjs. Nicht von Hand bearbeiten.

local R = MDTRouteLibrary

R:RegisterRoute({
    id = "rio-7762998",
    source = "raider.io",
    pulls = {
        {
            enemies = {
                { enemy = 2, clones = { 11 } },
                { enemy = 5, clones = { 13 } },
                { enemy = 4, clones = { 6, 7 } },
                { enemy = 1, clones = { 11 } },
                { enemy = 6, clones = { 3, 2 } },
                { enemy = 7, clones = { 1 } },
            },
            forces = 64,
            cumulative = 64,
        },
        {
            enemies = {
                { enemy = 10, clones = { 1 } },
            },
            forces = 40,
            cumulative = 104,
        },
        {
            enemies = {
                { enemy = 4, clones = { 2, 1, 3 } },
                { enemy = 2, clones = { 2, 1, 3 } },
                { enemy = 3, clones = { 3, 2, 1 } },
                { enemy = 1, clones = { 3, 2, 1 } },
            },
            forces = 51,
            cumulative = 155,
        },
        {
            enemies = {
                { enemy = 11, clones = { 1 } },
                { enemy = 2, clones = { 4, 5 } },
                { enemy = 12, clones = { 1 } },
                { enemy = 4, clones = { 4, 5 } },
                { enemy = 13, clones = { 1 } },
            },
            forces = 53,
            cumulative = 208,
        },
        {
            enemies = {
                { enemy = 14, clones = { 1 } },
                { enemy = 15, clones = { 1 } },
                { enemy = 3, clones = { 4, 5 } },
                { enemy = 1, clones = { 4, 5 } },
                { enemy = 16, clones = { 1 } },
            },
            forces = 54,
            cumulative = 262,
        },
        {
            enemies = {
                { enemy = 25, clones = { 1 } },
            },
            forces = 0,
            cumulative = 262,
            boss = true,
        },
        {
            enemies = {
                { enemy = 18, clones = { 1 } },
                { enemy = 17, clones = { 1 } },
                { enemy = 6, clones = { 4 } },
                { enemy = 21, clones = { 1 } },
            },
            forces = 84,
            cumulative = 346,
        },
        {
            enemies = {
                { enemy = 21, clones = { 4 } },
            },
            forces = 65,
            cumulative = 411,
        },
        {
            enemies = {
                { enemy = 26, clones = { 1 } },
                { enemy = 28, clones = { 2, 1 } },
            },
            forces = 0,
            cumulative = 411,
            boss = true,
        },
        {
            enemies = {
                { enemy = 18, clones = { 14 } },
                { enemy = 17, clones = { 15, 17, 16 } },
                { enemy = 3, clones = { 6, 8, 7 } },
                { enemy = 1, clones = { 8 } },
                { enemy = 22, clones = { 1 } },
                { enemy = 24, clones = { 2, 1 } },
            },
            forces = 82,
            cumulative = 493,
        },
        {
            enemies = {
                { enemy = 2, clones = { 10, 9 } },
                { enemy = 22, clones = { 3 } },
                { enemy = 24, clones = { 6, 5 } },
                { enemy = 18, clones = { 15 } },
                { enemy = 1, clones = { 6, 9 } },
            },
            forces = 67,
            cumulative = 560,
        },
        {
            enemies = {
                { enemy = 21, clones = { 3 } },
                { enemy = 18, clones = { 8 } },
                { enemy = 2, clones = { 6 } },
                { enemy = 1, clones = { 7 } },
                { enemy = 23, clones = { 31, 36, 32, 34, 39, 35, 33, 38, 37, 40 } },
            },
            forces = 90,
            cumulative = 650,
        },
        {
            enemies = {
                { enemy = 22, clones = { 2 } },
                { enemy = 24, clones = { 4, 3 } },
                { enemy = 6, clones = { 14 } },
                { enemy = 17, clones = { 18, 6 } },
                { enemy = 23, clones = { 18, 17, 15, 12, 13, 20, 11, 14, 19, 16 } },
            },
            forces = 71,
            cumulative = 721,
        },
        {
            enemies = {
                {
                    enemy = 23,
                    clones = { 60, 56, 55, 51, 52, 53, 58, 57, 54, 59, 28, 27, 29, 25, 30, 21, 22, 26, 23, 24 },
                },
                { enemy = 27, clones = { 1 } },
            },
            forces = 20,
            cumulative = 741,
            boss = true,
        },
    },
    enemyForces = 741,
    wclReport = "NmGYcMD86kh94a1q",
    wclFight = 3,
    title = "+16 · 23:03",
    author = "Brewmaster Monk",
    url = "https://raider.io/mythic-plus-runs/season-mn-2/7762998-16-voidscar-arena",
    keystoneUrl = "https://keystone.guru/route/voidscar-arena/tHMoXgh",
    challengeModeId = 585,
    dungeonEnglishName = "Voidscar Arena",
    mdtDungeonIdx = 163,
    keyLevelMin = 16,
    keyLevel = 16,
    clearSeconds = 1383,
    onTime = true,
    rank = 10308,
    region = "us",
    bracket = "mid",
    tier = "fast",
    roster = {
        { name = "Littlehell", class = "Shaman", spec = "Restoration", role = "healer" },
        { name = "Quickwinnter", class = "Paladin", spec = "Retribution", role = "dps" },
        { name = "Shantiana", class = "Rogue", spec = "Outlaw", role = "dps" },
        { name = "Snapjutsu", class = "Monk", spec = "Brewmaster", role = "tank" },
        { name = "Buhyussy", class = "Warrior", spec = "Arms", role = "dps" },
    },
    enemyForcesRequired = 738,
})
