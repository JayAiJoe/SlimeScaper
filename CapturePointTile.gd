extends Tile

var current_control = 0

signal ingredient_placed(type)


func occupy(slime : Slime) -> void:
	entity = null
	var player_color = (slime.aggro as Player).player_color
	var delta = 0
	if player_color == "blue":
		delta = 1
	else:
		delta = -1
	current_control = min(max(current_control + delta, -3), 3)
	
	if (sign(current_control) > 0 and player_color == "blue") or (sign(current_control) < 0 and player_color == "red"):
		captured_by = slime.aggro
		$TerrainSprite.set_modulate(GameData.COLORS[player_color])
	elif current_control == 0:
		captured_by = null
		$TerrainSprite.set_modulate(Color.WHITE)
	
	ingredient_placed.emit(slime.type)
	slime.trigger_free()
	
	
	
	
	
