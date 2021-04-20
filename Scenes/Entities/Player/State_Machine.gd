extends StateMachine

var coyote_time = 0

func _ready():
	add_state("jump")
	add_state("fall")
	add_state("idle")
	add_state("walk")
	call_deferred("set_state", states.fall)

func _state_logic(delta):
	determine_input()
	parent._process_tool()
	parent._process_physics(delta)
	parent.BODY.Update(self, parent.direction)
	#print(state)
	
func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.motion.y < 0:
					return states.jump
				elif parent.motion.y > 0:
					return states.fall
			elif parent.x_input != 0:
				return states.walk
		states.walk:
			if !parent.is_on_floor():
				if parent.motion.y < 0:
					return states.jump
				elif parent.motion.y > 0:
					return states.fall
			elif parent.x_input == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.motion.y > 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.motion.y < 0:
				return states.jump
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			pass
		states.walk:
			pass
		states.jump:
			pass
		states.fall:
			pass
	
func _exit_state(old_state, new_state):
	pass
	
#Input logic
func determine_input():
	_determine_x_input()
	_determine_jump_input()
	_determine_look_input()
	_determine_action_input()
		
func _determine_x_input():
	var x = 0
	x = Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT")
	if x:
		if parent.is_on_wall(): x *= 0.5
		parent.direction = x > 0
	parent.x_input = x

func _determine_jump_input():
	if [states.idle, states.walk].has(state): 
		coyote_time = parent.COYOTE_TIME
	else:
		coyote_time -= 1
		
	if Input.is_action_just_pressed("JUMP") and coyote_time > 0:
		parent.motion.y = -parent.JUMP_FORCE
		coyote_time = 0
	if state == states.jump:
		if Input.is_action_just_released("JUMP") and abs(parent.motion.y) > 0:
			parent.motion.y *= 0.5
		
func _determine_look_input():
	if Input.is_action_pressed("UP"):
		parent.looking_direction = parent.UP
	elif Input.is_action_pressed("DOWN"):
		parent.looking_direction = parent.DOWN
	else:
		parent.looking_direction = parent.NONE

func _determine_action_input():
	if parent._tool:
		parent._determine_tool_direction_lock()
		if Input.is_action_pressed("BUTTON_A"):
			parent._tool.Primary(parent.direction, parent.looking_direction, parent.motion)
		if Input.is_action_just_released("BUTTON_A"):
			parent._tool.Primary_Release(parent.direction, parent.looking_direction, parent.motion)
		
		if Input.is_action_pressed("BUTTON_B"):
			parent._tool.Secondary(parent.direction, parent.looking_direction, parent.motion)
		if Input.is_action_just_released("BUTTON_B"):
			parent._tool.Secondary_Release(parent.direction, parent.looking_direction, parent.motion)
