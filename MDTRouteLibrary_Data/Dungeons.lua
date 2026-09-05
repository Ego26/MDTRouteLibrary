-- Erzeugt von tools/generate-lua.mjs. Nicht von Hand bearbeiten.

local R = MDTRouteLibrary

R:RegisterDungeon({
    challengeModeId = 588,
    englishName = "Altar of Fangs",
    shortName = "FANG",
    mdtDungeonIdx = 164,
    totalCount = 817,
    npcs = {
        [259445] = {
            name = "Rav'i",
            displayId = 144110,
            creatureType = "Beast",
            level = 92,
            health = 21216292,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1296050,
                },
                {
                    id = 1296058,
                },
                {
                    id = 1296069,
                    disease = true,
                },
                {
                    id = 1296216,
                },
                {
                    id = 1296219,
                },
                {
                    id = 1296220,
                },
                {
                    id = 1297876,
                },
                {
                    id = 1298221,
                },
            },
        },
        [259446] = {
            name = "The Writhing Coil",
            displayId = 144156,
            creatureType = "Beast",
            level = 92,
            health = 30405514,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1287798,
                },
                {
                    id = 1287811,
                },
                {
                    id = 1298949,
                },
                {
                    id = 1299053,
                },
                {
                    id = 1299080,
                },
                {
                    id = 1299130,
                },
                {
                    id = 1299135,
                },
                {
                    id = 1299154,
                },
            },
        },
        [259447] = {
            name = "Zul'jan",
            displayId = 145435,
            creatureType = "Humanoid",
            level = 92,
            health = 27027124,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1300876,
                },
                {
                    id = 1300886,
                },
                {
                    id = 1300888,
                },
                {
                    id = 1300892,
                },
                {
                    id = 1300894,
                },
                {
                    id = 1300901,
                },
                {
                    id = 1301111,
                },
                {
                    id = 1301114,
                },
            },
        },
        [261550] = {
            name = "Venom Leech",
            displayId = 146598,
            creatureType = "Beast",
            level = 90,
            health = 1945953,
            count = 1,
            spells = {
                {
                    id = 1294432,
                },
                {
                    id = 1305637,
                },
                {
                    id = 1306232,
                },
                {
                    id = 1306235,
                },
                {
                    id = 1307098,
                },
                {
                    id = 1307144,
                },
            },
        },
        [261552] = {
            name = "Bloodletter",
            displayId = 146661,
            creatureType = "Beast",
            level = 90,
            health = 3243255,
            count = 5,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1307526,
                },
            },
        },
        [261553] = {
            name = "Ravenous Descendant",
            displayId = 146654,
            creatureType = "Humanoid",
            level = 90,
            health = 3567581,
            count = 5,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1306308,
                    enrage = true,
                },
                {
                    id = 1306333,
                },
                {
                    id = 1306338,
                },
            },
        },
        [261554] = {
            name = "Twinfang Harrower",
            displayId = 147569,
            creatureType = "Beast",
            level = 91,
            health = 5513534,
            count = 25,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1294567,
                },
                {
                    id = 1294568,
                },
                {
                    id = 1294569,
                    magic = true,
                },
                {
                    id = 1294570,
                },
                {
                    id = 1294572,
                },
                {
                    id = 1306668,
                },
                {
                    id = 1306669,
                },
            },
        },
        [261556] = {
            name = "Hatchling",
            displayId = 146662,
            creatureType = "Beast",
            level = 90,
            health = 972977,
            count = 0,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1306383,
                },
            },
        },
        [261557] = {
            name = "High Evolutionist",
            displayId = 146663,
            creatureType = "Humanoid",
            level = 90,
            health = 2918930,
            count = 7,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1287544,
                },
                {
                    id = 1289416,
                    interruptible = true,
                    poison = true,
                },
                {
                    id = 1292904,
                },
                {
                    id = 1306385,
                },
                {
                    id = 1307567,
                    interruptible = true,
                },
                {
                    id = 1307571,
                    poison = true,
                },
                {
                    id = 1307602,
                },
            },
        },
        [261560] = {
            name = "Primal Serpent",
            displayId = 146653,
            creatureType = "Beast",
            level = 90,
            health = 2918930,
            count = 7,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1294557,
                    interruptible = true,
                },
                {
                    id = 1306381,
                },
            },
        },
        [261573] = {
            name = "Ascendant Serpent",
            displayId = 146299,
            creatureType = "Beast",
            level = 91,
            health = 8173003,
            count = 30,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1293420,
                },
                {
                    id = 1294934,
                },
                {
                    id = 1294958,
                },
                {
                    id = 1295055,
                },
                {
                    id = 1295073,
                },
                {
                    id = 1308864,
                },
                {
                    id = 1308865,
                },
            },
        },
        [262011] = {
            name = "Rattling Writhe",
            displayId = 146664,
            creatureType = "Beast",
            level = 91,
            health = 5513534,
            count = 25,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1294845,
                    poison = true,
                },
                {
                    id = 1294849,
                },
                {
                    id = 1294859,
                },
            },
        },
        [262398] = {
            name = "Uncoiled Writhe",
            displayId = 142361,
            creatureType = "Beast",
            level = 92,
            health = 33783904,
            count = 0,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1300503,
                },
                {
                    id = 1300618,
                },
                {
                    id = 1300698,
                },
                {
                    id = 1305368,
                    poison = true,
                },
                {
                    id = 1305393,
                },
                {
                    id = 1310666,
                    interruptible = true,
                },
            },
        },
        [263109] = {
            name = "Ula'tek's Chosen",
            displayId = 147578,
            creatureType = "Humanoid",
            level = 91,
            health = 4864883,
            count = 25,
            spells = {
                {
                    id = 1289416,
                    interruptible = true,
                    poison = true,
                },
                {
                    id = 1292892,
                },
                {
                    id = 1306852,
                },
                {
                    id = 1306853,
                },
                {
                    id = 1306856,
                },
                {
                    id = 1307567,
                    interruptible = true,
                },
                {
                    id = 1307571,
                    poison = true,
                },
            },
        },
        [263112] = {
            name = "Living Venom",
            displayId = 146677,
            creatureType = "Elemental",
            level = 90,
            health = 1297302,
            count = 1,
            spells = {
                {
                    id = 1303366,
                },
                {
                    id = 1306230,
                    poison = true,
                },
            },
        },
        [264798] = {
            name = "Infused Eggs",
            displayId = 144271,
            creatureType = "Not specified",
            level = 90,
            health = 648651,
            count = 0,
            spells = {
                {
                    id = 1293059,
                },
                {
                    id = 1293079,
                },
            },
        },
        [268358] = {
            name = "Ritual Snake",
            displayId = 11686,
            creatureType = "Beast",
            level = 90,
            health = 10000,
            count = 0,
            spells = {
                {
                    id = 1300885,
                },
            },
        },
        [270306] = {
            name = "Ritual Chieftain",
            displayId = 146680,
            creatureType = "Humanoid",
            level = 91,
            health = 5189208,
            count = 25,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1306517,
                },
                {
                    id = 1306550,
                },
                {
                    id = 1306641,
                },
                {
                    id = 1306844,
                },
                {
                    id = 1306893,
                },
                {
                    id = 1306911,
                },
            },
        },
        [270378] = {
            name = "Ritual Spirit",
            displayId = 146372,
            creatureType = "Humanoid",
            level = 91,
            health = 5189208,
            count = 0,
            spells = {
                {
                    id = 1306657,
                },
            },
        },
        [270417] = {
            name = "Uncoiled Writhe",
            displayId = 142361,
            creatureType = "Beast",
            level = 92,
            health = 32432550,
            count = 0,
            spells = {
                {
                    id = 1300618,
                },
                {
                    id = 1300698,
                },
                {
                    id = 1305393,
                },
            },
        },
        [271453] = {
            name = "Blade of the Altar",
            displayId = 147577,
            creatureType = "Humanoid",
            level = 90,
            health = 3243255,
            count = 5,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1308518,
                },
            },
        },
    },
    enemies = {
        [1] = {
            npc = 270306,
            count = 25,
            clones = 6,
            pos = {
                [1] = { 66, -205, 1 },
                [2] = { 201, -205, 1 },
                [3] = { 99, -292, 1 },
                [4] = { 161, -290, 1 },
                [5] = { 634, -167, 1 },
                [6] = { 649, -167, 1 },
            },
        },
        [2] = {
            npc = 261552,
            count = 5,
            clones = 16,
            pos = {
                [1] = { 352, -274, 1 },
                [2] = { 343, -275, 1 },
                [3] = { 303, -267, 1 },
                [4] = { 323, -295, 1 },
                [5] = { 331, -303, 1 },
                [6] = { 390, -290, 1 },
                [7] = { 377, -305, 1 },
                [8] = { 369, -241, 1 },
                [9] = { 387, -256, 1 },
                [10] = { 393, -266, 1 },
                [11] = { 474, -372, 1 },
                [12] = { 481, -364, 1 },
                [13] = { 468, -380, 1 },
                [14] = { 292, -227, 1 },
                [15] = { 302, -224, 1 },
                [16] = { 300, -236, 1 },
            },
        },
        [3] = {
            npc = 261557,
            count = 7,
            clones = 11,
            pos = {
                [1] = { 335, -243, 1 },
                [3] = { 298, -259, 1 },
                [4] = { 333, -292, 1 },
                [8] = { 362, -234, 1 },
                [9] = { 398, -255, 1 },
                [10] = { 466, -371, 1 },
                [11] = { 473, -361, 1 },
                [12] = { 777, -384, 1 },
                [13] = { 779, -423, 1 },
                [14] = { 739, -422, 1 },
                [15] = { 739, -383, 1 },
            },
        },
        [4] = {
            npc = 261556,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 404, -48, 1 },
            },
        },
        [5] = {
            npc = 263112,
            count = 1,
            clones = 18,
            pos = {
                [1] = { 639, -430, 1 },
                [2] = { 639, -452, 1 },
                [3] = { 647, -435, 1 },
                [4] = { 630, -447, 1 },
                [5] = { 630, -435, 1 },
                [6] = { 647, -447, 1 },
                [7] = { 614, -349, 1 },
                [8] = { 614, -371, 1 },
                [9] = { 624, -355, 1 },
                [10] = { 623, -367, 1 },
                [11] = { 605, -354, 1 },
                [12] = { 605, -367, 1 },
                [13] = { 660, -348, 1 },
                [14] = { 661, -370, 1 },
                [15] = { 669, -353, 1 },
                [16] = { 669, -365, 1 },
                [17] = { 651, -353, 1 },
                [18] = { 651, -366, 1 },
            },
        },
        [6] = {
            npc = 261560,
            count = 7,
            clones = 14,
            pos = {
                [1] = { 100, -181, 1 },
                [2] = { 109, -180, 1 },
                [3] = { 167, -227, 1 },
                [4] = { 160, -227, 1 },
                [5] = { 119, -202, 1 },
                [6] = { 146, -202, 1 },
                [8] = { 59, -205, 1 },
                [9] = { 202, -197, 1 },
                [11] = { 93, -305, 1 },
                [12] = { 104, -305, 1 },
                [13] = { 157, -303, 1 },
                [14] = { 168, -303, 1 },
                [15] = { 628, -284, 1 },
                [16] = { 651, -284, 1 },
            },
        },
        [7] = {
            npc = 261553,
            count = 5,
            clones = 19,
            pos = {
                [1] = { 100, -238, 1 },
                [2] = { 108, -239, 1 },
                [3] = { 115, -239, 1 },
                [4] = { 113, -231, 1 },
                [5] = { 104, -232, 1 },
                [6] = { 126, -213, 1 },
                [7] = { 140, -213, 1 },
                [8] = { 66, -197, 1 },
                [9] = { 66, -212, 1 },
                [11] = { 207, -205, 1 },
                [12] = { 128, -256, 1 },
                [13] = { 139, -256, 1 },
                [14] = { 87, -295, 1 },
                [15] = { 111, -296, 1 },
                [17] = { 128, -281, 1 },
                [18] = { 138, -281, 1 },
                [19] = { 175, -294, 1 },
                [20] = { 149, -295, 1 },
                [21] = { 201, -212, 1 },
            },
        },
        [8] = {
            npc = 263109,
            count = 25,
            clones = 4,
            pos = {
                [1] = { 639, -441, 1 },
                [2] = { 660, -359, 1 },
                [3] = { 614, -360, 1 },
                [4] = { 641, -180, 1 },
            },
        },
        [9] = {
            npc = 261573,
            count = 30,
            clones = 1,
            pos = {
                [1] = { 759, -403, 1 },
            },
        },
        [10] = {
            npc = 261554,
            count = 25,
            clones = 6,
            pos = {
                [1] = { 133, -201, 1 },
                [2] = { 126, -335, 1 },
                [3] = { 142, -336, 1 },
                [4] = { 640, -280, 1 },
                [5] = { 197, -100, 1 },
                [6] = { 70, -101, 1 },
            },
        },
        [11] = {
            npc = 261550,
            count = 1,
            clones = 28,
            pos = {
                [1] = { 80, -118, 1 },
                [2] = { 89, -118, 1 },
                [3] = { 98, -118, 1 },
                [4] = { 83, -126, 1 },
                [5] = { 93, -126, 1 },
                [6] = { 173, -119, 1 },
                [7] = { 182, -119, 1 },
                [8] = { 191, -119, 1 },
                [9] = { 187, -127, 1 },
                [10] = { 177, -128, 1 },
                [11] = { 155, -178, 1 },
                [12] = { 163, -179, 1 },
                [13] = { 170, -179, 1 },
                [14] = { 158, -185, 1 },
                [15] = { 167, -185, 1 },
                [16] = { 97, -231, 1 },
                [17] = { 108, -226, 1 },
                [18] = { 119, -232, 1 },
                [19] = { 171, -234, 1 },
                [20] = { 156, -234, 1 },
                [21] = { 163, -234, 1 },
                [22] = { 99, -261, 1 },
                [23] = { 107, -261, 1 },
                [24] = { 102, -268, 1 },
                [25] = { 160, -259, 1 },
                [26] = { 168, -258, 1 },
                [27] = { 160, -266, 1 },
                [28] = { 168, -265, 1 },
            },
        },
        [12] = {
            npc = 262011,
            count = 25,
            clones = 3,
            pos = {
                [1] = { 321, -260, 1 },
                [2] = { 379, -293, 1 },
                [3] = { 461, -359, 1 },
            },
        },
        [13] = {
            npc = 271453,
            count = 5,
            clones = 21,
            pos = {
                [1] = { 735, -392, 1 },
                [2] = { 785, -399, 1 },
                [3] = { 786, -409, 1 },
                [4] = { 742, -435, 1 },
                [5] = { 742, -444, 1 },
                [6] = { 634, -390, 1 },
                [7] = { 643, -390, 1 },
                [8] = { 633, -400, 1 },
                [9] = { 643, -400, 1 },
                [10] = { 664, -388, 1 },
                [11] = { 665, -400, 1 },
                [12] = { 610, -388, 1 },
                [13] = { 612, -399, 1 },
                [14] = { 663, -313, 1 },
                [15] = { 663, -322, 1 },
                [16] = { 613, -316, 1 },
                [17] = { 612, -326, 1 },
                [18] = { 634, -293, 1 },
                [19] = { 647, -293, 1 },
                [20] = { 630, -179, 1 },
                [21] = { 653, -180, 1 },
            },
        },
        [14] = {
            npc = 259445,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 135, -429, 1 },
            },
        },
        [15] = {
            npc = 259446,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 501, -390, 1 },
            },
        },
        [16] = {
            npc = 259447,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 639, -133, 1 },
            },
        },
        [17] = {
            npc = 262398,
            count = 0,
            clones = 2,
            pos = {
                [1] = { 501, -407, 1 },
                [2] = { 511, -403, 1 },
            },
        },
        [18] = {
            npc = 264798,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 346, -221, 1 },
            },
        },
        [19] = {
            npc = 268358,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 640, -111, 1 },
            },
        },
        [20] = {
            npc = 270378,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 417, -47, 1 },
            },
        },
        [21] = {
            npc = 270417,
            count = 0,
            clones = 2,
            pos = {
                [1] = { 517, -384, 1 },
                [2] = { 517, -394, 1 },
            },
        },
    },
    maps = {
        [1] = {
            path = "Interface\\AddOns\\MythicDungeonTools\\Midnight\\Textures\\AltarOfFangs",
            name = "Altar of Fangs",
        },
    },
})

