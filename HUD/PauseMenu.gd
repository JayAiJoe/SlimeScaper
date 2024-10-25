extends Panel

func setup(type:String)->void:
	if type == "pause":
		$MarginContainer/Settings/Label.set_text("Paused")
		$MarginContainer/Settings/HBoxContainer/ResumeButton.show()
	else:
		$MarginContainer/Settings/Label.set_text("Settings")
		$MarginContainer/Settings/HBoxContainer/ResumeButton.hide()
	
func _on_music_toggle_toggled(button_pressed):
	SoundManager.bg_player.stream_paused = not SoundManager.bg_player.stream_paused


func _on_sound_toggle_toggled(button_pressed):
	SoundManager.allow_sound = not SoundManager.allow_sound

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Screens/main_menu.tscn")
	get_parent().paused = false
	hide()

func _on_resume_button_pressed():
	get_parent().paused = false
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
