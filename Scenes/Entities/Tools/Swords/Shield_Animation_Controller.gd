extends Node2D

const UP_ANGLE = -5
const MIDDLE_ANGLE = 0
const DOWN_ANGLE = 0

const SHIELD_UP_ANGLE = -45
const SHIELD_MIDDLE_ANGLE = 0
const SHIELD_DOWN_ANGLE = 45

enum {NONE = 0, UP = 1, DOWN = 2}
var previous_animation = ""
var charge_state = 0.0

onready var Animation_Player = $Animation_Player

func Update(direction, looking_direction, preparing_strike):
	Tool_Animation(preparing_strike, direction)
	Tool_Position(direction, looking_direction, preparing_strike)

func Play_Animation(ID):
	Animation_Player.play(ID)
	previous_animation = ID

func Tool_Animation(preparing_strike, direction):
	if preparing_strike:
		Play_Animation("Shields_Up")
	else:
		if direction:
			Play_Animation("Back_Idle")
		else:
			Play_Animation("Front_Idle")

func Tool_Position(direction, looking_direction: int, preparing_strike):
	var x_mod = 0
	if direction:
		z_index = -1
		x_mod = 2
	else:
		z_index = 0
	if preparing_strike:
		position.y = -1
		position.x = 4 + x_mod
		if looking_direction == UP:
			position.y = -4
			position.x = 4 + x_mod
			rotation = deg2rad(SHIELD_UP_ANGLE)
		elif looking_direction == DOWN:
			position.y = 1
			position.x = 4 + x_mod
			rotation = deg2rad(SHIELD_DOWN_ANGLE)
		else:
			rotation = deg2rad(SHIELD_MIDDLE_ANGLE)
	else:
		position.y = -1
		position.x = 0 + x_mod
		if looking_direction == UP:
			rotation = deg2rad(UP_ANGLE)
		elif looking_direction == DOWN:
			rotation = deg2rad(DOWN_ANGLE)
		else:
			rotation = deg2rad(MIDDLE_ANGLE)

#	pass