R:RegisterDungeon({
    challengeModeId = 586,
    englishName = "Den of Nalorakk",
    shortName = "NALO",
    mdtDungeonIdx = 161,
    totalCount = 729,
    npcs = {
        [241808] = {
            name = "Territorial Matriarch",
            displayId = 14316,
            creatureType = "Beast",
            level = 90,
            health = 3729743,
            count = 8,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1238053,
                    enrage = true,
                },
                {
                    id = 1241219,
                },
            },
        },
        [241809] = {
            name = "Curious Yearling",
            displayId = 141179,
            creatureType = "Beast",
            level = 90,
            health = 778381,
            count = 0,
            spells = {
                {
                    id = 1238053,
                    enrage = true,
                },
            },
        },
        [241812] = {
            name = "The Hoardmonger",
            displayId = 129344,
            creatureType = "Humanoid",
            level = 92,
            health = 23648734,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1232012,
                },
                {
                    id = 1234021,
                },
                {
                    id = 1234233,
                },
                {
                    id = 1234681,
                },
                {
                    id = 1234734,
                },
                {
                    id = 1234846,
                    poison = true,
                },
                {
                    id = 1235072,
                },
            },
        },
        [241813] = {
            name = "Thornclaw Gatherer",
            displayId = 141213,
            creatureType = "Humanoid",
            level = 90,
            health = 3243255,
            count = 5,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1241217,
                },
                {
                    id = 1297699,
                    disease = true,
                },
                {
                    id = 1297701,
                },
            },
        },
        [241814] = {
            name = "Earthwhisper Tender",
            displayId = 128080,
            creatureType = "Humanoid",
            level = 90,
            health = 3729743,
            count = 7,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1241214,
                    interruptible = true,
                },
                {
                    id = 1297696,
                    interruptible = true,
                    magic = true,
                },
            },
        },
        [241816] = {
            name = "Keen-Eyed Striker",
            displayId = 124212,
            creatureType = "Beast",
            level = 90,
            health = 2918930,
            count = 7,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1238439,
                    bleed = true,
                },
                {
                    id = 1238440,
                },
            },
        },
        [241869] = {
            name = "Avatar of Determination",
            displayId = 128095,
            creatureType = "Undead",
            level = 91,
            health = 6486510,
            count = 28,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1240280,
                },
                {
                    id = 1241463,
                },
                {
                    id = 1241464,
                },
            },
        },
        [241872] = {
            name = "Frigid Mauler",
            displayId = 141288,
            creatureType = "Beast",
            level = 90,
            health = 3567581,
            count = 9,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1309919,
                    interruptible = true,
                },
            },
        },
        [241874] = {
            name = "Frostfang",
            displayId = 141223,
            creatureType = "Beast",
            level = 90,
            health = 2789199,
            count = 5,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1241226,
                },
                {
                    id = 1265400,
                },
                {
                    id = 1265402,
                },
            },
        },
        [241876] = {
            name = "Glacial Revenant",
            displayId = 103213,
            creatureType = "Elemental",
            level = 90,
            health = 3081092,
            count = 7,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1239860,
                    magic = true,
                },
                {
                    id = 1239871,
                },
                {
                    id = 1266178,
                },
            },
        },
        [241911] = {
            name = "Terra Rumbler",
            displayId = 73034,
            creatureType = "Elemental",
            level = 90,
            health = 2918930,
            count = 7,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1296518,
                },
                {
                    id = 1296519,
                },
            },
        },
        [244100] = {
            name = "Sentinel of Winter",
            displayId = 129418,
            creatureType = "Humanoid",
            level = 92,
            health = 21283861,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1235548,
                },
                {
                    id = 1235549,
                    magic = true,
                },
                {
                    id = 1235623,
                },
                {
                    id = 1235635,
                },
                {
                    id = 1235656,
                },
                {
                    id = 1235658,
                },
                {
                    id = 1235783,
                },
                {
                    id = 1235795,
                },
            },
        },
        [244696] = {
            name = "Raging Squall",
            displayId = 169,
            creatureType = "Not specified",
            level = 90,
            health = 428857,
            count = 0,
            spells = {
                {
                    id = 1235638,
                },
                {
                    id = 1235641,
                },
            },
        },
        [244759] = {
            name = "Fractured Shivercore",
            displayId = 103231,
            creatureType = "Elemental",
            level = 90,
            health = 675678,
            count = 0,
            spells = {
                {
                    id = 1234314,
                },
                {
                    id = 1235829,
                    interruptible = true,
                },
                {
                    id = 1263590,
                },
                {
                    id = 1263597,
                },
            },
        },
        [244889] = {
            name = "Loa Speaker Nanea",
            displayId = 138584,
            creatureType = "Humanoid",
            level = 91,
            health = 7783812,
            count = 35,
            spells = {
                {
                    id = 1247366,
                },
                {
                    id = 1247367,
                },
                {
                    id = 1251027,
                },
                {
                    id = 1264753,
                },
                {
                    id = 1290205,
                    interruptible = true,
                },
                {
                    id = 1296722,
                },
                {
                    id = 1309924,
                },
                {
                    id = 1309925,
                },
            },
        },
        [245076] = {
            name = "The Pale Eye",
            displayId = 129498,
            creatureType = "Not specified",
            level = 90,
            health = 457907,
            count = 0,
            spells = {
                {
                    id = 1250805,
                },
            },
        },
        [245139] = {
            name = "Stormbound Mystic",
            displayId = 129562,
            creatureType = "Humanoid",
            level = 90,
            health = 2918930,
            count = 7,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1246687,
                    interruptible = true,
                },
                {
                    id = 1297778,
                    interruptible = true,
                },
            },
        },
        [245143] = {
            name = "Ruthless Totemcaller",
            displayId = 129563,
            creatureType = "Humanoid",
            level = 90,
            health = 3243255,
            count = 5,
            spells = {
                {
                    id = 1246820,
                },
            },
        },
        [245145] = {
            name = "Bonded Beasttamer",
            displayId = 129581,
            creatureType = "Humanoid",
            level = 90,
            health = 3081092,
            count = 6,
            spells = {
                {
                    id = 1246847,
                    interruptible = true,
                },
                {
                    id = 1246860,
                },
                {
                    id = 1246865,
                    enrage = true,
                },
                {
                    id = 1246877,
                },
                {
                    id = 1266207,
                },
            },
        },
        [245146] = {
            name = "Grizzled Warbringer",
            displayId = 131630,
            creatureType = "Beast",
            level = 91,
            health = 5513534,
            count = 25,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1246957,
                },
                {
                    id = 1246986,
                },
            },
        },
        [245148] = {
            name = "Grizzled Warbringer",
            displayId = 129564,
            creatureType = "Humanoid",
            level = 90,
            health = 606102,
            count = 0,
            spells = {
                {
                    id = 1247030,
                },
                {
                    id = 1311572,
                },
            },
        },
        [245190] = {
            name = "Loyal Saberfang",
            displayId = 124949,
            creatureType = "Beast",
            level = 90,
            health = 2594604,
            count = 5,
            spells = {
                {
                    id = 1246865,
                    enrage = true,
                },
                {
                    id = 1246882,
                },
            },
        },
        [245567] = {
            name = "Starvation Effigy",
            displayId = 129707,
            creatureType = "Not specified",
            level = 90,
            health = 589867,
            count = 0,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1238801,
                    curse = true,
                },
            },
        },
        [245752] = {
            name = "Keen-Eyed Striker",
            displayId = 124212,
            creatureType = "Beast",
            level = 90,
            health = 2918930,
            count = 7,
            spells = {
                {
                    id = 110960,
                },
                {
                    id = 1238439,
                    bleed = true,
                },
                {
                    id = 1238440,
                },
                {
                    id = 1239394,
                    interruptible = true,
                },
            },
        },
        [245855] = {
            name = "Spirit of Hunger",
            displayId = 26857,
            creatureType = "Undead",
            level = 91,
            health = 4864883,
            count = 25,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1238687,
                },
                {
                    id = 1238725,
                },
                {
                    id = 1238760,
                },
                {
                    id = 1249737,
                },
            },
        },
        [246404] = {
            name = "Nalorakk",
            displayId = 129989,
            creatureType = "Beast",
            level = 92,
            health = 21891972,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1242860,
                },
                {
                    id = 1242869,
                },
                {
                    id = 1242887,
                },
                {
                    id = 1243002,
                },
                {
                    id = 1243011,
                },
                {
                    id = 1243273,
                },
                {
                    id = 1243408,
                },
            },
        },
        [246409] = {
            name = "Zul'jarra",
            displayId = 125149,
            creatureType = "Humanoid",
            level = 90,
            health = 21891972,
            count = 0,
            spells = {
                {
                    id = 1243018,
                },
                {
                    id = 1243078,
                },
                {
                    id = 1243856,
                },
                {
                    id = 1249186,
                },
                {
                    id = 1261776,
                },
                {
                    id = 1262253,
                },
                {
                    id = 1270826,
                },
            },
        },
        [247301] = {
            name = "Echo of Nalorakk",
            displayId = 129989,
            creatureType = "Beast",
            level = 92,
            health = 3378390,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1242976,
                },
                {
                    id = 1255570,
                },
                {
                    id = 1255577,
                },
                {
                    id = 1262577,
                },
            },
        },
        [248666] = {
            name = "Magma Totem",
            displayId = 30762,
            creatureType = "Not specified",
            level = 90,
            health = 589867,
            count = 0,
            spells = {
                {
                    id = 1246821,
                },
                {
                    id = 1246825,
                },
            },
        },
        [250478] = {
            name = "The Winter Squall",
            displayId = 138885,
            creatureType = "Elemental",
            level = 91,
            health = 3243255,
            count = 50,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1309947,
                },
                {
                    id = 1309964,
                },
            },
        },
        [251189] = {
            name = "Snow Orb Stalker",
            displayId = 169,
            creatureType = "Not specified",
            level = 90,
            health = 648651,
            count = 0,
            spells = {
                {
                    id = 1253083,
                },
            },
        },
        [272074] = {
            name = "Volatile Totem",
            displayId = 30762,
            creatureType = "Not specified",
            level = 90,
            health = 462070,
            count = 0,
            spells = {
                {
                    id = 1309931,
                },
            },
        },
    },
    enemies = {
        [1] = {
            npc = 245855,
            count = 25,
            clones = 7,
            pos = {
                [1] = { 92, -439, 1 },
                [2] = { 133, -391, 1 },
                [3] = { 97, -339, 1 },
                [4] = { 72, -402, 1 },
                [5] = { 165, -492, 1 },
                [6] = { 162, -455, 1 },
                [7] = { 196, -391, 1 },
            },
        },
        [2] = {
            npc = 241814,
            count = 7,
            clones = 12,
            pos = {
                [1] = { 128, -475, 1 },
                [2] = { 130, -467, 1 },
                [3] = { 112, -352, 1 },
                [5] = { 205, -316, 1 },
                [6] = { 203, -344, 1 },
                [8] = { 138, -429, 1 },
                [9] = { 163, -481, 1 },
                [10] = { 403, -371, 1 },
                [11] = { 401, -398, 1 },
                [12] = { 429, -365, 1 },
                [13] = { 418, -439, 1 },
                [14] = { 427, -437, 1 },
            },
        },
        [3] = {
            npc = 241813,
            count = 5,
            clones = 21,
            pos = {
                [1] = { 138, -479, 1 },
                [2] = { 139, -470, 1 },
                [3] = { 84, -321, 1 },
                [4] = { 93, -319, 1 },
                [5] = { 120, -352, 1 },
                [6] = { 122, -331, 1 },
                [7] = { 200, -310, 1 },
                [8] = { 208, -310, 1 },
                [9] = { 212, -352, 1 },
                [10] = { 202, -353, 1 },
                [11] = { 83, -378, 1 },
                [12] = { 85, -385, 1 },
                [15] = { 139, -422, 1 },
                [16] = { 172, -485, 1 },
                [17] = { 373, -382, 1 },
                [18] = { 378, -378, 1 },
                [19] = { 397, -363, 1 },
                [20] = { 406, -363, 1 },
                [21] = { 368, -400, 1 },
                [22] = { 401, -389, 1 },
                [23] = { 425, -445, 1 },
            },
        },
        [4] = {
            npc = 241808,
            count = 8,
            clones = 16,
            pos = {
                [1] = { 66, -444, 1 },
                [2] = { 73, -448, 1 },
                [3] = { 195, -453, 1 },
                [4] = { 106, -385, 1 },
                [5] = { 162, -341, 1 },
                [6] = { 59, -418, 1 },
                [7] = { 133, -423, 1 },
                [8] = { 188, -375, 1 },
                [9] = { 441, -417, 1 },
                [10] = { 434, -420, 1 },
                [11] = { 401, -426, 1 },
                [12] = { 543, -393, 1 },
                [13] = { 584, -321, 1 },
                [14] = { 527, -342, 1 },
                [15] = { 538, -370, 1 },
                [16] = { 581, -361, 1 },
            },
        },
        [5] = {
            npc = 250478,
            count = 50,
            clones = 1,
            pos = {
                [1] = { 287, -186, 1 },
            },
        },
        [6] = {
            npc = 241874,
            count = 5,
            clones = 18,
            pos = {
                [1] = { 501, -287, 1 },
                [2] = { 508, -283, 1 },
                [3] = { 478, -231, 1 },
                [4] = { 478, -222, 1 },
                [5] = { 483, -228, 1 },
                [6] = { 429, -246, 1 },
                [7] = { 429, -253, 1 },
                [8] = { 434, -250, 1 },
                [9] = { 365, -165, 1 },
                [10] = { 358, -161, 1 },
                [11] = { 372, -160, 1 },
                [12] = { 348, -212, 1 },
                [13] = { 346, -218, 1 },
                [14] = { 542, -323, 1 },
                [15] = { 548, -326, 1 },
                [16] = { 553, -321, 1 },
                [17] = { 535, -364, 1 },
                [18] = { 531, -369, 1 },
            },
        },
        [7] = {
            npc = 241911,
            count = 7,
            clones = 11,
            pos = {
                [1] = { 470, -256, 1 },
                [2] = { 436, -201, 1 },
                [3] = { 408, -191, 1 },
                [4] = { 374, -195, 1 },
                [5] = { 328, -191, 1 },
                [6] = { 511, -260, 1 },
                [7] = { 518, -255, 1 },
                [8] = { 560, -351, 1 },
                [9] = { 583, -396, 1 },
                [10] = { 577, -395, 1 },
                [11] = { 517, -262, 1 },
            },
        },
        [8] = {
            npc = 241872,
            count = 9,
            clones = 8,
            pos = {
                [1] = { 484, -273, 1 },
                [2] = { 473, -250, 1 },
                [3] = { 498, -217, 1 },
                [4] = { 505, -219, 1 },
                [5] = { 388, -211, 1 },
                [6] = { 387, -219, 1 },
                [7] = { 361, -171, 1 },
                [8] = { 369, -172, 1 },
            },
        },
        [9] = {
            npc = 241876,
            count = 7,
            clones = 8,
            pos = {
                [1] = { 465, -250, 1 },
                [2] = { 445, -199, 1 },
                [3] = { 443, -207, 1 },
                [4] = { 408, -222, 1 },
                [5] = { 407, -230, 1 },
                [6] = { 373, -203, 1 },
                [7] = { 319, -211, 1 },
                [8] = { 398, -168, 1 },
            },
        },
        [10] = {
            npc = 241869,
            count = 28,
            clones = 2,
            pos = {
                [1] = { 457, -231, 1 },
                [2] = { 323, -200, 1 },
            },
        },
        [11] = {
            npc = 245143,
            count = 5,
            clones = 5,
            pos = {
                [1] = { 683, -253, 1 },
                [2] = { 674, -200, 1 },
                [3] = { 679, -200, 1 },
                [4] = { 673, -154, 1 },
                [5] = { 665, -154, 1 },
            },
        },
        [12] = {
            npc = 245139,
            count = 7,
            clones = 5,
            pos = {
                [1] = { 693, -251, 1 },
                [2] = { 676, -252, 1 },
                [3] = { 678, -178, 1 },
                [4] = { 677, -154, 1 },
                [5] = { 681, -129, 1 },
            },
        },
        [13] = {
            npc = 245146,
            count = 25,
            clones = 3,
            pos = {
                [1] = { 683, -237, 1 },
                [2] = { 662, -135, 1 },
                [3] = { 673, -134, 1 },
            },
        },
        [14] = {
            npc = 245145,
            count = 6,
            clones = 4,
            pos = {
                [1] = { 669, -200, 1 },
                [2] = { 664, -179, 1 },
                [3] = { 683, -177, 1 },
                [4] = { 661, -154, 1 },
            },
        },
        [15] = {
            npc = 241809,
            count = 0,
            clones = 33,
            pos = {
                [1] = { 72, -456, 1 },
                [2] = { 64, -449, 1 },
                [3] = { 66, -455, 1 },
                [4] = { 105, -462, 1 },
                [5] = { 110, -459, 1 },
                [6] = { 190, -459, 1 },
                [7] = { 194, -460, 1 },
                [8] = { 199, -458, 1 },
                [9] = { 202, -453, 1 },
                [10] = { 109, -392, 1 },
                [11] = { 113, -381, 1 },
                [12] = { 155, -340, 1 },
                [13] = { 159, -347, 1 },
                [14] = { 57, -432, 1 },
                [15] = { 61, -433, 1 },
                [16] = { 129, -428, 1 },
                [17] = { 132, -431, 1 },
                [18] = { 182, -370, 1 },
                [19] = { 193, -370, 1 },
                [20] = { 429, -418, 1 },
                [21] = { 432, -414, 1 },
                [22] = { 435, -411, 1 },
                [23] = { 440, -410, 1 },
                [24] = { 548, -393, 1 },
                [25] = { 546, -389, 1 },
                [26] = { 538, -375, 1 },
                [27] = { 542, -372, 1 },
                [28] = { 524, -338, 1 },
                [29] = { 529, -345, 1 },
                [30] = { 586, -362, 1 },
                [31] = { 585, -357, 1 },
                [32] = { 588, -318, 1 },
                [33] = { 585, -315, 1 },
            },
        },
        [16] = {
            npc = 241812,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 265, -395, 1 },
            },
        },
        [17] = {
            npc = 241816,
            count = 7,
            clones = 17,
            pos = {
                [1] = { 106, -456, 1 },
                [2] = { 125, -335, 1 },
                [3] = { 146, -364, 1 },
                [4] = { 165, -333, 1 },
                [5] = { 169, -342, 1 },
                [7] = { 102, -422, 1 },
                [8] = { 179, -415, 1 },
                [9] = { 187, -414, 1 },
                [10] = { 182, -421, 1 },
                [11] = { 408, -393, 1 },
                [12] = { 432, -372, 1 },
                [13] = { 554, -348, 1 },
                [14] = { 592, -379, 1 },
                [15] = { 594, -386, 1 },
                [16] = { 535, -417, 1 },
                [17] = { 45, -383, 1 },
                [18] = { 46, -394, 1 },
            },
        },
        [18] = {
            npc = 244100,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 239, -147, 1 },
            },
        },
        [19] = {
            npc = 244696,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 241, -161, 1 },
            },
        },
        [20] = {
            npc = 244759,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 250, -145, 1 },
            },
        },
        [21] = {
            npc = 244889,
            count = 35,
            clones = 1,
            pos = {
                [1] = { 667, -103, 1 },
            },
        },
        [22] = {
            npc = 245148,
            count = 0,
            clones = 3,
            pos = {
                [1] = { 683, -227, 1 },
                [2] = { 659, -126, 1 },
                [3] = { 671, -126, 1 },
            },
        },
        [23] = {
            npc = 245190,
            count = 5,
            clones = 4,
            pos = {
                [1] = { 684, -200, 1 },
                [2] = { 668, -179, 1 },
                [3] = { 673, -178, 1 },
                [4] = { 670, -154, 1 },
            },
        },
        [24] = {
            npc = 245567,
            count = 0,
            clones = 7,
            pos = {
                [1] = { 104, -333, 1 },
                [2] = { 79, -402, 1 },
                [3] = { 85, -432, 1 },
                [4] = { 139, -392, 1 },
                [5] = { 204, -391, 1 },
                [6] = { 168, -448, 1 },
                [7] = { 169, -499, 1 },
            },
        },
        [25] = {
            npc = 246404,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 647, -86, 1 },
            },
        },
        [26] = {
            npc = 246409,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 655, -72, 1 },
            },
        },
        [27] = {
            npc = 247301,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 665, -82, 1 },
            },
        },
        [28] = {
            npc = 251189,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 252, -102, 1 },
            },
        },
        [29] = {
            npc = 272074,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 169, -111, 1 },
            },
        },
        [30] = {
            npc = 245076,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 200, -200, 1 },
            },
        },
        [31] = {
            npc = 245752,
            count = 7,
            clones = 2,
            pos = {
                [1] = { 64, -363, 1 },
                [2] = { 51, -452, 1 },
            },
        },
        [32] = {
            npc = 248666,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 385, -109, 1 },
            },
        },
    },
    maps = {
        [1] = {
            path = "Interface\\AddOns\\MythicDungeonTools\\Midnight\\Textures\\DenOfNalorakk",
            name = "Den of Nalorakk",
        },
    },
})

