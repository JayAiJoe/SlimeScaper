extends Node2D
class_name Level

const MAX_SCALE = 1.2
const STANDARD_SCALE = 1
const SCALE_TIME = 0.05

@onready var sprite : Sprite2D = $Sprite2D
var type : int = GameData.TERRAIN.DIRT

func _ready():
	set_type(type)
	

func set_type(type_code : int) -> void:
	type = type_code
	
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite, "scale", Vector2.ONE * MAX_SCALE, SCALE_TIME)
	sprite.set_texture(load("res://Assets/sample_tiles/" + str(type) + ".png"))
	tween.tween_property(sprite, "scale", Vector2.ONE * STANDARD_SCALE, SCALE_TIME)
	
	

func set_y_offset(offset : float) -> void:
	if not sprite:
		sprite = $Sprite2D
	sprite.offset.y = offset
