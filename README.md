## Installation

1. Download the latest stabel release of our ressource.
2. Put it into your ressource folder
3. Setup the config to your liking.
4. That it!

## Configuration
The most important configuration is displayed here!

```lua
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
    -- there are 1-27
} 
```