R:RegisterDungeon({
    challengeModeId = 249,
    englishName = "King's Rest",
    shortName = "KR",
    mdtDungeonIdx = 17,
    totalCount = 608,
    npcs = {
        [133935] = {
            name = "Animated Guardian",
            displayId = 83252,
            creatureType = "Undead",
            level = 91,
            health = 5513534,
            count = 22,
            spells = {
                {
                    id = 270003,
                },
                {
                    id = 270016,
                },
                {
                    id = 1310755,
                },
            },
        },
        [133943] = {
            name = "Minion of Zul",
            displayId = 76055,
            creatureType = "Aberration",
            level = 90,
            health = 362169,
            count = 0,
            spells = {
                {
                    id = 269935,
                    magic = true,
                },
            },
        },
        [134157] = {
            name = "Umbral Warrior",
            displayId = 83363,
            creatureType = "Undead",
            level = 90,
            health = 3243255,
            count = 5,
            spells = {
                {
                    id = 1311942,
                },
            },
        },
        [134158] = {
            name = "Shadow-Borne Champion",
            displayId = 83364,
            creatureType = "Undead",
            level = 91,
            health = 5189208,
            count = 25,
            spells = {
                {
                    id = 269928,
                },
                {
                    id = 269976,
                    enrage = true,
                },
                {
                    id = 1305945,
                },
                {
                    id = 1310758,
                },
            },
        },
        [134174] = {
            name = "Risen Hexer",
            displayId = 83371,
            creatureType = "Undead",
            level = 91,
            health = 4864883,
            count = 20,
            spells = {
                {
                    id = 269972,
                    interruptible = true,
                    curse = true,
                },
                {
                    id = 1294815,
                    interruptible = true,
                    magic = true,
                },
            },
        },
        [134251] = {
            name = "Seneschal M'bara",
            displayId = 83517,
            creatureType = "Undead",
            level = 90,
            health = 3243255,
            count = 10,
            spells = {
                {
                    id = 270901,
                    interruptible = true,
                    magic = true,
                },
                {
                    id = 1296671,
                    magic = true,
                },
            },
        },
        [134331] = {
            name = "King Rahu'ai",
            displayId = 83544,
            creatureType = "Undead",
            level = 91,
            health = 5189208,
            count = 25,
            spells = {
                {
                    id = 270889,
                },
                {
                    id = 270891,
                },
                {
                    id = 1296671,
                    magic = true,
                },
                {
                    id = 1296719,
                },
            },
        },
        [134739] = {
            name = "Purification Construct",
            displayId = 83836,
            creatureType = "Undead",
            level = 91,
            health = 7783811,
            count = 25,
            spells = {
                {
                    id = 270292,
                },
                {
                    id = 270293,
                },
                {
                    id = 1310755,
                },
            },
        },
        [134993] = {
            name = "Mchimba the Embalmer",
            displayId = 83529,
            creatureType = "Mechanical",
            level = 92,
            health = 21283860,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 267618,
                },
                {
                    id = 267639,
                },
                {
                    id = 267702,
                },
                {
                    id = 267874,
                },
                {
                    id = 271290,
                },
                {
                    id = 1312146,
                },
                {
                    id = 1312848,
                },
            },
        },
        [135167] = {
            name = "Royal Berserker",
            displayId = 84112,
            creatureType = "Undead",
            level = 91,
            health = 3891906,
            count = 22,
            spells = {
                {
                    id = 270482,
                },
                {
                    id = 270485,
                },
                {
                    id = 1301851,
                    bleed = true,
                },
            },
        },
        [135192] = {
            name = "Honored Raptor",
            displayId = 84133,
            creatureType = "Undead",
            level = 90,
            health = 3243255,
            count = 5,
            spells = {
                {
                    id = 270500,
                },
                {
                    id = 270502,
                },
                {
                    id = 270503,
                },
            },
        },
        [135204] = {
            name = "Phantom Hex Priest",
            displayId = 84140,
            creatureType = "Undead",
            level = 90,
            health = 2918930,
            count = 7,
            spells = {
                {
                    id = 270492,
                    interruptible = true,
                    curse = true,
                },
                {
                    id = 1295125,
                    interruptible = true,
                    magic = true,
                },
            },
        },
        [135231] = {
            name = "Ghostly Brute",
            displayId = 85125,
            creatureType = "Undead",
            level = 91,
            health = 6486509,
            count = 25,
            spells = {
                {
                    id = 270514,
                },
                {
                    id = 1302028,
                },
            },
        },
        [135239] = {
            name = "Spectral Shaman",
            displayId = 84163,
            creatureType = "Undead",
            level = 90,
            health = 3243255,
            count = 7,
            spells = {
                {
                    id = 270497,
                },
                {
                    id = 270499,
                    magic = true,
                },
            },
        },
        [135322] = {
            name = "The Golden Serpent",
            displayId = 84202,
            creatureType = "Beast",
            level = 92,
            health = 21283860,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 265773,
                },
                {
                    id = 265781,
                },
                {
                    id = 265910,
                },
                {
                    id = 265923,
                },
                {
                    id = 265991,
                },
                {
                    id = 1306736,
                },
                {
                    id = 1311987,
                },
                {
                    id = 1311988,
                },
            },
        },
        [135406] = {
            name = "Animated Gold",
            displayId = 88651,
            creatureType = "Aberration",
            level = 90,
            health = 385943,
            count = 0,
            spells = {
                {
                    id = 265991,
                },
                {
                    id = 1289063,
                },
            },
        },
        [135761] = {
            name = "Thundering Totem",
            displayId = 84680,
            creatureType = "Totem",
            level = 90,
            health = 444902,
            count = 0,
            spells = {
                {
                    id = 267257,
                },
                {
                    id = 1309499,
                },
            },
        },
        [135764] = {
            name = "Explosive Totem",
            displayId = 84933,
            creatureType = "Totem",
            level = 90,
            health = 440583,
            count = 0,
            spells = {
                {
                    id = 267077,
                },
                {
                    id = 1309499,
                },
            },
        },
        [135765] = {
            name = "Torrent Totem",
            displayId = 84934,
            creatureType = "Totem",
            level = 90,
            health = 324326,
            count = 0,
            spells = {
                {
                    id = 267105,
                },
                {
                    id = 1309499,
                },
            },
        },
        [136160] = {
            name = "King Dazar",
            displayId = 84352,
            creatureType = "Undead",
            level = 92,
            health = 30405514,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 268586,
                },
                {
                    id = 268587,
                },
                {
                    id = 268589,
                },
                {
                    id = 268590,
                },
                {
                    id = 268591,
                },
                {
                    id = 269503,
                },
                {
                    id = 1302945,
                },
                {
                    id = 1303105,
                },
            },
        },
        [136256] = {
            name = "Coffin",
            displayId = 76137,
            creatureType = "Not specified",
            level = 334,
            health = 540543,
            count = 0,
        },
        [136976] = {
            name = "T'zala",
            displayId = 84274,
            creatureType = "Undead",
            level = 91,
            health = 27027125,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1303324,
                },
                {
                    id = 1303326,
                },
                {
                    id = 1303327,
                },
                {
                    id = 1303396,
                },
                {
                    id = 1303399,
                },
                {
                    id = 1303488,
                },
                {
                    id = 1303490,
                },
            },
        },
        [136984] = {
            name = "Reban",
            displayId = 84273,
            creatureType = "Undead",
            level = 91,
            health = 3783798,
            count = 0,
            spells = {
                {
                    id = 269230,
                },
                {
                    id = 269231,
                },
                {
                    id = 269232,
                },
                {
                    id = 269369,
                    interruptible = true,
                },
                {
                    id = 1303039,
                },
            },
        },
        [137473] = {
            name = "Guard Captain Atu",
            displayId = 85270,
            creatureType = "Undead",
            level = 90,
            health = 5270289,
            count = 10,
            spells = {
                {
                    id = 1296671,
                    magic = true,
                },
            },
        },
        [137474] = {
            name = "King Timalji",
            displayId = 85272,
            creatureType = "Undead",
            level = 91,
            health = 7783811,
            count = 25,
            spells = {
                {
                    id = 270927,
                },
                {
                    id = 270928,
                },
                {
                    id = 1297326,
                },
                {
                    id = 1306049,
                },
                {
                    id = 1306056,
                },
            },
        },
        [137478] = {
            name = "Queen Wasi",
            displayId = 85274,
            creatureType = "Undead",
            level = 91,
            health = 7783811,
            count = 25,
            spells = {
                {
                    id = 270920,
                    interruptible = true,
                    magic = true,
                },
                {
                    id = 1294972,
                    interruptible = true,
                    magic = true,
                },
                {
                    id = 1297326,
                },
            },
        },
        [137484] = {
            name = "King A'akul",
            displayId = 85284,
            creatureType = "Undead",
            level = 91,
            health = 8432462,
            count = 25,
            spells = {
                {
                    id = 1297918,
                    bleed = true,
                },
                {
                    id = 1297970,
                },
            },
        },
        [137485] = {
            name = "Bloodsworn Assassin",
            displayId = 85285,
            creatureType = "Undead",
            level = 90,
            health = 3243255,
            count = 7,
            spells = {
                {
                    id = 1297781,
                    bleed = true,
                },
            },
        },
        [137486] = {
            name = "Queen Patlaa",
            displayId = 85287,
            creatureType = "Undead",
            level = 91,
            health = 5189208,
            count = 25,
            spells = {
                {
                    id = 270931,
                },
                {
                    id = 1294883,
                },
                {
                    id = 1297763,
                    enrage = true,
                },
                {
                    id = 1305982,
                },
                {
                    id = 1306761,
                },
                {
                    id = 1306763,
                    poison = true,
                },
            },
        },
        [137487] = {
            name = "Skeletal Hunting Raptor",
            displayId = 33733,
            creatureType = "Undead",
            level = 91,
            health = 3243255,
            count = 10,
            spells = {
                {
                    id = 270500,
                },
                {
                    id = 270502,
                },
                {
                    id = 270503,
                },
                {
                    id = 1297763,
                    enrage = true,
                },
            },
        },
        [137591] = {
            name = "Healing Tide Totem",
            displayId = 84934,
            creatureType = "Totem",
            level = 90,
            health = 372519,
            count = 0,
        },
        [137969] = {
            name = "Interment Construct",
            displayId = 85677,
            creatureType = "Undead",
            level = 91,
            health = 5837859,
            count = 15,
            spells = {
                {
                    id = 271555,
                },
                {
                    id = 271561,
                },
                {
                    id = 271562,
                },
                {
                    id = 1310755,
                },
                {
                    id = 1312569,
                },
            },
        },
        [137989] = {
            name = "Embalming Fluid",
            displayId = 33008,
            creatureType = "Aberration",
            level = 90,
            health = 1945953,
            count = 1,
            spells = {
                {
                    id = 271563,
                },
                {
                    id = 1298104,
                    poison = true,
                },
            },
        },
        [138489] = {
            name = "Shadow of Zul",
            displayId = 85860,
            creatureType = "Humanoid",
            level = -1,
            health = 8432462,
            count = 30,
            spells = {
                {
                    id = 272388,
                },
                {
                    id = 1298304,
                },
                {
                    id = 1309385,
                },
            },
        },
        [138493] = {
            name = "Minion of Zul",
            displayId = 76055,
            creatureType = "Aberration",
            level = 90,
            health = 6,
            count = 0,
            spells = {
                {
                    id = 269935,
                    magic = true,
                },
            },
        },
        [269808] = {
            name = "Aka'ali the Conqueror",
            displayId = 84269,
            creatureType = "Undead",
            level = 92,
            health = 8108137,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 266237,
                },
                {
                    id = 266951,
                },
                {
                    id = 267494,
                },
                {
                    id = 1310761,
                },
            },
        },
        [269810] = {
            name = "Zanazal the Wise",
            displayId = 84271,
            creatureType = "Undead",
            level = 92,
            health = 10135171,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 267060,
                },
                {
                    id = 267273,
                    interruptible = true,
                    poison = true,
                },
                {
                    id = 1305810,
                },
            },
        },
        [269811] = {
            name = "Kula the Butcher",
            displayId = 84272,
            creatureType = "Undead",
            level = 92,
            health = 5405425,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 266191,
                    bleed = true,
                },
                {
                    id = 266206,
                },
                {
                    id = 266231,
                    bleed = true,
                },
            },
        },
        [270502] = {
            name = "Half-Finished Mummy",
            displayId = 84688,
            creatureType = "Undead",
            level = 91,
            health = 3243255,
            count = 7,
            spells = {
                {
                    id = 267763,
                    interruptible = true,
                    disease = true,
                },
            },
        },
    },
    enemies = {
        [1] = {
            npc = 133935,
            count = 22,
            clones = 4,
            pos = {
                [1] = { 587, -268, 1 },
                [2] = { 588, -300, 1 },
                [3] = { 609, -373, 1 },
                [4] = { 597, -381, 1 },
            },
        },
        [2] = {
            npc = 133943,
            count = 0,
            clones = 13,
            pos = {
                [1] = { 596, -343, 1 },
                [2] = { 609, -350, 1 },
                [3] = { 604, -335, 1 },
                [4] = { 596, -335, 1 },
                [5] = { 613, -335, 1 },
                [6] = { 605, -343, 1 },
                [7] = { 614, -343, 1 },
                [8] = { 600, -351, 1 },
                [9] = { 643, -408, 1 },
                [10] = { 637, -428, 1 },
                [11] = { 640, -418, 1 },
                [12] = { 650, -415, 1 },
                [14] = { 647, -424, 1 },
            },
        },
        [3] = {
            npc = 134174,
            count = 20,
            clones = 1,
            pos = {
                [4] = { 707, -441, 1 },
            },
        },
        [4] = {
            npc = 134158,
            count = 25,
            clones = 2,
            pos = {
                [1] = { 699, -401, 1 },
                [2] = { 666, -452, 1 },
            },
        },
        [5] = {
            npc = 134157,
            count = 5,
            clones = 6,
            pos = {
                [1] = { 698, -453, 1 },
                [4] = { 654, -463, 1 },
                [5] = { 651, -446, 1 },
                [6] = { 693, -439, 1 },
                [7] = { 689, -411, 1 },
                [8] = { 684, -398, 1 },
            },
        },
        [6] = {
            npc = 135322,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 749, -413, 1 },
            },
        },
        [7] = {
            npc = 137487,
            count = 10,
            clones = 1,
            pos = {
                [1] = { 516, -501, 1 },
            },
        },
        [8] = {
            npc = 137486,
            count = 25,
            clones = 1,
            pos = {
                [1] = { 516, -482, 1 },
            },
        },
        [9] = {
            npc = 137484,
            count = 25,
            clones = 1,
            pos = {
                [1] = { 563, -494, 1 },
            },
        },
        [10] = {
            npc = 137485,
            count = 7,
            clones = 4,
            pos = {
                [1] = { 564, -523, 1 },
                [2] = { 564, -509, 1 },
                [3] = { 565, -465, 1 },
                [4] = { 564, -479, 1 },
            },
        },
        [11] = {
            npc = 134251,
            count = 10,
            clones = 1,
            pos = {
                [1] = { 540, -476, 1 },
            },
        },
        [12] = {
            npc = 137473,
            count = 10,
            clones = 1,
            pos = {
                [1] = { 540, -509, 1 },
            },
        },
        [13] = {
            npc = 134331,
            count = 25,
            clones = 1,
            pos = {
                [1] = { 540, -492, 1 },
            },
        },
        [14] = {
            npc = 137474,
            count = 25,
            clones = 1,
            pos = {
                [1] = { 589, -503, 1 },
            },
        },
        [15] = {
            npc = 137478,
            count = 25,
            clones = 1,
            pos = {
                [1] = { 590, -484, 1 },
            },
        },
        [16] = {
            npc = 134739,
            count = 25,
            clones = 1,
            pos = {
                [1] = { 462, -330, 1 },
            },
        },
        [17] = {
            npc = 137969,
            count = 15,
            clones = 2,
            pos = {
                [1] = { 494, -176, 1 },
                [2] = { 430, -108, 1 },
            },
        },
        [18] = {
            npc = 134993,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 484, -123, 1 },
            },
        },
        [19] = {
            npc = 135204,
            count = 7,
            clones = 3,
            pos = {
                [1] = { 352, -143, 1 },
                [2] = { 366, -143, 1 },
                [3] = { 358, -223, 1 },
            },
        },
        [20] = {
            npc = 135167,
            count = 22,
            clones = 3,
            pos = {
                [1] = { 359, -354, 1 },
                [2] = { 369, -166, 1 },
                [4] = { 349, -166, 1 },
            },
        },
        [21] = {
            npc = 135239,
            count = 7,
            clones = 4,
            pos = {
                [2] = { 344, -223, 1 },
                [4] = { 353, -129, 1 },
                [5] = { 366, -129, 1 },
                [6] = { 373, -224, 1 },
            },
        },
        [22] = {
            npc = 135231,
            count = 25,
            clones = 1,
            pos = {
                [1] = { 358, -288, 1 },
            },
        },
        [23] = {
            npc = 135192,
            count = 5,
            clones = 4,
            pos = {
                [1] = { 368, -368, 1 },
                [2] = { 350, -368, 1 },
                [5] = { 349, -235, 1 },
                [6] = { 368, -235, 1 },
            },
        },
        [24] = {
            npc = 138489,
            count = 30,
            clones = 1,
            pos = {
                [1] = { 208, -289, 1 },
            },
        },
        [25] = {
            npc = 136160,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 65, -292, 1 },
            },
        },
        [26] = {
            npc = 137989,
            count = 1,
            clones = 17,
            pos = {
                [1] = { 442, -156, 1 },
                [2] = { 447, -160, 1 },
                [3] = { 452, -164, 1 },
                [4] = { 446, -166, 1 },
                [5] = { 441, -162, 1 },
                [6] = { 461, -176, 1 },
                [7] = { 467, -176, 1 },
                [8] = { 425, -174, 1 },
                [9] = { 431, -180, 1 },
                [10] = { 426, -141, 1 },
                [11] = { 433, -141, 1 },
                [12] = { 429, -146, 1 },
                [13] = { 421, -121, 1 },
                [14] = { 422, -128, 1 },
                [15] = { 441, -121, 1 },
                [16] = { 446, -119, 1 },
                [17] = { 446, -125, 1 },
            },
        },
        [27] = {
            npc = 135761,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 360, -496, 1 },
            },
        },
        [28] = {
            npc = 135764,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 344, -473, 1 },
            },
        },
        [29] = {
            npc = 135765,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 373, -472, 1 },
            },
        },
        [30] = {
            npc = 136256,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 504, -122, 1 },
            },
        },
        [31] = {
            npc = 136976,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 87, -281, 1 },
            },
        },
        [32] = {
            npc = 136984,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 87, -307, 1 },
            },
        },
        [33] = {
            npc = 138493,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 193, -291, 1 },
            },
        },
        [34] = {
            npc = 269808,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 325, -503, 1 },
            },
        },
        [35] = {
            npc = 269810,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 361, -533, 1 },
            },
        },
        [36] = {
            npc = 269811,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 396, -502, 1 },
            },
        },
        [37] = {
            npc = 270502,
            count = 7,
            clones = 4,
            pos = {
                [1] = { 502, -161, 1 },
                [2] = { 503, -187, 1 },
                [3] = { 447, -105, 1 },
                [4] = { 415, -105, 1 },
            },
        },
        [38] = {
            npc = 135406,
            count = 0,
            clones = 5,
            pos = {
                [1] = { 757, -391, 1 },
                [2] = { 761, -430, 1 },
                [3] = { 767, -422, 1 },
                [4] = { 769, -410, 1 },
                [5] = { 766, -400, 1 },
            },
        },
        [39] = {
            npc = 137591,
            count = 0,
            clones = 2,
            pos = {
                [1] = { 359, -120, 1 },
                [2] = { 359, -234, 1 },
            },
        },
    },
    maps = {
        [1] = {
            path = "Interface\\AddOns\\MythicDungeonTools\\Midnight\\Textures\\KingsRest",
            name = "Kings' Rest",
        },
    },
})

