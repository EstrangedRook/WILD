extends Node2D

enum {NONE = 0, GROWING = 1, GROWN = 2}

var rng = RandomNumberGenerator.new()

var entities = {}
var impulse = Vector2.ZERO

var tree_leaf_state = GROWN

func _ready():
	make_shader_unique(position.x)
	rng.randomize()
	var rand = rng.randi_range(1, 4)
	var sprite_directory_holder = "res://Assets/Textures/Objects/Foliage/Trees/Normal_Trees/Tree_" + str(rand) + "/Grown/"
	rand = rng.randi_range(1, 2)
	$Trunk.texture = load(sprite_directory_holder + "Tree_Trunk.png")
	$Trunk/Leaves.texture = load(sprite_directory_holder + "Leaves_" + str(rand) + ".png")
		

func make_shader_unique(pos):
	$Trunk/Leaves.material = $Trunk/Leaves.material.duplicate()
	$Trunk/Leaves.material.set_shader_param("global_position", pos)
	
func _process(delta):
	if tree_leaf_state == NONE:
		$Trunk/Leaves.visible = false
		$Trunk/Leaves.frame = 0
		$Trunk.frame = 0
	elif tree_leaf_state == GROWING:
		$Trunk/Leaves.visible = true
		$Trunk/Leaves.frame = 0
		$Trunk.frame = 0
	else:
		$Trunk/Leaves.visible = true
		$Trunk/Leaves.frame = 1
		$Trunk.frame = 1
		
	if tree_leaf_state == GROWN:
		var largest_impulse = 0;
		var current_impulse = Vector2(0,0)
		for i in entities:
			var temp_impulse = abs(i.motion.length())
			if largest_impulse < temp_impulse:
				largest_impulse = temp_impulse
				current_impulse = (i.motion / 2)
		impulse.x = lerp(impulse.x, current_impulse.x, 0.1)
		impulse.y = lerp(impulse.y, current_impulse.y, 0.1)
		$Trunk/Leaves.material.set_shader_param("impulse", impulse.x)


func _on_Leaves_Collider_body_entered(body):
	entities[body] = body

func _on_Leaves_Collider_body_exited(body):
	entities.erase(body)

func _on_Leaves_Collider_area_entered(area):
	entities[area] = area

func _on_Leaves_Collider_area_exited(area):
	entities.erase(area)
