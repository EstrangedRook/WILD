extends Node2D


export var no_of_stars = 20
export var width = 320
export var height = 180

# Called when the node enters the scene tree for the first time.
func _ready():
	var star_tiny = load("res://Scenes/Entities/Parallax/Star/Star_Tiny.tscn")
	var star_small = load("res://Scenes/Entities/Parallax/Star/Star_Small.tscn")
	var star_medium = load("res://Scenes/Entities/Parallax/Star/Star_Medium.tscn")
	var star_large = load("res://Scenes/Entities/Parallax/Star/Star_Large.tscn")
	var star_pos_memory = Array()
	for i in no_of_stars:
		var progress = false
		Global.Random.randomize()
		var star_position = Vector2(0,0)
		while !progress:
			star_position = Vector2(Global.Random.randi_range(1, width - 1), Global.Random.randi_range(1, height - 1))
			if !star_pos_memory.has(star_position.x + star_position.y):
				progress = true
				star_pos_memory.append((star_position.x + star_position.y))
		var instance
		var rand_type = Global.Random.randi_range(0, 100)
		if rand_type < 50:
			instance = star_tiny.instance()
			star_position.x += 0.5
			star_position.y += 0.5
		elif rand_type < 80:
			instance = star_small.instance()
		elif rand_type < 95:
			instance = star_medium.instance()
		else:
			instance = star_large.instance()
		instance.position = star_position
		instance.frame = Global.Random.randi_range(0, 5)
		add_child(instance)
