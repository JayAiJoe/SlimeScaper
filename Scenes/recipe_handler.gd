extends Node2D


var recipe_list = []
var recipe_nums = [2,1,1,1]

func init_recipe_list(is_main_menu):
	randomize()
	if is_main_menu:
		for i in range(100):
			for recipe in generate_unique_combinations(3, 1):
				recipe_list.append(recipe)
		return
	
	for i in range(recipe_nums.size()):
		for recipe in generate_unique_combinations(i+3, recipe_nums[i]): #(3, 4)
			recipe_list.append(recipe)

func generate_unique_combinations(ingredient_count : int, combination_count : int) -> Array:
	var combinations = []
	while combinations.size() < combination_count:
		var ingredients = []
		for i in range(ingredient_count):
			ingredients.append(randi() % GameData.INGREDIENT_VARIETIES)
		var counts = []
		for variety in range(GameData.INGREDIENT_VARIETIES):
			counts.append(0)
		for ingredient in ingredients:
			counts[ingredient] += 1
		if counts not in combinations:
			combinations.append(counts)
	return combinations

func handle_recipe_request(index : int, indicator) -> void:
	if index >= recipe_list.size():
		print(indicator.player_color)
		HUD.display_winner(indicator.player_color)
		return
	indicator.update_recipe(recipe_list[index])
