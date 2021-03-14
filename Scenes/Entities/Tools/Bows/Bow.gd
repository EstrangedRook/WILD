extends Node2D

var draw_strength = 0
var max_draw_strength = 50
var launch_power = 300.0
var current_arrow

var preparing_primary_strike = false

func Update(looking_direction, direction):
	$Body.Update(!direction, looking_direction, preparing_primary_strike)
	
func Primary(direction):
	if draw_strength <= 0:
		var arrow = load("res://Scenes/Entities/Projectiles/Arrow/Wooden_Arrow/Wooden_Arrow.tscn")
		current_arrow = arrow.instance()
		$Body.add_child(current_arrow)
		preparing_primary_strike = true
	if draw_strength < max_draw_strength:
		draw_strength += 1
	$Body.charge_state = float(float(draw_strength) / float(max_draw_strength))
		
func Primary_Release(direction, moving_velocity):
	if current_arrow && draw_strength > 0:
		preparing_primary_strike = false
		if draw_strength < max_draw_strength/3:
			current_arrow.get_parent().remove_child(current_arrow)
		else:
			var power = float(float(draw_strength) / float(max_draw_strength)) * float(launch_power)
			var launch_vector = Vector2.ZERO
			launch_vector.x = cos($Body/Sprite.rotation)
			launch_vector.y = sin($Body/Sprite.rotation)
			if !direction:
				launch_vector.x *= -1
			launch_vector = launch_vector * power
			current_arrow.position = current_arrow.global_position
			current_arrow.Launch(launch_vector + moving_velocity)
			current_arrow.get_parent().remove_child(current_arrow)
			get_node("/root/World").add_child(current_arrow)
			current_arrow.Offset(0)
		draw_strength = 0
		current_arrow = null
		
		draw_strength = 0	

func Secondary(direction):
	pass
	
func Secondary_Release(direction, moving_velocity):
	pass

func Complete():
	var complete = true
	if current_arrow:
		complete = false
	return complete
