extends Area2D

export var mass = 0.5

var launched = false
var velocity = Vector2(0,0)

var max_life_time = 10
var life_time = 10

func _ready():
	$Sprite.visible = false
	pass
	
func _physics_process(delta):
	z_index = 1
	if launched:
		if !$Sprite.visible: $Sprite.visible = true
		position+= velocity*delta
		rotation = velocity.angle()
		life_time -= 1
		
		var life_key = float(float(max_life_time) / 5.0)
		if life_time / life_key > 4:
			$AnimationPlayer.play("Stage_1")
		elif life_time / life_key > 3:
			$AnimationPlayer.play("Stage_2")
		elif life_time / life_key > 2:
			$AnimationPlayer.play("Stage_3")
		elif life_time / life_key > 1:
			$AnimationPlayer.play("Stage_4")
		elif life_time / life_key > 0:
			$AnimationPlayer.play("Stage_5")
		else:
			get_parent().remove_child(self)
		
func Launch(initial_velocity: Vector2, life_length, scale_change, full_charge):
	if full_charge:
		scale_change *= 1.5
		life_length *= 1.5
	scale.y = scale_change
	launched = true
	$CollisionShape2D.disabled = false
	velocity = initial_velocity
	max_life_time = life_length
	life_time = max_life_time
