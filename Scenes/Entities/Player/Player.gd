extends KinematicBody2D

enum {GROUNDED = 0, JUMPING = 1, FALLING = 2}
enum {NONE = 0, UP = 1, DOWN = 2}

const TARGET_FPS = Engine.iterations_per_second

const ACCELERATION = 15
const MAX_SPEED = 80
const FRICTION = 18
const AIR_RESISTANCE = 1
const GRAVITY = 9.807
const TERMINAL_VELOCITY = 400.0
const JUMP_FORCE = 210

const SLOPE_THRESHOLD = deg2rad(50)

const COYOTE_TIME = 6

var motion = Vector2.ZERO
var direction = 0
var looking_direction = NONE
var moving = 0 #If the player applied any movement input.

#Jump stuff
var just_jumped = 0 # If the player just jumped
var surface_timer = 0 # Coyote time timer

func _physics_process(delta):
	print(Engine.get_frames_per_second())
	Inputs()
	Movement(Get_X_Input(), delta)
	$Body.Update(1, moving, Get_Jump_State(), looking_direction, direction)
	var _tool = get_node_or_null("Body/Tool")
	if _tool: _tool.Update(looking_direction, direction)
	
func Movement(x_input, delta):
	moving = 0
	if x_input:
		if is_on_wall(): x_input *= 0.5
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		moving = 1
		
		#Lock direction if you have a tool and your attack/use isn't complete
		var _tool = get_node_or_null("Body/Tool")
		if _tool && _tool.Complete() || !_tool:
			direction = x_input > 0
	
	#Deceleration + Coyote Time + Jump Height
	if is_on_floor():
		surface_timer = COYOTE_TIME # Coyote Time
		if x_input == 0: motion.x = lerp(motion.x, 0, FRICTION * delta)
	else:
		if surface_timer > 0: surface_timer -= 1
		if !x_input: motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)

	#!Gravity!
	motion.y += GRAVITY * delta * TARGET_FPS
	motion.y = min(motion.y, TERMINAL_VELOCITY)
	
	#!Movement Code!
	var floor_slope = rad2deg(atan2(get_floor_normal().y, get_floor_normal().x))+90
	if abs(floor_slope) > 0 && is_on_floor():
		if x_input == 0 && !just_jumped:
			if floor_slope < 0 && !direction:
				motion.y = 0
				motion.x = 0
			elif floor_slope > 0 && direction:
				motion.y = 0
				motion.x = 0
		if motion.y < 0:
			motion.x = clamp(motion.x, -MAX_SPEED*0.75, MAX_SPEED*0.75)
		motion.y = move_and_slide(motion, Vector2.UP, 1, 4, SLOPE_THRESHOLD, false).y
	else:
		motion = move_and_slide(motion, Vector2.UP, 1, 4, SLOPE_THRESHOLD, false)
	
func Inputs():
	if is_on_floor():
		just_jumped = 0
		
	if Input.is_action_just_pressed("JUMP") && surface_timer > 0:
		motion.y = -JUMP_FORCE
		just_jumped = 1
		surface_timer = 0
	if Input.is_action_just_released("JUMP") and motion.y < 0:
		motion.y *= 0.5
	
	if Input.is_action_pressed("UP"):
		looking_direction = UP
	elif Input.is_action_pressed("DOWN"):
		looking_direction = DOWN
	else:
		looking_direction = NONE
	
	var _tool = get_node_or_null("Body/Tool")
	if _tool:
		if Input.is_action_pressed("BUTTON_A"):
			_tool.Primary(direction, looking_direction, motion)
		if Input.is_action_just_released("BUTTON_A"):
			_tool.Primary_Release(direction, looking_direction, motion)
		
		if Input.is_action_pressed("BUTTON_B"):
			_tool.Secondary(direction, looking_direction, motion)
		if Input.is_action_just_released("BUTTON_B"):
			_tool.Secondary_Release(direction, looking_direction, motion)

func Get_X_Input():
	return Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT")
	
func Get_Jump_State():
	var jump_state = 0
	if surface_timer <= 0 && motion.y < 0:
		jump_state = JUMPING
	elif surface_timer <= 0 && motion.y > 0:
		jump_state = FALLING
	return jump_state
