extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("points_gained", update_score)
	
func update_score(player_color, new_score):
	get_node(player_color+"_score").set_text(str(new_score))
