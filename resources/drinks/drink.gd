class_name Drink extends Resource

@export var name: String
@export var recipe: Array[RecipeTier]
@export var image: Texture2D
@export var description: String
@export var transitions: Dictionary

func is_equal_to(other: Drink) -> bool:
	return self == other

func show_ingredients() -> String:
	var output = []
	for tier in recipe:
		output += tier.ingredients.map(func(ingredient): return ingredient.name)
	return ", ".join(output)