R:RegisterDungeon({
    challengeModeId = 587,
    englishName = "Murder Row",
    shortName = "MURD",
    mdtDungeonIdx = 160,
    totalCount = 655,
    npcs = {
        [234647] = {
            name = "Xathuux the Annihilator",
            displayId = 140268,
            creatureType = "Demon",
            level = 92,
            health = 23648734,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 473898,
                },
                {
                    id = 474197,
                },
                {
                    id = 474231,
                },
                {
                    id = 474234,
                },
                {
                    id = 1214637,
                },
                {
                    id = 1214641,
                },
                {
                    id = 1214647,
                },
                {
                    id = 1214663,
                },
            },
        },
        [234648] = {
            name = "Kystia Manaheart",
            displayId = 124578,
            creatureType = "Humanoid",
            level = 92,
            health = 20270343,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 474238,
                },
                {
                    id = 474240,
                },
                {
                    id = 1214959,
                },
                {
                    id = 1217464,
                },
                {
                    id = 1217989,
                },
                {
                    id = 1221063,
                },
                {
                    id = 1223906,
                },
                {
                    id = 1230298,
                },
            },
        },
        [234649] = {
            name = "Zaen Bladesorrow",
            displayId = 124592,
            creatureType = "Humanoid",
            level = 92,
            health = 23648734,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 474478,
                },
                {
                    id = 474483,
                },
                {
                    id = 474515,
                    poison = true,
                },
                {
                    id = 474545,
                },
                {
                    id = 474740,
                    bleed = true,
                },
                {
                    id = 474763,
                },
                {
                    id = 734276,
                    interruptible = true,
                },
                {
                    id = 1214352,
                },
            },
        },
        [234660] = {
            name = "Nibbles",
            displayId = 126199,
            creatureType = "Beast",
            level = 92,
            health = 20270343,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1217464,
                },
                {
                    id = 1221063,
                },
                {
                    id = 1228198,
                    magic = true,
                },
                {
                    id = 1230289,
                },
                {
                    id = 1230304,
                },
                {
                    id = 1253811,
                },
                {
                    id = 1253813,
                },
            },
        },
        [234763] = {
            name = "Lithiel Cinderfury",
            displayId = 124577,
            creatureType = "Humanoid",
            level = 92,
            health = 17567631,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 474375,
                    interruptible = true,
                },
                {
                    id = 474408,
                },
                {
                    id = 474457,
                },
                {
                    id = 474462,
                },
                {
                    id = 1214675,
                },
                {
                    id = 1214730,
                },
                {
                    id = 1214740,
                },
                {
                    id = 1216945,
                    interruptible = true,
                },
            },
        },
        [234799] = {
            name = "Furious Vilefiend",
            displayId = 84426,
            creatureType = "Demon",
            level = 92,
            health = 1621628,
            count = 0,
            spells = {
                {
                    id = 1217881,
                },
                {
                    id = 1293101,
                },
            },
        },
        [234849] = {
            name = "Unleashed Imp",
            displayId = 65901,
            creatureType = "Demon",
            level = 90,
            health = 486488,
            count = 2,
            spells = {
                {
                    id = 1223204,
                    interruptible = true,
                },
            },
        },
        [234852] = {
            name = "Forbidden Freight",
            displayId = 137176,
            creatureType = "Not specified",
            level = 90,
            health = 459705,
            count = 0,
            spells = {
                {
                    id = 1217099,
                    interruptible = true,
                },
                {
                    id = 1219631,
                },
                {
                    id = 1222598,
                },
                {
                    id = 1266241,
                },
            },
        },
        [234860] = {
            name = "Crate Loader",
            displayId = 140261,
            creatureType = "Humanoid",
            level = 90,
            health = 648651,
            count = 0,
            spells = {
                {
                    id = 474766,
                },
                {
                    id = 474768,
                },
            },
        },
        [234984] = {
            name = "Silvermoon Patron",
            displayId = 136524,
            creatureType = "Humanoid",
            level = 90,
            health = 648651,
            count = 0,
            spells = {
                {
                    id = 44427,
                },
                {
                    id = 1214260,
                },
                {
                    id = 1214487,
                },
            },
        },
        [235257] = {
            name = "Demon Fly",
            displayId = 77024,
            creatureType = "Demon",
            level = 90,
            health = 1621628,
            count = 1,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1293022,
                },
            },
        },
        [235261] = {
            name = "Trained Felhunter",
            displayId = 1913,
            creatureType = "Demon",
            level = 90,
            health = 3405418,
            count = 5,
            spells = {
                {
                    id = 1217881,
                },
                {
                    id = 1217930,
                    magic = true,
                },
                {
                    id = 1221063,
                },
                {
                    id = 1293101,
                },
            },
        },
        [235265] = {
            name = "Corrupted Warlock",
            displayId = 124763,
            creatureType = "Humanoid",
            level = 91,
            health = 5027045,
            count = 25,
            spells = {
                {
                    id = 1217973,
                    curse = true,
                },
                {
                    id = 1221063,
                },
                {
                    id = 1294789,
                },
                {
                    id = 1297682,
                },
                {
                    id = 1297683,
                },
                {
                    id = 1297684,
                },
                {
                    id = 1297686,
                },
            },
        },
        [235267] = {
            name = "Wrathguard Flayer",
            displayId = 63968,
            creatureType = "Demon",
            level = 90,
            health = 3405418,
            count = 5,
            spells = {
                {
                    id = 1214922,
                    interruptible = true,
                    enrage = true,
                },
                {
                    id = 1221063,
                },
                {
                    id = 1295426,
                },
                {
                    id = 1295427,
                },
            },
        },
        [235268] = {
            name = "Fel Invoker",
            displayId = 124770,
            creatureType = "Humanoid",
            level = 90,
            health = 5513534,
            count = 7,
            spells = {
                {
                    id = 1214980,
                    interruptible = true,
                },
                {
                    id = 1221063,
                },
                {
                    id = 1297693,
                },
                {
                    id = 1297695,
                },
                {
                    id = 1309970,
                },
            },
        },
        [235322] = {
            name = "Defiled Golem",
            displayId = 137564,
            creatureType = "Mechanical",
            level = 91,
            health = 8432463,
            count = 35,
            spells = {
                {
                    id = 1215872,
                },
                {
                    id = 1215961,
                },
                {
                    id = 1215985,
                },
                {
                    id = 1218187,
                },
                {
                    id = 1221063,
                },
                {
                    id = 1294824,
                },
                {
                    id = 1294827,
                },
                {
                    id = 1294836,
                },
            },
        },
        [235465] = {
            name = "Shivan Punisher",
            displayId = 76712,
            creatureType = "Demon",
            level = 91,
            health = 5513534,
            count = 25,
            spells = {
                {
                    id = 1294770,
                },
                {
                    id = 1294774,
                },
                {
                    id = 1297676,
                },
                {
                    id = 1297691,
                },
            },
        },
        [235520] = {
            name = "Legion Axe",
            displayId = 16956,
            creatureType = "Not specified",
            level = 90,
            health = 1013518,
            count = 0,
            spells = {
                {
                    id = 5543,
                },
                {
                    id = 1214650,
                },
            },
        },
        [235841] = {
            name = "Selenar Sunshy",
            displayId = 105873,
            creatureType = "Humanoid",
            level = 90,
            health = 648651,
            count = 0,
            spells = {
                {
                    id = 1216074,
                },
            },
        },
        [236071] = {
            name = "Bribed Guard",
            displayId = 126157,
            creatureType = "Humanoid",
            level = 91,
            health = 5189208,
            count = 25,
            spells = {
                {
                    id = 1216529,
                },
                {
                    id = 1221063,
                },
                {
                    id = 1295035,
                },
            },
        },
        [236073] = {
            name = "Row Hooligan",
            displayId = 136939,
            creatureType = "Humanoid",
            level = 90,
            health = 1945953,
            count = 3,
            spells = {
                {
                    id = 1216300,
                    bleed = true,
                },
                {
                    id = 1221063,
                },
            },
        },
        [236082] = {
            name = "Seductive Sayaad",
            displayId = 77400,
            creatureType = "Demon",
            level = 90,
            health = 2270279,
            count = 6,
            spells = {
                {
                    id = 1201554,
                    interruptible = true,
                    magic = true,
                },
            },
        },
        [236084] = {
            name = "Felonious Mage",
            displayId = 129784,
            creatureType = "Humanoid",
            level = 90,
            health = 2854064,
            count = 7,
            spells = {
                {
                    id = 1216570,
                },
                {
                    id = 1216571,
                    interruptible = true,
                },
                {
                    id = 1221063,
                },
                {
                    id = 1229433,
                    magic = true,
                },
            },
        },
        [236085] = {
            name = "Felwyrm",
            displayId = 139997,
            creatureType = "Beast",
            level = 90,
            health = 1297302,
            count = 1,
            spells = {
                {
                    id = 1214966,
                },
                {
                    id = 1216538,
                    magic = true,
                },
                {
                    id = 1221063,
                },
            },
        },
        [236088] = {
            name = "Masked Noble",
            displayId = 140207,
            creatureType = "Humanoid",
            level = 90,
            health = 10000,
            count = 0,
            spells = {
                {
                    id = 1219468,
                },
            },
        },
        [236091] = {
            name = "Street Sneak",
            displayId = 137441,
            creatureType = "Humanoid",
            level = 90,
            health = 2918930,
            count = 3,
            spells = {
                {
                    id = 1216284,
                },
                {
                    id = 1216589,
                },
                {
                    id = 1216590,
                    poison = true,
                },
                {
                    id = 1221063,
                },
            },
        },
        [236525] = {
            name = "Rowdy Patron",
            displayId = 136524,
            creatureType = "Humanoid",
            level = 90,
            health = 648651,
            count = 0,
            spells = {
                {
                    id = 1213658,
                    interruptible = true,
                    enrage = true,
                },
            },
        },
        [236893] = {
            name = "Warehouse Worker",
            displayId = 136834,
            creatureType = "Humanoid",
            level = 90,
            health = 2270279,
            count = 2,
            spells = {
                {
                    id = 1216970,
                    enrage = true,
                },
                {
                    id = 1217992,
                },
                {
                    id = 1311136,
                },
            },
        },
        [236897] = {
            name = "Keen Taskmaster",
            displayId = 136657,
            creatureType = "Humanoid",
            level = 90,
            health = 3243255,
            count = 7,
            spells = {
                {
                    id = 1216970,
                    enrage = true,
                },
            },
        },
        [236902] = {
            name = "Massive Felwyrm",
            displayId = 139996,
            creatureType = "Beast",
            level = 91,
            health = 4540557,
            count = 12,
            spells = {
                {
                    id = 1217633,
                    magic = true,
                },
                {
                    id = 1256299,
                },
                {
                    id = 1256300,
                    magic = true,
                },
                {
                    id = 1258537,
                },
                {
                    id = 1297667,
                },
            },
        },
        [236905] = {
            name = "Felmaster Lucsei",
            displayId = 138787,
            creatureType = "Humanoid",
            level = 91,
            health = 6486510,
            count = 30,
            spells = {
                {
                    id = 1216954,
                },
                {
                    id = 1216955,
                },
                {
                    id = 1217930,
                    magic = true,
                },
                {
                    id = 1217937,
                },
                {
                    id = 1302007,
                },
                {
                    id = 1302010,
                },
            },
        },
        [237626] = {
            name = "Wild Imp",
            displayId = 77406,
            creatureType = "Demon",
            level = 90,
            health = 459705,
            count = 0,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1223204,
                    interruptible = true,
                },
                {
                    id = 1226469,
                },
            },
        },
        [238414] = {
            name = "Infernal",
            displayId = 103096,
            creatureType = "Demon",
            level = 93,
            health = 202703433,
            count = 0,
            spells = {
                {
                    id = 1221063,
                },
                {
                    id = 1231256,
                },
                {
                    id = 1231262,
                },
                {
                    id = 1231353,
                },
            },
        },
        [240289] = {
            name = "Nauseous Patron",
            displayId = 136524,
            creatureType = "Humanoid",
            level = 90,
            health = 648651,
            count = 0,
            spells = {
                {
                    id = 1216076,
                },
            },
        },
        [252529] = {
            name = "Bribed Captain",
            displayId = 137450,
            creatureType = "Humanoid",
            level = 91,
            health = 7783812,
            count = 35,
            spells = {
                {
                    id = 1216529,
                },
                {
                    id = 1221063,
                },
                {
                    id = 1256276,
                },
                {
                    id = 1295035,
                },
            },
        },
        [253081] = {
            name = "Influentual Reviewer",
            displayId = 136524,
            creatureType = "Humanoid",
            level = 90,
            health = 648651,
            count = 0,
            spells = {
                {
                    id = 1257877,
                    interruptible = true,
                },
            },
        },
        [253324] = {
            name = "Tiny Felwyrm",
            displayId = 139997,
            creatureType = "Beast",
            level = 90,
            health = 648651,
            count = 0,
            spells = {
                {
                    id = 1214966,
                },
                {
                    id = 1216538,
                    magic = true,
                },
            },
        },
        [255050] = {
            name = "Kystia Manaheart",
            displayId = 138932,
            creatureType = "Humanoid",
            level = 92,
            health = 5405427,
            count = 0,
            spells = {
                {
                    id = 1264106,
                    interruptible = true,
                },
                {
                    id = 1264110,
                    interruptible = true,
                },
            },
        },
        [255604] = {
            name = "Seductive Sayaad",
            displayId = 138981,
            creatureType = "Demon",
            level = 90,
            health = 2270279,
            count = 6,
            spells = {
                {
                    id = 1201554,
                    interruptible = true,
                    magic = true,
                },
            },
        },
        [263940] = {
            name = "Belath Dawnblade",
            displayId = 129619,
            creatureType = "Humanoid",
            level = 90,
            health = 648651,
            count = 0,
            spells = {
                {
                    id = 1218465,
                },
                {
                    id = 1218466,
                },
                {
                    id = 1218467,
                },
                {
                    id = 1218468,
                },
                {
                    id = 1218508,
                },
                {
                    id = 1255881,
                },
            },
        },
        [272246] = {
            name = "Trained Felhunter",
            displayId = 1913,
            creatureType = "Demon",
            level = 90,
            health = 10000,
            count = 0,
            spells = {
                {
                    id = 1293101,
                },
            },
        },
    },
    enemies = {
        [1] = {
            npc = 236085,
            count = 1,
            clones = 18,
            pos = {
                [1] = { 698, -479, 1 },
                [2] = { 705, -472, 1 },
                [3] = { 669, -512, 1 },
                [4] = { 699, -438, 1 },
                [5] = { 708, -433, 1 },
                [6] = { 664, -387, 1 },
                [7] = { 660, -513, 1 },
                [8] = { 653, -505, 1 },
                [9] = { 651, -496, 1 },
                [10] = { 557, -427, 1 },
                [11] = { 568, -426, 1 },
                [12] = { 526, -388, 1 },
                [13] = { 526, -382, 1 },
                [14] = { 526, -395, 1 },
                [15] = { 765, -374, 1 },
                [16] = { 759, -367, 1 },
                [17] = { 771, -380, 1 },
                [18] = { 778, -388, 1 },
            },
        },
        [2] = {
            npc = 236073,
            count = 3,
            clones = 12,
            pos = {
                [1] = { 717, -516, 1 },
                [2] = { 705, -514, 1 },
                [3] = { 666, -481, 1 },
                [4] = { 681, -496, 1 },
                [5] = { 737, -397, 1 },
                [6] = { 745, -406, 1 },
                [7] = { 688, -372, 1 },
                [8] = { 679, -366, 1 },
                [9] = { 557, -383, 1 },
                [10] = { 557, -393, 1 },
                [11] = { 545, -400, 1 },
                [12] = { 545, -373, 1 },
            },
        },
        [3] = {
            npc = 236084,
            count = 7,
            clones = 9,
            pos = {
                [1] = { 690, -471, 1 },
                [2] = { 698, -464, 1 },
                [3] = { 694, -429, 1 },
                [4] = { 703, -422, 1 },
                [5] = { 649, -396, 1 },
                [6] = { 567, -414, 1 },
                [7] = { 556, -414, 1 },
                [8] = { 770, -365, 1 },
                [9] = { 782, -377, 1 },
            },
        },
        [4] = {
            npc = 236071,
            count = 25,
            clones = 2,
            pos = {
                [1] = { 665, -499, 1 },
                [4] = { 754, -389, 1 },
            },
        },
        [5] = {
            npc = 252529,
            count = 35,
            clones = 1,
            pos = {
                [1] = { 690, -401, 1 },
            },
        },
        [6] = {
            npc = 236082,
            count = 6,
            clones = 4,
            pos = {
                [1] = { 168, -291, 1 },
                [2] = { 179, -425, 1 },
                [4] = { 189, -433, 1 },
                [5] = { 784, -351, 1 },
            },
        },
        [7] = {
            npc = 236902,
            count = 12,
            clones = 1,
            pos = {
                [1] = { 534, -389, 1 },
            },
        },
        [8] = {
            npc = 236091,
            count = 3,
            clones = 6,
            pos = {
                [1] = { 670, -361, 1 },
                [2] = { 697, -377, 1 },
                [3] = { 654, -386, 1 },
                [4] = { 615, -377, 1 },
                [5] = { 620, -390, 1 },
                [6] = { 662, -397, 1 },
            },
        },
        [9] = {
            npc = 236893,
            count = 2,
            clones = 6,
            pos = {
                [1] = { 482, -64, 1 },
                [2] = { 488, -74, 1 },
                [3] = { 475, -74, 1 },
                [4] = { 419, -94, 1 },
                [5] = { 408, -101, 1 },
                [6] = { 419, -107, 1 },
            },
        },
        [10] = {
            npc = 236897,
            count = 7,
            clones = 2,
            pos = {
                [1] = { 440, -102, 1 },
                [2] = { 481, -99, 1 },
            },
        },
        [11] = {
            npc = 234849,
            count = 2,
            clones = 58,
            pos = {
                [1] = { 303, -446, 1 },
                [3] = { 308, -443, 1 },
                [4] = { 314, -440, 1 },
                [5] = { 300, -439, 1 },
                [6] = { 306, -437, 1 },
                [7] = { 312, -434, 1 },
                [8] = { 254, -363, 1 },
                [9] = { 259, -360, 1 },
                [10] = { 264, -358, 1 },
                [11] = { 254, -356, 1 },
                [12] = { 260, -354, 1 },
                [13] = { 262, -231, 1 },
                [14] = { 269, -231, 1 },
                [15] = { 276, -230, 1 },
                [16] = { 263, -238, 1 },
                [17] = { 269, -237, 1 },
                [18] = { 276, -237, 1 },
                [19] = { 267, -272, 1 },
                [20] = { 274, -272, 1 },
                [21] = { 280, -272, 1 },
                [22] = { 267, -279, 1 },
                [23] = { 273, -279, 1 },
                [24] = { 280, -279, 1 },
                [25] = { 206, -335, 1 },
                [26] = { 212, -332, 1 },
                [27] = { 218, -330, 1 },
                [28] = { 205, -328, 1 },
                [29] = { 211, -326, 1 },
                [30] = { 217, -324, 1 },
                [31] = { 180, -288, 1 },
                [32] = { 178, -292, 1 },
                [33] = { 175, -298, 1 },
                [34] = { 180, -299, 1 },
                [35] = { 182, -294, 1 },
                [36] = { 184, -289, 1 },
                [37] = { 157, -306, 1 },
                [38] = { 164, -306, 1 },
                [39] = { 169, -305, 1 },
                [40] = { 158, -310, 1 },
                [41] = { 163, -311, 1 },
                [42] = { 169, -311, 1 },
                [43] = { 162, -279, 1 },
                [44] = { 167, -279, 1 },
                [45] = { 173, -278, 1 },
                [46] = { 161, -273, 1 },
                [47] = { 166, -273, 1 },
                [48] = { 172, -273, 1 },
                [49] = { 143, -281, 1 },
                [50] = { 143, -287, 1 },
                [51] = { 143, -293, 1 },
                [52] = { 148, -293, 1 },
                [53] = { 148, -287, 1 },
                [54] = { 148, -281, 1 },
                [55] = { 135, -258, 1 },
                [56] = { 141, -258, 1 },
                [57] = { 194, -224, 1 },
                [58] = { 140, -342, 1 },
                [59] = { 118, -363, 1 },
            },
        },
        [12] = {
            npc = 235261,
            count = 5,
            clones = 15,
            pos = {
                [1] = { 235, -394, 1 },
                [3] = { 219, -378, 1 },
                [4] = { 223, -263, 1 },
                [5] = { 234, -264, 1 },
                [6] = { 242, -256, 1 },
                [7] = { 214, -132, 1 },
                [8] = { 204, -134, 1 },
                [9] = { 154, -224, 1 },
                [10] = { 165, -224, 1 },
                [11] = { 198, -232, 1 },
                [12] = { 198, -242, 1 },
                [13] = { 156, -397, 1 },
                [14] = { 165, -404, 1 },
                [15] = { 258, -488, 1 },
                [16] = { 238, -495, 1 },
            },
        },
        [13] = {
            npc = 235268,
            count = 7,
            clones = 11,
            pos = {
                [1] = { 227, -386, 1 },
                [2] = { 202, -123, 1 },
                [3] = { 212, -122, 1 },
                [4] = { 285, -309, 1 },
                [5] = { 160, -215, 1 },
                [6] = { 188, -242, 1 },
                [7] = { 163, -251, 1 },
                [8] = { 147, -345, 1 },
                [9] = { 119, -372, 1 },
                [10] = { 211, -408, 1 },
                [12] = { 204, -417, 1 },
            },
        },
        [14] = {
            npc = 235267,
            count = 5,
            clones = 11,
            pos = {
                [1] = { 289, -465, 1 },
                [2] = { 300, -464, 1 },
                [3] = { 231, -358, 1 },
                [4] = { 238, -357, 1 },
                [5] = { 281, -319, 1 },
                [6] = { 292, -318, 1 },
                [7] = { 189, -231, 1 },
                [8] = { 158, -261, 1 },
                [9] = { 168, -260, 1 },
                [10] = { 171, -326, 1 },
                [11] = { 185, -334, 1 },
            },
        },
        [15] = {
            npc = 235265,
            count = 25,
            clones = 4,
            pos = {
                [1] = { 173, -339, 1 },
                [2] = { 138, -353, 1 },
                [3] = { 128, -363, 1 },
                [5] = { 229, -251, 1 },
            },
        },
        [16] = {
            npc = 235257,
            count = 1,
            clones = 20,
            pos = {
                [1] = { 197, -280, 1 },
                [2] = { 204, -280, 1 },
                [4] = { 197, -286, 1 },
                [5] = { 204, -286, 1 },
                [6] = { 187, -315, 1 },
                [7] = { 193, -315, 1 },
                [8] = { 188, -308, 1 },
                [9] = { 195, -309, 1 },
                [10] = { 228, -426, 1 },
                [11] = { 223, -430, 1 },
                [12] = { 227, -436, 1 },
                [13] = { 232, -432, 1 },
                [14] = { 241, -454, 1 },
                [15] = { 247, -452, 1 },
                [16] = { 243, -460, 1 },
                [17] = { 249, -457, 1 },
                [18] = { 164, -348, 1 },
                [19] = { 172, -348, 1 },
                [20] = { 163, -356, 1 },
                [21] = { 171, -356, 1 },
            },
        },
        [17] = {
            npc = 235465,
            count = 25,
            clones = 7,
            pos = {
                [1] = { 248, -106, 1 },
                [2] = { 235, -113, 1 },
                [3] = { 166, -119, 1 },
                [4] = { 179, -127, 1 },
                [5] = { 226, -234, 1 },
                [6] = { 127, -233, 1 },
                [7] = { 199, -404, 1 },
            },
        },
        [18] = {
            npc = 236905,
            count = 30,
            clones = 1,
            pos = {
                [1] = { 248, -492, 1 },
            },
        },
        [19] = {
            npc = 235322,
            count = 35,
            clones = 7,
            pos = {
                [1] = { 177, -112, 1 },
                [2] = { 235, -98, 1 },
                [3] = { 252, -170, 1 },
                [4] = { 278, -423, 1 },
                [5] = { 184, -182, 1 },
                [6] = { 291, -358, 1 },
                [7] = { 205, -109, 1 },
            },
        },
        [20] = {
            npc = 234647,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 286, -544, 1 },
            },
        },
        [21] = {
            npc = 234648,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 669, -268, 1 },
            },
        },
        [22] = {
            npc = 234649,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 427, -246, 1 },
            },
        },
        [23] = {
            npc = 234660,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 633, -268, 1 },
            },
        },
        [24] = {
            npc = 234763,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 193, -55, 1 },
            },
        },
        [25] = {
            npc = 234799,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 208, -41, 1 },
            },
        },
        [26] = {
            npc = 234852,
            count = 0,
            clones = 5,
            pos = {
                [1] = { 413, -205, 1 },
                [2] = { 438, -206, 1 },
                [3] = { 425, -187, 1 },
                [4] = { 404, -190, 1 },
                [5] = { 445, -189, 1 },
            },
        },
        [27] = {
            npc = 234860,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 363, -209, 1 },
            },
        },
        [28] = {
            npc = 234984,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 616, -109, 1 },
            },
        },
        [29] = {
            npc = 235520,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 303, -540, 1 },
            },
        },
        [30] = {
            npc = 235841,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 616, -100, 1 },
            },
        },
        [31] = {
            npc = 236088,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 607, -100, 1 },
            },
        },
        [32] = {
            npc = 236525,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 625, -100, 1 },
            },
        },
        [33] = {
            npc = 237626,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 213, -60, 1 },
            },
        },
        [34] = {
            npc = 238414,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 213, -49, 1 },
            },
        },
        [35] = {
            npc = 240289,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 607, -109, 1 },
            },
        },
        [36] = {
            npc = 253081,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 625, -109, 1 },
            },
        },
        [37] = {
            npc = 253324,
            count = 0,
            clones = 4,
            pos = {
                [1] = { 520, -398, 1 },
                [2] = { 520, -377, 1 },
                [3] = { 520, -384, 1 },
                [4] = { 520, -392, 1 },
            },
        },
        [38] = {
            npc = 255050,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 649, -289, 1 },
            },
        },
        [39] = {
            npc = 255604,
            count = 6,
            clones = 1,
            pos = {
                [1] = { 793, -360, 1 },
            },
        },
        [40] = {
            npc = 263940,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 649, -222, 1 },
            },
        },
        [41] = {
            npc = 272246,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 542, -39, 1 },
            },
        },
    },
    maps = {
        [1] = {
            path = "Interface\\AddOns\\MythicDungeonTools\\Midnight\\Textures\\MurderRow",
            name = "Murder Row",
        },
    },
})

