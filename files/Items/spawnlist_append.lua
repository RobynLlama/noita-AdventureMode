---@diagnostic disable: undefined-global

---@param ListName string
---@param Item table
---@param Weight integer
function AddToSpawnList(ListName, Weight, Item)

    if (spawnlists == nil) then
        print("Spawnlist no good")
        return
    end

    if (spawnlists[ListName] == nil) then
        print("ListName no good")
        return
    end

    local List = spawnlists[ListName]

    Item.rnd_min = List.rnd_max + 1
    Item.rnd_max = Item.rnd_min + Weight
    List.rnd_max = List.rnd_max + 1 + Weight

    --print(string.format("Inserting item with weight %s, ItemMin = %s ItemMax = %s List max = %s"), Weight, Item.rnd_min, Item.rnd_max, List.rnd_max)
    table.insert(List.spawns, Item)
end

AddToSpawnList("potion_spawnlist", 3,
    {
		load_entity = "mods/AdventureMode/files/Items/Wonders/WonderBoots.xml",
		offset_y = -2,
    }
)