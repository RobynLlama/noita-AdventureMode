--Touch of Soup
table.insert(actions,
    {
        id                  = "ADV_TOUCH_SOUP",
        name                = "Touch of Soup",
        description         =
        "Transmutes everything in a very small radius into delicious pea soup, including walls, creatures... and you!",
        sprite              = "mods/AdventureMode/files/Spells/img/touch_soup.png",
        sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
        related_projectiles = { "mods/AdventureMode/files/Spells/TouchOfSoup.xml" },
        type                = ACTION_TYPE_MATERIAL,
        spawn_level         = "1,2,3,4,5,6,7",
        spawn_probability   = "0,0,0.5,0.5,1,1,1",
        price               = 350,
        mana                = 200,
        max_uses            = 5,
        action              = function()
            add_projectile("mods/AdventureMode/files/Spells/TouchOfSoup.xml")
        end,
    }
)

--Summon Snack
table.insert(actions,
    {
        id                  = "ADV_SUMMON_SNACK",
        name                = "Summon Snack",
        description         = "Summons a tasty snack to fill your belly. Magic Flasks cannot be refilled.",
        sprite              = "mods/AdventureMode/files/Spells/img/summon_snack.png",
        sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
        related_projectiles = { "mods/AdventureMode/files/Spells/SummonedSnack.xml" },
        type                = ACTION_TYPE_UTILITY,
        spawn_level         = "1,2,3,4,5,6,7",
        spawn_probability   = "0,0,0.5,0.5,1,1,1",
        price               = 400,
        mana                = 100,
        max_uses            = 5,
        action              = function()
            add_projectile("mods/AdventureMode/files/Spells/SummonedSnack.xml")
        end,
    }
)

--Summon Feast
table.insert(actions,
    {
        id                  = "ADV_SUMMON_FEAST",
        name                = "Summon Sumptuous Feast",
        description         = "Summons a hearty meal to stop the rumbling in your tummy. Magic Flasks cannot be refilled.",
        sprite              = "mods/AdventureMode/files/Spells/img/summon_feast.png",
        sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
        related_projectiles = { "mods/AdventureMode/files/Spells/SummonedFeast.xml" },
        type                = ACTION_TYPE_UTILITY,
        spawn_level         = "1,2,3,4,5,6,7",
        spawn_probability   = "0,0,0.5,0.5,1,1,1",
        price               = 450,
        mana                = 150,
        max_uses            = 3,
        action              = function()
            add_projectile("mods/AdventureMode/files/Spells/SummonedFeast.xml")
        end,
    }
)
