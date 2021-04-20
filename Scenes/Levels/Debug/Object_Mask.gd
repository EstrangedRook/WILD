extends TileMap

func _ready():
	visible = false

func Generate_Objects():
	var grass = load("res://Scenes/Entities/Objects/Foliage/Grass/Grass.tscn")
	var foliage_map = get_parent().Foreground_Foliage_Map
	for cell in get_used_cells():
		if get_cellv(cell) == 0:
			var instance = grass.instance()
			instance.position = cell * 8
			instance.position.x += 4
			instance.position.y += 4
			instance.make_shader_unique(instance.position.x)
			get_parent().call_deferred("add_child", instance)
			foliage_map.set_cellv(cell, 0)
	foliage_map.update_bitmask_region(-get_parent().world_size, get_parent().world_size)
