extends VBoxContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	if Utils.has_played_tutorial:
		get_tree().change_scene_to_file("res://Scenes/stage_loader.tscn")
	else:
		Utils.has_played_tutorial = true
		get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")


func _on_tutorial_pressed():
	Utils.has_played_tutorial = true
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")

func _on_ewan_pressed():
	print("EWAN")
