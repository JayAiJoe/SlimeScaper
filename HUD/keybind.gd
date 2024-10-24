extends TextureButton

@export var action_name : String
var is_listening := false
var current_key = InputEvent

func _ready() -> void:
	set_listening(false)

func _on_button_up() -> void:
	set_listening(not is_listening)

func set_listening(val:bool) -> void:
	is_listening = val
	set_process_input(val)
	$Outline.set_visible(val)

func _input(event) -> void:
	if event is InputEventKey and event.is_pressed:
		change_action_input(event)

func change_action_input(input_key : InputEventKey) -> void:
	if action_name == "":
		return
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, input_key)
	$KeyLabel.set_text(OS.get_keycode_string(input_key.key_label))
	set_listening(false)
