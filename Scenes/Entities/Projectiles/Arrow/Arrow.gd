extends Area2D

export var mass = 0.5

var launched = false
var velocity = Vector2(0,0)
var pierce_target
var decay_timer = 500
var drop_ignore_timer = 10

func _ready():
	$CollisionShape2D.disabled = true
	pass
	
func _physics_process(delta):
	if launched:
		if drop_ignore_timer <= 0: 
			velocity += gravity_vec*gravity*mass
		else: 
			drop_ignore_timer -= 1
		position+= velocity*delta
		rotation = velocity.angle()
		if pierce_target:
			position = global_position - pierce_target.global_position
			$CollisionShape2D.disabled = true
			launched = false
			get_parent().remove_child(self)
			var temp_target = pierce_target.get_node_or_null("Body")
			z_index = -1
			if temp_target:
				temp_target.add_child(self)
			else:
				pierce_target.add_child(self)
	elif pierce_target:
		decay_timer -= 1
		if decay_timer <= 0:
			get_parent().remove_child(self)
	
	if rotation_degrees > 90 || rotation_degrees < -90:
		$Sprite.frame = 1
	else:
		$Sprite.frame = 0
		
func Launch(initial_velocity: Vector2):
	launched = true
	$CollisionShape2D.disabled = false
	velocity = initial_velocity

func _on_Arrow_body_entered(body):
	if launched:
		pierce_target = body

func Offset(value):
	$Sprite.position.x = value
