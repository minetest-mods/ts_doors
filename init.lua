ts_doors = {}

local function copytable(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[copytable(orig_key)] = copytable(orig_value)
		end
		setmetatable(copy, copytable(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end

local function register_alias(name, convert_to)
	minetest.register_alias(name        , convert_to        )
	minetest.register_alias(name .. "_a", convert_to .. "_a")
	minetest.register_alias(name .. "_b", convert_to .. "_b")
end

function ts_doors.register_door(recipe, description, texture)
	register_alias("doors:ts_door_" .. recipe:gsub(":", "_"), "ts_doors:door_" .. recipe:gsub(":", "_"))
	register_alias("doors:ts_door_full_" .. recipe:gsub(":", "_"), "ts_doors:door_full_" .. recipe:gsub(":", "_"))
	register_alias("doors:ts_door_locked_" .. recipe:gsub(":", "_"), "ts_doors:door_locked_" .. recipe:gsub(":", "_"))
	register_alias("doors:ts_door_full_locked_" .. recipe:gsub(":", "_"), "ts_doors:door_full_locked_" .. recipe:gsub(":", "_"))

	local groups = minetest.registered_nodes[recipe].groups
	local door_groups = {}
	for k,v in pairs(groups) do
		if k ~= "wood" then
			door_groups[k] = v
		end
	end

	trapdoor_groups = copytable(door_groups)

	doors.register("ts_doors:door_" .. recipe:gsub(":", "_"), {
		tiles = {{ name = "[combine:32x38:0,0=" .. texture .. ":0,16=" .. texture .. ":0,32=" .. texture .. ":16,0=" .. texture .. ":16,16=" .. texture .. ":16,32=" .. texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base.png^[noalpha^[makealpha:0,255,0", backface_culling = true }},
		description = description .. " Door",
		inventory_image = "[combine:32x38:0,0=" .. texture .. ":0,16=" .. texture .. ":16,0=" .. texture .. ":16,16=" .. texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_inv.png^[noalpha^[makealpha:0,255,0",
		groups = door_groups,
		recipe = {
			{recipe, recipe},
			{recipe, recipe},
			{recipe, recipe},
		}
	})

	doors.register("ts_doors:door_full_" .. recipe:gsub(":", "_"), {
		tiles = {{ name = "[combine:32x38:0,0=" .. texture .. ":0,16=" .. texture .. ":0,32=" .. texture .. ":16,0=" .. texture .. ":16,16=" .. texture .. ":16,32=" .. texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_full.png^[noalpha", backface_culling = true }},
		description = description .. " Door",
		inventory_image = "[combine:32x38:0,0=" .. texture .. ":0,16=" .. texture .. ":16,0=" .. texture .. ":16,16=" .. texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_full_inv.png^[noalpha^[makealpha:0,255,0",
		groups = door_groups,
		recipe = {
			{recipe},
			{"ts_doors:door_" .. recipe:gsub(":", "_")},
		}
	})

	doors.register_trapdoor("ts_doors:trapdoor_" .. recipe:gsub(":", "_"), {
		description = description .. " Trapdoor",
		inventory_image = texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_trapdoor.png^[noalpha^[makealpha:0,255,0",
		wield_image = texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_trapdoor.png^[noalpha^[makealpha:0,255,0",
		tile_front = texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_trapdoor.png^[noalpha^[makealpha:0,255,0",
		tile_side = texture .. "^[colorize:#fff:30",
		groups = trapdoor_groups,
	})

	doors.register_trapdoor("ts_doors:trapdoor_full_" .. recipe:gsub(":", "_"), {
		description = description .. " Trapdoor",
		inventory_image = texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_trapdoor_full.png^[noalpha",
		wield_image = texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_trapdoor_full.png^[noalpha",
		tile_front = texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_trapdoor_full.png^[noalpha",
		tile_side = texture .. "^[colorize:#fff:30",
		groups = trapdoor_groups,
	})

	minetest.register_craft({
		output = "ts_doors:trapdoor_" .. recipe:gsub(":", "_"),
		recipe = {
			{recipe, recipe},
			{recipe, recipe},
		}
	})

	minetest.register_craft({
		output = "ts_doors:trapdoor_full_" .. recipe:gsub(":", "_"),
		recipe = {
			{recipe},
			{"ts_doors:trapdoor_" .. recipe:gsub(":", "_")},
		}
	})

	door_groups.level = 2
	trapdoor_groups.level = 2

	doors.register("ts_doors:door_locked_" .. recipe:gsub(":", "_"), {
		tiles = {{ name = "[combine:32x38:0,0=" .. texture .. ":0,16=" .. texture .. ":0,32=" .. texture .. ":16,0=" .. texture .. ":16,16=" .. texture .. ":16,32=" .. texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_locked.png^[noalpha^[makealpha:0,255,0", backface_culling = true }},
		description = description .. " Locked Door",
		inventory_image = "[combine:32x38:0,0=" .. texture .. ":0,16=" .. texture .. ":16,0=" .. texture .. ":16,16=" .. texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_locked_inv.png^[noalpha^[makealpha:0,255,0",
		protected = true,
		groups = door_groups,
		sound_open = "doors_steel_door_open",
		sound_close = "doors_steel_door_close",
		recipe = {
			{recipe, recipe},
			{recipe, "default:steel_ingot"},
			{recipe, recipe},
		}
	})

	doors.register("ts_doors:door_full_locked_" .. recipe:gsub(":", "_"), {
		tiles = {{ name = "[combine:32x38:0,0=" .. texture .. ":0,16=" .. texture .. ":0,32=" .. texture .. ":16,0=" .. texture .. ":16,16=" .. texture .. ":16,32=" .. texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_full_locked.png^[noalpha", backface_culling = true }},
		description = description .. " Locked Door",
		inventory_image = "[combine:32x38:0,0=" .. texture .. ":0,16=" .. texture .. ":16,0=" .. texture .. ":16,16=" .. texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_full_locked_inv.png^[noalpha^[makealpha:0,255,0",
		protected = true,
		groups = door_groups,
		sound_open = "doors_steel_door_open",
		sound_close = "doors_steel_door_close",
		recipe = {
			{recipe},
			{"ts_doors:door_locked_" .. recipe:gsub(":", "_")},
		}
	})

	doors.register_trapdoor("ts_doors:trapdoor_locked_" .. recipe:gsub(":", "_"), {
		description = description .. " Locked Trapdoor",
		inventory_image = texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_trapdoor_locked.png^[noalpha^[makealpha:0,255,0",
		wield_image = texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_trapdoor_locked.png^[noalpha^[makealpha:0,255,0",
		tile_front = texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_trapdoor_locked.png^[noalpha^[makealpha:0,255,0",
		tile_side = texture .. "^[colorize:#fff:30",
		protected = true,
		sounds = default.node_sound_stone_defaults(),
		sound_open = "doors_steel_door_open",
		sound_close = "doors_steel_door_close",
		groups = trapdoor_groups
	})

	doors.register_trapdoor("ts_doors:trapdoor_full_locked_" .. recipe:gsub(":", "_"), {
		description = description .. " Locked Trapdoor",
		inventory_image = texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_trapdoor_full_locked.png^[noalpha",
		wield_image = texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_trapdoor_full_locked.png^[noalpha",
		tile_front = texture .. "^[transformR270^[colorize:#fff:30^ts_doors_base_trapdoor_full_locked.png^[noalpha",
		tile_side = texture .. "^[colorize:#fff:30",
		protected = true,
		sounds = default.node_sound_stone_defaults(),
		sound_open = "doors_steel_door_open",
		sound_close = "doors_steel_door_close",
		groups = trapdoor_groups
	})

	minetest.register_craft({
		output = "ts_doors:trapdoor_locked_" .. recipe:gsub(":", "_"),
		recipe = {
			{"default:steel_ingot"},
			{"ts_doors:trapdoor_" .. recipe:gsub(":", "_")},
		}
	})

	minetest.register_craft({
		output = "ts_doors:trapdoor_full_locked_" .. recipe:gsub(":", "_"),
		recipe = {
			{recipe},
			{"ts_doors:trapdoor_locked_" .. recipe:gsub(":", "_")},
		}
	})
end

ts_doors.register_door("default:aspen_wood" , "Aspen"      , "default_aspen_wood.png" )
ts_doors.register_door("default:pine_wood"  , "Pine"       , "default_pine_wood.png"  )
ts_doors.register_door("default:acacia_wood", "Acacia"     , "default_acacia_wood.png")
ts_doors.register_door("default:wood"       , "Wooden"     , "default_wood.png"       )
ts_doors.register_door("default:junglewood" , "Jungle Wood", "default_junglewood.png" )


if(minetest.get_modpath("moretrees")) then
	ts_furniture.register_furniture("moretrees:apple_tree_planks", "Apple Tree", "moretrees_apple_tree_wood.png")
	ts_furniture.register_furniture("moretrees:beech_planks", "Beech", "moretrees_beech_wood.png")
	ts_furniture.register_furniture("moretrees:birch_planks", "Birch", "moretrees_birch_wood.png")
	ts_furniture.register_furniture("moretrees:fir_planks", "Fir", "moretrees_fir_wood.png")
	ts_furniture.register_furniture("moretrees:oak_planks", "Oak", "moretrees_oak_wood.png")
	ts_furniture.register_furniture("moretrees:palm_planks", "Palm", "moretrees_palm_wood.png")
	ts_furniture.register_furniture("moretrees:rubber_tree_planks", "Rubber Tree", "moretrees_rubber_tree_wood.png")
	ts_furniture.register_furniture("moretrees:sequoia_planks", "Sequoia", "moretrees_sequoia_wood.png")
	ts_furniture.register_furniture("moretrees:spruce_planks", "Spruce", "moretrees_spruce_wood.png")
	ts_furniture.register_furniture("moretrees:willow_planks", "Willow", "moretrees_willow_wood.png")
end
