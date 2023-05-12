extends Node2D

var tools = ["stick", "bait"]
var current_index = -1

var tool_sprites = {
	"stick" : preload("res://Assets/tools/stick.png"),
	"bait" : preload("res://Assets/tools/bait.png"),
}


func _ready():
	switch_tool(1)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				switch_tool(1)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				switch_tool(-1)


func switch_tool(delta : int = 1) -> void:
	current_index += delta
	if current_index >= tools.size():
		current_index = 0
	elif current_index < 0:
		current_index = tools.size() - 1
	Input.set_custom_mouse_cursor(tool_sprites[tools[current_index]], Input.CURSOR_ARROW, Vector2.ZERO)

func use_tool(target_tile : Tile, entity) -> void:
	print("used " + tools[current_index] + " at " + str(target_tile.coordinates) + ".")
	match tools[current_index]:
		"stick":
			use_stick(target_tile, entity)

func use_stick(target_tile, entity) -> void:
	if entity is Slime:
		entity.set_aggro(true)
