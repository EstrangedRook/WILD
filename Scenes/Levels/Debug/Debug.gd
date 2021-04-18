extends Node2D

var player_position
var world_size = Vector2(500,500)
onready var Main_Tile_Map = $TileMap
onready var Foreground_Foliage_Map = $Foreground_Foliage_Mask

func _ready():
	$Object_Mask.Generate_Objects()

func _process(delta):
	player_position = $Player.global_position
