extends Sprite

func _ready():
	modulate.r *= 120.0
	modulate.g *= 120.0
	modulate.b *= 120.0

func _process(delta):
	if position.y > 10:
		var rgb_mod = 5 - ((position.y-10)/6)
		var alpha_mod = rgb_mod
		if(rgb_mod <= 1):
			rgb_mod = 1
		modulate.r = rgb_mod
		modulate.g = rgb_mod
		modulate.b = rgb_mod
		modulate.a = alpha_mod
	else:
		var rgb_mod = 10
		modulate.r = rgb_mod
		modulate.g = rgb_mod
		modulate.b = rgb_mod
		modulate.a = rgb_mod
