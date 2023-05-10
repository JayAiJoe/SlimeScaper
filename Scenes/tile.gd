extends Node2D
class_name Tile

var coordinates  = Vector2(0,0)
var Level = preload("res://Scenes/level.tscn")
var levels = []
var entity = null

var capturing = null
var captured_by = null
var point_score = 1
const TIME_TO_CAP = 3

var trail_level : int = 0

@onready var highlight = $Highlight

var tile_type = "dirt"

var selectable : bool = false

var colors = {"blue":Color(0,0,1), "red":Color(1,0,0)}
signal clicked(tile)

func _ready():
	$CaptureTimer.set_wait_time(TIME_TO_CAP)

func create_new_tile(_coordinates = Vector2(0,0), terrain_type : int = GameData.TERRAIN.DIRT) -> void:
	coordinates = _coordinates
	
	set_position(Utils.coordinates_to_global(coordinates) )
	
	set_z_index(position.y*0.8)
	set_sprite(terrain_type)
	if terrain_type == StageData.TERRAIN.ROCK:
		tile_type = "capture"
		Events.connect("global_tick", global_tick)

func set_sprite(terrain_type : int) -> void:
	$TerrainSprite.set_texture(load("res://Assets/sample_tiles/" + str(terrain_type) + ".png"))
	$TerrainSprite.offset.y = -Utils.TILE_HEIGHT

func get_top_pos() -> Vector2:
	return get_position() + Vector2(0,-Utils.TILE_THICK*(levels.size()-1))

func will_highlight(yes : bool) -> void:
	if yes:
		highlight.set_position(get_top_pos()-get_position())
	highlight.set_visible(yes)


func decrement_trail_level() -> void:
	trail_level = max(0, trail_level - 1)

func set_trail_level(t_level : int) -> void:
	trail_level = t_level

func _on_area_2d_mouse_entered():
	if selectable:
		will_highlight(true)

func _on_area_2d_mouse_exited():
	will_highlight(false)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if selectable:
		if event is InputEventMouseButton:
			if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
				clicked.emit(self)

func occupy(slime : Slime) -> void:
	entity = slime
	if tile_type == "capture":
		capturing = slime.aggro
		$CaptureTimer.start()
		captured_by = slime.aggro
		$TerrainSprite.set_modulate(colors[captured_by.player_color])

func leave() -> void:
	entity = null
	$CaptureTimer.stop()


func global_tick():
	if captured_by:
		captured_by.add_score(point_score)
