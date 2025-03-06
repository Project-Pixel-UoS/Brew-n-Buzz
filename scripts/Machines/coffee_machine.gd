extends Node2D

var coffee_made = false
var has_group_handle = false
var has_mug = false
var groupHandleObject
var mugObject

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for child in get_parent().get_parent().get_children():
		if child.name.begins_with("Mug"):
			mugObject = child 
	if has_group_handle and has_mug:
		make_coffee()
		has_group_handle = false 
		has_mug = false

func add_water():
	#playAnimation
	mugObject.get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)  # Disable collision
	
	await get_tree().create_timer(3.0).timeout
	mugObject.get_node("Area2D/CollisionShape2D").set_deferred("disabled", false)  # Disable collision
	mugObject.add_ingredient("Water")
	
func is_group_handle_in_machine(truth_value):
	has_group_handle = truth_value
	for child in get_parent().get_children():
		if child.name.begins_with("GroupHandle"):
			groupHandleObject = child
	
func is_mug_in_machine(truth_value):
	has_mug = truth_value
		
func make_coffee():
	print("making coffee")
	groupHandleObject.get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)  # Disable collision
	mugObject.get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)  # Disable collision
	
	await get_tree().create_timer(3.0).timeout
	groupHandleObject.get_node("Area2D/CollisionShape2D").set_deferred("disabled", false)  # Disable collision
	mugObject.get_node("Area2D/CollisionShape2D").set_deferred("disabled", false)  # Disable collision
	coffee_made = true
	groupHandleObject.replenish_group_handle()
	groupHandleObject.queue_free()
	mugObject.add_ingredient("Coffee")
