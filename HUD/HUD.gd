extends CanvasLayer

var in_game = false
var paused = false

signal pause(paused)

func _ready():
	pass

func display_winner(player_color):
	$WinnerPanel.show()
	$WinnerPanel/Winner.set_modulate(GameData.COLORS[player_color])
	$WinnerPanel/Winner.set_text(player_color+" wins!")

func display_number(num):
	$Number.set_text(str(num))
	$Number.set_modulate(Color(1,1,1,1))
	$Number.set_scale(Vector2(1,1))
	$Number.show()
	var tween = get_tree().create_tween()
	tween.tween_property($Number, "modulate", Color(1,1,1,0), 0.85)
	tween.parallel().tween_property($Number, "scale", Vector2(0.4,0.4), 0.85)
	tween.tween_callback($Number.hide)

func _input(event):
	if event.is_action_pressed("pause"):
		if in_game:
			open_pause_menu()

func open_pause_menu():
	paused = not paused
	$PauseMenu.setup("pause")
	$PauseMenu.set_visible(paused)
	emit_signal("pause", paused)

func open_settings():
	paused = not paused
	$PauseMenu.setup("settings")
	$PauseMenu.set_visible(paused)
	emit_signal("pause", paused)
