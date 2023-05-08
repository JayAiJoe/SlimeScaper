extends Node2D
class_name Map2D

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
	#test_grid()

func test_grid():
	var coords = Utils.get_coords_in_radius(Vector2(0,0),3, true)
	for coord in coords:
		add_new_tile(coord)
	coords = Utils.get_coords_in_ring(Vector2(1,1),2)
	for coord in coords:
		add_new_tile(coord)
	highlight_tiles(Utils.get_coords_in_radius(Vector2(1,1),2, true))
	

func generate_main_menu():
	var coords = Utils.get_coords_in_radius(Vector2(0,0),10, true)
	for coord in coords:
		add_new_tile(coord)

func connect_starting_signals() -> void:
	#$slime.landed.connect(change_top_level) #test functionm
	pass
	
func add_new_tile(coordinates : Vector2, terrain : int = GameData.TERRAIN.DIRT) -> void:
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
		#print("top_left ",top_left)
		#print("bot_right ",bot_right)
		if max_length:
			map_scale = Utils.SCREEN_HEIGHT/max_length*0.85
		var cam_pos = top_left + (bot_right-top_left)/2
		var cam_zoom = map_scale*Vector2(1,1)
		Events.emit_signal("resize_camera", cam_pos, cam_zoom)

func highlight_tiles(tiles:Array) -> void:
	for coord in tiles:
		if coord in grid:
			grid[coord].will_highlight(true)

func change_top_level(coordinates : Vector2, slime_type : int) -> void:
	var top_level : Level = grid[coordinates].get_top_level()
	if top_level.type in GameData.REACTIONS and slime_type in GameData.REACTIONS[top_level.type]:
		top_level.set_type(GameData.REACTIONS[top_level.type][slime_type])

func update_trails(new_coords : Vector2) -> void:
	for tile in grid.values():
		(tile as Tile2D).decrement_trail_level()
	(grid[new_coords] as Tile2D).set_trail_level(GameData.PLAYER_TRAIL_STRENGTH)
