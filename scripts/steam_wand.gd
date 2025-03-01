extends Node2D

var milk_steamed = true

func steam_milk(milk_jug_node):
	print("milk being steamed!")
	milk_jug_node.get_node("Area2D").get_node("CollisionShape2D").set_deferred("disabled", true)  # Disable collision
	await get_tree().create_timer(3.0).timeout
	milk_steamed = true
	milk_jug_node.set_steamed_milk(true)
	print("finished steaming milk")
	milk_jug_node.get_node("Area2D").get_node("CollisionShape2D").set_deferred("disabled", false)  # Disable collision
