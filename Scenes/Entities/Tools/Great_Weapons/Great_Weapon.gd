extends Node2D

enum {NONE = 0, UP = 1, DOWN = 2}
var rng = RandomNumberGenerator.new()

var preparing_primary_strike = false
var primary_striking = false
var preparing_secondary_strike = false
var secondary_striking = false

func Update(looking_direction, direction):
	$Body.Update(direction, looking_direction, preparing_primary_strike, primary_striking)
	pass

func Primary(direction, looking_direction, moving_velocity):
	if !Complete():
		return
	preparing_primary_strike = true
	if $Body.charge_state < 1.0:
		$Body.charge_state += 0.01
	pass

func Primary_Release(direction, looking_direction, moving_velocity):
	if !Complete():
		return
	preparing_primary_strike = false
	primary_striking = true

	
func Secondary(direction, looking_direction, moving_velocity):
	preparing_secondary_strike = true
	pass
	
func Secondary_Release(direction, looking_direction, moving_velocity):
	preparing_secondary_strike = false
	pass

func Complete():
	var complete = true
	if $Body.attacking:
		complete = false
	return complete
