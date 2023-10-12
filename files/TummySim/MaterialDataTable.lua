--[[
    Material Data Table used to store healing for the advanced tummy simulation.
    Values are listed in StoredHealing / CellConsumed. A flask of liquid can store
    1000 cells of material. Other notable measures include: The player's default maximum
    ingestion size (their whole stomach) is about 7500 cells. A player will consume around
    75 - 90 cells from the world while eating
]]--

MaterialDataTable = {

    --[[
        STANDARD MATERIALS:

        Water is everywhere so the number has to be low or we can suck it up for healing
    ]]--
    water = 0.010,
    water_ice = 0.009,
    water_salt = 0.008,
    --I only know GRASS out of all of these, think they're just recolors
    grass = 0.005,
    grass_dark = 0.005,
    grass_dry = 0.005,
    --??
    sand_herb = 0.005,
    ice = 0.009,
    --Pretty sure honey only shows up in the jungle
    honey = 0.085,
    --I'm only familiar with 2 of these
    fungi = 0.035,
    fungi_green = 0.035,
    fungi_creeping = 0.035,
    fungi_creeping_secret = 0.035,


    --[[
        Meat will not become "warm" "hot" "done" or "burnt" without oil so
        it seems there is an oil that is suited both to burning and cooking in Noita
        Either way, oil is unpleasant and the player will throw it up so we're not
        likely to get much out of it
    ]]--
    oil = 0.015,

    --[[
        MEAT:

        Meat is a tough one to decide because it should obviously be better than
        things like water but most things don't leave behind much meat. Blood and
        water may be less valuable numerically but they're everywhere and you can
        bottle them.
        Ratio: 20x Water
    ]]--
    meat = 0.150,
    --teehee
    meat_helpless = 0.165,
    meat_warm = 0.170,
    meat_hot = 0.190,
    meat_done = 0.220,
    meat_confusion = 0.150,
    meat_cursed = 0.150,
    meat_cursed_dry = 0.150,
    meat_teleport = 0.150,
    meat_frog = 0.150,
    meat_fast = 0.150,
    meat_worm = 0.150,
    --This is called "Stinky Meat", it can't taste good
    meat_polymorph_protection = 0.125,

    --Bad Meat
    meat_slime = -0.100,
    meat_slime_green = -0.100,
    meat_slime_cursed = -0.100,
    meat_burned = -0.100,

    --[[
        BLOOD:

        Blood is plentiful and can sorta be farmed by using a plasma cutter on a corpse.
        Can't say I'm opposed to the idea since its kinda works like dressing game
        Worm blood is certainly a bit harder to find and has no negative effects
    ]]--
    blood = 0.025,
    blood_fading = 0.020,
    blood_fading_slow = 0.020,
    blood_worm = 0.026,
    --No real analogue for this. Fungus don't really have blood, how nutritious is it?
    blood_fungi = 0.015,

    --[[
        ALCHOHOL:

        Whiskey, Juhannussima and Sima are all various strengths of fermented beverage
        
        Given how incredibly intoxicated whiskey gets the player I've always treated
        it (in other mods) as tho it was a very high proof distilled spirit made for
        alchemical use (such as creating tinctures/essence infusions)

        The other two are both types of Finnish Holiday Mead that only show up in game
        on their specific holdiays.
    ]]--
    alcohol = 0.012,
    sima = 0.016,
    juhannussima = 0.016,

    --[[
        PREPARED FOOD

        This only includes the two items right now. Not much prepared food in Noita
    ]]--
    porridge = 0.280,
    pea_soup = 0.280,


    --[[
        POTIONS:

        Hear me out, Magic potions should actually deplete some of the stored healing
        based on how useful they are when ingested. Sorta like the magic needs something
        to work with.
        TODO: Make this a table append and optional in settings
    ]]--
    magic_liquid_movement_faster = -0.030,
    --[[
        Finally decided on Ambrosia's use. A source of food poisoning that doesn't
        also cause regular poisoning
    ]]--
    magic_liquid_protection_all = 0.070,
    magic_liquid_berserk = -0.030,
    magic_liquid_polymorph = -0.030,
    magic_liquid_random_polymorph = -0.030,
    magic_liquid_unstable_polymorph = -0.030,
    magic_liquid_mana_regeneration = -0.030,
    material_confusion = -0.025,
    magic_liquid_faster_levitation_and_movement = -0.060,
    magic_liquid_faster_levitation = -0.030,
    magic_liquid_hp_regeneration = -0.070,
    magic_liquid_invisibility = -0.050,
    magic_liquid_hp_regeneration_unstable = -0.050,
    magic_liquid_unstable_teleportation = -0.030,
    magic_liquid_teleportation = -0.030,
    magic_liquid_worm_attractor = -0.030,

    --[[
        HARMFUL:

        The player will probably puke these up before long but its worth being thorough
        and having a punishment for the brief time they were in Mina's tummy.
    ]]--
    vomit = -0.080,
    poison = -0.100,
    swamp = -0.010,
    water_swamp = -0.010,
    radioactive_liquid = -0.020,
    radioactive_liquid_fading = -0.020,
    radioactive_liquid_yellow = -0.020,
    urine = -0.010,

    --[[
        OTHER:

        I dunno what to do with these, tbh.
    ]]
    material_rainbow = 0.001,
}