R:RegisterDungeon({
    challengeModeId = 399,
    englishName = "Ruby Life Pools",
    shortName = "RLP",
    mdtDungeonIdx = 42,
    totalCount = 551,
    npcs = {
        [187894] = {
            name = "Infused Whelp",
            displayId = 110633,
            creatureType = "Dragonkin",
            level = 90,
            health = 1297302,
            count = 0,
            spells = {
                {
                    id = 1305234,
                    magic = true,
                },
            },
        },
        [187897] = {
            name = "Defier Draghar",
            displayId = 107106,
            creatureType = "Dragonkin",
            level = 91,
            health = 9729765,
            count = 30,
            isBoss = true,
            spells = {
                {
                    id = 372047,
                },
                {
                    id = 372087,
                },
                {
                    id = 372794,
                },
                {
                    id = 1309705,
                },
            },
        },
        [187969] = {
            name = "Deepstone Earthshaper",
            displayId = 102955,
            creatureType = "Humanoid",
            level = 90,
            health = 3567581,
            count = 5,
            spells = {
                {
                    id = 371471,
                },
                {
                    id = 1305225,
                },
            },
        },
        [188011] = {
            name = "Earthbound Guardian",
            displayId = 79800,
            creatureType = "Elemental",
            level = 90,
            health = 3567581,
            count = 5,
            spells = {
                {
                    id = 384933,
                    interruptible = true,
                },
                {
                    id = 1307205,
                },
            },
        },
        [188067] = {
            name = "Flashfrost Chillweaver",
            displayId = 107397,
            creatureType = "Humanoid",
            level = 90,
            health = 2918930,
            count = 7,
            spells = {
                {
                    id = 371489,
                },
                {
                    id = 371984,
                    interruptible = true,
                },
                {
                    id = 372743,
                    interruptible = true,
                },
                {
                    id = 372749,
                },
                {
                    id = 384933,
                    interruptible = true,
                },
            },
        },
        [188244] = {
            name = "Primal Juggernaut",
            displayId = 101209,
            creatureType = "Elemental",
            level = 91,
            health = 6486510,
            count = 25,
            spells = {
                {
                    id = 372730,
                },
                {
                    id = 372793,
                },
                {
                    id = 1305201,
                },
                {
                    id = 1305213,
                },
                {
                    id = 1310489,
                },
            },
        },
        [188252] = {
            name = "Melidrussa Chillworn",
            displayId = 106891,
            creatureType = "Humanoid",
            level = 92,
            health = 20270343,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 372808,
                    interruptible = true,
                },
                {
                    id = 372851,
                },
                {
                    id = 372988,
                },
                {
                    id = 373046,
                },
                {
                    id = 373680,
                },
                {
                    id = 373688,
                },
                {
                    id = 373727,
                },
                {
                    id = 383925,
                },
            },
        },
        [189232] = {
            name = "Kokia Blazehoof",
            displayId = 106851,
            creatureType = "Humanoid",
            level = 92,
            health = 21621700,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 372107,
                },
                {
                    id = 372811,
                },
                {
                    id = 372819,
                },
                {
                    id = 372820,
                },
                {
                    id = 372858,
                },
                {
                    id = 372859,
                },
                {
                    id = 372860,
                },
                {
                    id = 372863,
                },
            },
        },
        [189886] = {
            name = "Blazebound Firestorm",
            displayId = 102505,
            creatureType = "Elemental",
            level = 91,
            health = 2162170,
            count = 0,
            spells = {
                {
                    id = 373017,
                    interruptible = true,
                },
                {
                    id = 373087,
                },
                {
                    id = 384823,
                },
            },
        },
        [189893] = {
            name = "Infused Whelp",
            displayId = 110633,
            creatureType = "Dragonkin",
            level = 90,
            health = 810814,
            count = 0,
            spells = {
                {
                    id = 1305234,
                    magic = true,
                },
            },
        },
        [190034] = {
            name = "Blazebound Destroyer",
            displayId = 102505,
            creatureType = "Elemental",
            level = 91,
            health = 7135161,
            count = 25,
            spells = {
                {
                    id = 373614,
                },
                {
                    id = 373692,
                },
                {
                    id = 384139,
                },
                {
                    id = 1305955,
                    interruptible = true,
                },
            },
        },
        [190205] = {
            name = "Scorchling",
            displayId = 102535,
            creatureType = "Elemental",
            level = 90,
            health = 648651,
            count = 0,
            spells = {
                {
                    id = 1307372,
                },
            },
        },
        [190206] = {
            name = "Ashseer Flamelasher",
            displayId = 102969,
            creatureType = "Humanoid",
            level = 90,
            health = 3567581,
            count = 7,
            spells = {
                {
                    id = 373972,
                    magic = true,
                },
                {
                    id = 373973,
                },
                {
                    id = 373977,
                },
                {
                    id = 385536,
                },
                {
                    id = 385567,
                },
                {
                    id = 1305865,
                },
            },
        },
        [190207] = {
            name = "Primalist Cinderweaver",
            displayId = 102886,
            creatureType = "Humanoid",
            level = 90,
            health = 2918930,
            count = 7,
            spells = {
                {
                    id = 373693,
                },
                {
                    id = 384194,
                    interruptible = true,
                },
            },
        },
        [190484] = {
            name = "Kyrakka",
            displayId = 107137,
            creatureType = "Dragonkin",
            level = 92,
            health = 13513562,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 381525,
                },
                {
                    id = 381526,
                },
                {
                    id = 381602,
                },
                {
                    id = 381605,
                },
                {
                    id = 381862,
                },
                {
                    id = 381864,
                },
                {
                    id = 384773,
                },
                {
                    id = 1312669,
                },
            },
        },
        [190485] = {
            name = "Erkhart Stormvein",
            displayId = 108318,
            creatureType = "Humanoid",
            level = 92,
            health = 15202758,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 181089,
                },
                {
                    id = 381512,
                },
                {
                    id = 381513,
                },
                {
                    id = 381514,
                },
                {
                    id = 381515,
                    magic = true,
                },
                {
                    id = 381516,
                },
                {
                    id = 381517,
                },
                {
                    id = 381518,
                },
            },
        },
        [194622] = {
            name = "Scorchling",
            displayId = 102535,
            creatureType = "Elemental",
            level = 90,
            health = 613089,
            count = 0,
            spells = {
                {
                    id = 1307372,
                },
            },
        },
        [195119] = {
            name = "Ruinous Stormbringer",
            displayId = 108753,
            creatureType = "Humanoid",
            level = 91,
            health = 10740817,
            count = 10,
            spells = {
                {
                    id = 385310,
                    interruptible = true,
                },
                {
                    id = 385311,
                },
                {
                    id = 385312,
                },
                {
                    id = 385313,
                },
                {
                    id = 385314,
                },
                {
                    id = 385316,
                },
            },
        },
        [197509] = {
            name = "Primal Thundercloud",
            displayId = 102516,
            creatureType = "Elemental",
            level = 89,
            health = 1621628,
            count = 0,
            spells = {
                {
                    id = 391031,
                    magic = true,
                },
                {
                    id = 392399,
                },
            },
        },
        [197535] = {
            name = "High Channeler Ryvati",
            displayId = 110966,
            creatureType = "Humanoid",
            level = 91,
            health = 6486510,
            count = 30,
            isBoss = true,
            spells = {
                {
                    id = 1306366,
                },
                {
                    id = 1307488,
                },
                {
                    id = 1307511,
                },
                {
                    id = 1310355,
                },
                {
                    id = 1310361,
                },
                {
                    id = 1310363,
                },
            },
        },
        [197697] = {
            name = "Flamegullet",
            displayId = 106023,
            creatureType = "Dragonkin",
            level = 91,
            health = 9729765,
            count = 40,
            isBoss = true,
            spells = {
                {
                    id = 391723,
                },
                {
                    id = 392394,
                },
                {
                    id = 392569,
                },
                {
                    id = 392570,
                },
                {
                    id = 395292,
                },
            },
        },
        [197698] = {
            name = "Thunderhead",
            displayId = 106435,
            creatureType = "Dragonkin",
            level = 91,
            health = 8432463,
            count = 48,
            isBoss = true,
            spells = {
                {
                    id = 391726,
                },
                {
                    id = 391727,
                },
                {
                    id = 392395,
                },
                {
                    id = 392640,
                },
                {
                    id = 392641,
                    magic = true,
                },
                {
                    id = 395303,
                },
                {
                    id = 1310599,
                },
            },
        },
        [197982] = {
            name = "Storm Warrior",
            displayId = 110964,
            creatureType = "Humanoid",
            level = 90,
            health = 3567581,
            count = 5,
            spells = {
                {
                    id = 392406,
                },
            },
        },
        [198047] = {
            name = "Tempest Channeler",
            displayId = 110967,
            creatureType = "Humanoid",
            level = 91,
            health = 5189208,
            count = 25,
            spells = {
                {
                    id = 392576,
                    interruptible = true,
                },
                {
                    id = 1306366,
                },
                {
                    id = 1307488,
                },
                {
                    id = 1307502,
                },
            },
        },
    },
    enemies = {
        [1] = {
            npc = 188244,
            count = 25,
            clones = 2,
            pos = {
                [1] = { 101, -463, 1 },
                [2] = { 138, -186, 1 },
            },
        },
        [2] = {
            npc = 187969,
            count = 5,
            clones = 9,
            pos = {
                [1] = { 126, -366, 1 },
                [2] = { 104, -348, 1 },
                [3] = { 117, -339, 1 },
                [4] = { 63, -270, 1 },
                [6] = { 124, -144, 1 },
                [7] = { 150, -129, 1 },
                [8] = { 190, -133, 1 },
                [9] = { 93, -478, 1 },
                [10] = { 139, -208, 1 },
            },
        },
        [3] = {
            npc = 188011,
            count = 5,
            clones = 6,
            pos = {
                [1] = { 132, -361, 1 },
                [4] = { 48, -263, 1 },
                [5] = { 114, -259, 1 },
                [6] = { 129, -220, 1 },
                [8] = { 110, -478, 1 },
                [9] = { 156, -122, 1 },
            },
        },
        [4] = {
            npc = 188067,
            count = 7,
            clones = 5,
            pos = {
                [1] = { 103, -334, 1 },
                [3] = { 102, -267, 1 },
                [6] = { 113, -197, 1 },
                [8] = { 118, -151, 1 },
                [9] = { 168, -143, 1 },
            },
        },
        [5] = {
            npc = 187894,
            count = 0,
            clones = 52,
            pos = {
                [1] = { 60, -219, 1 },
                [2] = { 56, -226, 1 },
                [3] = { 64, -225, 1 },
                [4] = { 78, -183, 1 },
                [5] = { 84, -177, 1 },
                [6] = { 94, -163, 1 },
                [7] = { 80, -196, 1 },
                [8] = { 72, -191, 1 },
                [9] = { 101, -168, 1 },
                [10] = { 84, -188, 1 },
                [11] = { 98, -183, 1 },
                [12] = { 89, -181, 1 },
                [13] = { 88, -195, 1 },
                [14] = { 103, -176, 1 },
                [15] = { 95, -174, 1 },
                [16] = { 93, -189, 1 },
                [17] = { 143, -230, 1 },
                [18] = { 154, -211, 1 },
                [19] = { 148, -216, 1 },
                [20] = { 149, -225, 1 },
                [21] = { 162, -216, 1 },
                [22] = { 142, -221, 1 },
                [23] = { 155, -221, 1 },
                [24] = { 117, -296, 1 },
                [25] = { 125, -298, 1 },
                [26] = { 115, -305, 1 },
                [27] = { 123, -307, 1 },
                [28] = { 127, -290, 1 },
                [29] = { 119, -288, 1 },
                [30] = { 56, -330, 1 },
                [31] = { 33, -330, 1 },
                [32] = { 41, -321, 1 },
                [33] = { 41, -330, 1 },
                [34] = { 49, -321, 1 },
                [35] = { 33, -321, 1 },
                [36] = { 57, -322, 1 },
                [37] = { 50, -313, 1 },
                [38] = { 50, -303, 1 },
                [39] = { 42, -303, 1 },
                [40] = { 33, -311, 1 },
                [41] = { 34, -302, 1 },
                [42] = { 41, -311, 1 },
                [43] = { 49, -330, 1 },
                [44] = { 58, -314, 1 },
                [45] = { 58, -305, 1 },
                [46] = { 66, -319, 1 },
                [47] = { 89, -169, 1 },
                [48] = { 212, -171, 1 },
                [49] = { 208, -163, 1 },
                [50] = { 203, -169, 1 },
                [51] = { 53, -233, 1 },
                [52] = { 61, -231, 1 },
            },
        },
        [6] = {
            npc = 187897,
            count = 30,
            clones = 1,
            pos = {
                [1] = { 188, -192, 1 },
            },
        },
        [7] = {
            npc = 188252,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 281, -291, 1 },
            },
        },
        [8] = {
            npc = 190205,
            count = 0,
            clones = 1,
            pos = {
                [22] = { 525, -208, 1 },
            },
        },
        [9] = {
            npc = 197698,
            count = 48,
            clones = 1,
            pos = {
                [1] = { 479, -312, 1 },
            },
        },
        [10] = {
            npc = 190207,
            count = 7,
            clones = 9,
            pos = {
                [1] = { 733, -275, 1 },
                [2] = { 788, -383, 1 },
                [3] = { 498, -423, 1 },
                [4] = { 578, -471, 1 },
                [5] = { 658, -502, 1 },
                [6] = { 473, -382, 1 },
                [7] = { 570, -229, 1 },
                [9] = { 338, -86, 1 },
                [10] = { 696, -222, 1 },
            },
        },
        [11] = {
            npc = 190034,
            count = 25,
            clones = 4,
            pos = {
                [1] = { 490, -385, 1 },
                [2] = { 571, -456, 1 },
                [3] = { 718, -280, 1 },
                [4] = { 631, -201, 1 },
            },
        },
        [12] = {
            npc = 190206,
            count = 7,
            clones = 9,
            pos = {
                [1] = { 501, -434, 1 },
                [2] = { 509, -426, 1 },
                [3] = { 561, -470, 1 },
                [4] = { 732, -288, 1 },
                [6] = { 571, -218, 1 },
                [7] = { 310, -117, 1 },
                [8] = { 776, -383, 1 },
                [9] = { 685, -229, 1 },
                [10] = { 656, -489, 1 },
            },
        },
        [13] = {
            npc = 195119,
            count = 10,
            clones = 4,
            pos = {
                [1] = { 527, -339, 1 },
                [2] = { 643, -437, 1 },
                [3] = { 715, -356, 1 },
                [4] = { 589, -258, 1 },
            },
        },
        [14] = {
            npc = 197697,
            count = 40,
            clones = 1,
            pos = {
                [1] = { 748, -334, 1 },
            },
        },
        [15] = {
            npc = 189232,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 480, -233, 1 },
            },
        },
        [16] = {
            npc = 197982,
            count = 5,
            clones = 9,
            pos = {
                [1] = { 443, -199, 1 },
                [2] = { 434, -207, 1 },
                [3] = { 356, -141, 1 },
                [4] = { 364, -134, 1 },
                [5] = { 328, -79, 1 },
                [7] = { 287, -85, 1 },
                [8] = { 295, -77, 1 },
                [9] = { 299, -117, 1 },
                [10] = { 306, -127, 1 },
            },
        },
        [17] = {
            npc = 197509,
            count = 0,
            clones = 22,
            pos = {
                [1] = { 431, -196, 1 },
                [2] = { 403, -181, 1 },
                [3] = { 411, -174, 1 },
                [4] = { 378, -168, 1 },
                [5] = { 395, -167, 1 },
                [6] = { 396, -151, 1 },
                [7] = { 256, -102, 1 },
                [8] = { 252, -108, 1 },
                [9] = { 251, -98, 1 },
                [10] = { 247, -104, 1 },
                [11] = { 296, -67, 1 },
                [12] = { 276, -84, 1 },
                [13] = { 279, -91, 1 },
                [14] = { 358, -65, 1 },
                [15] = { 356, -72, 1 },
                [16] = { 330, -50, 1 },
                [18] = { 349, -71, 1 },
                [19] = { 324, -48, 1 },
                [20] = { 330, -43, 1 },
                [21] = { 304, -71, 1 },
                [22] = { 321, -85, 1 },
                [23] = { 349, -63, 1 },
            },
        },
        [18] = {
            npc = 198047,
            count = 25,
            clones = 2,
            pos = {
                [1] = { 387, -158, 1 },
                [2] = { 328, -92, 1 },
            },
        },
        [19] = {
            npc = 197535,
            count = 30,
            clones = 1,
            pos = {
                [1] = { 282, -71, 1 },
            },
        },
        [20] = {
            npc = 190485,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 255, -21, 1 },
            },
        },
        [21] = {
            npc = 190484,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 226, -49, 1 },
            },
        },
        [22] = {
            npc = 189886,
            count = 0,
            clones = 3,
            pos = {
                [1] = { 503, -221, 1 },
                [2] = { 504, -239, 1 },
                [3] = { 494, -255, 1 },
            },
        },
        [23] = {
            npc = 189893,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 338, -242, 1 },
            },
        },
        [24] = {
            npc = 194622,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 517, -200, 1 },
            },
        },
    },
    maps = {
        [1] = {
            path = "Interface\\AddOns\\MythicDungeonTools\\Midnight\\Textures\\RubyLifePools",
            name = "Ruby Life Pools",
        },
    },
})

