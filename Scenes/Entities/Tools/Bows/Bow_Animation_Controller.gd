extends Node2D

const UP_ANGLE = -45
const MIDDLE_ANGLE = 0
const DOWN_ANGLE = 45

enum {NONE = 0, UP = 1, DOWN = 2}
var previous_animation = ""
var charge_state = 0.0

onready var Animation_Player = $Animation_Player

func Update(direction, looking_direction, preparing_strike):
	Tool_Animation(preparing_strike)
	Tool_Position(looking_direction, preparing_strike)

func Play_Animation(ID):
	Animation_Player.play(ID)
	previous_animation = ID

func Tool_Animation(preparing_strike):
	var arrow = get_parent().current_arrow
	if arrow:
		arrow.rotation = $Sprite.rotation
	if preparing_strike:
		if charge_state <= 0.25:
			Play_Animation("Prepare_1")
			if arrow: arrow.Offset(6)
		elif charge_state <= 0.50:
			Play_Animation("Prepare_2")
			if arrow: arrow.Offset(5)
		elif charge_state <= 0.75:
			Play_Animation("Prepare_3")
			if arrow: arrow.Offset(4)
		elif charge_state >= 1:
			Play_Animation("Prepare_4")
			if arrow: arrow.Offset(4)
		else:
			Play_Animation("Prepare_4")
			if arrow: arrow.Offset(4)
	else:
		Idle()

func Tool_Position(looking_direction: int, preparing_strike):
	if preparing_strike:
		position.y = 4
		position.x = 5
		if looking_direction == UP:
			position.y = 0
			position.x = 4
			$Sprite.rotation = deg2rad(UP_ANGLE)
		elif looking_direction == DOWN:
			position.y = 8
			position.x = 4
			$Sprite.rotation = deg2rad(DOWN_ANGLE)
		else:
			$Sprite.rotation = deg2rad(MIDDLE_ANGLE)
	else:
		position.y = 9
		position.x = -2
		$Sprite.rotation = deg2rad(110)
	
func Idle():
	Play_Animation("Idle")
