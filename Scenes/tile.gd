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

var trail_levels = {"blue": 0, "red":0}

var tile_type = "dirt"

var selectable : bool = false


signal clicked(tile)

func _ready():
	$CaptureTimer.set_wait_time(TIME_TO_CAP)

func create_new_tile(_coordinates = Vector2(0,0), terrain_type : int = GameData.TERRAIN.DIRT) -> void:
	coordinates = _coordinates
	
	set_position(Utils.coordinates_to_global(coordinates) )
	
	set_z_index(position.y*0.8)
	set_sprite(terrain_type)
	tile_type = terrain_type

func set_sprite(terrain_type : int) -> void:
	$TerrainSprite.set_texture(load("res://Assets/sample_tiles/" + str(terrain_type) + ".png"))
	$TerrainSprite.offset.y = -Utils.TILE_HEIGHT

func get_top_pos() -> Vector2:
	return get_position() + Vector2(0,-Utils.TILE_THICK*(levels.size()-1))

#func will_highlight(yes : bool) -> void:
#	if yes:
#		highlight.set_position(get_top_pos()-get_position())
#	highlight.set_visible(yes)


func decrement_trail_level(color) -> void:
	trail_levels[color] = max(1, pow(trail_levels[color],0.65))

func set_trail_level(color, t_level : int) -> void:
	trail_levels[color] = t_level

#func _on_area_2d_mouse_entered():
#	if selectable:
#		will_highlight(true)

#func _on_area_2d_mouse_exited():
#	will_highlight(false)

#func _on_area_2d_input_event(viewport, event, shape_idx):
#	if selectable:
#		if event is InputEventMouseButton:
#			if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
#				clicked.emit(self)

func occupy(slime : Slime) -> void:
	entity = slime
#	if tile_type == "capture":
#		capturing = slime.aggro
#		$CaptureTimer.start()
#		captured_by = slime.aggro
#		$TerrainSprite.set_modulate(GameData.COLORS[captured_by.player_color])

func leave() -> void:
	entity = null
	$CaptureTimer.stop()

#
#func global_tick():
#	if captured_by:
#		captured_by.add_score(point_score)
#		$ScoreEffect.set_position(Vector2(0,0))
#		$ScoreEffect.set_modulate(GameData.COLORS[captured_by.player_color])
#		var transparent = GameData.COLORS[captured_by.player_color]
#		transparent.a = 0
#		$ScoreEffect.show()
#		var tween = get_tree().create_tween()
#		tween.tween_property($ScoreEffect, "position", Vector2(0,-130), 0.6)
#		tween.parallel().tween_property($ScoreEffect, "modulate", transparent, 0.6)
		
