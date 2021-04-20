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
var x_input = 0

#Tools
var _tool

#States
onready var SM = $State_Machine

#Body
onready var BODY = $Body

func _physics_process(delta):
	print(Engine.get_frames_per_second())

func _process_physics(delta):
	_process_horizontal_motion(delta)
	_process_vertical_motion(delta)
	_apply_motion(delta)

func _process_horizontal_motion(delta):
	motion.x += x_input * ACCELERATION * delta * TARGET_FPS
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	if [SM.states.idle, SM.states.walk].has(SM.state):
		if !x_input: motion.x = lerp(motion.x, 0, FRICTION * delta)
	else:
		if !x_input: motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)	
		
func _process_vertical_motion(delta):
	motion.y += GRAVITY * delta * TARGET_FPS
	motion.y = min(motion.y, TERMINAL_VELOCITY)
	
func _apply_motion(delta):
	var floor_slope = rad2deg(atan2(get_floor_normal().y, get_floor_normal().x))+90
	if abs(floor_slope) > 0 && [SM.states.idle, SM.states.walk].has(SM.state):
		if x_input == 0 && motion.y > 0:
			if floor_slope < 0 && direction:
				motion.y = 0
				motion.x = 0
			elif floor_slope > 0 && !direction:
				motion.y = 0
				motion.x = 0
		if motion.y < 0:
			motion.x = clamp(motion.x, -MAX_SPEED*0.75, MAX_SPEED*0.75)
		motion.y = move_and_slide(motion, Vector2.UP, 1, 4, SLOPE_THRESHOLD, false).y
	else:
		motion = move_and_slide(motion, Vector2.UP, 1, 4, SLOPE_THRESHOLD, false)

func _process_tool():
	var _tool = get_node_or_null("Body/Tool")
	if _tool: _tool.Update(looking_direction, direction)
	self._tool = _tool