R:RegisterDungeon({
    challengeModeId = 250,
    englishName = "Temple of Sethraliss",
    shortName = "TOS",
    mdtDungeonIdx = 20,
    totalCount = 687,
    npcs = {
        [133384] = {
            name = "Merektha",
            displayId = 88585,
            creatureType = "Beast",
            level = 92,
            health = 15540596,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 264172,
                },
                {
                    id = 1289205,
                },
                {
                    id = 1289589,
                },
                {
                    id = 1289602,
                },
                {
                    id = 1290031,
                },
                {
                    id = 1290797,
                },
                {
                    id = 1291734,
                },
                {
                    id = 1293048,
                },
            },
        },
        [133392] = {
            name = "Avatar of Sethraliss",
            displayId = 83203,
            creatureType = "Undead",
            level = 120,
            health = 23783870,
            count = 0,
            isBoss = true,
        },
        [134364] = {
            name = "Faithless Subjugator",
            displayId = 86510,
            creatureType = "Humanoid",
            level = 90,
            health = 3243255,
            count = 7,
            spells = {
                {
                    id = 269896,
                },
                {
                    id = 1293307,
                    interruptible = true,
                    curse = true,
                },
                {
                    id = 1314082,
                    interruptible = true,
                    curse = true,
                },
            },
        },
        [134388] = {
            name = "A Knot of Snakes",
            displayId = 83574,
            creatureType = "Beast",
            level = 90,
            health = 540542,
            count = 0,
            spells = {
                {
                    id = 263958,
                },
            },
        },
        [134389] = {
            name = "Toxic Viper",
            displayId = 78250,
            creatureType = "Beast",
            level = 90,
            health = 324056,
            count = 0,
            spells = {
                {
                    id = 267027,
                    interruptible = true,
                    poison = true,
                },
            },
        },
        [134390] = {
            name = "Storm Serpent",
            displayId = 147087,
            creatureType = "Beast",
            level = 91,
            health = 2972984,
            count = 0,
            spells = {
                {
                    id = 1289589,
                },
                {
                    id = 1291622,
                },
            },
        },
        [134487] = {
            name = "Merektha",
            displayId = 78247,
            creatureType = "Beast",
            level = 90,
            health = 369424,
            count = 0,
        },
        [134599] = {
            name = "Imbued Stormcaller",
            displayId = 83779,
            creatureType = "Humanoid",
            level = 90,
            health = 3243255,
            count = 7,
            spells = {
                {
                    id = 269116,
                },
                {
                    id = 1291262,
                    interruptible = true,
                },
                {
                    id = 1296045,
                },
                {
                    id = 1296052,
                    magic = true,
                },
                {
                    id = 1310739,
                    magic = true,
                },
            },
        },
        [134600] = {
            name = "Sandswept Hunter",
            displayId = 83780,
            creatureType = "Humanoid",
            level = 90,
            health = 3567581,
            count = 7,
            spells = {
                {
                    id = 1292585,
                },
                {
                    id = 1292623,
                },
                {
                    id = 1308113,
                },
                {
                    id = 1308116,
                },
            },
        },
        [134602] = {
            name = "Shrouded Fang",
            displayId = 83782,
            creatureType = "Humanoid",
            level = 90,
            health = 3243255,
            count = 7,
            spells = {
                {
                    id = 1295610,
                },
                {
                    id = 1295635,
                },
                {
                    id = 1308100,
                    interruptible = true,
                    poison = true,
                },
            },
        },
        [134616] = {
            name = "Barbed Krolusk",
            displayId = 83787,
            creatureType = "Beast",
            level = 90,
            health = 2594604,
            count = 5,
            spells = {
                {
                    id = 1291399,
                },
            },
        },
        [134629] = {
            name = "Sand-Sworn Rider",
            displayId = 84761,
            creatureType = "Humanoid",
            level = 91,
            health = 5189208,
            count = 25,
            spells = {
                {
                    id = 262046,
                },
                {
                    id = 272655,
                },
                {
                    id = 1291399,
                },
                {
                    id = 1292990,
                },
            },
        },
        [134686] = {
            name = "Krolusk Matriarch",
            displayId = 75595,
            creatureType = "Beast",
            level = 91,
            health = 4216232,
            count = 16,
            spells = {
                {
                    id = 272654,
                },
                {
                    id = 272655,
                },
            },
        },
        [134691] = {
            name = "Static Anomaly",
            displayId = 81655,
            creatureType = "Elemental",
            level = 90,
            health = 3243255,
            count = 5,
            spells = {
                {
                    id = 264763,
                },
                {
                    id = 1310693,
                },
            },
        },
        [134990] = {
            name = "Storm Adept",
            displayId = 84024,
            creatureType = "Humanoid",
            level = 90,
            health = 2918930,
            count = 7,
            spells = {
                {
                    id = 1291262,
                    interruptible = true,
                },
            },
        },
        [134991] = {
            name = "Sandfury Stonefist",
            displayId = 84207,
            creatureType = "Humanoid",
            level = 91,
            health = 5837859,
            count = 25,
            spells = {
                {
                    id = 265966,
                },
                {
                    id = 1291468,
                },
            },
        },
        [135007] = {
            name = "Orb Watcher",
            displayId = 84503,
            creatureType = "Humanoid",
            level = 91,
            health = 6486510,
            count = 25,
            spells = {
                {
                    id = 1303443,
                },
                {
                    id = 1303452,
                },
                {
                    id = 1303486,
                },
                {
                    id = 1308546,
                },
            },
        },
        [135445] = {
            name = "Lightning Spire",
            displayId = 46710,
            creatureType = "Elemental",
            level = 90,
            health = 235746,
            count = 0,
        },
        [135562] = {
            name = "Poisonous Viper",
            displayId = 78250,
            creatureType = "Beast",
            level = 90,
            health = 3243255,
            count = 7,
            spells = {
                {
                    id = 1308148,
                    interruptible = true,
                    poison = true,
                },
            },
        },
        [135846] = {
            name = "Lightning Serpent",
            displayId = 78247,
            creatureType = "Beast",
            level = 90,
            health = 3243255,
            count = 5,
            spells = {
                {
                    id = 1293133,
                },
                {
                    id = 1310396,
                },
                {
                    id = 1310402,
                },
            },
        },
        [135971] = {
            name = "Faithless Conscript",
            displayId = 147077,
            creatureType = "Humanoid",
            level = 90,
            health = 648651,
            count = 0,
        },
        [136076] = {
            name = "Agitated Nimbus",
            displayId = 65631,
            creatureType = "Elemental",
            level = 91,
            health = 5189208,
            count = 25,
            spells = {
                {
                    id = 1293464,
                    magic = true,
                },
                {
                    id = 1293475,
                },
                {
                    id = 1293650,
                },
                {
                    id = 1293652,
                },
                {
                    id = 1310739,
                    magic = true,
                },
            },
        },
        [136250] = {
            name = "Twisted Hexxer",
            displayId = 84676,
            creatureType = "Humanoid",
            level = 91,
            health = 4864883,
            count = 25,
            spells = {
                {
                    id = 268013,
                    interruptible = true,
                },
                {
                    id = 1300666,
                },
                {
                    id = 1300684,
                },
                {
                    id = 1311964,
                },
                {
                    id = 1311980,
                },
                {
                    id = 1311981,
                },
            },
        },
        [139097] = {
            name = "Sandswept Marksman",
            displayId = 83780,
            creatureType = "Humanoid",
            level = 90,
            health = 214315,
            count = 0,
            spells = {
                {
                    id = 273225,
                },
            },
        },
        [139108] = {
            name = "Loose Spark",
            displayId = 51418,
            creatureType = "Elemental",
            level = 90,
            health = 3243255,
            count = 0,
            spells = {
                {
                    id = 267483,
                },
                {
                    id = 273241,
                },
                {
                    id = 1225638,
                },
            },
        },
        [139110] = {
            name = "Spark Channeler",
            displayId = 83553,
            creatureType = "Humanoid",
            level = 90,
            health = 972977,
            count = 5,
            spells = {
                {
                    id = 267483,
                },
            },
        },
        [139131] = {
            name = "Polarized Spire",
            displayId = 46710,
            creatureType = "Elemental",
            level = 90,
            health = 10000,
            count = 0,
        },
        [139422] = {
            name = "Dutiful Tamer",
            displayId = 84761,
            creatureType = "Humanoid",
            level = 90,
            health = 3243255,
            count = 7,
            spells = {
                {
                    id = 1291399,
                },
                {
                    id = 1292990,
                },
            },
        },
        [139425] = {
            name = "Brood Tender",
            displayId = 83444,
            creatureType = "Humanoid",
            level = 90,
            health = 3243255,
            count = 7,
            spells = {
                {
                    id = 1310683,
                    interruptible = true,
                },
            },
        },
        [240681] = {
            name = "Eye of Sethraliss",
            displayId = 169,
            creatureType = "Not specified",
            level = 90,
            health = 324056,
            count = 0,
            spells = {
                {
                    id = 1303596,
                },
            },
        },
        [262530] = {
            name = "Adderis",
            displayId = 83550,
            creatureType = "Humanoid",
            level = 92,
            health = 10135171,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 263425,
                },
                {
                    id = 1288087,
                },
                {
                    id = 1288092,
                },
                {
                    id = 1288235,
                },
                {
                    id = 1288428,
                },
                {
                    id = 1289229,
                },
                {
                    id = 1308738,
                },
                {
                    id = 1308740,
                },
            },
        },
        [262822] = {
            name = "Aspix",
            displayId = 83552,
            creatureType = "Humanoid",
            level = 92,
            health = 10135171,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1288457,
                },
                {
                    id = 1288864,
                },
                {
                    id = 1288885,
                },
                {
                    id = 1289062,
                },
                {
                    id = 1289229,
                },
                {
                    id = 1292035,
                },
                {
                    id = 1310311,
                },
                {
                    id = 1310712,
                },
            },
        },
        [263181] = {
            name = "Egg",
            displayId = 55649,
            creatureType = "Humanoid",
            level = 91,
            health = 10000,
            count = 0,
            spells = {
                {
                    id = 1289208,
                },
                {
                    id = 1296738,
                },
            },
        },
        [263383] = {
            name = "Snake",
            displayId = 7409,
            creatureType = "Beast",
            level = 90,
            health = 1081085,
            count = 0,
        },
        [263658] = {
            name = "Galvazzt",
            displayId = 147355,
            creatureType = "Elemental",
            level = 92,
            health = 21621698,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1290531,
                },
                {
                    id = 1291815,
                },
            },
        },
        [264785] = {
            name = "Swarming Krolusk",
            displayId = 83787,
            creatureType = "Beast",
            level = 91,
            health = 810814,
            count = 0,
        },
        [265057] = {
            name = "Spark Channeler",
            displayId = 83553,
            creatureType = "Humanoid",
            level = 120,
            health = 648651,
            count = 5,
        },
        [268317] = {
            name = "Faithless Tormentor",
            displayId = 147718,
            creatureType = "Humanoid",
            level = 90,
            health = 1135139,
            count = 5,
            spells = {
                {
                    id = 1300704,
                },
                {
                    id = 1300714,
                },
            },
        },
        [268344] = {
            name = "Corrupted Guardian",
            displayId = 84761,
            creatureType = "Elemental",
            level = 91,
            health = 1702709,
            count = 0,
            spells = {
                {
                    id = 1300803,
                },
                {
                    id = 1302616,
                },
                {
                    id = 1302618,
                },
                {
                    id = 1302761,
                },
                {
                    id = 1303446,
                },
            },
        },
        [268364] = {
            name = "Lifeforce",
            displayId = 169,
            creatureType = "Not specified",
            level = 90,
            health = 224234,
            count = 0,
            spells = {
                {
                    id = 1300871,
                },
                {
                    id = 1302826,
                },
                {
                    id = 1302897,
                },
                {
                    id = 1312214,
                },
            },
        },
        [268427] = {
            name = "Essence Defiler",
            displayId = 84024,
            creatureType = "Humanoid",
            level = 91,
            health = 4324340,
            count = 0,
            spells = {
                {
                    id = 1301199,
                },
            },
        },
        [268491] = {
            name = "Twisted Hexxer",
            displayId = 84676,
            creatureType = "Humanoid",
            level = 91,
            health = 2351360,
            count = 0,
            spells = {
                {
                    id = 1300684,
                },
                {
                    id = 1302153,
                },
                {
                    id = 1302158,
                    interruptible = true,
                },
                {
                    id = 1311964,
                },
                {
                    id = 1311979,
                },
            },
        },
        [268729] = {
            name = "Faithless Tormentor",
            displayId = 147085,
            creatureType = "Humanoid",
            level = 90,
            health = 486488,
            count = 0,
            spells = {
                {
                    id = 1300704,
                },
                {
                    id = 1300714,
                },
            },
        },
        [268747] = {
            name = "Lesser Lifeforce",
            displayId = 169,
            creatureType = "Not specified",
            level = 90,
            health = 10000,
            count = 0,
        },
        [269227] = {
            name = "Temple Disruptor",
            displayId = 80961,
            creatureType = "Humanoid",
            level = 90,
            health = 1945953,
            count = 5,
        },
    },
    enemies = {
        [1] = {
            npc = 134600,
            count = 7,
            clones = 9,
            pos = {
                [8] = { 711, -527, 1 },
                [13] = { 533, -422, 1 },
                [18] = { 501, -393, 1 },
                [19] = { 486, -253, 1 },
                [20] = { 682, -426, 1 },
                [21] = { 717, -387, 1 },
                [22] = { 682, -489, 1 },
                [23] = { 726, -454, 1 },
                [24] = { 737, -455, 1 },
            },
        },
        [2] = {
            npc = 134616,
            count = 5,
            clones = 7,
            pos = {
                [8] = { 700, -526, 1 },
                [9] = { 508, -452, 1 },
                [10] = { 492, -440, 1 },
                [13] = { 707, -399, 1 },
                [15] = { 679, -455, 1 },
                [16] = { 688, -459, 1 },
                [17] = { 726, -466, 1 },
            },
        },
        [3] = {
            npc = 134990,
            count = 7,
            clones = 8,
            pos = {
                [2] = { 705, -516, 1 },
                [3] = { 469, -409, 1 },
                [4] = { 477, -417, 1 },
                [5] = { 538, -433, 1 },
                [6] = { 706, -387, 1 },
                [7] = { 723, -426, 1 },
                [8] = { 675, -465, 1 },
                [9] = { 685, -469, 1 },
            },
        },
        [4] = {
            npc = 134991,
            count = 25,
            clones = 4,
            pos = {
                [3] = { 728, -416, 1 },
                [4] = { 670, -489, 1 },
                [7] = { 677, -415, 1 },
                [8] = { 733, -488, 1 },
            },
        },
        [5] = {
            npc = 134602,
            count = 7,
            clones = 7,
            pos = {
                [2] = { 731, -515, 1 },
                [3] = { 724, -507, 1 },
                [4] = { 671, -426, 1 },
                [5] = { 695, -388, 1 },
                [10] = { 735, -427, 1 },
                [11] = { 686, -508, 1 },
                [12] = { 736, -466, 1 },
            },
        },
        [6] = {
            npc = 134629,
            count = 25,
            clones = 4,
            pos = {
                [1] = { 642, -392, 1 },
                [2] = { 490, -352, 1 },
                [6] = { 495, -279, 1 },
                [7] = { 470, -279, 1 },
            },
        },
        [7] = {
            npc = 135562,
            count = 7,
            clones = 6,
            pos = {
                [1] = { 547, -428, 1 },
                [3] = { 490, -394, 1 },
                [4] = { 518, -270, 1 },
                [5] = { 482, -232, 1 },
                [6] = { 492, -231, 1 },
                [7] = { 444, -269, 1 },
            },
        },
        [8] = {
            npc = 135846,
            count = 5,
            clones = 7,
            pos = {
                [1] = { 542, -418, 1 },
                [3] = { 497, -403, 1 },
                [4] = { 509, -268, 1 },
                [5] = { 516, -260, 1 },
                [6] = { 448, -278, 1 },
                [7] = { 465, -243, 1 },
                [8] = { 491, -263, 1 },
            },
        },
        [9] = {
            npc = 139422,
            count = 7,
            clones = 1,
            pos = {
                [1] = { 497, -450, 1 },
            },
        },
        [10] = {
            npc = 134686,
            count = 16,
            clones = 1,
            pos = {
                [1] = { 505, -438, 1 },
            },
        },
        [11] = {
            npc = 134364,
            count = 7,
            clones = 2,
            pos = {
                [1] = { 483, -307, 1 },
                [6] = { 481, -263, 1 },
            },
        },
        [12] = {
            npc = 139425,
            count = 7,
            clones = 3,
            pos = {
                [1] = { 493, -307, 1 },
                [5] = { 506, -246, 1 },
                [6] = { 457, -248, 1 },
            },
        },
        [13] = {
            npc = 133384,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 415, -228, 1 },
            },
        },
        [14] = {
            npc = 136076,
            count = 25,
            clones = 3,
            pos = {
                [1] = { 554, -156, 1 },
                [2] = { 503, -157, 1 },
                [4] = { 542, -251, 1 },
            },
        },
        [15] = {
            npc = 134599,
            count = 7,
            clones = 4,
            pos = {
                [1] = { 558, -169, 1 },
                [4] = { 546, -169, 1 },
                [5] = { 515, -153, 1 },
                [6] = { 513, -165, 1 },
            },
        },
        [16] = {
            npc = 134691,
            count = 5,
            clones = 6,
            pos = {
                [1] = { 484, -145, 1 },
                [2] = { 473, -162, 1 },
                [3] = { 469, -171, 1 },
                [4] = { 479, -170, 1 },
                [5] = { 538, -155, 1 },
                [10] = { 545, -145, 1 },
            },
        },
        [17] = {
            npc = 136250,
            count = 25,
            clones = 1,
            pos = {
                [6] = { 103, -140, 1 },
            },
        },
        [18] = {
            npc = 133392,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 67, -80, 1 },
            },
        },
        [19] = {
            npc = 265057,
            count = 5,
            clones = 1,
            pos = {
                [1] = { 553, -199, 1 },
            },
        },
        [20] = {
            npc = 134388,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 431, -217, 1 },
            },
        },
        [21] = {
            npc = 134389,
            count = 0,
            clones = 2,
            pos = {
                [1] = { 403, -271, 1 },
                [2] = { 414, -271, 1 },
            },
        },
        [22] = {
            npc = 134390,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 410, -259, 1 },
            },
        },
        [23] = {
            npc = 134487,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 433, -236, 1 },
            },
        },
        [24] = {
            npc = 135007,
            count = 25,
            clones = 2,
            pos = {
                [1] = { 262, -301, 1 },
                [2] = { 174, -342, 1 },
            },
        },
        [25] = {
            npc = 135445,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 459, -149, 1 },
            },
        },
        [26] = {
            npc = 139097,
            count = 0,
            clones = 2,
            pos = {
                [1] = { 595, -413, 1 },
                [2] = { 595, -380, 1 },
            },
        },
        [27] = {
            npc = 139108,
            count = 0,
            clones = 2,
            pos = {
                [1] = { 259, -381, 1 },
                [2] = { 556, -219, 1 },
            },
        },
        [28] = {
            npc = 139131,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 457, -140, 1 },
            },
        },
        [29] = {
            npc = 240681,
            count = 0,
            clones = 2,
            pos = {
                [1] = { 247, -306, 1 },
                [2] = { 188, -335, 1 },
            },
        },
        [30] = {
            npc = 262530,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 645, -429, 1 },
            },
        },
        [31] = {
            npc = 262822,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 645, -456, 1 },
            },
        },
        [32] = {
            npc = 263181,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 429, -244, 1 },
            },
        },
        [33] = {
            npc = 263658,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 438, -149, 1 },
            },
        },
        [34] = {
            npc = 264785,
            count = 0,
            clones = 4,
            pos = {
                [1] = { 641, -401, 1 },
                [2] = { 500, -353, 1 },
                [3] = { 505, -286, 1 },
                [4] = { 464, -287, 1 },
            },
        },
        [35] = {
            npc = 268317,
            count = 5,
            clones = 4,
            pos = {
                [1] = { 84, -134, 1 },
                [2] = { 76, -119, 1 },
                [3] = { 99, -112, 1 },
                [4] = { 105, -124, 1 },
            },
        },
        [36] = {
            npc = 268344,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 143, -101, 1 },
            },
        },
        [37] = {
            npc = 268364,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 85, -71, 1 },
            },
        },
        [38] = {
            npc = 268427,
            count = 0,
            clones = 2,
            pos = {
                [1] = { 133, -95, 1 },
                [2] = { 154, -96, 1 },
            },
        },
        [39] = {
            npc = 268491,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 143, -92, 1 },
            },
        },
        [40] = {
            npc = 268729,
            count = 0,
            clones = 4,
            pos = {
                [1] = { 150, -74, 1 },
                [2] = { 133, -73, 1 },
                [3] = { 141, -73, 1 },
                [4] = { 158, -74, 1 },
            },
        },
        [41] = {
            npc = 139110,
            count = 5,
            clones = 1,
            pos = {
                [1] = { 242, -353, 1 },
            },
        },
        [42] = {
            npc = 135971,
            count = 0,
            clones = 8,
            pos = {
                [5] = { 136, -200, 1 },
                [6] = { 142, -195, 1 },
                [7] = { 140, -206, 1 },
                [8] = { 148, -203, 1 },
                [9] = { 116, -169, 1 },
                [10] = { 123, -164, 1 },
                [11] = { 120, -175, 1 },
                [12] = { 127, -170, 1 },
            },
        },
        [43] = {
            npc = 263383,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 435, -227, 1 },
            },
        },
        [44] = {
            npc = 268747,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 88, -81, 1 },
            },
        },
        [45] = {
            npc = 269227,
            count = 5,
            clones = 4,
            pos = {
                [1] = { 242, -295, 1 },
                [2] = { 254, -317, 1 },
                [3] = { 193, -347, 1 },
                [4] = { 181, -323, 1 },
            },
        },
    },
    maps = {
        [1] = {
            path = "Interface\\AddOns\\MythicDungeonTools\\Midnight\\Textures\\TempleOfSethraliss",
            name = "Temple of Sethraliss",
        },
    },
})

