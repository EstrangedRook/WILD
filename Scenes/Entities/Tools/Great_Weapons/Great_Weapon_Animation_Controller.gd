extends Node2D

const RESTING_ANGLE = -135
const FINAL_ANGLE = 0

const MAX_CHARGE_ANGLE = -160

const MAX_SWING_SPEED = 20
const SWING_SPEED_INIT = 0.1

const ACCELERATION_INIT = 1.1
const ACCELERATION_MUTLIPLIER = 1.004

const STRIKE_SETUP_POSITION = 2

enum {NONE = 0, UP = 1, DOWN = 2}
var previous_animation = ""
var charge_state = 0.0

var current_swing_speed = 1.0
var accel_mod = 1.0
var recoiling = false
var attacking = false

onready var Animation_Player = $Object_Offset/Animation_Player

func Update(direction, looking_direction, preparing_strike, striking):
	Tool_Animation(preparing_strike)
	Tool_Position(direction, looking_direction, preparing_strike, striking)

func Play_Animation(ID):
	Animation_Player.play(ID)
	previous_animation = ID

func Tool_Animation(preparing_strike):
	if preparing_strike:
		pass
	else:
		Idle()

func Tool_Position(direction, looking_direction: int, preparing_strike, striking):
	position.y = 8.5
	position.x = 1.5
	attacking = false
	if preparing_strike:
		if $Object_Offset.position.x < STRIKE_SETUP_POSITION:
			$Object_Offset.position.x += 0.2
		else:
			rotation_degrees = RESTING_ANGLE + ((MAX_CHARGE_ANGLE - RESTING_ANGLE) * charge_state)
	elif striking && charge_state > 0:
		attacking = true
		if rotation_degrees < FINAL_ANGLE && !recoiling:
			current_swing_speed *= accel_mod
			accel_mod *= ACCELERATION_MUTLIPLIER
			if current_swing_speed > MAX_SWING_SPEED:
				current_swing_speed = MAX_SWING_SPEED
			rotation_degrees += current_swing_speed
			$Object_Offset.position.x = STRIKE_SETUP_POSITION
		elif rotation_degrees > RESTING_ANGLE && recoiling:
			current_swing_speed *= accel_mod
			accel_mod *= ACCELERATION_MUTLIPLIER
			if current_swing_speed > MAX_SWING_SPEED:
				current_swing_speed = MAX_SWING_SPEED
			rotation_degrees -= current_swing_speed * 0.5
			if $Object_Offset.position.x > 0:
				$Object_Offset.position.x -= 0.1
		elif rotation_degrees > RESTING_ANGLE:
			current_swing_speed = SWING_SPEED_INIT
			recoiling = true
		else:
			striking = false
			recoiling = false
			charge_state = 0
	else:
		rotation_degrees = RESTING_ANGLE
		$Object_Offset.position.x = 0
		current_swing_speed = SWING_SPEED_INIT
		accel_mod = ACCELERATION_INIT
	
func Idle():
	Play_Animation("Idle")
