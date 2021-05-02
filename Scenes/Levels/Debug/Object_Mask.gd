extends TileMap

var rng = RandomNumberGenerator.new()

func _ready():
	visible = false
	pass

func Generate_Objects():
	var grass = load("res://Scenes/Entities/Objects/Foliage/Grass/Grass.tscn")
	var tree = load("res://Scenes/Entities/Objects/Foliage/Tree/Tree.tscn")
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
		elif get_cellv(cell) == 2:
			var instance = tree.instance()
			instance.position = cell * 8
			instance.position.x += 4
			instance.position.y -= 28
			instance.make_shader_unique(instance.position.x)
			get_parent().call_deferred("add_child", instance)
			rng.randomize()
			var create_grass = rng.randi_range(0,1)
			if create_grass:
				instance = grass.instance()
				instance.position = cell * 8
				instance.position.x += 4
				instance.position.y += 4
				instance.make_shader_unique(instance.position.x)
				get_parent().call_deferred("add_child", instance)
				foliage_map.set_cellv(cell, 0)
	foliage_map.update_bitmask_region(-get_parent().world_size, get_parent().world_size)
