extends TextureButton

@export var action_name : String

signal listening_changed(key:TextureButton, listening:bool)

var is_listening := false
var current_key : InputEventKey


func _ready() -> void:
	set_listening(false)
	var events = InputMap.action_get_events(action_name)
	if events.size() > 0:
		current_key = events[0] as InputEventKey
		var keycode = DisplayServer.keyboard_get_keycode_from_physical(current_key.physical_keycode)
		$KeyLabel.set_text(OS.get_keycode_string(keycode))
	
func _on_button_up() -> void:
	set_listening(not is_listening)

func set_listening(val:bool) -> void:
	is_listening = val
	set_process_input(val)
	$Outline.set_visible(val)
	listening_changed.emit(self, is_listening)

func _input(event) -> void:
	if event is InputEventKey and event.is_pressed:
		change_action_input(event)
		accept_event()

func change_action_input(input_key : InputEventKey) -> void:
	if action_name == "":
		return
	current_key = input_key
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, current_key)
	$KeyLabel.set_text(OS.get_keycode_string(current_key.keycode))
	set_listening(false)
