extends KinematicBody2D

const TARGET_FPS = Engine.iterations_per_second

const JUMP_FORCE = 210

const COYOTE_TIME = 6

var direction = 0
var x_input = 0

var motion = Vector2(0,0)

#Tools
var _tool

#Water
var in_water

onready var STATE_MACHINE = $State_Machine
onready var BODY = $Body
onready var PHYSICS = $Physics2D

func _ready():
	Global.player_camera = $Camera2D

func _physics_process(delta):
	#print(Engine.get_frames_per_second())
	#print(_determine_is_in_water())
	pass

func _process_physics(delta):
	var on_surface = [STATE_MACHINE.states.idle, STATE_MACHINE.states.walk].has(STATE_MACHINE.state)
	PHYSICS._process_physics(x_input, on_surface, delta)

func _process_tool():
	var _tool = get_node_or_null("Body/Tool")
	if _tool: _tool.Update(direction)
	self._tool = _tool
	
func _determine_tool_direction_lock():
	if _tool:
		if _tool.direction_lock && _tool.is_striking():
			var mouse_pos = rad2deg(get_local_mouse_position().angle())
			if mouse_pos > -90 && mouse_pos <= 90:
				direction = 1
			else:
				direction = 0
				
