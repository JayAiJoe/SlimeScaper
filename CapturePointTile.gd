extends Tile

const color = {"blue":Color(1,1,1,1),"red":Color(1,0,0,1),}

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
	elif current_control == 0:
		captured_by = null
	
	ingredient_placed.emit(slime.type)
	score_effect(slime.aggro)
	slime.trigger_free()

func score_effect(player):
	$ScoreEffect.set_modulate(color[player.player_color])
	$ScoreEffect.set_position(Vector2(0,0-Utils.TILE_HEIGHT))
	
	var transparent = color[player.player_color]
	transparent.a = 0
	$ScoreEffect.show()
	var tween = get_tree().create_tween()
	tween.tween_property($ScoreEffect, "position", Vector2(0,-Utils.TILE_HEIGHT-100), 0.6)
	tween.parallel().tween_property($ScoreEffect, "modulate", transparent, 0.8).set_trans(Tween.TRANS_QUINT)
	tween.tween_callback($ScoreEffect.hide)
