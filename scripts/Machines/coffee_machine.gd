extends Node2D

var coffee_made = false
var has_group_handle = false
var has_mug = false
var groupHandleObject
var mugObject

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_group_handle and has_mug:
		make_coffee()
		has_group_handle = false 
		has_mug = false
		for child in get_parent().get_parent().get_children():
			if child.name.begins_with("Mug"):
				mugObject = child 
		mugObject.add_ingredient("Coffee")
		

func is_group_handle_in_machine(truth_value):
	has_group_handle = truth_value
	for child in get_parent().get_children():
		if child.name.begins_with("GroupHandle"):
			groupHandleObject = child
	
func is_mug_in_machine(truth_value):
	has_mug = truth_value
		
func make_coffee():
	print("making coffee")
	get_node("StaticBody2D").get_node("CollisionShape2D").set_deferred("disabled", true)  # Disable collision
	
	await get_tree().create_timer(3.0).timeout
	get_node("StaticBody2D").get_node("CollisionShape2D").set_deferred("disabled", false)  # Disable collision
	coffee_made = true
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)
	groupHandleObject.replenish_group_handle()
	groupHandleObject.queue_free()
