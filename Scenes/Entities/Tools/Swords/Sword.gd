extends Node2D

enum {NONE = 0, UP = 1, DOWN = 2}
var rng = RandomNumberGenerator.new()

var slash_speed = 25
var slash_timer = 0

var slash_charge_speed = 50
var slash_charge = 0

var slash_launch_strength = 75

var preparing_primary_strike = false
var preparing_secondary_strike = false

onready var slash = preload("res://Scenes/Entities/Projectiles/Slash/Sword_Slash/Sword_Slash.tscn")

func Update(looking_direction, direction):
	$Primary_Body.Update(direction, looking_direction, preparing_primary_strike, slash_timer, slash_speed)
	$Secondary_Body.Update(direction, looking_direction, preparing_secondary_strike)
	if slash_timer > 0:
		slash_timer -= 1
	pass

func Primary(direction, looking_direction, moving_velocity):
	if slash_timer > 0:
		return
	if slash_charge < slash_charge_speed:
		slash_charge += 1
	preparing_primary_strike = true
	$Primary_Body.charge_state = float(float(slash_charge) / float(slash_charge_speed))

func Primary_Release(direction, looking_direction, moving_velocity):
	if slash_timer > 0:
		return
	preparing_primary_strike = false
	var power = float(float(slash_charge) / float(slash_charge_speed)) * float(slash_launch_strength)
	var temp_slash = slash.instance()
	var launch_vector = Vector2.ZERO
	var shoot_angle = 0
	var temp_position = Vector2(8,4)
	if looking_direction == UP:
		shoot_angle = -45
		temp_position.y = 0
	elif looking_direction == DOWN:
		shoot_angle = 45
		temp_position.y = 8
	shoot_angle += rng.randf_range(-10.0, 10.0)
	launch_vector.x = cos(deg2rad(shoot_angle))
	launch_vector.y = sin(deg2rad(shoot_angle))
	var full_charge = false
	if slash_charge >= slash_charge_speed:
		power *= 2
		full_charge = true
		launch_vector = launch_vector * power
	else:
		launch_vector = launch_vector * slash_launch_strength
	temp_slash.position = temp_position
	get_parent().add_child(temp_slash)
	temp_slash.Launch(launch_vector, rng.randf_range(10, 15.0), rng.randf_range(0.5, 1.0), full_charge)
	slash_charge = 0
	slash_timer = slash_speed
	
func Secondary(direction, looking_direction, moving_velocity):
	preparing_secondary_strike = true
	pass
	
func Secondary_Release(direction, looking_direction, moving_velocity):
	preparing_secondary_strike = false
	pass

func Complete():
	var complete = true
	return complete
