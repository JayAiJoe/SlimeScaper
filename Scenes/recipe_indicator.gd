extends NinePatchRect

@onready var ingredient_container = $IngredientContainer

var PIP = preload("res://Scenes/ingredient_pip.tscn")

var current_recipe = []
var contained_ingredients = []
var current_index = 0
var player_color

signal recipe_requested(index, indicator)

func _ready():
	pass

#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		receive_ingredient(0)

func request_new_recipe() -> void:
	recipe_requested.emit(current_index, self)
	current_index += 1
	$Recipe_index.set_text("Recipe # "+ str(current_index))
	
func reset_contained() -> void:
	for i in range(GameData.INGREDIENT_VARIETIES):
		contained_ingredients.append(0)

func update_recipe(new_recipe : Array) -> void:
	current_recipe = new_recipe
	for child in ingredient_container.get_children():
		child.queue_free()
	for i in range(GameData.INGREDIENT_VARIETIES):
		for j in range(current_recipe[i]):
			var pip = PIP.instantiate()
			ingredient_container.add_child(pip)
			pip.set_type_empty(i)
	reset_contained()

func reset_recipe() -> void:
	for child in ingredient_container.get_children():
		child.queue_free()
	for i in range(GameData.INGREDIENT_VARIETIES):
		for j in range(current_recipe[i]):
			var pip = PIP.instantiate()
			ingredient_container.add_child(pip)
			pip.set_type_empty(i)
	reset_contained()
			

func receive_ingredient(type : int) -> void:
	if type == GameData.CHOMPY_INDEX:
		reset_recipe()
		$Clear.hide()
		$IngredientContainer.show()
		return
	for pip in ingredient_container.get_children():
		if not pip.filled and pip.type == type:
			pip.fill()
			if check_recipe():
				animate_fulfill()
				request_new_recipe()
			return
	for pip in ingredient_container.get_children():
		if not pip.filled:
			pip.set_type_incorrect(type)
			$Clear.show()
			$IngredientContainer.hide()
			return

func check_recipe() -> bool:
	for pip in ingredient_container.get_children():
		if pip.correctly_filled == false:
			return false
	return true

func animate_fulfill():
	var orig_scale = scale
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", orig_scale*1.2, 0.25)
	tween.tween_property(self, "scale", orig_scale, 0.25)
