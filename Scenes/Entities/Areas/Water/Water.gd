extends Node2D

func _ready():
	pass # Replace with function body.

func _on_Collider_body_entered(body):
	var index = body.position.x - position.x;
	if body.position.y > position.y + 5:
		return
	index /= $Water_Body.segment_spread
	$Water_Body.Splash(index, body.motion.y/50)

func _on_Collider_area_entered(area):
	var index = area.position.x - position.x;
	if area.position.y > position.y + 5:
		return
	index /= $Water_Body.segment_spread
	$Water_Body.Splash(index, area.motion.y/50)

func _on_Collider_body_exited(body):
	var index = body.position.x - position.x;
	if body.position.y > position.y + 5:
		return
	index /= $Water_Body.segment_spread
	$Water_Body.Splash(index, body.motion.y/50)

func _on_Collider_area_exited(area):
	var index = area.position.x - position.x;
	if area.position.y > position.y + 5:
		return
	index /= $Water_Body.segment_spread
	$Water_Body.Splash(index, area.motion.y/50)
