extends TextureButton

@export var action_name : String

signal listening_changed(key:TextureButton, listening:bool)
signal request_action_change(key:TextureButton, new_action:InputEventKey)

var is_listening := false
var displayed_key := ""

func _ready() -> void:
	set_listening(false)
	var events = InputMap.action_get_events(action_name)
	if events.size() > 0:
		var key = events[0] as InputEventKey
		var keycode = DisplayServer.keyboard_get_keycode_from_physical(key.physical_keycode)
		displayed_key = OS.get_keycode_string(keycode)
		$KeyLabel.set_text(displayed_key)
	
func _on_button_up() -> void:
	set_listening(not is_listening)

func set_listening(val:bool) -> void:
	is_listening = val
	set_process_input(val)
	$Outline.set_visible(val)
	listening_changed.emit(self, is_listening)

func _input(event) -> void:
	if event is InputEventKey and event.is_pressed:
		request_action_change.emit(self, event)
		accept_event()

func change_action_input(input_key : InputEventKey) -> void:
	if action_name == "":
		return
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, input_key)
	displayed_key = OS.get_keycode_string(input_key.keycode)
	$KeyLabel.set_text(displayed_key)
	
	set_listening(false)
