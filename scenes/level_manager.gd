extends Node
@onready var timer: Timer = %Timer
var correct_recipes = 0
var incorrect_recipes = 0

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
