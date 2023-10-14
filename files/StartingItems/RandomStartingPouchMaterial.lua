---@diagnostic disable: param-type-mismatch
dofile_once("data/scripts/lib/utilities.lua")

materials_standard = 
{
	{
		material="sand",
	},
	{
		material="soil",
	},
	{
		material="snow",
	},
	{
		material="salt",
		amount=250,
	},
	{
		material="coal",
	},
	{
		material="gunpowder",
		amount=100,
	},
	{
		material="fungisoil",
	},
	{
		material="meat_done",
		amount=175,
	}
}

materials_magic = 
{
	{
		material="copper",
	},
	{
		material="silver",
		amount=200,
	},
	{
		material="brass",
	},
	{
		material="bone",
		amount=400,
	},
	{
		material="purifying_powder",
		amount = 200,
		icon="data/items_gfx/pressure_bottle.png",
	},
	{
		material="fungi",
		amount = 100,
	},
}

function init( entity_id )
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y ) -- so that all the potions will be the same in every position with the same seed

	--default
	local potion_material = {
		material="sand",
	}

	if( Random( 0, 100 ) <= 75 ) then
		potion_material = random_from_array( materials_magic )
	else
		potion_material = random_from_array( materials_standard )
	end

	local total_capacity = potion_material.amount or 300

	if (potion_material.icon) then
		--Nonsense, but do it
		ComponentSetValue2(EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent"), "image_file" ,potion_material.icon)
		ComponentSetValue2(EntityGetFirstComponentIncludingDisabled(entity_id, "PhysicsImageShapeComponent"), "image_file" ,potion_material.icon)
		ComponentSetValue2(EntityGetFirstComponentIncludingDisabled(entity_id, "ItemComponent"), "ui_sprite" ,potion_material.icon)
	end

	AddMaterialInventoryMaterial( entity_id, potion_material.material, total_capacity)
end