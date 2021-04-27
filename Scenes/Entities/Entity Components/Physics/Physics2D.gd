extends Node2D

const TARGET_FPS = Engine.iterations_per_second

const ACCELERATION = 15
const MAX_SPEED = 80
const FRICTION = 18
const AIR_RESISTANCE = 1
const GRAVITY = 9.807
const TERMINAL_VELOCITY = 400.0
const SLOPE_THRESHOLD = deg2rad(50)

const SWIM_ACCELERATION = 10
const SWIM_MAX_SPEED = 50
const SWIM_RESISTANCE = 5

const SWIM_FLOAT_SPEED = 10
const SWIM_MAX_FLOAT_SPEED = 50
const SWIM_MAX_SINK_SPEED = 250
const SWIM_BUOYANCY = 1

var surface_clamp = false

var motion = Vector2.ZERO
var direction = 0

var jumping = false

onready var WATER_LEVEL = $Water_Level
onready var PARENT = get_parent()

#water stuff
var water_bounds = Vector2(0,0)
var in_water = false

func _process_physics(x_input, on_surface, delta):
	if !_determine_is_in_water():
		_process_horizontal_motion(x_input, on_surface, delta)
		_process_vertical_motion(delta)
		_apply_motion(x_input, on_surface, delta)
	else:
		_water_process_horizontal_motion(x_input, on_surface, delta)
		_water_process_vertical_motion(delta)
		_handle_surfacing(delta)
		_water_apply_motion(x_input, on_surface, delta)

func _process_horizontal_motion(x_input, on_surface, delta):
	motion.x += x_input * ACCELERATION * delta * TARGET_FPS
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	if on_surface:
		if !x_input: motion.x = lerp(motion.x, 0, FRICTION * delta)
	else:
		if !x_input: motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)	
		
func _process_vertical_motion(delta):
	motion.y += GRAVITY * delta * TARGET_FPS
	motion.y = min(motion.y, TERMINAL_VELOCITY)
	
func _apply_motion(x_input, on_surface, delta):
	var floor_slope = rad2deg(atan2(PARENT.get_floor_normal().y, PARENT.get_floor_normal().x))+90
	if abs(floor_slope) > 0 && on_surface:
		if x_input == 0 && motion.y > 0:
			if floor_slope < 0 && direction:
				motion.y = 0
				motion.x = 0
			elif floor_slope > 0 && !direction:
				motion.y = 0
				motion.x = 0
		if motion.y < 0:
			motion.x = clamp(motion.x, -MAX_SPEED*0.75, MAX_SPEED*0.75)
		motion.y = PARENT.move_and_slide(motion, Vector2.UP, 1, 4, SLOPE_THRESHOLD, false).y
	else:
		motion = PARENT.move_and_slide(motion, Vector2.UP, 1, 4, SLOPE_THRESHOLD, false)
	PARENT.motion = motion

#Water
func _water_process_horizontal_motion(x_input, on_surface, delta):
	motion.x += x_input * SWIM_ACCELERATION * delta * TARGET_FPS
	motion.x = clamp(motion.x, -SWIM_MAX_SPEED, SWIM_MAX_SPEED)
	if !x_input: motion.x = lerp(motion.x, 0, SWIM_RESISTANCE * delta)
		
func _water_process_vertical_motion(delta):
	if !SWIM_BUOYANCY:
		motion.y += GRAVITY * delta * TARGET_FPS
	elif !jumping:
		motion.y += -SWIM_FLOAT_SPEED * delta * TARGET_FPS
	if !jumping:
		motion.y = max(motion.y, -SWIM_MAX_FLOAT_SPEED)
		motion.y = min(motion.y, SWIM_MAX_SINK_SPEED)
	
func _water_apply_motion(x_input, on_surface, delta):
	motion = PARENT.move_and_slide(motion)
	if motion.y > 0:
		jumping = false

func _handle_surfacing(delta):
	if jumping:
		surface_clamp = false
	elif surface_clamp:
		if abs(WATER_LEVEL.global_position.y - water_bounds.x) < 1.5:
			PARENT.position.y = (water_bounds.x + 1) - WATER_LEVEL.position.y
			motion.y = 0
		else:
			surface_clamp = false
	elif motion.y < 0 && abs(WATER_LEVEL.global_position.y - water_bounds.x) < 1:
		motion.y = ((water_bounds.x + 1) - WATER_LEVEL.global_position.y)/delta
		if abs(motion.y) < 0.25:
			motion.y = 0
			surface_clamp = true
		
func _determine_is_in_water():
	if in_water:
		if !PARENT.is_on_floor():
			if WATER_LEVEL.global_position.y >= water_bounds.x || surface_clamp:
				return true
	return false

func _determine_can_jump_out_of_water():
	if in_water:
		if WATER_LEVEL.global_position.y <= water_bounds.x + 8 && motion.y < 15:
			return true
	return false
