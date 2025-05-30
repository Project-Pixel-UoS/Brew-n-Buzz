extends Node

@onready var timer: Timer = %Timer
@onready var endOfLevel = %end_of_level_layer
@onready var customerPanel = %CustomerPanel
var correct_recipes = 0
var incorrect_recipes = 0
var inactive_objects = ["KitchenPanel/Ingredients/Seasonal", "KitchenPanel/Machines/Grinder", "KitchenPanel/Machines/MilkJug", 
"KitchenPanel/Ingredients/Coffee", "KitchenPanel/Ingredients/Milk"]
var shader
var level_money = 0
func _ready() -> void:
	endOfLevel.visible = false
	shader = preload("res://scenes/kitchen_panel/ingredient_scenes/greyscale.gdshader") 
	for object in inactive_objects:
		turn_inactive(object)

func _process(delta: float) -> void:
	if timer.out_of_time() or customerPanel.get_node('Panel/CustomerQueueManager').is_queue_empty():
		#@TODO SAVE LEVEL HERE
		Engine.time_scale = 0
		endOfLevel.visible = true
		
		GameManager.update_level()

func increment_correct_recipe():
	correct_recipes += 1

func increment_incorrect_recipe():
	incorrect_recipes += 1

func add_payment(payment):
	level_money += payment

func get_level_money():
	return level_money

func get_drinks_served():
	return (correct_recipes + incorrect_recipes)
	
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
