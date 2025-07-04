extends Node

var max_amount = 5 
var amount_in 
var coffee_grinded = true #can be changed
@onready var animationPlayer = %AnimationPlayer
@onready var groupHandle = %GroupHandle
var time_waiting = 0
var upgrades = GameManager.get_number_upgrades("Grinder")
var starting_time = 3

func _ready() -> void:
	amount_in = 0
	time_waiting = starting_time - (0.25*upgrades)
	
func remove_coffee():
	if get_tree().current_scene.name == "Level1":
		return
	amount_in-= 1
	animationPlayer.play_backwards('grinding' + str(amount_in + 1))

func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventScreenTouch:
		get_tree().set_input_as_handled()

func add_coffee():
	groupHandle.set_dragged(false)
	animationPlayer.play('grinding' + str(amount_in))
	await get_tree().create_timer(time_waiting).timeout
	groupHandle.set_dragged(true)
	amount_in += 1
	
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
	
func get_current_time():
	return time_waiting
