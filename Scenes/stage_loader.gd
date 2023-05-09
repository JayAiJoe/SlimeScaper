extends Node2D

var stage_info 

@onready var map : Map2D = $Grid
@onready var player_container  = $PlayerContainer
@onready var slime_container = $SlimeContainer
@onready var tool_handler = $ToolHandler

var slime_scene = preload("res://Scenes/slime.tscn")

func set_stage_info(info : Dictionary) -> void:
	stage_info = info

func load_stage() -> void:
	if stage_info:
		
		for tile in stage_info.map:
			map.add_new_tile(tile[0], tile[1])
		for player in player_container.get_children():
			player.set_starting_position(stage_info[player.player_color+"_start"])
		for slime in stage_info.slimes:
			var new_slime : Slime = slime_scene.instantiate()
			slime_container.add_child(new_slime)
			new_slime.set_starting_position(slime[0])
			new_slime.set_type(slime[1])
			new_slime.landed.connect(map.change_top_level)
			
func get_click_info(target_tile):
	var entity = null
	tool_handler.use_tool(target_tile, entity)

func _ready():
	for player in player_container.get_children():
		player.landed.connect(map.update_trails)
		player.landed.connect(map.update_selectables)
	map.tile_clicked.connect(get_click_info)
	
	stage_info = StageData.LEVEL_DATA["level_2"]
	load_stage()
