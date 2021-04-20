extends Node2D

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
		$Sprite.position = get_parent().bow_ready_offset
		
		position.x = 0
		position.y = 5
		
		var mouse_angle = rad2deg(get_local_mouse_position().angle())
		mouse_angle = deg2rad(mouse_angle)
		rotation += mouse_angle
		
	else:
		$Sprite.position = get_parent().bow_idle_offset
		
		position.x = 0
		position.y = 0
		
		rotation = deg2rad(110)
	
func Idle():
	Play_Animation("Idle")
