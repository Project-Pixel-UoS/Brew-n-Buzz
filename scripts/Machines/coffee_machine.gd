extends Node2D

var coffee_made = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func make_coffee():
	print("making coffee")
	get_node("StaticBody2D").get_node("CollisionShape2D").set_deferred("disabled", true)  # Disable collision
	
	await get_tree().create_timer(3.0).timeout
	get_node("StaticBody2D").get_node("CollisionShape2D").set_deferred("disabled", false)  # Disable collision
	
	coffee_made = true
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)
