extends Node2D
class_name Tile2D

var coordinates  = Vector2(0,0)
var Level = preload("res://Scenes/level.tscn")
var levels = []

var trail_level : int = 0

@onready var highlight = $Highlight

func _ready():
	pass # Replace with function body.

func create_new_tile(_coordinates = Vector2(0,0), terrain_type : int = GameData.TERRAIN.DIRT) -> void:
	coordinates = _coordinates
	set_position(Utils.coordinates_to_global(coordinates) )
	
	set_z_index(position.y)
	add_level(terrain_type)

func add_level(terrain_type : int) -> void:
	if levels.size() == 3:
		return
		
	var new_level = Level.instantiate()
	new_level.type = terrain_type
	add_child(new_level)
	levels.append(new_level)
	
	new_level.set_y_offset(-(Utils.TILE_HEIGHT + Utils.TILE_THICK*(levels.size()-1)))

func get_top_pos() -> Vector2:
	return get_position() + Vector2(0,-Utils.TILE_THICK*(levels.size()-1))

func will_highlight(yes : bool) -> void:
	if yes:
		highlight.set_position(get_top_pos()-get_position())
	highlight.set_visible(yes)

func get_top_level() -> Level:
	return levels[-1]

func decrement_trail_level() -> void:
	trail_level = max(0, trail_level - 1)

func set_trail_level(t_level : int) -> void:
	trail_level = t_level
