extends Node2D

var TILE = preload("res://Scenes/tile_2d.tscn")

var grid = {}

func _ready():
	Utils.grid = self
	var coords = get_coords_in_radius(Vector2(0,0),3, true)
	for coord in coords:
		add_new_tile(coord)
	coords = get_coords_in_ring(Vector2(1,1),2)
	for coord in coords:
		add_new_tile(coord)
	highlight_tiles(get_coords_in_radius(Vector2(1,1),2, true))
	
	connect_starting_signals()
	randomize()
	

func connect_starting_signals() -> void:
	$Player.landed.connect(change_top_level) #test functionm
	
func add_new_tile(coordinates : Vector2, terrain = "dirt") -> void:
	if coordinates in grid:
		grid[coordinates].add_level(terrain)
	else:
		var new_tile = TILE.instantiate()
		new_tile.create_new_tile(coordinates, terrain)
		grid[coordinates] = new_tile
		add_child(new_tile)
	#fix global scaling

func get_coords_in_ring(center:Vector2, radius:int) -> Array:
	var result = []
	var current = Vector2(-1,1)*radius + center
	
	for dir in Utils.DIR:
		for i in range(radius):
			result.append(current)
			current += Utils.DIR[dir]
	return result
	
func get_coords_in_radius(center:Vector2, radius:int, include_center = false) -> Array: 
	var results = []
	if include_center:
		results.append(center)
	for i in range(1,radius+1):
		results += get_coords_in_ring(center, i)
	return results

func highlight_tiles(tiles:Array) -> void:
	for coord in tiles:
		if coord in grid:
			grid[coord].will_highlight(true)

func change_top_level(coordinates : Vector2) -> void:
	#grid[coordinates].change_top_level(randi() % GameData.TERRAIN_TYPES.size())
	pass
