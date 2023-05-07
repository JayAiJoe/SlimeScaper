extends Node2D
class_name Tile2D

var coordinates  = Vector2(0,0)
var Level = preload("res://Scenes/level.tscn")
var levels = []

func _ready():
	pass # Replace with function body.

func create_new_tile(_coordinates = Vector2(0,0), terrain_type = "undefined") -> void:
	coordinates = _coordinates
	set_position(Utils.coordinates_to_global(coordinates) )
	
	set_z_index(position.y)
	add_level(terrain_type)

func add_level(terrain_type:String) -> void:
	if levels.size() == 3:
		return
		
	var new_level = Level.instantiate()
	add_child(new_level)
	levels.append(new_level)
	
	new_level.set_position(Vector2(0,-Utils.TILE_THICK*(levels.size()-1)))
	new_level.set_y_offset(-103)


func get_top_pos() -> Vector2:
	print(get_position())
	print(-Utils.TILE_THICK*(levels.size()-1))
	return get_position() + Vector2(0,-Utils.TILE_THICK*(levels.size()-1))

func change_top_level(type : int) -> void:
	levels[-1].set_type(type)
