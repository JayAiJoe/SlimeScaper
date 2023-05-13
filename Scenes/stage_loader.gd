extends Node2D

var stage_info 

@onready var map : Map2D = $Grid
@onready var player_container  = $PlayerContainer
@onready var slime_container = $SlimeContainer

@export var is_main_menu = false

var slime_scene = preload("res://Scenes/slime.tscn")

var ready_players = 0
var max_ready_time = 3
var ready_decay = 1

const MAX_COUNTDOWN = 3
var COUNTDOWN = MAX_COUNTDOWN

func set_stage_info(info : Dictionary) -> void:
	stage_info = info

func load_stage() -> void:
	if stage_info:
		var cauldrons = []
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
			cauldrons[i].ingredient_placed.connect($Recipes.get_children()[i].receive_ingredient)
			cauldrons[i].player_owner = GameData.COLORS.keys()[i]
		
		var idx = 0
		for indicator in $Recipes.get_children():
			indicator.recipe_requested.connect($RecipeHandler.handle_recipe_request)
			indicator.request_new_recipe()
			indicator.player_color = GameData.COLORS.keys()[idx]
			idx += 1
			
#		for slime_pos in stage_info.slimes:
#			var new_slime : Slime = slime_scene.instantiate()
#			slime_container.add_child(new_slime)
#			new_slime.set_starting_position(slime_pos)
#			new_slime.set_type(StageData.SLIME.GRASS)
			#new_slime.landed.connect(map.change_top_level)

func update_ready(delta):
	ready_players += delta

func _ready():
	Events.connect("ready_player", update_ready)
	for player in player_container.get_children():
		player.landed.connect(map.update_trails)
		#player.landed.connect(map.update_selectables)
	
	map.slime_container = slime_container
	
	if is_main_menu:
		for player in player_container.get_children():
			player.show_keys()
		stage_info = StageData.LEVEL_DATA["main_menu"]
		Events.connect("slime_absorbed", map.spawn_fixed_slimes)
		Events.disconnect("points_gained", HUD.update_score)
		$Prompts/TextureProgressBar.set_max(max_ready_time)
		start_round()
	else:
		stage_info = StageData.LEVEL_DATA["garden1"]
		Events.connect("slime_absorbed", map.spawn_random_slime)
		#$WINCON.show()
		set_physics_process(false)
		$round_start_timer.set_wait_time(1)
		$round_start_timer.start()
		HUD.display_number(COUNTDOWN)
		
	$RecipeHandler.init_recipe_list(is_main_menu)
	var recipe_sum = $RecipeHandler.recipe_nums.reduce(func(accum, number): return accum + number,0)
	#$WINCON.set_text("First to complete %d recipes wins!" % recipe_sum)
	load_stage()

func _physics_process(delta):
	if ready_players == 2:
		$Prompts/TextureProgressBar.set_value($Prompts/TextureProgressBar.get_value()+delta)
		if $Prompts/TextureProgressBar.get_value() >= $Prompts/TextureProgressBar.get_max():
			get_tree().change_scene_to_file("res://Scenes/stage_loader.tscn")
	else:
		$Prompts/TextureProgressBar.set_value($Prompts/TextureProgressBar.get_value()-delta*ready_decay)

func _on_round_start_timer_timeout():
	COUNTDOWN -= 1
	if COUNTDOWN == 0:
		HUD.display_number("START")
		start_round()
	else:
		HUD.display_number(COUNTDOWN)
		$round_start_timer.start()

func start_round():
	for player in player_container.get_children():
		player.paused = false
