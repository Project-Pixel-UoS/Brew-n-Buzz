class_name RecipeTier extends Resource

@export var ingredients: Array[Ingredient]

func size():
	return ingredients.size()

func has(ingredient):
	return ingredients.has(ingredient)
