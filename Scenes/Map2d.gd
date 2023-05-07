extends Node2D


const TILE = preload("res://Scenes/tile_2d.tscn")

var grid = {}

func _ready():
	
	add_new_tile(Vector2(1,1), "walow")
	add_new_tile(Vector2(1,0), "walow")
	add_new_tile(Vector2(0,1), "walow")
	add_new_tile(Vector2(0,0), "walow")
	add_new_tile(Vector2(-1,1), "walow")

func add_new_tile(coordinates : Vector2, state : String) -> void:
	if coordinates in grid:
		return
	var new_tile = TILE.instantiate()
	new_tile.init(coordinates, state)
	print(coordinates)
	print(Utils.coordinates_to_global(coordinates))
	grid[coordinates] = new_tile
	add_child(new_tile)
	#fix global scaling