R:RegisterDungeon({
    challengeModeId = 584,
    englishName = "The Blinding Vale",
    shortName = "VALE",
    mdtDungeonIdx = 162,
    totalCount = 686,
    npcs = {
        [243028] = {
            name = "Meittik",
            displayId = 129588,
            creatureType = "Humanoid",
            level = 92,
            health = 45608271,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1234753,
                },
                {
                    id = 1234773,
                },
                {
                    id = 1234802,
                },
                {
                    id = 1253028,
                },
                {
                    id = 1276586,
                },
            },
        },
        [243029] = {
            name = "Kezkitt",
            displayId = 139027,
            creatureType = "Humanoid",
            level = 92,
            health = 45608271,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1235564,
                },
                {
                    id = 1235574,
                },
                {
                    id = 1235616,
                    interruptible = true,
                },
                {
                    id = 1235828,
                },
                {
                    id = 1253028,
                },
            },
        },
        [243030] = {
            name = "Lekshi",
            displayId = 139025,
            creatureType = "Humanoid",
            level = 92,
            health = 45608271,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1234850,
                },
                {
                    id = 1235546,
                },
                {
                    id = 1235640,
                },
                {
                    id = 1235642,
                },
                {
                    id = 1235865,
                    bleed = true,
                },
                {
                    id = 1253028,
                },
                {
                    id = 1261011,
                },
                {
                    id = 1261013,
                },
            },
        },
        [244528] = {
            name = "Lightblossom",
            displayId = 129261,
            creatureType = "Not specified",
            level = 90,
            health = 10000,
            count = 0,
            spells = {
                {
                    id = 1235752,
                },
            },
        },
        [244887] = {
            name = "Ikuzz the Light Hunter",
            displayId = 129424,
            creatureType = "Elemental",
            level = 92,
            health = 23648733,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1236709,
                },
                {
                    id = 1236731,
                },
                {
                    id = 1236746,
                },
                {
                    id = 1236747,
                },
                {
                    id = 1237073,
                },
                {
                    id = 1237093,
                },
                {
                    id = 1237166,
                },
                {
                    id = 1237267,
                    bleed = true,
                },
            },
        },
        [245336] = {
            name = "Radiant Spellsower",
            displayId = 127945,
            creatureType = "Humanoid",
            level = 90,
            health = 2918930,
            count = 7,
            spells = {
                {
                    id = 1238063,
                    interruptible = true,
                },
                {
                    id = 1238200,
                    interruptible = true,
                },
                {
                    id = 1267029,
                },
                {
                    id = 1301834,
                    interruptible = true,
                },
            },
        },
        [245339] = {
            name = "Underbrush Stalker",
            displayId = 127942,
            creatureType = "Humanoid",
            level = 90,
            health = 3243254,
            count = 6,
            spells = {
                {
                    id = 1238066,
                },
                {
                    id = 1238071,
                },
                {
                    id = 1238076,
                    bleed = true,
                },
            },
        },
        [245345] = {
            name = "Lightgorged Lasher",
            displayId = 125875,
            creatureType = "Elemental",
            level = 90,
            health = 8756789,
            count = 7,
            spells = {
                {
                    id = 1238158,
                    interruptible = true,
                },
                {
                    id = 1238173,
                },
            },
        },
        [245346] = {
            name = "Virid Grovekeeper",
            displayId = 127946,
            creatureType = "Humanoid",
            level = 91,
            health = 5189207,
            count = 20,
            spells = {
                {
                    id = 1237855,
                },
                {
                    id = 1237858,
                },
                {
                    id = 1255205,
                },
            },
        },
        [245410] = {
            name = "Lasher",
            displayId = 104473,
            creatureType = "Elemental",
            level = 90,
            health = 648651,
            count = 1,
            spells = {
                {
                    id = 1238084,
                    magic = true,
                },
            },
        },
        [245460] = {
            name = "Leafy Grovecrawler",
            displayId = 128068,
            creatureType = "Elemental",
            level = 90,
            health = 3243254,
            count = 7,
            spells = {
                {
                    id = 1238232,
                    interruptible = true,
                },
                {
                    id = 1242180,
                },
                {
                    id = 1242200,
                },
            },
        },
        [245473] = {
            name = "Thorny Saptor",
            displayId = 122805,
            creatureType = "Elemental",
            level = 90,
            health = 3243254,
            count = 5,
            spells = {
                {
                    id = 269230,
                },
                {
                    id = 269231,
                },
                {
                    id = 269232,
                },
                {
                    id = 1242180,
                },
                {
                    id = 1242200,
                },
                {
                    id = 1303039,
                },
                {
                    id = 1314883,
                },
                {
                    id = 1314884,
                },
            },
        },
        [245484] = {
            name = "Lightfeather Petalwing",
            displayId = 136758,
            creatureType = "Elemental",
            level = 90,
            health = 3891906,
            count = 7,
            spells = {
                {
                    id = 1238294,
                    interruptible = true,
                },
                {
                    id = 1242180,
                },
                {
                    id = 1242200,
                },
            },
        },
        [245513] = {
            name = "Overgrown Hydra",
            displayId = 142839,
            creatureType = "Elemental",
            level = 91,
            health = 6162185,
            count = 25,
            spells = {
                {
                    id = 1238368,
                },
                {
                    id = 1238463,
                },
                {
                    id = 1238638,
                },
                {
                    id = 1238642,
                },
            },
        },
        [245527] = {
            name = "Spineshield Beetle",
            displayId = 110392,
            creatureType = "Beast",
            level = 90,
            health = 385226,
            count = 1,
            spells = {
                {
                    id = 1238581,
                    magic = true,
                },
                {
                    id = 1238588,
                },
                {
                    id = 1242180,
                },
                {
                    id = 1242200,
                },
            },
        },
        [245912] = {
            name = "Lightwarden Ruia",
            displayId = 129856,
            creatureType = "Humanoid",
            level = 92,
            health = 21283860,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1239821,
                    interruptible = true,
                },
                {
                    id = 1239824,
                },
                {
                    id = 1239825,
                },
                {
                    id = 1239882,
                },
                {
                    id = 1239883,
                },
                {
                    id = 1239885,
                },
                {
                    id = 1239919,
                },
                {
                    id = 1240100,
                },
            },
        },
        [246367] = {
            name = "Spirit Bear",
            displayId = 129858,
            creatureType = "Beast",
            level = 90,
            health = 540543,
            count = 0,
            spells = {
                {
                    id = 1240210,
                },
                {
                    id = 1240257,
                },
                {
                    id = 1241058,
                    bleed = true,
                },
                {
                    id = 1257094,
                },
            },
        },
        [246371] = {
            name = "Spirit Moonkin",
            displayId = 137347,
            creatureType = "Beast",
            level = 90,
            health = 540543,
            count = 0,
            spells = {
                {
                    id = 1239824,
                },
                {
                    id = 1239825,
                },
                {
                    id = 1240100,
                },
                {
                    id = 1240152,
                },
            },
        },
        [246871] = {
            name = "Luminous Thornmaw",
            displayId = 126929,
            creatureType = "Elemental",
            level = 91,
            health = 5675695,
            count = 22,
            spells = {
                {
                    id = 1242135,
                },
                {
                    id = 1242138,
                },
                {
                    id = 1242180,
                },
                {
                    id = 1242200,
                },
            },
        },
        [247676] = {
            name = "Ziekket",
            displayId = 136619,
            creatureType = "Elemental",
            level = 92,
            health = 23648733,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1246372,
                },
                {
                    id = 1246527,
                },
                {
                    id = 1246607,
                },
                {
                    id = 1246751,
                },
                {
                    id = 1246753,
                },
                {
                    id = 1246858,
                },
                {
                    id = 1247039,
                },
                {
                    id = 1247050,
                },
            },
        },
        [247755] = {
            name = "Lightspawn Lasher",
            displayId = 131589,
            creatureType = "Elemental",
            level = 90,
            health = 1081085,
            count = 0,
            spells = {
                {
                    id = 1246527,
                },
                {
                    id = 1247669,
                    interruptible = true,
                },
                {
                    id = 1253320,
                },
            },
        },
        [249756] = {
            name = "Potatoad Matriarch",
            displayId = 136026,
            creatureType = "Elemental",
            level = 91,
            health = 8756789,
            count = 60,
            spells = {
                {
                    id = 1250100,
                },
                {
                    id = 1250199,
                },
                {
                    id = 1250200,
                },
                {
                    id = 1250813,
                },
                {
                    id = 1250937,
                    poison = true,
                },
            },
        },
        [249783] = {
            name = "Potadpole Egg",
            displayId = 83115,
            creatureType = "Beast",
            level = 90,
            health = 648651,
            count = 0,
            spells = {
                {
                    id = 1250203,
                },
            },
        },
        [250202] = {
            name = "Newborn Potadpole",
            displayId = 131772,
            creatureType = "Elemental",
            level = 90,
            health = 648651,
            count = 0,
            spells = {
                {
                    id = 1250829,
                },
                {
                    id = 1250831,
                },
            },
        },
        [253571] = {
            name = "Bloodthorn Roots",
            displayId = 141000,
            creatureType = "Not specified",
            level = 90,
            health = 405407,
            count = 0,
            spells = {
                {
                    id = 1259365,
                    magic = true,
                },
            },
        },
        [254850] = {
            name = "Sporeblight Belcher",
            displayId = 126462,
            creatureType = "Elemental",
            level = 91,
            health = 5837858,
            count = 25,
            spells = {
                {
                    id = 1242180,
                },
                {
                    id = 1242200,
                },
                {
                    id = 1263628,
                },
                {
                    id = 1263636,
                },
                {
                    id = 1263642,
                },
                {
                    id = 1271385,
                },
            },
        },
    },
    enemies = {
        [1] = {
            npc = 245345,
            count = 7,
            clones = 28,
            pos = {
                [2] = { 338, -333, 1 },
                [3] = { 342, -326, 1 },
                [4] = { 344, -339, 1 },
                [5] = { 362, -326, 1 },
                [6] = { 364, -342, 1 },
                [7] = { 370, -333, 1 },
                [8] = { 524, -280, 1 },
                [9] = { 528, -287, 1 },
                [10] = { 450, -244, 1 },
                [11] = { 62, -275, 1 },
                [12] = { 98, -242, 1 },
                [13] = { 74, -235, 1 },
                [14] = { 343, -116, 1 },
                [15] = { 349, -83, 1 },
                [16] = { 303, -104, 1 },
                [17] = { 286, -80, 1 },
                [18] = { 140, -120, 1 },
                [19] = { 149, -129, 1 },
                [20] = { 212, -73, 1 },
                [21] = { 216, -78, 1 },
                [22] = { 56, -160, 1 },
                [23] = { 61, -165, 1 },
                [24] = { 74, -149, 1 },
                [25] = { 402, -173, 1 },
                [26] = { 391, -235, 1 },
                [27] = { 391, -245, 1 },
                [28] = { 439, -208, 1 },
                [29] = { 346, -255, 1 },
            },
        },
        [2] = {
            npc = 245410,
            count = 1,
            clones = 99,
            pos = {
                [2] = { 349, -324, 1 },
                [3] = { 355, -332, 1 },
                [4] = { 350, -341, 1 },
                [5] = { 354, -323, 1 },
                [6] = { 354, -337, 1 },
                [7] = { 355, -341, 1 },
                [8] = { 516, -280, 1 },
                [9] = { 520, -286, 1 },
                [10] = { 522, -291, 1 },
                [11] = { 536, -288, 1 },
                [12] = { 531, -278, 1 },
                [13] = { 528, -274, 1 },
                [14] = { 534, -283, 1 },
                [15] = { 450, -251, 1 },
                [16] = { 454, -248, 1 },
                [17] = { 455, -243, 1 },
                [18] = { 449, -238, 1 },
                [19] = { 444, -246, 1 },
                [27] = { 77, -277, 1 },
                [28] = { 70, -272, 1 },
                [29] = { 65, -268, 1 },
                [30] = { 102, -235, 1 },
                [31] = { 96, -235, 1 },
                [32] = { 92, -240, 1 },
                [33] = { 95, -246, 1 },
                [34] = { 100, -249, 1 },
                [35] = { 348, -112, 1 },
                [36] = { 348, -118, 1 },
                [37] = { 354, -78, 1 },
                [38] = { 348, -76, 1 },
                [39] = { 343, -79, 1 },
                [40] = { 342, -84, 1 },
                [41] = { 311, -105, 1 },
                [42] = { 308, -99, 1 },
                [43] = { 315, -112, 1 },
                [44] = { 278, -85, 1 },
                [45] = { 277, -79, 1 },
                [46] = { 278, -73, 1 },
                [47] = { 286, -72, 1 },
                [48] = { 293, -74, 1 },
                [49] = { 294, -81, 1 },
                [50] = { 131, -125, 1 },
                [51] = { 145, -139, 1 },
                [52] = { 244, -109, 1 },
                [53] = { 246, -115, 1 },
                [54] = { 250, -119, 1 },
                [55] = { 255, -118, 1 },
                [56] = { 260, -116, 1 },
                [57] = { 214, -152, 1 },
                [58] = { 221, -154, 1 },
                [59] = { 219, -149, 1 },
                [60] = { 217, -157, 1 },
                [61] = { 227, -152, 1 },
                [62] = { 224, -147, 1 },
                [63] = { 205, -80, 1 },
                [64] = { 200, -78, 1 },
                [65] = { 198, -72, 1 },
                [66] = { 202, -68, 1 },
                [67] = { 207, -67, 1 },
                [68] = { 205, -86, 1 },
                [69] = { 208, -90, 1 },
                [70] = { 213, -90, 1 },
                [71] = { 217, -87, 1 },
                [72] = { 219, -83, 1 },
                [73] = { 50, -160, 1 },
                [74] = { 46, -164, 1 },
                [75] = { 44, -170, 1 },
                [76] = { 48, -175, 1 },
                [77] = { 53, -179, 1 },
                [78] = { 58, -178, 1 },
                [79] = { 61, -175, 1 },
                [80] = { 64, -171, 1 },
                [81] = { 67, -167, 1 },
                [82] = { 78, -153, 1 },
                [83] = { 82, -149, 1 },
                [84] = { 77, -144, 1 },
                [85] = { 92, -183, 1 },
                [86] = { 98, -185, 1 },
                [87] = { 103, -186, 1 },
                [88] = { 92, -190, 1 },
                [89] = { 99, -191, 1 },
                [90] = { 409, -227, 1 },
                [91] = { 415, -231, 1 },
                [92] = { 416, -225, 1 },
                [93] = { 422, -230, 1 },
                [94] = { 423, -223, 1 },
                [104] = { 394, -240, 1 },
                [105] = { 398, -244, 1 },
                [106] = { 399, -239, 1 },
                [107] = { 446, -203, 1 },
                [108] = { 452, -204, 1 },
                [109] = { 453, -209, 1 },
                [110] = { 453, -214, 1 },
                [111] = { 447, -217, 1 },
                [112] = { 436, -215, 1 },
                [113] = { 433, -209, 1 },
                [114] = { 345, -247, 1 },
                [115] = { 340, -251, 1 },
                [116] = { 349, -247, 1 },
            },
        },
        [3] = {
            npc = 245339,
            count = 6,
            clones = 16,
            pos = {
                [1] = { 402, -246, 1 },
                [2] = { 378, -312, 1 },
                [3] = { 72, -223, 1 },
                [4] = { 64, -230, 1 },
                [5] = { 264, -110, 1 },
                [6] = { 256, -102, 1 },
                [7] = { 206, -74, 1 },
                [8] = { 56, -171, 1 },
                [9] = { 85, -162, 1 },
                [10] = { 90, -167, 1 },
                [11] = { 393, -185, 1 },
                [12] = { 414, -182, 1 },
                [13] = { 476, -223, 1 },
                [14] = { 479, -237, 1 },
                [15] = { 314, -261, 1 },
                [16] = { 327, -261, 1 },
            },
        },
        [4] = {
            npc = 245346,
            count = 20,
            clones = 5,
            pos = {
                [2] = { 81, -200, 1 },
                [3] = { 347, -93, 1 },
                [5] = { 422, -262, 1 },
                [6] = { 438, -230, 1 },
                [7] = { 330, -280, 1 },
            },
        },
        [5] = {
            npc = 254850,
            count = 25,
            clones = 10,
            pos = {
                [2] = { 310, -341, 1 },
                [3] = { 435, -297, 1 },
                [4] = { 160, -443, 1 },
                [5] = { 146, -520, 1 },
                [6] = { 356, -423, 1 },
                [7] = { 189, -102, 1 },
                [8] = { 235, -172, 1 },
                [9] = { 107, -145, 1 },
                [10] = { 403, -183, 1 },
                [11] = { 756, -214, 1 },
            },
        },
        [6] = {
            npc = 245336,
            count = 7,
            clones = 14,
            pos = {
                [1] = { 401, -233, 1 },
                [2] = { 348, -332, 1 },
                [3] = { 363, -333, 1 },
                [4] = { 71, -281, 1 },
                [5] = { 306, -111, 1 },
                [6] = { 150, -167, 1 },
                [7] = { 137, -133, 1 },
                [8] = { 268, -129, 1 },
                [9] = { 253, -110, 1 },
                [10] = { 211, -84, 1 },
                [11] = { 50, -168, 1 },
                [13] = { 315, -277, 1 },
                [14] = { 319, -293, 1 },
                [15] = { 193, -110, 1 },
            },
        },
        [7] = {
            npc = 245484,
            count = 7,
            clones = 16,
            pos = {
                [2] = { 481, -293, 1 },
                [3] = { 482, -303, 1 },
                [4] = { 488, -297, 1 },
                [5] = { 479, -262, 1 },
                [6] = { 459, -270, 1 },
                [7] = { 444, -264, 1 },
                [8] = { 91, -357, 1 },
                [9] = { 142, -425, 1 },
                [10] = { 114, -458, 1 },
                [11] = { 142, -506, 1 },
                [12] = { 134, -512, 1 },
                [13] = { 254, -507, 1 },
                [14] = { 246, -482, 1 },
                [15] = { 344, -428, 1 },
                [16] = { 412, -262, 1 },
                [17] = { 660, -247, 1 },
            },
        },
        [8] = {
            npc = 245473,
            count = 5,
            clones = 13,
            pos = {
                [1] = { 132, -415, 1 },
                [2] = { 67, -326, 1 },
                [3] = { 73, -316, 1 },
                [4] = { 112, -438, 1 },
                [5] = { 235, -463, 1 },
                [6] = { 227, -471, 1 },
                [7] = { 248, -516, 1 },
                [8] = { 344, -419, 1 },
                [9] = { 433, -262, 1 },
                [10] = { 651, -240, 1 },
                [11] = { 764, -273, 1 },
                [12] = { 772, -237, 1 },
                [13] = { 801, -208, 1 },
            },
        },
        [9] = {
            npc = 245527,
            count = 1,
            clones = 39,
            pos = {
                [1] = { 116, -330, 1 },
                [2] = { 109, -329, 1 },
                [3] = { 112, -335, 1 },
                [4] = { 107, -410, 1 },
                [5] = { 102, -414, 1 },
                [6] = { 109, -416, 1 },
                [7] = { 122, -462, 1 },
                [8] = { 116, -466, 1 },
                [9] = { 109, -465, 1 },
                [10] = { 173, -467, 1 },
                [11] = { 168, -474, 1 },
                [12] = { 248, -501, 1 },
                [13] = { 238, -518, 1 },
                [14] = { 242, -523, 1 },
                [15] = { 248, -525, 1 },
                [16] = { 253, -522, 1 },
                [17] = { 258, -516, 1 },
                [18] = { 618, -229, 1 },
                [19] = { 625, -228, 1 },
                [20] = { 632, -227, 1 },
                [21] = { 621, -223, 1 },
                [22] = { 628, -221, 1 },
                [23] = { 290, -415, 1 },
                [24] = { 297, -415, 1 },
                [25] = { 290, -423, 1 },
                [26] = { 297, -423, 1 },
                [27] = { 351, -432, 1 },
                [28] = { 356, -433, 1 },
                [29] = { 362, -431, 1 },
                [30] = { 803, -269, 1 },
                [31] = { 797, -264, 1 },
                [32] = { 803, -260, 1 },
                [33] = { 796, -255, 1 },
                [34] = { 773, -202, 1 },
                [35] = { 772, -196, 1 },
                [36] = { 777, -191, 1 },
                [37] = { 780, -204, 1 },
                [38] = { 778, -198, 1 },
                [39] = { 802, -251, 1 },
            },
        },
        [10] = {
            npc = 245460,
            count = 7,
            clones = 10,
            pos = {
                [2] = { 76, -333, 1 },
                [3] = { 83, -323, 1 },
                [4] = { 151, -463, 1 },
                [5] = { 223, -460, 1 },
                [6] = { 241, -507, 1 },
                [7] = { 260, -456, 1 },
                [8] = { 264, -476, 1 },
                [9] = { 660, -235, 1 },
                [10] = { 790, -260, 1 },
                [11] = { 747, -237, 1 },
            },
        },
        [11] = {
            npc = 245513,
            count = 25,
            clones = 7,
            pos = {
                [2] = { 274, -229, 1 },
                [3] = { 394, -324, 1 },
                [5] = { 108, -394, 1 },
                [6] = { 198, -468, 1 },
                [7] = { 280, -465, 1 },
                [8] = { 393, -264, 1 },
                [9] = { 366, -254, 1 },
            },
        },
        [12] = {
            npc = 246871,
            count = 22,
            clones = 4,
            pos = {
                [2] = { 370, -291, 1 },
                [3] = { 623, -246, 1 },
                [4] = { 692, -241, 1 },
                [5] = { 753, -256, 1 },
            },
        },
        [13] = {
            npc = 243028,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 403, -97, 1 },
            },
        },
        [14] = {
            npc = 243029,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 411, -80, 1 },
            },
        },
        [15] = {
            npc = 243030,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 390, -77, 1 },
            },
        },
        [16] = {
            npc = 245912,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 820, -237, 1 },
            },
        },
        [17] = {
            npc = 247676,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 224, -285, 1 },
            },
        },
        [18] = {
            npc = 244887,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 406, -356, 1 },
            },
        },
        [19] = {
            npc = 244528,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 429, -97, 1 },
            },
        },
        [20] = {
            npc = 246367,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 830, -246, 1 },
            },
        },
        [21] = {
            npc = 246371,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 831, -228, 1 },
            },
        },
        [22] = {
            npc = 247755,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 245, -290, 1 },
            },
        },
        [23] = {
            npc = 249756,
            count = 60,
            clones = 1,
            pos = {
                [1] = { 544, -237, 1 },
            },
        },
        [24] = {
            npc = 249783,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 85, -78, 1 },
            },
        },
        [25] = {
            npc = 250202,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 85, -92, 1 },
            },
        },
        [26] = {
            npc = 253571,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 243, -276, 1 },
            },
        },
    },
    maps = {
        [1] = {
            path = "Interface\\AddOns\\MythicDungeonTools\\Midnight\\Textures\\TheBlindingVale",
            name = "The Blinding Vale",
        },
    },
})

