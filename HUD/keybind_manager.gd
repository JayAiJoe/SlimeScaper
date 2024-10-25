extends Control

var bound_keys := {}
var only_listener : TextureButton = null

func _ready() -> void:
	for key in get_children():
		key.listening_changed.connect(update_listener)
		key.request_action_change.connect(update_action)
		bound_keys[key.displayed_key] = key

func update_action(key, action) -> void:
	var new_string = OS.get_keycode_string(action.keycode)
	if new_string in bound_keys:
		bound_keys[new_string].flash_red()
		return
	var old_string = bound_keys.find_key(key)
	bound_keys.erase(old_string)
	bound_keys[new_string] = key
	key.change_action_input(action)

func update_listener(key, listening:bool) -> void:
	if listening and only_listener != null:
		only_listener.set_listening(false)
	only_listener = key
