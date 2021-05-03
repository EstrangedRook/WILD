extends Node2D


export var no_of_low_stars = 20
export var no_of_med_stars = 20
export var no_of_high_stars = 20
export var width = 320
export var height = 180
export var flicker_frequency = 60

var stars = Array()
var stars_in_use = Array()
var twinkling_stars = Array()

var star_tiny = load("res://Scenes/Entities/Parallax/Star/Star_Tiny.tscn")
var star_small = load("res://Scenes/Entities/Parallax/Star/Star_Small.tscn")
var star_medium = load("res://Scenes/Entities/Parallax/Star/Star_Medium.tscn")
var star_large = load("res://Scenes/Entities/Parallax/Star/Star_Large.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in int(no_of_low_stars):
		generate_star(height*0.35, 0, 0)
	for i in int(no_of_med_stars):
		generate_star(height*0.70, height*0.35, 2)
	for i in int(no_of_high_stars):
		generate_star(height-1, height*0.70, 3)
	stars_in_use.clear()

func _physics_process(delta):
	Global.Random.randomize()
	var rand = Global.Random.randi_range(0, flicker_frequency)
	if rand == flicker_frequency:
		rand = Global.Random.randi_range(0, (no_of_low_stars+no_of_med_stars+no_of_high_stars) - 1)
		if !stars_in_use.has(rand):
			stars_in_use.append(rand)
			twinkling_stars.append(Twinkling_Star.new(rand, stars[rand], Global.Random.randi_range(1, 4), Global.Random.randi_range(60, 300)))
	for i in twinkling_stars:
		if i.done_twinkle:
			stars_in_use.erase(i.star_id)
			twinkling_stars.erase(i)
		else:
			i.update()

func generate_star(max_height, min_height, star_tier):
		max_height = height-max_height
		min_height = height - min_height
		var progress = false
		Global.Random.randomize()
		var star_position = Vector2(0,0)
		while !progress:
			star_position = Vector2(Global.Random.randi_range(1, width - 1), Global.Random.randi_range(min_height, max_height))
			if !stars_in_use.has(star_position.x + star_position.y):
				progress = true
				stars_in_use.append((star_position.x + star_position.y))
		var instance
		var rand_type = Global.Random.randi_range(0, 100)
		if rand_type < 2 && star_tier >= 3:
			instance = star_large.instance()
			star_position.x += 0.5
			star_position.y += 0.5
		elif rand_type < 8 && star_tier >= 2:
			instance = star_medium.instance()
		elif rand_type < 25 && star_tier >= 1:
			instance = star_small.instance()
		else:
			instance = star_tiny.instance()
			star_position.x += 0.5
			star_position.y += 0.5
		instance.position = star_position
		instance.frame = Global.Random.randi_range(0, 5)
		add_child(instance)
		stars.append(instance)
	
class Twinkling_Star:
	var twinkle_value = 255
	var twinkle_speed = -1
	var dead_time = 20
	var star
	var star_id = 0
	var done_twinkle = false
	
	func _init(_star_id, _star, speed, d_time):
		star_id = _star_id
		star = _star
		twinkle_speed = speed
		dead_time = d_time
		
	func update():
		if twinkle_value <= 0:
			if dead_time > 0:
				dead_time -= 1
			else:
				twinkle_speed *= -1
				twinkle_value -= twinkle_speed
		else:
			twinkle_value -= twinkle_speed
			if twinkle_value >= 255:
				done_twinkle = true
		star.modulate.a = float(float(twinkle_value)/255.0)
		
