extends Node2D

var milk_frothed = false

func froth_milk():
	print("milk being frothed!")
	get_node("Area2D").get_node("CollisionShape2D").set_deferred("disabled", true)  # Disable collision
	
	await get_tree().create_timer(3.0).timeout
	get_node("Area2D").get_node("CollisionShape2D").set_deferred("disabled", false)  # Disable collision
	
	milk_frothed = true
