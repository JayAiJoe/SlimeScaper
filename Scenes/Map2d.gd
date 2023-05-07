extends Node2D

var TILE = preload("res://Scenes/tile_2d.tscn")

@export var level = "main menu"

var grid = {}

var top_left = Vector2()
var bot_right = Vector2()
var map_scale = 1

func _ready():
	Utils.grid = self
	connect_starting_signals()
	randomize()
	
	if level == "main menu":
		generate_main_menu()
	else:
		test_grid()

func test_grid():
	var coords = get_coords_in_radius(Vector2(0,0),3, true)
	for i in range(7):
		add_new_tile(Vector2(i,-i))
	

func generate_main_menu():
	var coords = get_coords_in_radius(Vector2(0,0),10, true)
	for coord in coords:
		add_new_tile(coord)

func connect_starting_signals() -> void:
	$Player.landed.connect(change_top_level) #test functionm
	
func add_new_tile(coordinates : Vector2, terrain = "dirt") -> void:
	if coordinates in grid:
		grid[coordinates].add_level(terrain)
	else:
		var new_tile = TILE.instantiate()
		new_tile.create_new_tile(coordinates, terrain)
		check_grid_size(new_tile.position)
		grid[coordinates] = new_tile
		add_child(new_tile)
		
	#fix global scaling

func check_grid_size(new_tile_pos: Vector2):
	var old_tl = top_left
	var old_br = bot_right
	if grid.is_empty():
		top_left = new_tile_pos
		bot_right = new_tile_pos
	else:
		top_left.x = min(top_left.x, new_tile_pos.x)
		top_left.y = min(top_left.y, new_tile_pos.y)
		bot_right.x = max(bot_right.x, new_tile_pos.x)
		bot_right.y = max(bot_right.y, new_tile_pos.y)
	
	if old_tl != top_left or old_br != bot_right:
		#resize na
		var max_length = max(bot_right.x - top_left.x, bot_right.y - top_left.y)
		print("top_left ",top_left)
		print("bot_right ",bot_right)
		if max_length:
			map_scale = Utils.SCREEN_HEIGHT/max_length*0.9
		$Camera.set_zoom(map_scale*Vector2(1,1))
		$Camera.set_position(Vector2((bot_right.x + top_left.x)/2,(bot_right.y + top_left.y)/2))

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
