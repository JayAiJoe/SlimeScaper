extends Panel


func _on_music_toggle_toggled(button_pressed):
	SoundManager.bg_player.stream_paused = not SoundManager.bg_player.stream_paused


func _on_sound_toggle_toggled(button_pressed):
	SoundManager.allow_sound = not SoundManager.allow_sound

func _on_menu_button_toggled(button_pressed):
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	hide()
