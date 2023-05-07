extends Node2D
class_name Tile2D

var coordinates  = Vector2(0,0)
var levels = []
@onready var highlight = $Highlight

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
	var new_sprite = Sprite2D.new()
	new_sprite.set_texture(load("res://Assets/sample_tiles/dirt_E.png"))
	new_sprite.set_position(Vector2(0,-Utils.TILE_THICK*(levels.size()-1)))
	new_sprite.set_offset(Vector2(0,-1)*103)
	add_child(new_sprite)
	levels.append(new_sprite)

func get_top_pos() -> Vector2:
	return get_position() + Vector2(0,-Utils.TILE_THICK*(levels.size()-1))

func will_highlight(yes : bool) -> void:
	if yes:
		highlight.set_position(get_top_pos()-get_position())
	highlight.set_visible(yes)
