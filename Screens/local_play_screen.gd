extends Node2D

const MAX_COUNTDOWN = 3
var COUNTDOWN = MAX_COUNTDOWN

func _ready() -> void:
	$StageLoader.load_stage("garden1")
	set_physics_process(false)
	$round_start_timer.set_wait_time(1)
	$round_start_timer.start()
	HUD.display_number(COUNTDOWN)
	$RecipeHandler.init_recipe_list(false)
	for i in range(len($StageLoader.cauldrons)):
		$StageLoader.cauldrons[i].ingredient_placed.connect($Recipes.get_child(i).receive_ingredient)
	
	var idx = 0
	for indicator in $Recipes.get_children():
		indicator.recipe_requested.connect($RecipeHandler.handle_recipe_request)
		indicator.request_new_recipe()
		indicator.player_color = GameData.COLORS.keys()[idx]
		idx += 1
			
func _on_round_start_timer_timeout():
	COUNTDOWN -= 1
	if COUNTDOWN == 0:
		HUD.display_number("START")
		start_round()
	else:
		HUD.display_number(COUNTDOWN)
		$round_start_timer.start()

func start_round():
	$StageLoader.unpause_players()
	
