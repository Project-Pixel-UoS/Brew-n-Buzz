extends Node2D
# Called when the node enters the scene tree for the first time.
var ingredients = []
func _ready() -> void:
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)

func add_ingredient(ingredient: String) -> void:
	ingredients.append(ingredient)
	print("added " + ingredient)
	
func get_ingredients() -> Array:
	return ingredients
