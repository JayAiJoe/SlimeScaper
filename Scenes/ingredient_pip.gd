extends Control
class_name IngredientPip

const ANIMATION_TIME = 0.5
const MAX_SCALE = 1.2

@onready var sprite = $Sprite2D

var type : int = -1
var filled : bool = false
var correctly_filled : bool = false


func _ready():
	sprite.scale = Vector2.ZERO

func set_type_empty(ingredient_type : int) -> void:
	type = ingredient_type
	filled = false
	sprite.modulate = Color.BLACK
	sprite.texture = load("res://Assets/slimes/" + GameData.INGREDIENT_NAMES[type] + ".png")
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ONE, ANIMATION_TIME)

func fill() -> void:
	filled = true
	sprite.modulate = Color.WHITE
	correctly_filled = true
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2.ONE * MAX_SCALE, ANIMATION_TIME/2)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ONE, ANIMATION_TIME/2)

func set_type_incorrect(ingredient_type : int) -> void:
	type = ingredient_type
	filled = true
	sprite.modulate = Color.RED
	sprite.texture = load("res://Assets/slimes/" + GameData.INGREDIENT_NAMES[type] + ".png")
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ONE, ANIMATION_TIME)
	
