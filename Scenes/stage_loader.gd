extends Node2D

@onready var map : Map2D = $Grid
@onready var player_container  = $PlayerContainer
@onready var slime_container = $SlimeContainer

@export var is_main_menu = false

var slime_scene = preload("res://Scenes/slime.tscn")

var ready_players = 0
var max_ready_time = 2
var ready_decay = 1

var cauldrons : Array

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
#					if tile_coord == stage_info["blue_cauldron"]:
#						new_tile.set_modulate(Color(0,0,1,1))
					cauldrons.append(new_tile)
		
		for player in player_container.get_children():
			player.set_starting_position(stage_info[player.player_color+"_start"])
		
		if is_main_menu:
			for i in range(4):
				map.spawn_fixed_slimes(i)
			Events.emit_signal("resize_camera", Vector2(960, 320), Vector2(1,1)*0.95)
		else:
			for i in range(stage_info["num_slimes"]):
				map.spawn_random_slime()
			Events.emit_signal("resize_camera", Vector2(960, 320), Vector2(1,1)*0.90566)
		
		for i in range(cauldrons.size()):

			cauldrons[i].player_owner = GameData.COLORS.keys()[i]
			cauldrons[i].set_cauldron(colored_cauldron_textures[cauldrons[i].player_owner])
		
		

func update_ready(delta):
	ready_players += delta

func _ready():
	HUD.set_in_game(true)
	Events.connect("ready_player", update_ready)
	for player in player_container.get_children():
		player.landed.connect(map.update_trails)
		#player.landed.connect(map.update_selectables)
	
	map.slime_container = slime_container
	
	if is_main_menu:
		for player in player_container.get_children():
			player.show_keys()
		Events.connect("slime_absorbed", map.spawn_fixed_slimes)
		$Prompts/TextureProgressBar.set_max(max_ready_time)
		$Recipes/RecipeIndicator.set_pips_visibility(false)
		$Recipes/RecipeIndicator2.set_pips_visibility(false)
		#start_round()
	else:
		Events.connect("slime_absorbed", map.spawn_random_slime)
		set_physics_process(false)
	

func _physics_process(delta):
	if ready_players == 2:
		$Prompts/TextureProgressBar.set_value($Prompts/TextureProgressBar.get_value()+delta)
		if $Prompts/TextureProgressBar.get_value() >= $Prompts/TextureProgressBar.get_max():
			get_tree().change_scene_to_file("res://Scenes/stage_loader.tscn")
	else:
		$Prompts/TextureProgressBar.set_value($Prompts/TextureProgressBar.get_value()-delta*ready_decay)
	
func unpause_players() -> void:
	for player in player_container.get_children():
		player.paused = false
