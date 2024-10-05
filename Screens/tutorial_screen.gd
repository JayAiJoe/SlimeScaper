extends Node2D

var ready_players = 0
var max_ready_time = 2
var ready_decay = 1

func _ready() -> void:
	$StageLoader.load_stage("tutorial")
	$Prompts/TextureProgressBar.set_max(max_ready_time)
	Events.connect("ready_player", update_ready)
	$RecipeHandler.init_recipe_list(true)
	$Recipes/RecipeIndicator.set_pips_visibility(false)
	$Recipes/RecipeIndicator2.set_pips_visibility(false)
	for i in range(len($StageLoader.cauldrons)):
		$StageLoader.cauldrons[i].ingredient_placed.connect($Recipes.get_child(i).receive_ingredient)
	
	for i in range(len($PlayerContainer.get_children())):
		$PlayerContainer.get_child(i).set_starting_position($StageLoader.player_start[i])
	var idx = 0
	for indicator in $Recipes.get_children():
		indicator.recipe_requested.connect($RecipeHandler.handle_recipe_request)
		indicator.request_new_recipe()
		indicator.player_color = GameData.COLORS.keys()[idx]
		idx += 1
	unpause_players()

func unpause_players() -> void:
	for player in $PlayerContainer.get_children():
		player.paused = false
	
func update_ready(delta):
	ready_players += delta
	
func _physics_process(delta):
	if ready_players == 2:
		$Prompts/TextureProgressBar.set_value($Prompts/TextureProgressBar.get_value()+delta)
		if $Prompts/TextureProgressBar.get_value() >= $Prompts/TextureProgressBar.get_max():
			get_tree().change_scene_to_file("res://Screens/main_menu.tscn")
	else:
		$Prompts/TextureProgressBar.set_value($Prompts/TextureProgressBar.get_value()-delta*ready_decay)
	
