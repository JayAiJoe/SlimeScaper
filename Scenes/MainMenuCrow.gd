extends Sprite2D


func _ready():
	$"../AnimationPlayer".play("fly")

func _on_animation_player_animation_finished(anim_name):
	await get_tree().create_timer(randf_range(1,3)).timeout
	$"../AnimationPlayer".play("fly")
