extends Node

var max_amount = 5 
var amount_in 
var coffee_grinded = false
@onready var animationPlayer = %AnimationPlayer

func _ready() -> void:
	amount_in = 0

func remove_coffee():
	amount_in-= 1
	animationPlayer.play_backwards('grinding' + str(amount_in + 1))

func add_coffee():
	amount_in += 1
	animationPlayer.play('grinding' + str(amount_in))
func fill_grinder() -> void:
	print(amount_in)
	#run animation here
	if (amount_in+1) > max_amount:
		print("Grinder is already full!")
	else:
		add_coffee()
		coffee_grinded = true
	#auto grinding???
	
func get_amount() -> int:
	return amount_in

func is_coffee_grinded() -> bool:
	return coffee_grinded
