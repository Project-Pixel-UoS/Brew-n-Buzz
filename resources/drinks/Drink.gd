class_name Drink extends Resource

@export var name: String
@export var recipe: Dictionary
@export var image: Texture2D

func isValidIngredients(ingredients: Array[String]) -> bool:
	var currentIngredientIndex = 0
	# Making copy so I can remove from it during this function
	var recipeCopy = recipe.duplicate(true)
	for ingredient in ingredients:
		if recipeCopy[ingredient] == null:
			print("This ingredient isn't needed in this recipe")
			return false
		if recipeCopy[ingredient] > currentIngredientIndex:
			print("You need other ingredients first")
			return false
		# Removing ingredient as its been used up
		recipeCopy.erase(ingredient)
		# Checking for if there are any other ingredients with this index
		if !(currentIngredientIndex in recipeCopy.values):
			currentIngredientIndex += 1
	return true
