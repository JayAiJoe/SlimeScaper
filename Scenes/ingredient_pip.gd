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
	$X.hide()
	type = ingredient_type
	filled = false
	sprite.modulate = Color.BLACK
	sprite.texture = load("res://Assets/slimes/"+GameData.INGREDIENT_NAMES[type]+"_idle.png")
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ONE, ANIMATION_TIME)

func fill() -> void:
	$X.hide()
	filled = true
	sprite.modulate = Color.WHITE
	correctly_filled = true
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2.ONE * MAX_SCALE, ANIMATION_TIME/2)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ONE, ANIMATION_TIME/2)

func set_type_incorrect(ingredient_type : int) -> void:
	$X.show()
	type = ingredient_type
	filled = true
	sprite.modulate = Color.RED
	sprite.texture = load("res://Assets/slimes/"+GameData.INGREDIENT_NAMES[type]+"_idle.png")
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ONE, ANIMATION_TIME)

func disappear(direction : int) -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property($Sprite2D, "position:x", $Sprite2D.position.x - 64 * direction, 0.1)
	tween.parallel().tween_property($Sprite2D, "scale", Vector2.ONE * 0.2, 0.1)
	tween.parallel().tween_property($Sprite2D, "rotation_degrees", -90 * direction, 0.1)
	tween.parallel().tween_property($Sprite2D, "modulate:a", 0, 0.1)
	tween.parallel().tween_property($X, "position:x", $X.position.x - 64 * direction, 0.1)
	tween.parallel().tween_property($X, "scale", Vector2.ONE * 0.2, 0.1)
	tween.parallel().tween_property($X, "modulate:a", 0, 0.1)
