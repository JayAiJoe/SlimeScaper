extends NinePatchRect

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Screens/main_menu.tscn")
	hide()


func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://Screens/main_menu.tscn")
	hide()
