extends Node2D

var TILE = preload("res://Scenes/tile_2d.tscn")

var grid = {}

func _ready():
	Utils.grid = self
	var coords = get_coords_in_radius(Vector2(0,0),3)
	for coord in coords:
		add_new_tile(coord)
	
func add_new_tile(coordinates : Vector2, terrain = "dirt") -> void:
	if coordinates in grid:
		grid[coordinates].add_level(terrain)
	else:
		var new_tile = TILE.instantiate()
		new_tile.create_new_tile(coordinates, terrain)
		grid[coordinates] = new_tile
		add_child(new_tile)
	#fix global scaling

func get_ring_coords(center:Vector2, radius:int) -> Array:
	var result = []
	var current = Vector2(-1,1)*radius
	
	for dir in Utils.DIR:
		for i in range(radius):
			result.append(current)
			current += Utils.DIR[dir]
	return result
	
func get_coords_in_radius(center:Vector2, radius:int) -> Array: 
	var results = []
	for i in range(1,radius+1):
		results += get_ring_coords(center, i)
	return results
