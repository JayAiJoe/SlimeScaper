extends Node2D

var stage_info 

@onready var map : Map2D = $Grid
@onready var player : Player = $Player
@onready var slime_container = $SlimeContainer

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
			
	

func _ready():
	player.landed.connect(map.update_trails)
	
	
	stage_info = StageData.level_1
	load_stage()
