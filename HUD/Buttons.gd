extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	HUD.set_in_game(false)

func _on_play_pressed():
#	if Utils.has_played_tutorial:
	get_tree().change_scene_to_file("res://Scenes/mode_select_screen.tscn")
#	else:
#		Utils.has_played_tutorial = true
#		get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")

func _on_tutorial_pressed():
	Utils.has_played_tutorial = true
	get_tree().change_scene_to_file("res://Screens/tutorial_screen.tscn")

func _on_ewan_pressed():
	HUD.open_settings()

func _on_credits_pressed():
	get_parent().get_node("MarginContainer").show()

func _on_back_pressed():
	get_parent().get_node("MarginContainer").hide()
