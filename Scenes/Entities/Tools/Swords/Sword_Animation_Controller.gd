extends Node2D

const UP_ANGLE = -15
const MIDDLE_ANGLE = -10
const DOWN_ANGLE = -10

enum {NONE = 0, UP = 1, DOWN = 2}
var previous_animation = ""
var charge_state = 0.0

var ideal_x = 0.0
var current_slash_x = 0.0

onready var Animation_Player = $Animation_Player

func Update(direction, looking_direction, preparing_strike, slash_timer, slash_speed):
	Tool_Animation(preparing_strike)
	Tool_Position(direction, looking_direction, preparing_strike, slash_timer, slash_speed)

func Play_Animation(ID):
	Animation_Player.play(ID)
	previous_animation = ID

func Tool_Animation(preparing_strike):
	if preparing_strike:
		if charge_state <= 0.2:
			Play_Animation("Idle")
		elif charge_state <= 0.4:
			Play_Animation("Prepare_1")
		elif charge_state <= 0.6:
			Play_Animation("Prepare_2")
		elif charge_state <= 0.8:
			Play_Animation("Prepare_3")
		elif charge_state <= 0.9:
			Play_Animation("Prepare_4")
		else:
			Play_Animation("Prepare_5")
	else:
		Idle()

func Tool_Position(direction, looking_direction: int, preparing_strike, slash_timer, slash_speed):
	var x_mod = 0
	if !direction:
		z_index = -1
		x_mod = 2
	else:
		z_index = 0
	
	if slash_timer > 0:
		if slash_timer > slash_speed * 0.5:
			$Sprite.visible = false
			current_slash_x = 2.5
		else:
			$Sprite.visible = true
			if current_slash_x > ideal_x:
				current_slash_x -= 0.5
		position.y = 0
		position.x = current_slash_x + x_mod
		if looking_direction == UP:
			position.y = 0
			rotation = deg2rad(UP_ANGLE)
		elif looking_direction == DOWN:
			position.y = 0
			rotation = deg2rad(DOWN_ANGLE)
		else:
			rotation = deg2rad(MIDDLE_ANGLE)
	else:
		position.y = 0
		position.x = 0 + x_mod
		if looking_direction == UP:
			position.y = 0
			position.x = 0 + x_mod
			rotation = deg2rad(UP_ANGLE)
		elif looking_direction == DOWN:
			position.y = 0
			position.x = 0 + x_mod
			rotation = deg2rad(DOWN_ANGLE)
		else:
			rotation = deg2rad(MIDDLE_ANGLE)
	
func Idle():
	Play_Animation("Idle")
