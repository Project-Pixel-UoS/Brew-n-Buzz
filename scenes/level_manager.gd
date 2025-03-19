extends Node
@onready var timer: Timer = %Timer
var correct_recipes = 0
var incorrect_recipes = 0
var inactive_objects = ["Ingredients/Seasonal", "Machines/Grinder", "Ingredients/Coffee", "Ingredients/Milk"]
var shader

func _ready() -> void:
	shader = preload("res://scenes/ingredient_scenes/greyscale.gdshader") 
	for object in inactive_objects:
		turn_inactive(object)
		
func _process(delta: float) -> void:
	if timer.out_of_time():
		pass	

func add_correct_recipe():
	correct_recipes += 1
	
func add_incorrect_recipe():
	incorrect_recipes += 1
	
func save_level():
	GameManager.update_level()
	pass

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
	
