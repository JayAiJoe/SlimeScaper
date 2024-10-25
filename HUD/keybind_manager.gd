extends Control

var current_keys := {}
var only_listener : TextureButton = null

func _ready() -> void:
	for key in get_children():
		key.listening_changed.connect(update_listener)

func update_listener(key, listening:bool) -> void:
	if listening and only_listener != null:
		only_listener.set_listening(false)
	only_listener = key
