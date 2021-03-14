	extends Node2D

enum {GROUNDED = 0, JUMPING = 1, FALLING = 2}
enum {NONE = 0, UP = 1, DOWN = 2}
var previous_animation = ""

onready var Body_Player = $Animation_Player

func Update(health, moving, jump_state, looking_direction, direction):
	if jump_state == JUMPING:
		Play_Body_Animation("Jump_Up")
	elif jump_state == FALLING:
		Play_Fall()	
	elif moving:
		Play_Moving(looking_direction)
	elif health > 0:
		Play_Idle(looking_direction)
	else:
		Play_Die()	
	if direction:
		if scale.x < 0:
			scale.x *= -1
	else:
		if scale.x > 0:
			scale.x *= -1

func Play_Body_Animation(ID):
	Body_Player.play(ID)
	previous_animation = ID
	
func Play_Moving(looking_direction):
	if looking_direction == UP:
		Play_Body_Animation("Walk_Up")
	elif looking_direction == DOWN:
		Play_Body_Animation("Walk_Down")
	else:
		Play_Body_Animation("Walk")

func Play_Idle(looking_direction):
	if looking_direction == UP:
		Play_Body_Animation("Look_Up")
	elif looking_direction == DOWN:
		Play_Body_Animation("Look_Down")
	else:
		Play_Body_Animation("Idle")

func Play_Fall():
	if previous_animation != "Falling":
		Play_Body_Animation("Falling")

func Play_Die():
	if previous_animation != "Dead":
		Play_Body_Animation("Dead")
