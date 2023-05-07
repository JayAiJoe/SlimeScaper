extends Node2D

const MAX_SCALE = 1.2
const STANDARD_SCALE = 1
const SCALE_TIME = 0.05

@onready var sprite : Sprite2D = $Sprite2D
var type : int

func _ready():
	set_type(0)

func set_type(type_code : int) -> void:
	type = type_code
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite, "scale", Vector2.ONE * MAX_SCALE, SCALE_TIME)
	sprite.set_texture(load("res://Assets/sample_tiles/" + GameData.TERRAIN_TYPES[type] + "_E.png"))
	tween.tween_property(sprite, "scale", Vector2.ONE * STANDARD_SCALE, SCALE_TIME)
	
	

func set_y_offset(offset : float) -> void:
	if not sprite:
		sprite = $Sprite2D
	sprite.offset.y = offset