R:RegisterDungeon({
    challengeModeId = 585,
    englishName = "Voidscar Arena",
    shortName = "VOID",
    mdtDungeonIdx = 163,
    totalCount = 738,
    npcs = {
        [238883] = {
            name = "Dominated Brawler",
            displayId = 130200,
            creatureType = "Humanoid",
            level = 90,
            health = 3891906,
            count = 7,
            spells = {
                {
                    id = 1254826,
                    enrage = true,
                },
                {
                    id = 1298899,
                    interruptible = true,
                },
            },
        },
        [238887] = {
            name = "Taz'Rah",
            displayId = 140300,
            creatureType = "Humanoid",
            level = 92,
            health = 21283860,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1296889,
                },
                {
                    id = 1296963,
                },
                {
                    id = 1296967,
                },
                {
                    id = 1297017,
                },
                {
                    id = 1300259,
                },
                {
                    id = 1300262,
                },
            },
        },
        [239008] = {
            name = "Atroxus",
            displayId = 131553,
            creatureType = "Beast",
            level = 92,
            health = 21283860,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1222484,
                },
                {
                    id = 1222519,
                },
                {
                    id = 1222642,
                },
                {
                    id = 1222721,
                },
                {
                    id = 1222724,
                },
                {
                    id = 1226031,
                    poison = true,
                },
                {
                    id = 1226120,
                },
                {
                    id = 1247395,
                },
            },
        },
        [239070] = {
            name = "Toxic Creeper",
            displayId = 140374,
            creatureType = "Beast",
            level = 91,
            health = 945949,
            count = 0,
            spells = {
                {
                    id = 1222692,
                },
                {
                    id = 1222693,
                },
                {
                    id = 1282892,
                },
            },
        },
        [239167] = {
            name = "Charonus",
            displayId = 138269,
            creatureType = "Aberration",
            level = 92,
            health = 24324411,
            count = 0,
            isBoss = true,
            spells = {
                {
                    id = 1222755,
                },
                {
                    id = 1227197,
                },
                {
                    id = 1227247,
                },
                {
                    id = 1248112,
                },
                {
                    id = 1248121,
                },
                {
                    id = 1300372,
                },
                {
                    id = 1310025,
                },
                {
                    id = 1311923,
                },
            },
        },
        [241496] = {
            name = "Enthralled Shaman",
            displayId = 130201,
            creatureType = "Humanoid",
            level = 90,
            health = 6227050,
            count = 7,
            spells = {
                {
                    id = 1228176,
                    interruptible = true,
                },
                {
                    id = 1246820,
                },
            },
        },
        [243736] = {
            name = "Blistercreep",
            displayId = 141204,
            creatureType = "Beast",
            level = 90,
            health = 648651,
            count = 1,
            spells = {
                {
                    id = 1233264,
                },
            },
        },
        [243766] = {
            name = "Kilivore Screamer",
            displayId = 141196,
            creatureType = "Beast",
            level = 90,
            health = 3081092,
            count = 7,
            spells = {
                {
                    id = 1233398,
                    interruptible = true,
                },
            },
        },
        [243835] = {
            name = "Savage Shredclaw",
            displayId = 141810,
            creatureType = "Beast",
            level = 90,
            health = 3405418,
            count = 5,
            spells = {
                {
                    id = 1233535,
                },
            },
        },
        [243983] = {
            name = "Sycophantic Tarasek",
            displayId = 140037,
            creatureType = "Dragonkin",
            level = 90,
            health = 2918930,
            count = 4,
            spells = {
                {
                    id = 1249661,
                    enrage = true,
                },
                {
                    id = 1250043,
                    magic = true,
                },
            },
        },
        [243985] = {
            name = "Longtooth Tuskarr",
            displayId = 140036,
            creatureType = "Humanoid",
            level = 90,
            health = 3243255,
            count = 5,
            spells = {
                {
                    id = 1249661,
                    enrage = true,
                },
                {
                    id = 1310319,
                    enrage = true,
                },
            },
        },
        [243988] = {
            name = "Feral Saberon",
            displayId = 140041,
            creatureType = "Humanoid",
            level = 90,
            health = 3405418,
            count = 4,
            spells = {
                {
                    id = 1249661,
                    enrage = true,
                },
                {
                    id = 1267754,
                },
                {
                    id = 1267894,
                },
            },
        },
        [243996] = {
            name = "Lost Sethrak",
            displayId = 140045,
            creatureType = "Humanoid",
            level = 90,
            health = 2918930,
            count = 4,
            spells = {
                {
                    id = 1250640,
                },
                {
                    id = 1268707,
                },
            },
        },
        [244260] = {
            name = "Chitigoth",
            displayId = 140256,
            creatureType = "Beast",
            level = 91,
            health = 5837859,
            count = 25,
            spells = {
                {
                    id = 1234833,
                },
                {
                    id = 1234855,
                },
                {
                    id = 1249661,
                    enrage = true,
                },
                {
                    id = 1250079,
                },
                {
                    id = 1250695,
                },
            },
        },
        [244309] = {
            name = "Brutok",
            displayId = 140264,
            creatureType = "Humanoid",
            level = 91,
            health = 7135161,
            count = 25,
            spells = {
                {
                    id = 1234890,
                },
                {
                    id = 1234917,
                },
                {
                    id = 1245186,
                },
                {
                    id = 1249661,
                    enrage = true,
                },
                {
                    id = 1269284,
                },
                {
                    id = 1310321,
                },
            },
        },
        [244708] = {
            name = "Voidminder",
            displayId = 147460,
            creatureType = "Aberration",
            level = 90,
            health = 6227050,
            count = 7,
            spells = {
                {
                    id = 1227020,
                },
                {
                    id = 1310324,
                    interruptible = true,
                },
            },
        },
        [245950] = {
            name = "Watchful Harrower",
            displayId = 141286,
            creatureType = "Beast",
            level = 91,
            health = 8756789,
            count = 65,
            spells = {
                {
                    id = 1239855,
                    magic = true,
                },
                {
                    id = 1239856,
                },
                {
                    id = 1300116,
                },
                {
                    id = 1300138,
                },
                {
                    id = 1300156,
                },
            },
        },
        [248666] = {
            name = "Magma Totem",
            displayId = 30762,
            creatureType = "Not specified",
            level = 90,
            health = 441313,
            count = 0,
            spells = {
                {
                    id = 1246821,
                },
                {
                    id = 1246825,
                },
            },
        },
        [249461] = {
            name = "Abducted Drakonid",
            displayId = 140299,
            creatureType = "Dragonkin",
            level = 90,
            health = 3243255,
            count = 5,
            spells = {
                {
                    id = 1249236,
                },
                {
                    id = 1249238,
                    magic = true,
                },
                {
                    id = 1249661,
                    enrage = true,
                },
            },
        },
        [249590] = {
            name = "Angry Krolusk",
            displayId = 141195,
            creatureType = "Beast",
            level = 90,
            health = 3567581,
            count = 8,
            spells = {
                {
                    id = 1249621,
                    interruptible = true,
                },
            },
        },
        [249603] = {
            name = "Protective Turtle",
            displayId = 140295,
            creatureType = "Beast",
            level = 90,
            health = 1945953,
            count = 5,
            spells = {
                {
                    id = 1249661,
                    enrage = true,
                },
                {
                    id = 1250021,
                },
                {
                    id = 1250023,
                },
                {
                    id = 1310320,
                },
            },
        },
        [249608] = {
            name = "Raging Raptor",
            displayId = 141194,
            creatureType = "Beast",
            level = 90,
            health = 3891906,
            count = 5,
            spells = {
                {
                    id = 1249661,
                    enrage = true,
                },
            },
        },
        [252053] = {
            name = "Brutal Overseer",
            displayId = 137329,
            creatureType = "Humanoid",
            level = 91,
            health = 5675696,
            count = 25,
            spells = {
                {
                    id = 1228126,
                },
                {
                    id = 1228127,
                },
                {
                    id = 1261645,
                },
                {
                    id = 1298900,
                },
                {
                    id = 1298901,
                },
                {
                    id = 1310309,
                },
            },
        },
        [252072] = {
            name = "Voidtouched Magi",
            displayId = 137330,
            creatureType = "Humanoid",
            level = 91,
            health = 5513534,
            count = 25,
            spells = {
                {
                    id = 1299913,
                },
                {
                    id = 1299938,
                    interruptible = true,
                },
            },
        },
        [252508] = {
            name = "Scavenging Siphoid",
            displayId = 141207,
            creatureType = "Aberration",
            level = 90,
            health = 1297302,
            count = 1,
            spells = {
                {
                    id = 1269866,
                },
                {
                    id = 1269878,
                },
            },
        },
        [254677] = {
            name = "Ethereal Shade",
            displayId = 147404,
            creatureType = "Humanoid",
            level = 92,
            health = 675678,
            count = 0,
            spells = {
                {
                    id = 1222100,
                },
                {
                    id = 1222103,
                },
                {
                    id = 1222105,
                },
                {
                    id = 1296963,
                },
            },
        },
        [255000] = {
            name = "Targeting Stalker",
            displayId = 169,
            creatureType = "Not specified",
            level = 90,
            health = 10000,
            count = 0,
            spells = {
                {
                    id = 1263984,
                },
                {
                    id = 1264188,
                },
            },
        },
        [255001] = {
            name = "Gravitic Orb",
            displayId = 169,
            creatureType = "Not specified",
            level = 334,
            health = 540543,
            count = 0,
            spells = {
                {
                    id = 1263983,
                },
            },
        },
        [263228] = {
            name = "Agitated Voidscythe",
            displayId = 138723,
            creatureType = "Beast",
            level = 91,
            health = 5189208,
            count = 25,
            spells = {
                {
                    id = 1233472,
                },
                {
                    id = 1233485,
                },
                {
                    id = 1289258,
                    poison = true,
                },
                {
                    id = 1289265,
                },
                {
                    id = 1311778,
                },
            },
        },
        [267545] = {
            name = "Aegyra the Unyielding",
            displayId = 147378,
            creatureType = "Humanoid",
            level = 91,
            health = 8432463,
            count = 40,
            spells = {
                {
                    id = 1298903,
                },
                {
                    id = 1298908,
                },
                {
                    id = 1298922,
                },
                {
                    id = 1298924,
                },
                {
                    id = 1298933,
                },
                {
                    id = 1299125,
                },
                {
                    id = 1299133,
                },
                {
                    id = 1299145,
                },
            },
        },
        [267546] = {
            name = "Raj'kess the Spellstorm",
            displayId = 147363,
            creatureType = "Humanoid",
            level = 91,
            health = 7459487,
            count = 40,
            spells = {
                {
                    id = 1298902,
                },
                {
                    id = 1299240,
                },
                {
                    id = 1299244,
                },
                {
                    id = 1299257,
                },
                {
                    id = 1299270,
                },
                {
                    id = 1299273,
                },
                {
                    id = 1311712,
                },
                {
                    id = 1311747,
                },
            },
        },
        [268184] = {
            name = "Devouring Brutalizer",
            displayId = 147459,
            creatureType = "Humanoid",
            level = 91,
            health = 6227050,
            count = 30,
            spells = {
                {
                    id = 1252406,
                },
                {
                    id = 1282959,
                },
                {
                    id = 1300243,
                },
                {
                    id = 1300244,
                },
                {
                    id = 1300248,
                },
                {
                    id = 1300249,
                },
                {
                    id = 1300250,
                },
                {
                    id = 1310324,
                    interruptible = true,
                },
            },
        },
    },
    enemies = {
        [1] = {
            npc = 243996,
            count = 4,
            clones = 14,
            pos = {
                [1] = { 185, -163, 1 },
                [2] = { 186, -201, 1 },
                [3] = { 219, -199, 1 },
                [4] = { 149, -206, 1 },
                [5] = { 141, -198, 1 },
                [6] = { 598, -329, 1 },
                [7] = { 714, -405, 1 },
                [8] = { 674, -400, 1 },
                [9] = { 615, -355, 1 },
                [10] = { 627, -355, 1 },
                [11] = { 246, -460, 1 },
                [12] = { 173, -508, 1 },
                [13] = { 139, -478, 1 },
                [14] = { 154, -454, 1 },
            },
        },
        [2] = {
            npc = 243988,
            count = 4,
            clones = 13,
            pos = {
                [1] = { 201, -175, 1 },
                [2] = { 225, -180, 1 },
                [3] = { 171, -182, 1 },
                [4] = { 240, -139, 1 },
                [5] = { 251, -145, 1 },
                [6] = { 703, -405, 1 },
                [7] = { 681, -327, 1 },
                [8] = { 691, -326, 1 },
                [9] = { 632, -306, 1 },
                [10] = { 646, -305, 1 },
                [11] = { 227, -506, 1 },
                [12] = { 184, -492, 1 },
                [13] = { 166, -458, 1 },
            },
        },
        [3] = {
            npc = 243983,
            count = 4,
            clones = 8,
            pos = {
                [1] = { 195, -157, 1 },
                [2] = { 194, -208, 1 },
                [3] = { 213, -209, 1 },
                [4] = { 263, -195, 1 },
                [5] = { 255, -203, 1 },
                [6] = { 673, -388, 1 },
                [7] = { 656, -344, 1 },
                [8] = { 668, -343, 1 },
            },
        },
        [4] = {
            npc = 243985,
            count = 5,
            clones = 7,
            pos = {
                [1] = { 202, -185, 1 },
                [2] = { 235, -180, 1 },
                [3] = { 181, -182, 1 },
                [4] = { 162, -137, 1 },
                [5] = { 152, -144, 1 },
                [6] = { 214, -493, 1 },
                [7] = { 257, -477, 1 },
            },
        },
        [5] = {
            npc = 238883,
            count = 7,
            clones = 7,
            pos = {
                [4] = { 742, -396, 1 },
                [8] = { 87, -189, 1 },
                [11] = { 698, -353, 1 },
                [13] = { 235, -479, 1 },
                [14] = { 156, -466, 1 },
                [15] = { 119, -439, 1 },
                [16] = { 108, -457, 1 },
            },
        },
        [6] = {
            npc = 241496,
            count = 7,
            clones = 10,
            pos = {
                [2] = { 281, -440, 1 },
                [3] = { 290, -452, 1 },
                [4] = { 200, -288, 1 },
                [6] = { 120, -189, 1 },
                [9] = { 570, -412, 1 },
                [10] = { 570, -400, 1 },
                [11] = { 553, -387, 1 },
                [12] = { 704, -359, 1 },
                [13] = { 165, -483, 1 },
                [14] = { 614, -381, 1 },
            },
        },
        [7] = {
            npc = 252072,
            count = 25,
            clones = 3,
            pos = {
                [1] = { 311, -427, 1 },
                [4] = { 534, -294, 1 },
                [5] = { 763, -324, 1 },
            },
        },
        [8] = {
            npc = 252053,
            count = 25,
            clones = 8,
            pos = {
                [1] = { 89, -427, 1 },
                [3] = { 104, -189, 1 },
                [4] = { 238, -110, 1 },
                [5] = { 507, -331, 1 },
                [6] = { 582, -322, 1 },
                [7] = { 803, -310, 1 },
                [8] = { 786, -310, 1 },
                [9] = { 729, -291, 1 },
            },
        },
        [9] = {
            npc = 267545,
            count = 40,
            clones = 1,
            pos = {
                [1] = { 130, -345, 1 },
            },
        },
        [10] = {
            npc = 267546,
            count = 40,
            clones = 1,
            pos = {
                [1] = { 269, -346, 1 },
            },
        },
        [11] = {
            npc = 244260,
            count = 25,
            clones = 1,
            pos = {
                [1] = { 201, -132, 1 },
            },
        },
        [12] = {
            npc = 249608,
            count = 5,
            clones = 1,
            pos = {
                [1] = { 241, -149, 1 },
            },
        },
        [13] = {
            npc = 249603,
            count = 5,
            clones = 1,
            pos = {
                [1] = { 164, -149, 1 },
            },
        },
        [14] = {
            npc = 244309,
            count = 25,
            clones = 1,
            pos = {
                [1] = { 202, -112, 1 },
            },
        },
        [15] = {
            npc = 249461,
            count = 5,
            clones = 1,
            pos = {
                [1] = { 252, -192, 1 },
            },
        },
        [16] = {
            npc = 249590,
            count = 8,
            clones = 1,
            pos = {
                [1] = { 152, -195, 1 },
            },
        },
        [17] = {
            npc = 243835,
            count = 5,
            clones = 19,
            pos = {
                [1] = { 194, -300, 1 },
                [2] = { 261, -227, 1 },
                [3] = { 271, -236, 1 },
                [4] = { 281, -89, 1 },
                [5] = { 292, -85, 1 },
                [6] = { 583, -400, 1 },
                [7] = { 583, -413, 1 },
                [8] = { 547, -376, 1 },
                [9] = { 549, -282, 1 },
                [10] = { 551, -293, 1 },
                [11] = { 547, -305, 1 },
                [12] = { 748, -406, 1 },
                [13] = { 736, -405, 1 },
                [14] = { 709, -353, 1 },
                [15] = { 662, -387, 1 },
                [16] = { 657, -356, 1 },
                [17] = { 669, -356, 1 },
                [18] = { 607, -392, 1 },
                [19] = { 620, -392, 1 },
            },
        },
        [18] = {
            npc = 243766,
            count = 7,
            clones = 15,
            pos = {
                [1] = { 208, -299, 1 },
                [2] = { 313, -221, 1 },
                [3] = { 318, -208, 1 },
                [4] = { 304, -117, 1 },
                [5] = { 310, -105, 1 },
                [6] = { 541, -387, 1 },
                [7] = { 598, -316, 1 },
                [8] = { 709, -394, 1 },
                [9] = { 762, -342, 1 },
                [10] = { 718, -305, 1 },
                [11] = { 731, -306, 1 },
                [12] = { 742, -299, 1 },
                [13] = { 704, -347, 1 },
                [14] = { 662, -400, 1 },
                [15] = { 621, -344, 1 },
            },
        },
        [19] = {
            npc = 263228,
            count = 25,
            clones = 7,
            pos = {
                [1] = { 239, -248, 1 },
                [2] = { 281, -175, 1 },
                [4] = { 258, -109, 1 },
                [5] = { 299, -175, 1 },
                [6] = { 526, -332, 1 },
                [7] = { 796, -292, 1 },
                [9] = { 687, -315, 1 },
            },
        },
        [20] = {
            npc = 243736,
            count = 1,
            clones = 12,
            pos = {
                [1] = { 239, -224, 1 },
                [2] = { 234, -229, 1 },
                [3] = { 240, -230, 1 },
                [4] = { 325, -179, 1 },
                [5] = { 329, -173, 1 },
                [6] = { 332, -180, 1 },
                [7] = { 291, -138, 1 },
                [8] = { 295, -145, 1 },
                [9] = { 286, -145, 1 },
                [10] = { 289, -210, 1 },
                [11] = { 293, -217, 1 },
                [12] = { 285, -217, 1 },
            },
        },
        [21] = {
            npc = 245950,
            count = 65,
            clones = 4,
            pos = {
                [1] = { 139, -233, 1 },
                [2] = { 588, -292, 1 },
                [3] = { 710, -265, 1 },
                [4] = { 119, -109, 1 },
            },
        },
        [22] = {
            npc = 268184,
            count = 30,
            clones = 3,
            pos = {
                [1] = { 732, -351, 1 },
                [2] = { 578, -350, 1 },
                [3] = { 640, -289, 1 },
            },
        },
        [23] = {
            npc = 252508,
            count = 1,
            clones = 60,
            pos = {
                [1] = { 561, -440, 1 },
                [2] = { 567, -440, 1 },
                [3] = { 561, -446, 1 },
                [4] = { 556, -446, 1 },
                [5] = { 567, -446, 1 },
                [6] = { 572, -446, 1 },
                [7] = { 556, -452, 1 },
                [8] = { 562, -452, 1 },
                [9] = { 567, -452, 1 },
                [10] = { 572, -451, 1 },
                [11] = { 512, -359, 1 },
                [12] = { 518, -364, 1 },
                [13] = { 523, -364, 1 },
                [14] = { 519, -375, 1 },
                [15] = { 518, -370, 1 },
                [16] = { 512, -364, 1 },
                [17] = { 512, -376, 1 },
                [18] = { 518, -359, 1 },
                [19] = { 523, -370, 1 },
                [20] = { 512, -370, 1 },
                [21] = { 554, -252, 1 },
                [22] = { 560, -252, 1 },
                [23] = { 566, -252, 1 },
                [24] = { 560, -258, 1 },
                [25] = { 566, -258, 1 },
                [26] = { 571, -252, 1 },
                [27] = { 554, -246, 1 },
                [28] = { 559, -246, 1 },
                [29] = { 565, -246, 1 },
                [30] = { 571, -246, 1 },
                [31] = { 717, -447, 1 },
                [32] = { 723, -441, 1 },
                [33] = { 729, -441, 1 },
                [34] = { 723, -447, 1 },
                [35] = { 729, -447, 1 },
                [36] = { 734, -447, 1 },
                [37] = { 734, -453, 1 },
                [38] = { 728, -453, 1 },
                [39] = { 723, -453, 1 },
                [40] = { 717, -453, 1 },
                [41] = { 763, -368, 1 },
                [42] = { 768, -361, 1 },
                [43] = { 774, -367, 1 },
                [44] = { 763, -374, 1 },
                [45] = { 768, -367, 1 },
                [46] = { 774, -373, 1 },
                [47] = { 768, -379, 1 },
                [48] = { 769, -373, 1 },
                [49] = { 774, -379, 1 },
                [50] = { 774, -361, 1 },
                [51] = { 666, -280, 1 },
                [52] = { 671, -277, 1 },
                [53] = { 676, -273, 1 },
                [54] = { 675, -281, 1 },
                [55] = { 679, -278, 1 },
                [56] = { 684, -274, 1 },
                [57] = { 683, -283, 1 },
                [58] = { 678, -286, 1 },
                [59] = { 670, -284, 1 },
                [60] = { 680, -270, 1 },
            },
        },
        [24] = {
            npc = 244708,
            count = 7,
            clones = 6,
            pos = {
                [1] = { 747, -354, 1 },
                [2] = { 740, -366, 1 },
                [3] = { 568, -363, 1 },
                [4] = { 562, -350, 1 },
                [5] = { 624, -293, 1 },
                [6] = { 655, -295, 1 },
            },
        },
        [25] = {
            npc = 238887,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 199, -244, 1 },
            },
        },
        [26] = {
            npc = 239008,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 643, -489, 1 },
            },
        },
        [27] = {
            npc = 239167,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 641, -221, 1 },
            },
        },
        [28] = {
            npc = 239070,
            count = 0,
            clones = 2,
            pos = {
                [1] = { 689, -493, 1 },
                [2] = { 593, -494, 1 },
            },
        },
        [29] = {
            npc = 248666,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 410, -69, 1 },
            },
        },
        [30] = {
            npc = 254677,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 217, -246, 1 },
            },
        },
        [31] = {
            npc = 255000,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 665, -219, 1 },
            },
        },
        [32] = {
            npc = 255001,
            count = 0,
            clones = 1,
            pos = {
                [1] = { 662, -209, 1 },
            },
        },
    },
    maps = {
        [1] = {
            path = "Interface\\AddOns\\MythicDungeonTools\\Midnight\\Textures\\VoidscarArena",
            name = "Voidscar Arena",
        },
    },
})
