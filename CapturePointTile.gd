extends Tile

const color = {"blue":Color(1,1,1,1),"red":Color(1,0,0,1),}


var current_control = 0
var player_owner = ""

signal ingredient_placed(type)

func _ready():
	super()
	$Cauldron

func occupy(slime : Slime) -> void:
	entity = null
	var player_color = (slime.aggro as Player).player_color
	
	ingredient_placed.emit(slime.type)
	
	if slime.type == GameData.SLIME.FIRE and slime.aggro.player_color != player_owner:
		SoundManager.play_sound("boom")
	
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
