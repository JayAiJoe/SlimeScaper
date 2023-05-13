extends Panel

	
func _on_music_toggle_toggled(button_pressed):
	SoundManager.bg_player.stream_paused = not SoundManager.bg_player.stream_paused


func _on_sound_toggle_toggled(button_pressed):
	SoundManager.allow_sound = not SoundManager.allow_sound

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	hide()

func _on_music_slider_value_changed(value):
	SoundManager.set_music_level(value)

func _on_sound_slider_value_changed(value):
	SoundManager.set_sound_level(value)

func _on_sound_slider_drag_ended(value_changed):
	if $MarginContainer/Settings/Sound/SoundSlider.get_min() == $MarginContainer/Settings/Sound/SoundSlider.get_value():
		SoundManager.allow_sound = false
	else:
		SoundManager.allow_sound = true
	SoundManager.play_sound("ping")



