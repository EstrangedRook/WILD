extends ParallaxLayer

export(float) var speed = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	self.motion_offset.x += float(speed) * float(delta)
