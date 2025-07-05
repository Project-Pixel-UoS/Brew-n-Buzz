class_name Drink extends Resource

@export var name: String
@export var recipe: Dictionary
@export var image: Texture2D

# Loop through each tier of the recipe
# while there's still ingredients to look at
# and the used ingredients for the tier is smaller than the tier_size
# compare the ingredient with the tier's ingredients
func isValidIngredients(ingredients: Array[Ingredient]) -> bool:
	if ingredients.is_empty() or ingredients.size() != recipe.size():
		return false
	var currentIngredientIndex = 0
	# Making copy so I can remove from it during this function
	print(recipe)
	var recipeCopy = recipe.duplicate(true)
	#for i in range(recipe.size()):
		#if ingredients[i] != recipe[i]:
			#return false
	for ingredient in ingredients:
		if !recipeCopy.has(ingredient):
			print("This ingredient isn't needed in this recipe")
			return false
		if recipeCopy[ingredient] > currentIngredientIndex:
			print("You need other ingredients first")
			return false
		# Removing ingredient as its been used up
		recipeCopy.erase(ingredient)
		# Checking for if there are any other ingredients with this index
		if !(currentIngredientIndex in recipeCopy.values()):
			currentIngredientIndex += 1
	return true
