extends Node

var max_amount = 8 # potential to have a set max_amount function later
var amount_left # amount left in grinder
var coffee_grinded = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	amount_left = randi() % max_amount + 1
	print(amount_left , " and " ,max_amount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass ## need to code how to catch teh object when falls into script, idk how :( plz help fanks


func fill_grinder() -> void:
	if amount_left == max_amount:
		print("Grinder is already full!")
	amount_left = max_amount
	print(amount_left)
	coffee_grinded = true
	

func get_amount() -> int: #will be needed for grinder visual level amount on sprite.
	return amount_left

func is_coffee_grinded() -> bool:
	return coffee_grinded
