--
-- =====================================================================================
--
--  OpenMiner
--
--  Copyright (C) 2018-2020 Unarelith, Quentin Bazin <openminer@unarelith.net>
--  Copyright (C) 2019-2020 the OpenMiner contributors (see CONTRIBUTORS.md)
--
--  This file is part of OpenMiner.
--
--  OpenMiner is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Lesser General Public
--  License as published by the Free Software Foundation; either
--  version 2.1 of the License, or (at your option) any later version.
--
--  OpenMiner is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--  Lesser General Public License for more details.
--
--  You should have received a copy of the GNU Lesser General Public License
--  along with OpenMiner; if not, write to the Free Software Foundation, Inc.,
--  51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA
--
-- =====================================================================================
--

mod:block {
	id = "dirt",
	name = "Dirt",
	tiles = "dirt.png"
}

mod:block {
	id = "cobblestone",
	name = "Cobblestone",
	tiles = "cobblestone.png",
	hardness = 2,
	harvest_requirements = 1,
}

mod:block {
	id = "grass",
	name = "Grass",
	tiles = {"grass_block_top.png", "dirt.png", "grass_block_side.png"},
	color_multiplier = {129, 191, 91, 255},

	item_drop = {
		id = mod:id()..":dirt",
		amount = 1
	}
}

mod:block {
	id = "oak_leaves",
	name = "Oak Leaves",
	tiles = "oak_leaves.png",
	color_multiplier = {106, 173, 51, 255},
	hardness = 0.5,
	draw_type = "leaves",
	-- is_opaque = false, -- FIXME
}

mod:block {
	id = "oak_wood",
	name = "Oak Wood",
	tiles = {"oak_log_top.png", "oak_log.png"},
	hardness = 2
}

mod:block {
	id = "stone",
	name = "Stone",
	tiles = "stone.png",
	hardness = 1.5,
	harvest_requirements = 1,
	item_drop = {
		id = mod:id()..":cobblestone",
		amount = 1
	},
}

mod:block {
	id = "sand",
	name = "Sand",
	tiles = "sand.png"
}

mod:block {
	id = "water",
	name = "Water",

	tiles = "water.png",
	color_multiplier = {51, 115, 255, 217},

	draw_type = "liquid",
	is_opaque = false,

	fog_depth = 20.0,
	fog_color = {0, 128, 255},
}

mod:block {
	id = "glass",
	name = "Glass",
	tiles = "glass.png",
	draw_type = "glass",
	is_opaque = false,
}

mod:block {
	id = "coal_ore",
	name = "Coal Ore",
	tiles = "coal_ore.png",
	hardness = 3,
	harvest_requirements = 1,
	item_drop = {
		id = mod:id()..":coal",
		amount = 1
	},
}

mod:block {
	id = "oak_planks",
	name = "Oak Wood Planks",
	tiles = "oak_planks.png",

	groups = {
		default_planks = 1
	}
}

mod:block {
	id = "glowstone",
	name = "Glowstone",
	tiles = "glowstone.png",
	is_light_source = true
}

mod:block {
	id = "iron_ore",
	name = "Iron Ore",
	tiles = "iron_ore.png",
	hardness = 3,
	harvest_requirements = 1,
}

mod:block {
	id = "dandelion",
	name = "Dandelion",
	tiles = "dandelion.png",
	hardness = 0,
	draw_type = "xshape",
	bounding_box = {0.25, 0.25, 0.0, 0.5, 0.5, 0.5},
}

mod:block {
	id = "tallgrass",
	name = "Grass",
	tiles = "grass.png",
	color_multiplier = {129, 191, 91, 255},
	hardness = 0,
	draw_type = "xshape",
}

mod:block {
	id = "stone_bricks",
	name = "Stone Bricks",
	tiles = "stone_bricks.png",
	hardness = 2,
	harvest_requirements = 1,
}

mod:block {
	id = "bricks",
	name = "Bricks",
	tiles = "bricks.png",
	hardness = 2,
	harvest_requirements = 1,
}

mod:block {
	id = "clay",
	name = "Clay",
	tiles = "clay.png",
	item_drop = {
		id = mod:id()..":clay_ball",
		amount = 4
	}
}

mod:block {
	id = "oak_slab",
	name = "Oak Wood Slab",
	tiles = "oak_planks.png",

	draw_type = "boundingbox",
	is_opaque = false,

	bounding_box = {0, 0, 0, 1, 1, 0.5}
}

mod:block {
	id = "portal",
	name = "Portal",
	tiles = "portal.png",

	draw_type = "glass",
	is_opaque = false,

	on_block_activated = function(pos, player, world, client, server, screen_width, screen_height, gui_scale)
		local dim = (player:dimension() + 1) % 2
		local pos = {
			x = math.floor(player:x()),
			y = math.floor(player:y()),
			z = math.floor(player:z())
		}

		server:send_player_change_dimension(client.id, pos.x, pos.y, pos.z, dim, client)
		player:set_dimension(dim)
		-- player:set_position(pos.x, pos.y, pos.z)
	end,
}

