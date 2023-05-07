extends Node2D

var TILE = preload("res://Scenes/tile_2d.tscn")

var grid = {}

func _ready():
	Utils.grid = self
	add_new_tile(Vector2(1,1), "walow")
	add_new_tile(Vector2(1,0), "walow")
	add_new_tile(Vector2(0,1), "walow")
	add_new_tile(Vector2(0,0), "walow")
	add_new_tile(Vector2(-1,1), "walow")
	add_new_tile(Vector2(-1,1), "walow")
	add_new_tile(Vector2(-1,1), "walow")
	add_new_tile(Vector2(0,1), "walow")
	
	connect_starting_signals()
	randomize()
	

func connect_starting_signals() -> void:
	$Player.landed.connect(change_top_level) #test functionm
	
func add_new_tile(coordinates : Vector2, terrain : String) -> void:
	if coordinates in grid:
		grid[coordinates].add_level(terrain)
	else:
		var new_tile = TILE.instantiate()
		new_tile.create_new_tile(coordinates, terrain)
		grid[coordinates] = new_tile
		add_child(new_tile)
	#fix global scaling

func change_top_level(coordinates : Vector2) -> void:
	#grid[coordinates].change_top_level(randi() % GameData.TERRAIN_TYPES.size())
	pass
