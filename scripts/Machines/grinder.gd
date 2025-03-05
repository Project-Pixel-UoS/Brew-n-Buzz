extends Node

var max_amount = 5 
var amount_in 
var coffee_grinded = true
func _ready() -> void:
	amount_in = 0


func fill_grinder() -> void:
	amount_in += 1
	print(amount_in)
	#run animation here
	if amount_in >= max_amount:
		print("Grinder is already full!")
	#auto grinding???
	coffee_grinded = true
	
func get_amount() -> int:
	return amount_in

func is_coffee_grinded() -> bool:
	return coffee_grinded
