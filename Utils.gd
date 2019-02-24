extends Node

func move_towards(from, to, max_step):
	if to > from:
		from += max_step
		if from > to:
			from = to
	elif to < from:
		from -= max_step
		if from < to:
			from = to
	return from

func find_in_2d_array(array, element):
	for i in range(array.size()):
		var idx = array[i].find(element)
		if idx != -1:
			return idx
	
	return -1

func interpolate(a, b, v):
	return (b * v) + (a * (1 - v))

func swap_tiles_with_objects(tile_map : TileMap, tile_name : String, object_scene : PackedScene):
	var wall_tileset : TileSet = tile_map.tile_set
	var water_tile_id = wall_tileset.find_tile_by_name(tile_name)
	var wall_cells : Array = tile_map.get_used_cells()
	
	for cell_pos in tile_map.get_used_cells():
		var cell_id = tile_map.get_cell(cell_pos.x, cell_pos.y)
		if cell_id == water_tile_id:
			tile_map.set_cell(cell_pos.x, cell_pos.y, -1)
			var new_water_tile : Node = object_scene.instance()
			tile_map.add_child(new_water_tile)
			new_water_tile.global_position = tile_map.map_to_world(cell_pos)
			new_water_tile.global_position += tile_map.cell_size / 2