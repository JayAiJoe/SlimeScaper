extends NinePatchRect

@onready var ingredient_container = $IngredientContainer
@onready var recipe_counter = $RecipeCounter

var PIP = preload("res://Scenes/ingredient_pip.tscn")

var current_recipe = []
var contained_ingredients = []
var current_index = 0
var player_color



var contaminated = false

signal recipe_requested(index, indicator)

func _ready():
	pass

#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		receive_ingredient(0)

func request_new_recipe() -> void:
	recipe_requested.emit(current_index, self)
	current_index += 1
	#$Recipe_index.set_text("Recipe # "+ str(current_index))
	if current_index > 1:
		complete_recipe()
	
func reset_contained() -> void:
	$Chompy.hide()
	contaminated = false
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
		animate_chompy()
		if ingredient_container.get_children().size() < 4:
			await get_tree().create_timer(ingredient_container.get_children().size() * 0.07).timeout
		cascading_remove_ingredients()
		
		#$Clear.hide()
		#$IngredientContainer.show()
		return
	for pip in ingredient_container.get_children():
		if not pip.filled and pip.type == type:
			pip.fill()
			if check_recipe():
				animate_fulfill()
				request_new_recipe()
			return
	if not contaminated:
		contaminated = true
		var pip = PIP.instantiate()
		ingredient_container.add_child(pip)
		pip.set_type_incorrect(type)
		$Chompy.show()
		$Chompy.set_modulate(Color.BLACK)
		
#	for pip in ingredient_container.get_children():
#		if not pip.filled:
#			pip.set_type_incorrect(type)
#			$Clear.show()
#			$IngredientContainer.hide()
#
#			return

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

func animate_chompy() -> void:
	$Chompy.show()
	$Chompy.set_modulate(Color.WHITE)
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Chompy, "position:x", 800, 1)
	tween.tween_callback(reset_chompy)

func reset_chompy() -> void:
	$Chompy.hide()
	$Chompy.position = Vector2(0, 128)

func cascading_remove_ingredients() -> void:
	for ingredient in ingredient_container.get_children():
		ingredient.disappear()
		await get_tree().create_timer(0.2).timeout
	await get_tree().create_timer(0.2).timeout
	reset_recipe()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		pass

func complete_recipe() -> void:
	for pip in recipe_counter.get_children():
		if pip.modulate == Color.GOLD:
			continue
		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_callback(func(): pip.set_modulate(Color.GOLD))
		tween.tween_property(pip, "scale", Vector2.ONE * 1.15, 0.15)
		tween.tween_property(pip, "scale", Vector2.ONE, 0.15)
		return

func reset_pips() -> void:
	for pip in recipe_counter.get_children():
		pip.set_modulate(Color.WHITE)

func set_pips_visibility(visibility : bool) -> void:
	$RecipeCounter.visible = visibility

