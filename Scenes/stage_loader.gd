extends Node2D

var stage_info 

@onready var map : Map2D = $Grid
@onready var player : Player = $Player
@onready var slime_container = $SlimeContainer
@onready var tool_handler = $ToolHandler

var slime_scene = preload("res://Scenes/slime.tscn")

func set_stage_info(info : Dictionary) -> void:
	stage_info = info
	

func load_stage() -> void:
	if stage_info:
		
		for tile in stage_info.map:
			map.add_new_tile(tile[0], tile[1])
		player.set_starting_position(stage_info.player_start)
		for slime in stage_info.slimes:
			var new_slime : Slime = slime_scene.instantiate()
			slime_container.add_child(new_slime)
			new_slime.set_starting_position(slime[0])
			new_slime.set_type(slime[1])
			new_slime.landed.connect(map.change_top_level)
			
func get_click_info(target_tile):
	var entity = null
	if player.current_coord == target_tile.coordinates:
		entity = player
	else:
		for slime in slime_container.get_children():
			if slime.current_coord == target_tile.coordinates:
				entity = slime
	tool_handler.use_tool(target_tile, entity)

func _ready():
	player.landed.connect(map.update_trails)
	player.landed.connect(map.update_selectables)
	map.tile_clicked.connect(get_click_info)
	
	stage_info = StageData.LEVEL_DATA["level_2"]
	load_stage()
