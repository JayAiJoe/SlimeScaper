extends CanvasLayer

var winning_points = 10

func _ready():
	Events.connect("points_gained", update_score)
	
func update_score(player_color, new_score):
	if new_score == winning_points:
		$Winner.set_modulate(GameData.COLORS[player_color])
		$Winner.set_text(player_color+" wins!")
