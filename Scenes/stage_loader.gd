extends Node2D

@onready var map : Map2D = $Grid
@onready var slime_container = $SlimeContainer

@export var is_tutorial = false

var slime_scene = preload("res://Scenes/slime.tscn")

var cauldrons : Array
var player_start : Array

const colored_cauldron_textures = {"blue":preload("res://Assets/sample_tiles/CauldronBlue.png"),
									"red":preload("res://Assets/sample_tiles/CauldronRed.png")}

func load_stage(map_name:String) -> void:
	if not map_name in StageData.LEVEL_DATA:
		printerr("UNRECOGNIZE MAP NAME: ",map_name)
		return
	var stage_info = StageData.LEVEL_DATA[map_name]
	if stage_info:
		cauldrons = []
		for tile_type in stage_info.map:
			for tile_coord in stage_info.map[tile_type]:
				var new_tile = map.add_new_tile(tile_coord, tile_type)
				if tile_type == GameData.TERRAIN.ROCK:
					cauldrons.append(new_tile)
		
		player_start = stage_info["player_start_positions"]
		
		if is_tutorial:
			for i in range(4):
				map.spawn_fixed_slimes(i)
		else:
			for i in range(stage_info["num_slimes"]):
				map.spawn_random_slime()
		
		for i in range(cauldrons.size()):
			cauldrons[i].player_owner = GameData.COLORS.keys()[i]
			cauldrons[i].set_cauldron(colored_cauldron_textures[cauldrons[i].player_owner])
		

func _ready():
	HUD.set_in_game(true)
	map.slime_container = slime_container
	if is_tutorial:
		Events.connect("slime_absorbed", map.spawn_fixed_slimes)
	else:
		Events.connect("slime_absorbed", map.spawn_random_slime)
		set_physics_process(false)
	
