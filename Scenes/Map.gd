extends Node2D
class_name Map2D

var TILE = preload("res://Scenes/tile.tscn")
var CAPTURE_POINT_TILE = preload("res://Scenes/capture_point_tile.tscn")
var READY_TILE = preload("res://Scenes/ready_tile.tscn")
var slime_scene = preload("res://Scenes/slime.tscn")

@export var level = "main menu"

var slime_container

var grid = {}
var garden_coords = []

var top_left = Vector2()
var bot_right = Vector2()
var map_scale = 1

var slime_deck = []

var player_color = ""

func _ready():
	Utils.map = self
	connect_starting_signals()
	randomize()
	
func generate_main_menu():
	var coords = Utils.get_coords_in_radius(Vector2(0,0),10, true)
	for coord in coords:
		add_new_tile(coord)

func connect_starting_signals() -> void:
	#$slime.landed.connect(change_top_level) #test function
	pass

func add_new_tile(coordinates : Vector2, terrain : int = GameData.TERRAIN.DIRT) -> Tile:
	if coordinates in grid:
		return null
		grid[coordinates].add_level(terrain)
	else:
		var new_tile
		if terrain == GameData.TERRAIN.WATER:
			new_tile = READY_TILE.instantiate()
		elif terrain == GameData.TERRAIN.ROCK:
			new_tile = CAPTURE_POINT_TILE.instantiate()
		else:
			new_tile = TILE.instantiate()
			
		new_tile.create_new_tile(coordinates, terrain)
		check_grid_size(new_tile.position)
		grid[coordinates] = new_tile
		if terrain == GameData.TERRAIN.GRASS:
			garden_coords.append(coordinates)
		add_child(new_tile)
		return new_tile
		

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
		if top_left == bot_right:
			return
		var max_length = min(Utils.SCREEN_WIDTH/(bot_right.x - top_left.x), Utils.SCREEN_HEIGHT/(bot_right.y - top_left.y))
		map_scale = max_length*0.9
		var cam_pos = top_left + (bot_right-top_left)/2
		var cam_zoom = map_scale*Vector2(1,1)
		#print(cam_pos," ",cam_zoom)
		Events.emit_signal("resize_camera", cam_pos, cam_zoom)

func spawn_random_slime(absorbed_slime = null) -> void:
	if absorbed_slime:
		slime_deck.remove_at(slime_deck.find(absorbed_slime.type))
	var spawn_coord = Vector2()
	while grid[spawn_coord].entity != null:
		spawn_coord = garden_coords.pick_random()
	
	var new_slime : Slime = slime_scene.instantiate()
	slime_container.add_child(new_slime)
	new_slime.set_starting_position(spawn_coord)
	var slime_type = -1
	for i in range(4):
		if not i in slime_deck:
			slime_type = i
			break
	if slime_type == -1:
		slime_type = randi()%3
		
	new_slime.set_type(slime_type)
	slime_deck.append(slime_type)

func spawn_fixed_slimes(_slime = null):
	for i in range(garden_coords.size()):
		if grid[garden_coords[i]].entity == null:
			var new_slime : Slime = slime_scene.instantiate()
			slime_container.add_child(new_slime)
			new_slime.set_starting_position(garden_coords[i])
			new_slime.set_type(i)

func highlight_tiles(tiles:Array, will_highlight = true) -> void:
	for coord in tiles:
		if coord in grid:
			grid[coord].will_highlight(will_highlight)

#func change_top_level(coordinates : Vector2, slime_type : int) -> void:
#	var top_level : Level = grid[coordinates].get_top_level()
#	if top_level.type in GameData.REACTIONS and slime_type in GameData.REACTIONS[top_level.type]:
#		top_level.set_type(GameData.REACTIONS[top_level.type][slime_type])

func update_trails( color : String,new_coords : Vector2) -> void:
	for tile in grid.values():
		(tile as Tile).decrement_trail_level(color)
	(grid[new_coords] as Tile).set_trail_level(color, GameData.PLAYER_TRAIL_STRENGTH)
#
#func update_selectables(new_coords : Vector2) -> void:
#	for tile in grid.values():
#		tile.selectable = false
#		tile.will_highlight(false)
#	for coord in Utils.get_coords_in_ring(new_coords, 1):
#		if coord in grid:
#			grid[coord].selectable = true
#
#func signal_tile_clicked(tile : Tile) -> void:
#	tile_clicked.emit(tile)

func get_pheromone_level(color : String, center:Vector2) -> float:
	var pheromone_level = pow(grid[center].trail_levels[color],5)
	for coord in Utils.get_coords_in_ring(center, 1):
		if coord in grid:
			pheromone_level += grid[coord].trail_levels[color]
	return pheromone_level
