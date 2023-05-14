extends Tile

const color = {"blue":Color(1,1,1,1),"red":Color(1,0,0,1),}

var current_control = 0
var player_owner = ""

signal ingredient_placed(type)

func _ready():
	super()
	
func set_cauldron(texture):
	$TerrainSprite.set_texture(texture)
	
func occupy(slime : Slime) -> void:
	entity = null
	var player_color = (slime.aggro as Player).player_color
	
	ingredient_placed.emit(slime.type)
	
	if slime.type == GameData.SLIME.FIRE and slime.aggro.player_color != player_owner:
		SoundManager.play_sound("boom")
	
	score_effect(slime.aggro)
	slime.trigger_free()

func score_effect(player):
	$CauldronEffect.show()
	$AnimationPlayer.play("ploop")
	

func _on_animation_player_animation_finished(anim_name):
	$CauldronEffect.hide()
