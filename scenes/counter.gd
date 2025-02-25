extends Node2D
@onready var mugObject: Node2D = %Mug
@onready var levelManager: Node = %LevelManager
var correct_recipe = ["Milk"]
@onready var counter = %Counter

func _ready() -> void:
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)
	var area2d = counter.get_node("Area2D")
	area2d.connect("area_entered", Callable(self, "_on_area_2d_area_entered"))
	
func check_recipe():
	if mugObject.get_ingredients() == correct_recipe:
		levelManager.add_correct_recipe()
		print("correct recipe")
	else:
		levelManager.add_incorrect_recipe()
		print("incorrect recipe")

func _on_area_2d_area_entered(body: Node2D) -> void:
	check_recipe()
