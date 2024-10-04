extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_local_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Screens/local_play_screen.tscn")
	
	
func _on_host_button_button_up() -> void:
	MultiplayerManager.host_server()
	StageData.current_level_name = "main_menu"
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
	

func _on_join_button_button_up() -> void:
	MultiplayerManager.join_server()
	StageData.current_level_name = "main_menu"
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
