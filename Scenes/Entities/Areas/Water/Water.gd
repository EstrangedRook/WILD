extends Node2D

var entities = {}

func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	for i in entities:
		if i.PHYSICS:
			var index = i.position.x - position.x
			index /= $Water_Body.segment_spread
			i.PHYSICS.water_bounds = $Water_Body.Water_Column_Dimensions(index)

func _on_Collider_body_entered(body):
	entities[body] = body
	var index = body.position.x - position.x
	if body.position.y > position.y + 5:
		return
	index /= $Water_Body.segment_spread
	$Water_Body.Splash(index, body.motion.y/50)
	if body.PHYSICS:
		body.PHYSICS.in_water = true

func _on_Collider_area_entered(area):
	var index = area.position.x - position.x
	if area.position.y > position.y + 5:
		return
	index /= $Water_Body.segment_spread
	$Water_Body.Splash(index, area.motion.y/50)

func _on_Collider_body_exited(body):
	entities.erase(body)
	var index = body.position.x - position.x
	if body.position.y > position.y + 5:
		return
	index /= $Water_Body.segment_spread
	$Water_Body.Splash(index, body.motion.y/50)
	if body.PHYSICS:
		body.PHYSICS.in_water = false

func _on_Collider_area_exited(area):
	var index = area.position.x - position.x
	if area.position.y > position.y + 5:
		return
	index /= $Water_Body.segment_spread
	$Water_Body.Splash(index, area.motion.y/50)