mod:block {
	id = "netherrack",
	name = "Netherrack",
	tiles = "netherrack.png",
}

mod:block {
	id = "soul_sand",
	name = "Soul Sand",
	tiles = "soul_sand.png",
}

mod:block {
	id = "lava",
	name = "Lava",
	tiles = "lava.png",

	draw_type = "liquid",
	is_light_source = true,
	is_opaque = false,

	fog_depth = 10.0,
	fog_color = {255, 128, 0},
}

mod:block {
	id = "cactus",
	name = "Cactus",
	tiles = {"cactus_top.png", "cactus_bottom.png", "cactus_side.png"},

	draw_type = "cactus",
	bounding_box = {1/16, 1/16, 0, 14/16, 14/16, 1};

	on_block_destroyed = function(pos, world)
		if world:get_block(pos.x, pos.y, pos.z + 1) == world:get_block(pos.x, pos.y, pos.z) then
			world:set_block(pos.x, pos.y, pos.z + 1, 0)
		end
	end,
}

mod:block {
	id = "deadbush",
	name = "Dead Bush",
	tiles = "deadbush.png",
	draw_type = "xshape",
}

mod:block {
	id = "debug",
	name = "Debug",
	tiles = {
		"debug/f.png",
		"debug/g.png",
		"debug/j.png",
		"debug/l.png",
		"debug/p.png",
		"debug/r.png",
	},
}

mod:block {
	id = "obsidian",
	name = "Obsidian",
	tiles = "obsidian.png",

	hardness = 2,
}

mod:block {
	id = "reeds",
	name = "Sugar Canes",
	tiles = "reeds.png",
	inventory_image = "reeds_item.png",

	draw_type = "xshape",
	hardness = 0.2,

	on_block_destroyed = function(pos, world)
		if world:get_block(pos.x, pos.y, pos.z + 1) == world:get_block(pos.x, pos.y, pos.z) then
			world:set_block(pos.x, pos.y, pos.z + 1, 0)
		end
	end,
}

mod:block {
	id = "redstone_lamp_off",
	name = "Redstone Lamp",
	tiles = "redstone_lamp_off.png",

	on_block_activated = function(pos, player, world, client, server, screen_width, screen_height, gui_scale)
		local block = openminer.registry:get_block_from_string("default:redstone_lamp_on")
		world:set_block(pos.x, pos.y, pos.z, block:id())
	end
}

mod:block {
	id = "redstone_lamp_on",
	name = "Redstone Lamp",
	tiles = "redstone_lamp_on.png",
	is_light_source = true,

	groups = {
		ci_ignore = 1
	},

	on_block_activated = function(pos, player, world, client, server, screen_width, screen_height, gui_scale)
		local block = openminer.registry:get_block_from_string("default:redstone_lamp_off")
		world:set_block(pos.x, pos.y, pos.z, block:id())
	end
}

mod:block {
	id = "farmland",
	name = "Farmland",
	tiles = {"farmland_dry.png", "dirt.png", "dirt.png"},
	alt_tiles = {"farmland_wet.png", "dirt.png", "dirt.png"},

	draw_type = "boundingbox",
	bounding_box = {0, 0, 0, 1, 1, 15 / 16},
}

mod:block {
	id = "grass_path",
	name = "Grass Path",
	tiles = {"grass_path_top.png", "dirt.png", "grass_path_side.png"},

	draw_type = "boundingbox",
	bounding_box = {0, 0, 0, 1, 1, 15 / 16},
}

mod:block {
	id = "seeds",
	name = "Seeds",
	tiles = "wheat_stage_0.png",
	alt_tiles = "wheat_stage_7.png",
	draw_type = "xshape",
	inventory_image = "seeds_wheat.png",
	hardness = 0,

	tick_randomly = true,
	tick_probability = 0.01,

	on_block_placed = function(pos, world)
		world:add_block_data(pos.x, pos.y, pos.z, 0, 0)
	end,

	on_tick = function(pos, chunk, world)
		local data = world:get_block_data(pos.x, pos.y, pos.z)
		if not data then return end

		local growth_stage = data.meta:get_int("growth_stage") or 0
		if growth_stage < 7 then
			data.use_alt_tiles = true
			data.meta:set_int("growth_stage", 7)
		end
	end,

	on_block_activated = function(pos, player, world, client, server, screen_width, screen_height, gui_scale)
		local data = world:get_block_data(pos.x, pos.y, pos.z)
		if not data then return end

		local growth_stage = data.meta:get_int("growth_stage") or 0
		if growth_stage >= 7 then
			data.use_alt_tiles = false
			data.meta:set_int("growth_stage", 0)

			-- FIXME: It should drop the item if 'default:use_item_drops' is enabled
			local item_stack = ItemStack.new("default:wheat", 1)
			mods["default"]:give_item_stack(player, item_stack)
		end
	end
}

dofile("blocks/workbench.lua")
dofile("blocks/furnace.lua")
dofile("blocks/door.lua")

