# Adventure Mode Changelog
### Note: not all updates get releases

### Update Oct-18-23#1
* Added or updated in this patch:
  #### New Features
    *  New type of item: Wonderous Item. These are equippable items that give perk-like effects. Mina has 6 slots to equip Wonderous Items to: Head, Body, Feet, Hands, Outer Body and Finery.
    *  New Wonderous Item: Boots of Leaping. Gives Mina's running jump a bit of extra oomph when equipped.
    *  Wonderous Items use placeholder graphics and lack a UI to explain what they do or what you have equipped \o/
  #### Bugfixes / Small Changes
    *  Starting small meal item now only contains 150 units of pea soup.
    *  All summoned meals now finally have a working timed life component and will disappear after 10 seconds, so eat up.
    *  Tons of code cleanup around the object system and finally scrapping the way New() worked for meta tables.
    *  Once again possible to switch simulation type mid-save. The object/module rewrite drastically reduced the burden to maintain this feature.

### Update Oct-15-23#1
* Added or updated in this patch:
    #### Removed Features
    *  No longer possible to switch simulation types mid save. Simulation scripts will only be added to the player at the start of a game, as well. It was becoming too much work to support switching while adding features.
    #### Bugfixes / Small Changes
    *  Fixed a serious issue in Version-4 that would overwrite the player's nourishment value with nil if it ever hit maximum.
    *  Lots of housekeeping with the intent to remove all new entity and component tags that weren't 100% mission critical.

### Update Oct-14-23#1
* Added or updated in this patch:
    #### New Features
    *  Added a new item type: Magic Flask, cannot be refilled
    *  Added proper strings for Pouchette (previously starting pouch)
    *  Added 3 new spells
        *  Touch of Soup: Acts like any touch spell except pea soup
        *  Summon Snack: Summons a Magic Flask filled with 300 units of pea soup (5 uses)
        *  Summon Sumptuous Feast: Summons a Magic Flask filled with 800 units of porridge (3 uses)
    #### Bugfixes / Small Changes
    *  Fixed a typo in an entity file that causes a log error
    *  Add an updated Compatibility.xml so the game doesn't complain about which API we're using anymore
    *  Lost of misc code cleanup and housekeeping

### Release 1
* Added or updated in this release
    #### New Features
    *  Start With Random Pouch setting. Adds a small pouch (500 capacity) to the player's inventory
        *  Will contain a random material from this list:  
        sand, soil, snow, salt, coal, gunpowder, cooked meat, fungal soil, copper, silver, brass, purifying powder, bone or fungus.
    *  Basic Tummy Sim added.
        *  Uses satiety to heal. Very simple implementation, makes the game much easier
    *  Advanced Tummy Sim added.
        *  Tracks "nourishment" based on what materials the player eats.
        *  Goes on cooldown the same way the default ingestion component does and healing is set on a configurable cooldown when firing wands or taking damage.
        *  Magic potions generally steal some nourishment value to perform their effects (they will still work with 0 nourishment)
        *  For a complete list of what materials have what effect on nourishment see [MaterialDataTable.lua](https://github.com/Crunchepillar/noita-AdventureMode/blob/Version-4/files/TummySim/MaterialDataTable.lua)
