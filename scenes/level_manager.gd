extends Node

@onready var timer: Timer = %Timer
@onready var endOfLevel = %end_of_level_layer
var correct_recipes = 0
var incorrect_recipes = 0
var inactive_objects = ["Ingredients/Seasonal", "Machines/Grinder", "Ingredients/Coffee", "Ingredients/Milk"]
var shader
var level_money = 0

# Dictionary mapping drink names to their required ingredients
var drink_recipes = {
	["Coffee"]: "espresso",
	["Coffee", "Milk"]: "latte",
	["Coffee", "Foam"]: "cappuccino"
}


# Current customer's requested drink (set when customer is spawned)
var current_customer_drink: String = ""

func _ready() -> void:
	endOfLevel.visible = false
	shader = preload("res://scenes/ingredient_scenes/greyscale.gdshader") 
	for object in inactive_objects:
		turn_inactive(object)

func _process(delta: float) -> void:
	if timer.out_of_time():
		endOfLevel.visible = false
		GameManager.update_level()

func add_correct_recipe():
	correct_recipes += 1

func add_incorrect_recipe():
	incorrect_recipes += 1

func add_payment(payment):
	level_money += payment

func get_level_money():
	return level_money

func turn_inactive(object_name):
	var obj = get_node_or_null(object_name)
	turn_greyscale(obj)
	turn_off_collisions(obj)

func turn_greyscale(object):
	var sprite = object.get_node("Sprite2D")
	sprite.set_material(ShaderMaterial.new())
	sprite.get_material().shader = shader

func turn_off_collisions(object):
	var has_area2D = object.get_node_or_null("Area2D")
	if has_area2D:
		object.get_node("Area2D/CollisionShape2D").set_disabled(true)
	else:
		object.get_node("StaticBody2D/CollisionShape2D").set_disabled(true)

# Converts a list of ingredients into a drink name based on drink_recipes
func get_drink_name(ingredients: Array) -> String:
	var sorted = ingredients.duplicate()
	sorted.sort()
	for key in drink_recipes.keys():
		var sorted_key = key.duplicate()
		sorted_key.sort()
		if sorted == sorted_key:
			return drink_recipes[key]
	return "unknown"
