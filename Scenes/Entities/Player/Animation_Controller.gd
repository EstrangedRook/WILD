	extends Node2D

enum {NONE = 0, UP = 1, DOWN = 2}
var previous_animation = ""

onready var Body_Player = $Animation_Player

func Update(SM, direction):
	if SM.state == SM.states.jump:
		Play_Jump()
	elif SM.state == SM.states.fall:
		Play_Fall()	
	elif SM.state == SM.states.walk:
		Play_Moving(0)
	elif SM.state == SM.states.idle:
		Play_Idle(0)
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

func Play_Jump():
	if previous_animation != "Jump":
		Play_Body_Animation("Jump_Up")

func Play_Fall():
	if previous_animation != "Falling":
		Play_Body_Animation("Falling")

func Play_Die():
	if previous_animation != "Dead":
		Play_Body_Animation("Dead")
