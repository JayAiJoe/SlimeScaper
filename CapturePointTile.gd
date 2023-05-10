extends Tile

@onready var pips = [$ControlIndicator/HBoxContainer/Pip, $ControlIndicator/HBoxContainer/Pip2, $ControlIndicator/HBoxContainer/Pip3]
var current_control = 0


func occupy(slime : Slime) -> void:
	entity = null
	var player_color = (slime.aggro as Player).player_color
	var delta = 0
	if player_color == "blue":
		delta = 1
	else:
		delta = -1
	current_control = min(max(current_control + delta, -3), 3)
	update_pips(current_control)
	
	if (sign(current_control) > 0 and player_color == "blue") or (sign(current_control) < 0 and player_color == "red"):
		captured_by = slime.aggro
		$TerrainSprite.set_modulate(GameData.COLORS[player_color])
	elif current_control == 0:
		captured_by = null
		$TerrainSprite.set_modulate(Color.WHITE)
	
	slime.trigger_free()
	
			
func update_pips(control : int) -> void:
	var color = Color.WHITE
	for pip in pips:
		pip.set_modulate(color)

	if sign(control) > 0:
		color = Color.BLUE
	elif sign(control) < 0:
		color = Color.RED
	
	for i in range(abs(control)):
		pips[i].set_modulate(color)
	
	
	
	
