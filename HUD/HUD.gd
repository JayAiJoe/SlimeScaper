extends CanvasLayer

var winning_points = 10
var paused = false

signal pause(paused)

func _ready():
	Events.connect("points_gained", update_score)
	
func update_score(player_color, new_score):
	if new_score == winning_points:
		$Winner.set_modulate(GameData.COLORS[player_color])
		$Winner.set_text(player_color+" wins!")

func display_winner(player_color):
	$Winner.set_modulate(GameData.COLORS[player_color])
	$Winner.set_text(player_color+" wins!")

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
		open_pause_menu()

func open_pause_menu():
	paused = not paused
	$PauseMenu.set_visible(paused)
	emit_signal("pause", paused)
