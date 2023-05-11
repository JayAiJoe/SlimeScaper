extends Node2D

var stage_info 

@onready var map : Map2D = $Grid
@onready var player_container  = $PlayerContainer
@onready var slime_container = $SlimeContainer

@export var is_main_menu = false

var slime_scene = preload("res://Scenes/slime.tscn")

const TICK_RATE = 5

func set_stage_info(info : Dictionary) -> void:
	stage_info = info

func load_stage() -> void:
	if stage_info:
		
		for tile_type in stage_info.map:
			for tile_coord in stage_info.map[tile_type]:
				map.add_new_tile(tile_coord, tile_type)
			
		for player in player_container.get_children():
			player.set_starting_position(stage_info[player.player_color+"_start"])
		
		if is_main_menu:
			map.spawn_fixed_slimes()
		else:
			for i in range(stage_info["num_slimes"]):
				map.spawn_random_slime()
			
#		for slime_pos in stage_info.slimes:
#			var new_slime : Slime = slime_scene.instantiate()
#			slime_container.add_child(new_slime)
#			new_slime.set_starting_position(slime_pos)
#			new_slime.set_type(StageData.SLIME.GRASS)
			#new_slime.landed.connect(map.change_top_level)



func _ready():
	for player in player_container.get_children():
		player.landed.connect(map.update_trails)
		#player.landed.connect(map.update_selectables)
	
	map.slime_container = slime_container
	
	if is_main_menu:
		stage_info = StageData.LEVEL_DATA["main_menu"]
		Events.connect("slime_absorbed", map.spawn_fixed_slimes)
		Events.disconnect("points_gained", HUD.update_score)
	else:
		stage_info = StageData.LEVEL_DATA["garden1"]
		Events.connect("slime_absorbed", map.spawn_random_slime)
	load_stage()
	$GlobalTickTimer.set_wait_time(TICK_RATE)
	$GlobalTickTimer.start()
	HUD.get_node("timer_visual").set_max(TICK_RATE)
	

func _physics_process(delta):
	Events.emit_signal("update_ticker", $GlobalTickTimer.time_left)

func _on_global_tick_timer_timeout():
	Events.emit_signal("global_tick")
