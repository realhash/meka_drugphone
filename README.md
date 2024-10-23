<div align="center">
   <img src="	https://cdn.discordapp.com/attachments/1294682930593005578/1298712719985217606/logo.png?ex=671a8ff9&is=67193e79&hm=f8fb5c9a7d7b123340e138a9eee10ab0779d260ca4f83335830e6048fe843c3d&" width="150px" alt="Project Logo" />
    <h1>MEKA STORE</h1>
</div>

# Meka Drugphone V1.0.0 - ESX ONLY

Meka Drugphone is a free drugphone made by the team Meka. This is 100% open source and will always be as we belive in free products. If you need any support please join our discord: https://discord.gg/hu8SwKQbfR

## Features

- **Low Resmon**
- **Easy configuration**
- **Choose between PED/BOX model**
- **Eye target or Text UI / BInd**

## Screenshots

![Screenshot 1](https://media.discordapp.net/attachments/1294682930593005578/1298714965234024458/image.png?ex=671a9210&is=67194090&hm=8bbd9c88c51c88b1407e00f150fceacc79d1645863faef555634838c2a35afde&=&format=webp&quality=lossless) 

![Screenshot 2](https://media.discordapp.net/attachments/1294682930593005578/1298715029218132008/image.png?ex=671a921f&is=6719409f&hm=bb0d1efd240a35b33a6630bb32c211cd43c26dccd9c3798bad17f214999e1deb&=&format=webp&quality=lossless)

![Screenshot 3](https://media.discordapp.net/attachments/1294682930593005578/1298715138790002688/image.png?ex=671a923a&is=671940ba&hm=a0d8afc5cce53b70e73a885f431328566487a2aa1cba2da0b369493dd1b945a2&=&format=webp&quality=lossless)

![Screenshot 4](https://cdn.discordapp.com/attachments/1294682930593005578/1298715257698652260/image.png?ex=671a9256&is=671940d6&hm=40ba297236b816b99513aaeb31145ad920c85a72d7da8c72352277f79f469c4e&)

## Installation

1. Download the latest stabel release of our ressource.
2. Import the SQL.
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
