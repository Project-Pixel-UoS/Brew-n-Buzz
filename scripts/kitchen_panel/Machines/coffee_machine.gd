extends Node2D

var coffee_made = false
var has_group_handle = false
var has_mug = false
var groupHandleObject
var mugObject
@onready var animationPlayer = %AnimationPlayer

func _ready() -> void:
	Input.set_use_accumulated_input(false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_group_handle and has_mug:
		make_coffee()
		has_group_handle = false 
		has_mug = false

func add_water():
	get_mug_object()
	mugObject.set_draggable(false)
	animationPlayer.play("water")
	await get_tree().create_timer(3.0).timeout
	mugObject.set_draggable(true)
	mugObject.add_ingredient("Water") # Ensure it's not locked in an animation

func is_group_handle_in_machine(truth_value):
	has_group_handle = truth_value
	for child in get_parent().get_children():
		if child.name.begins_with("GroupHandle"):
			groupHandleObject = child
	
func is_mug_in_machine(truth_value):
	has_mug = truth_value

func get_mug_object():
	for child in get_parent().get_parent().get_children():
		if child.name == ("Mug"):
			mugObject = child 
			
func make_coffee():
	get_mug_object()
	if not mugObject:
		return
	print("making coffee")
	mugObject.set_draggable(false)
	groupHandleObject.replenish_group_handle()
	groupHandleObject.queue_free()
	animationPlayer.play("coffee")
	await get_tree().create_timer(3.0).timeout
	mugObject.set_draggable(true)
	coffee_made = true
	mugObject.add_ingredient("Coffee")
