extends Area2D
class_name Grass

var rng = RandomNumberGenerator.new()

var entities = {}
var impulse = 0

func _ready():
	rng.randomize()
	var frame = rng.randi_range(0, 12)
	if frame > 10:
		frame = rng.randi_range(11, 15)
	$Sprite.frame = frame

func make_shader_unique(pos):
	$Sprite.material = $Sprite.material.duplicate()
	$Sprite.material.set_shader_param("global_position", pos)
	
func _process(delta):
	var largest_impulse = 0;
	var current_impulse = 0;
	for i in entities:
		var temp_impulse = abs(i.motion.x)
		if largest_impulse < temp_impulse:
			largest_impulse = temp_impulse
			current_impulse = i.motion.x
	impulse = lerp(impulse, current_impulse, 0.1)
	$Sprite.material.set_shader_param("impulse", impulse)


func _on_Grass_body_entered(body):
	entities[body] = body

func _on_Grass_body_exited(body):
	entities.erase(body)

func _on_Grass_area_entered(area):
	entities[area] = area

func _on_Grass_area_exited(area):
	entities.erase(area)
