extends Area2D

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	var frame = rng.randi_range(0, 12)
	if frame > 10:
		frame = rng.randi_range(11, 15)
	$Sprite.frame = frame

func make_shader_unique(pos):
	$Sprite.material = $Sprite.material.duplicate()
	$Sprite.material.set_shader_param("global_position", pos)


func _on_Grass_body_entered(body):
	var direction = position.x - body.position.x
	if direction > 0:
		$AnimationPlayer.play("Shuffle_Right")
	else:
		$AnimationPlayer.play("Shuffle_Left")


func _on_Grass_area_entered(area):
	var direction = position.x - area.position.x
	if direction > 0:
		$AnimationPlayer.play("Shuffle_Right")
	else:
		$AnimationPlayer.play("Shuffle_Left")
