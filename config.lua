Config = {}

Config.Debug = true
Config.Locale = 'en'

Config.MoneyItem = 'black_money'

Config.Delivery = {
    Method = 'target', -- target / bind
    Bind = "E", -- Button to the BIND GUI
    BindDistance = 2.5, -- How close u need to be
    Punishment = true, -- Shall you be punished if u dont have enough Drugs?
    Chance = true, -- Set to true if its 50/50, false if 100%
    PunishCost = math.random(20000, 30000), -- Amount to lose on punishment
    Type = "ped", -- ped // box
    Peds = { -- The ped model that can spawn if Type = "ped"
        [1] = 'a_f_m_skidrow_01',
        [2] = 'a_m_m_og_boss_01',
        [3] = 'a_m_o_tramp_01',
        [4] = 'g_m_m_mexboss_01',
        [5] = 'g_m_y_korean_02',
    }
}


Config.DrugsNeeded = math.random(5, 25)
Config.DrugTypes = {
    [1] = {
        name = "Kokain",
        item = "coke_pooch",
        reward = math.random(10000, 15000)
    },
    [2] = {
        name = "Heroin",
        item = "opium_pooch",
        reward = math.random(10000, 15000)
    },
    [3] = {
        name = "Meth",
        item = "meth_pooch",
        reward = math.random(10000, 15000)
    },
    [4] = {
        name = "Hash",
        item = "weed_pooch",
        reward = math.random(10000, 15000)
    }
}

Config.DrugLocations = {
    [1] = {
        loc = vector4(-1841.6027, -1198.1422, 19.1951 - 1, 110.4234),
    },
    [2] = {
        loc = vector4(-2016.0770, 551.8673, 108.4147 - 1, 72.1082),
    },
    [3] = {
        loc = vector4(-1040.7505, 513.9594, 88.5297 - 1, 318.6956),
    },
    [4] = {
        loc = vector4(-197.6831, 793.6313, 198.1087 - 1, 266.2827),
    },
    [5] = {
       loc = vector4(525.1851, -41.4367, 88.8582 - 1, 99.1682),
    },
    [6] = {
        loc = vector4(970.8868, -194.1970, 73.2084 - 1, 151.5257),
    },
    [7] = {
        loc = vector4(660.7307, 268.0732, 102.7702 - 1, 310.4121),
    },
    [8] = {
        loc = vector4(-267.5060, -753.0703, 53.2465 - 1, 103.6696),
    },
    [9] = {
        loc = vector4(-954.3610, -1330.4818, 5.6562 - 1, 152.8276),
    },
    [10] = {
        loc = vector4(1007.5941, 514.0256, 99.6426 - 1, 141.8706),
    },
    [11] = {
        loc = vector4(-886.9387, -2613.4756, 31.6050 - 1, 129.9275),
    },
    [12] = {
        loc = vector4(1542.9177, 786.3701, 77.5550 - 1, 288.4448),
    },
    [13] = {
        loc = vector4(2166.2830, 3379.8962, 46.4345 - 1, 254.9404),
    },
    [14] = {
        loc = vector4(1762.3292, 3778.2620, 33.7970 - 1, 26.7580),
    },
    [15] = {
        loc = vector4(1861.1154, 2719.8848, 45.8375 - 1, 127.5169),
    },
    [16] = {
        loc = vector4(1986.9091, 3790.7744, 32.1808 - 1, 313.9808),
    },
    [17] = {
        loc = vector4(1994.7806, 3051.9275, 47.2145 - 1, 322.4697),
    },
    [18] = {
        loc = vector4(25.5374, 6601.4717, 32.4704 - 1, 322),
    },
    [19] = {
        loc = vector4(1695.2937, 6431.0376, 32.7140 - 1, 313.1422),
    },
    [20] = {
        loc = vector4(153.6718, 6645.1636, 31.5732 - 1, 302.8117),
    },
    [21] = {
        loc = vector4(-150.0757, 6422.5508, 31.9159 - 1, 143.1389),
    },
    [22] = {
        loc = vector4(-546.9229, -1677.6464, 19.5681 - 1, 268.0704),
    },
    [23] = {
        loc = vector4(-1176.0706, -1783.3356, 3.9085 - 1, 309.1704),
    },
    [24] = {
        loc = vector4(-1178.2224, -2048.2668, 13.9454 - 1, 193.1880),
    },
    [25] = {
        loc = vector4(168.9687, -581.6237, 43.8679 - 1, 180.4195),
    },
    [26] = {
        loc = vector4(554.7072, -164.0893, 54.4867 - 1, 168.8063),
    },
    [27] = {
        loc = vector4(934.0274, 2.5397, 78.7640 - 1, 197.1853),
    },
}

Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}