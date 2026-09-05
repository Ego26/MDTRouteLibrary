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
        },
        [2] = {
            npc = 261552,
            count = 5,
            clones = 16,
        },
        [3] = {
            npc = 261557,
            count = 7,
            clones = 11,
        },
        [4] = {
            npc = 261556,
            count = 0,
            clones = 1,
        },
        [5] = {
            npc = 263112,
            count = 1,
            clones = 18,
        },
        [6] = {
            npc = 261560,
            count = 7,
            clones = 14,
        },
        [7] = {
            npc = 261553,
            count = 5,
            clones = 19,
        },
        [8] = {
            npc = 263109,
            count = 25,
            clones = 4,
        },
        [9] = {
            npc = 261573,
            count = 30,
            clones = 1,
        },
        [10] = {
            npc = 261554,
            count = 25,
            clones = 4,
        },
        [11] = {
            npc = 261550,
            count = 1,
            clones = 28,
        },
        [12] = {
            npc = 262011,
            count = 25,
            clones = 3,
        },
        [13] = {
            npc = 271453,
            count = 5,
            clones = 21,
        },
        [14] = {
            npc = 259445,
            count = 0,
            clones = 1,
        },
        [15] = {
            npc = 259446,
            count = 0,
            clones = 1,
        },
        [16] = {
            npc = 259447,
            count = 0,
            clones = 1,
        },
        [17] = {
            npc = 262398,
            count = 0,
            clones = 2,
        },
        [18] = {
            npc = 264798,
            count = 0,
            clones = 1,
        },
        [19] = {
            npc = 268358,
            count = 0,
            clones = 1,
        },
        [20] = {
            npc = 270378,
            count = 0,
            clones = 1,
        },
        [21] = {
            npc = 270417,
            count = 0,
            clones = 2,
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
        },
        [2] = {
            npc = 241814,
            count = 7,
            clones = 12,
        },
        [3] = {
            npc = 241813,
            count = 5,
            clones = 21,
        },
        [4] = {
            npc = 241808,
            count = 8,
            clones = 16,
        },
        [5] = {
            npc = 250478,
            count = 50,
            clones = 1,
        },
        [6] = {
            npc = 241874,
            count = 5,
            clones = 18,
        },
        [7] = {
            npc = 241911,
            count = 7,
            clones = 11,
        },
        [8] = {
            npc = 241872,
            count = 9,
            clones = 8,
        },
        [9] = {
            npc = 241876,
            count = 7,
            clones = 8,
        },
        [10] = {
            npc = 241869,
            count = 28,
            clones = 2,
        },
        [11] = {
            npc = 245143,
            count = 5,
            clones = 5,
        },
        [12] = {
            npc = 245139,
            count = 7,
            clones = 5,
        },
        [13] = {
            npc = 245146,
            count = 25,
            clones = 3,
        },
        [14] = {
            npc = 245145,
            count = 6,
            clones = 4,
        },
        [15] = {
            npc = 241809,
            count = 0,
            clones = 33,
        },
        [16] = {
            npc = 241812,
            count = 0,
            clones = 1,
        },
        [17] = {
            npc = 241816,
            count = 7,
            clones = 17,
        },
        [18] = {
            npc = 244100,
            count = 0,
            clones = 1,
        },
        [19] = {
            npc = 244696,
            count = 0,
            clones = 1,
        },
        [20] = {
            npc = 244759,
            count = 0,
            clones = 1,
        },
        [21] = {
            npc = 244889,
            count = 35,
            clones = 1,
        },
        [22] = {
            npc = 245148,
            count = 0,
            clones = 3,
        },
        [23] = {
            npc = 245190,
            count = 5,
            clones = 4,
        },
        [24] = {
            npc = 245567,
            count = 0,
            clones = 7,
        },
        [25] = {
            npc = 246404,
            count = 0,
            clones = 1,
        },
        [26] = {
            npc = 246409,
            count = 0,
            clones = 1,
        },
        [27] = {
            npc = 247301,
            count = 0,
            clones = 1,
        },
        [28] = {
            npc = 251189,
            count = 0,
            clones = 1,
        },
        [29] = {
            npc = 272074,
            count = 0,
            clones = 1,
        },
        [30] = {
            npc = 245076,
            count = 0,
            clones = 1,
        },
        [31] = {
            npc = 245752,
            count = 7,
            clones = 2,
        },
        [32] = {
            npc = 248666,
            count = 0,
            clones = 1,
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
        },
        [2] = {
            npc = 133943,
            count = 0,
            clones = 13,
        },
        [3] = {
            npc = 134174,
            count = 20,
            clones = 1,
        },
        [4] = {
            npc = 134158,
            count = 25,
            clones = 2,
        },
        [5] = {
            npc = 134157,
            count = 5,
            clones = 6,
        },
        [6] = {
            npc = 135322,
            count = 0,
            clones = 1,
        },
        [7] = {
            npc = 137487,
            count = 10,
            clones = 1,
        },
        [8] = {
            npc = 137486,
            count = 25,
            clones = 1,
        },
        [9] = {
            npc = 137484,
            count = 25,
            clones = 1,
        },
        [10] = {
            npc = 137485,
            count = 7,
            clones = 4,
        },
        [11] = {
            npc = 134251,
            count = 10,
            clones = 1,
        },
        [12] = {
            npc = 137473,
            count = 10,
            clones = 1,
        },
        [13] = {
            npc = 134331,
            count = 25,
            clones = 1,
        },
        [14] = {
            npc = 137474,
            count = 25,
            clones = 1,
        },
        [15] = {
            npc = 137478,
            count = 25,
            clones = 1,
        },
        [16] = {
            npc = 134739,
            count = 25,
            clones = 1,
        },
        [17] = {
            npc = 137969,
            count = 15,
            clones = 2,
        },
        [18] = {
            npc = 134993,
            count = 0,
            clones = 1,
        },
        [19] = {
            npc = 135204,
            count = 7,
            clones = 3,
        },
        [20] = {
            npc = 135167,
            count = 22,
            clones = 3,
        },
        [21] = {
            npc = 135239,
            count = 7,
            clones = 4,
        },
        [22] = {
            npc = 135231,
            count = 25,
            clones = 1,
        },
        [23] = {
            npc = 135192,
            count = 5,
            clones = 4,
        },
        [24] = {
            npc = 138489,
            count = 30,
            clones = 1,
        },
        [25] = {
            npc = 136160,
            count = 0,
            clones = 1,
        },
        [26] = {
            npc = 137989,
            count = 1,
            clones = 17,
        },
        [27] = {
            npc = 135761,
            count = 0,
            clones = 1,
        },
        [28] = {
            npc = 135764,
            count = 0,
            clones = 1,
        },
        [29] = {
            npc = 135765,
            count = 0,
            clones = 1,
        },
        [30] = {
            npc = 136256,
            count = 0,
            clones = 1,
        },
        [31] = {
            npc = 136976,
            count = 0,
            clones = 1,
        },
        [32] = {
            npc = 136984,
            count = 0,
            clones = 1,
        },
        [33] = {
            npc = 138493,
            count = 0,
            clones = 1,
        },
        [34] = {
            npc = 269808,
            count = 0,
            clones = 1,
        },
        [35] = {
            npc = 269810,
            count = 0,
            clones = 1,
        },
        [36] = {
            npc = 269811,
            count = 0,
            clones = 1,
        },
        [37] = {
            npc = 270502,
            count = 7,
            clones = 4,
        },
        [38] = {
            npc = 135406,
            count = 0,
            clones = 5,
        },
        [39] = {
            npc = 137591,
            count = 0,
            clones = 2,
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
        },
        [2] = {
            npc = 236073,
            count = 3,
            clones = 12,
        },
        [3] = {
            npc = 236084,
            count = 7,
            clones = 9,
        },
        [4] = {
            npc = 236071,
            count = 25,
            clones = 2,
        },
        [5] = {
            npc = 252529,
            count = 35,
            clones = 1,
        },
        [6] = {
            npc = 236082,
            count = 6,
            clones = 4,
        },
        [7] = {
            npc = 236902,
            count = 12,
            clones = 1,
        },
        [8] = {
            npc = 236091,
            count = 3,
            clones = 6,
        },
        [9] = {
            npc = 236893,
            count = 2,
            clones = 6,
        },
        [10] = {
            npc = 236897,
            count = 7,
            clones = 2,
        },
        [11] = {
            npc = 234849,
            count = 2,
            clones = 58,
        },
        [12] = {
            npc = 235261,
            count = 5,
            clones = 15,
        },
        [13] = {
            npc = 235268,
            count = 7,
            clones = 11,
        },
        [14] = {
            npc = 235267,
            count = 5,
            clones = 11,
        },
        [15] = {
            npc = 235265,
            count = 25,
            clones = 4,
        },
        [16] = {
            npc = 235257,
            count = 1,
            clones = 20,
        },
        [17] = {
            npc = 235465,
            count = 25,
            clones = 7,
        },
        [18] = {
            npc = 236905,
            count = 30,
            clones = 1,
        },
        [19] = {
            npc = 235322,
            count = 35,
            clones = 7,
        },
        [20] = {
            npc = 234647,
            count = 0,
            clones = 1,
        },
        [21] = {
            npc = 234648,
            count = 0,
            clones = 1,
        },
        [22] = {
            npc = 234649,
            count = 0,
            clones = 1,
        },
        [23] = {
            npc = 234660,
            count = 0,
            clones = 1,
        },
        [24] = {
            npc = 234763,
            count = 0,
            clones = 1,
        },
        [25] = {
            npc = 234799,
            count = 0,
            clones = 1,
        },
        [26] = {
            npc = 234852,
            count = 0,
            clones = 5,
        },
        [27] = {
            npc = 234860,
            count = 0,
            clones = 1,
        },
        [28] = {
            npc = 234984,
            count = 0,
            clones = 1,
        },
        [29] = {
            npc = 235520,
            count = 0,
            clones = 1,
        },
        [30] = {
            npc = 235841,
            count = 0,
            clones = 1,
        },
        [31] = {
            npc = 236088,
            count = 0,
            clones = 1,
        },
        [32] = {
            npc = 236525,
            count = 0,
            clones = 1,
        },
        [33] = {
            npc = 237626,
            count = 0,
            clones = 1,
        },
        [34] = {
            npc = 238414,
            count = 0,
            clones = 1,
        },
        [35] = {
            npc = 240289,
            count = 0,
            clones = 1,
        },
        [36] = {
            npc = 253081,
            count = 0,
            clones = 1,
        },
        [37] = {
            npc = 253324,
            count = 0,
            clones = 4,
        },
        [38] = {
            npc = 255050,
            count = 0,
            clones = 1,
        },
        [39] = {
            npc = 255604,
            count = 6,
            clones = 1,
        },
        [40] = {
            npc = 263940,
            count = 0,
            clones = 1,
        },
        [41] = {
            npc = 272246,
            count = 0,
            clones = 1,
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
        },
        [2] = {
            npc = 187969,
            count = 5,
            clones = 9,
        },
        [3] = {
            npc = 188011,
            count = 5,
            clones = 6,
        },
        [4] = {
            npc = 188067,
            count = 7,
            clones = 5,
        },
        [5] = {
            npc = 187894,
            count = 0,
            clones = 52,
        },
        [6] = {
            npc = 187897,
            count = 30,
            clones = 1,
        },
        [7] = {
            npc = 188252,
            count = 0,
            clones = 1,
        },
        [8] = {
            npc = 190205,
            count = 0,
            clones = 1,
        },
        [9] = {
            npc = 197698,
            count = 48,
            clones = 1,
        },
        [10] = {
            npc = 190207,
            count = 7,
            clones = 9,
        },
        [11] = {
            npc = 190034,
            count = 25,
            clones = 4,
        },
        [12] = {
            npc = 190206,
            count = 7,
            clones = 9,
        },
        [13] = {
            npc = 195119,
            count = 10,
            clones = 4,
        },
        [14] = {
            npc = 197697,
            count = 40,
            clones = 1,
        },
        [15] = {
            npc = 189232,
            count = 0,
            clones = 1,
        },
        [16] = {
            npc = 197982,
            count = 5,
            clones = 9,
        },
        [17] = {
            npc = 197509,
            count = 0,
            clones = 22,
        },
        [18] = {
            npc = 198047,
            count = 25,
            clones = 2,
        },
        [19] = {
            npc = 197535,
            count = 30,
            clones = 1,
        },
        [20] = {
            npc = 190485,
            count = 0,
            clones = 1,
        },
        [21] = {
            npc = 190484,
            count = 0,
            clones = 1,
        },
        [22] = {
            npc = 189886,
            count = 0,
            clones = 3,
        },
        [23] = {
            npc = 189893,
            count = 0,
            clones = 1,
        },
        [24] = {
            npc = 194622,
            count = 0,
            clones = 1,
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
        },
        [2] = {
            npc = 134616,
            count = 5,
            clones = 7,
        },
        [3] = {
            npc = 134990,
            count = 7,
            clones = 8,
        },
        [4] = {
            npc = 134991,
            count = 25,
            clones = 4,
        },
        [5] = {
            npc = 134602,
            count = 7,
            clones = 7,
        },
        [6] = {
            npc = 134629,
            count = 25,
            clones = 4,
        },
        [7] = {
            npc = 135562,
            count = 7,
            clones = 6,
        },
        [8] = {
            npc = 135846,
            count = 5,
            clones = 7,
        },
        [9] = {
            npc = 139422,
            count = 7,
            clones = 1,
        },
        [10] = {
            npc = 134686,
            count = 16,
            clones = 1,
        },
        [11] = {
            npc = 134364,
            count = 7,
            clones = 2,
        },
        [12] = {
            npc = 139425,
            count = 7,
            clones = 3,
        },
        [13] = {
            npc = 133384,
            count = 0,
            clones = 1,
        },
        [14] = {
            npc = 136076,
            count = 25,
            clones = 3,
        },
        [15] = {
            npc = 134599,
            count = 7,
            clones = 4,
        },
        [16] = {
            npc = 134691,
            count = 5,
            clones = 6,
        },
        [17] = {
            npc = 136250,
            count = 25,
            clones = 1,
        },
        [18] = {
            npc = 133392,
            count = 0,
            clones = 1,
        },
        [19] = {
            npc = 265057,
            count = 5,
            clones = 1,
        },
        [20] = {
            npc = 134388,
            count = 0,
            clones = 1,
        },
        [21] = {
            npc = 134389,
            count = 0,
            clones = 2,
        },
        [22] = {
            npc = 134390,
            count = 0,
            clones = 1,
        },
        [23] = {
            npc = 134487,
            count = 0,
            clones = 1,
        },
        [24] = {
            npc = 135007,
            count = 25,
            clones = 2,
        },
        [25] = {
            npc = 135445,
            count = 0,
            clones = 1,
        },
        [26] = {
            npc = 139097,
            count = 0,
            clones = 2,
        },
        [27] = {
            npc = 139108,
            count = 0,
            clones = 2,
        },
        [28] = {
            npc = 139131,
            count = 0,
            clones = 1,
        },
        [29] = {
            npc = 240681,
            count = 0,
            clones = 2,
        },
        [30] = {
            npc = 262530,
            count = 0,
            clones = 1,
        },
        [31] = {
            npc = 262822,
            count = 0,
            clones = 1,
        },
        [32] = {
            npc = 263181,
            count = 0,
            clones = 1,
        },
        [33] = {
            npc = 263658,
            count = 0,
            clones = 1,
        },
        [34] = {
            npc = 264785,
            count = 0,
            clones = 4,
        },
        [35] = {
            npc = 268317,
            count = 5,
            clones = 4,
        },
        [36] = {
            npc = 268344,
            count = 0,
            clones = 1,
        },
        [37] = {
            npc = 268364,
            count = 0,
            clones = 1,
        },
        [38] = {
            npc = 268427,
            count = 0,
            clones = 2,
        },
        [39] = {
            npc = 268491,
            count = 0,
            clones = 1,
        },
        [40] = {
            npc = 268729,
            count = 0,
            clones = 4,
        },
        [41] = {
            npc = 139110,
            count = 5,
            clones = 1,
        },
        [42] = {
            npc = 135971,
            count = 0,
            clones = 8,
        },
        [43] = {
            npc = 263383,
            count = 0,
            clones = 1,
        },
        [44] = {
            npc = 268747,
            count = 0,
            clones = 1,
        },
        [45] = {
            npc = 269227,
            count = 5,
            clones = 4,
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
        },
        [2] = {
            npc = 245410,
            count = 1,
            clones = 99,
        },
        [3] = {
            npc = 245339,
            count = 6,
            clones = 16,
        },
        [4] = {
            npc = 245346,
            count = 20,
            clones = 5,
        },
        [5] = {
            npc = 254850,
            count = 25,
            clones = 10,
        },
        [6] = {
            npc = 245336,
            count = 7,
            clones = 14,
        },
        [7] = {
            npc = 245484,
            count = 7,
            clones = 16,
        },
        [8] = {
            npc = 245473,
            count = 5,
            clones = 13,
        },
        [9] = {
            npc = 245527,
            count = 1,
            clones = 39,
        },
        [10] = {
            npc = 245460,
            count = 7,
            clones = 10,
        },
        [11] = {
            npc = 245513,
            count = 25,
            clones = 7,
        },
        [12] = {
            npc = 246871,
            count = 22,
            clones = 4,
        },
        [13] = {
            npc = 243028,
            count = 0,
            clones = 1,
        },
        [14] = {
            npc = 243029,
            count = 0,
            clones = 1,
        },
        [15] = {
            npc = 243030,
            count = 0,
            clones = 1,
        },
        [16] = {
            npc = 245912,
            count = 0,
            clones = 1,
        },
        [17] = {
            npc = 247676,
            count = 0,
            clones = 1,
        },
        [18] = {
            npc = 244887,
            count = 0,
            clones = 1,
        },
        [19] = {
            npc = 244528,
            count = 0,
            clones = 1,
        },
        [20] = {
            npc = 246367,
            count = 0,
            clones = 1,
        },
        [21] = {
            npc = 246371,
            count = 0,
            clones = 1,
        },
        [22] = {
            npc = 247755,
            count = 0,
            clones = 1,
        },
        [23] = {
            npc = 249756,
            count = 60,
            clones = 1,
        },
        [24] = {
            npc = 249783,
            count = 0,
            clones = 1,
        },
        [25] = {
            npc = 250202,
            count = 0,
            clones = 1,
        },
        [26] = {
            npc = 253571,
            count = 0,
            clones = 1,
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
        },
        [2] = {
            npc = 243988,
            count = 4,
            clones = 13,
        },
        [3] = {
            npc = 243983,
            count = 4,
            clones = 8,
        },
        [4] = {
            npc = 243985,
            count = 5,
            clones = 7,
        },
        [5] = {
            npc = 238883,
            count = 7,
            clones = 7,
        },
        [6] = {
            npc = 241496,
            count = 7,
            clones = 10,
        },
        [7] = {
            npc = 252072,
            count = 25,
            clones = 3,
        },
        [8] = {
            npc = 252053,
            count = 25,
            clones = 8,
        },
        [9] = {
            npc = 267545,
            count = 40,
            clones = 1,
        },
        [10] = {
            npc = 267546,
            count = 40,
            clones = 1,
        },
        [11] = {
            npc = 244260,
            count = 25,
            clones = 1,
        },
        [12] = {
            npc = 249608,
            count = 5,
            clones = 1,
        },
        [13] = {
            npc = 249603,
            count = 5,
            clones = 1,
        },
        [14] = {
            npc = 244309,
            count = 25,
            clones = 1,
        },
        [15] = {
            npc = 249461,
            count = 5,
            clones = 1,
        },
        [16] = {
            npc = 249590,
            count = 8,
            clones = 1,
        },
        [17] = {
            npc = 243835,
            count = 5,
            clones = 19,
        },
        [18] = {
            npc = 243766,
            count = 7,
            clones = 15,
        },
        [19] = {
            npc = 263228,
            count = 25,
            clones = 7,
        },
        [20] = {
            npc = 243736,
            count = 1,
            clones = 12,
        },
        [21] = {
            npc = 245950,
            count = 65,
            clones = 4,
        },
        [22] = {
            npc = 268184,
            count = 30,
            clones = 3,
        },
        [23] = {
            npc = 252508,
            count = 1,
            clones = 60,
        },
        [24] = {
            npc = 244708,
            count = 7,
            clones = 6,
        },
        [25] = {
            npc = 238887,
            count = 0,
            clones = 1,
        },
        [26] = {
            npc = 239008,
            count = 0,
            clones = 1,
        },
        [27] = {
            npc = 239167,
            count = 0,
            clones = 1,
        },
        [28] = {
            npc = 239070,
            count = 0,
            clones = 2,
        },
        [29] = {
            npc = 248666,
            count = 0,
            clones = 1,
        },
        [30] = {
            npc = 254677,
            count = 0,
            clones = 1,
        },
        [31] = {
            npc = 255000,
            count = 0,
            clones = 1,
        },
        [32] = {
            npc = 255001,
            count = 0,
            clones = 1,
        },
    },
})
