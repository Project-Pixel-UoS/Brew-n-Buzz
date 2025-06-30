class_name Drink extends Resource

@export var name: String
@export var recipe: Array[RecipeTier]
@export var image: Texture2D
@export var description: String

# Loop through each tier of the recipe
# while there's still ingredients to look at
# and the used ingredients for the tier is smaller than the tier_size
# compare the ingredient with the tier's ingredients
func isValidIngredients(ingredients: Array[Ingredient]) -> bool:
	if ingredients.is_empty():
		return false

	var ingredients_index = 0
	for tier in recipe:
		var used_ingredients: Array[Ingredient]

		while used_ingredients.size() < tier.size():
			# if tier is exhausted by not the mug's ingredients
			if ingredients_index >= ingredients.size():
				return false

			var current_ingredient = ingredients[ingredients_index]

			if !tier.has(current_ingredient) \
			or used_ingredients.has(current_ingredient):
				return false

			used_ingredients.push_back(current_ingredient)
			ingredients_index += 1

	#if all ingredients in the mug are exhausted
	return ingredients_index == ingredients.size()
