extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("ingredient"):  # Check if it's an ingredient like milk
		print("Ingredient entered mug!")
		print("Ingredient Path:", body.get_path())  # Debugging line
		print("Mug Path:", get_path())  # Debugging line
		modulate = Color(Color.DARK_BLUE, 1)  # Change mug color when ingredient enters
		# You can add more logic here, like setting a flag that milk is inside the mug


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("ingredient"):  # Check if the ingredient exits
		print("Ingredient exited mug!")
		modulate = Color(Color.MEDIUM_BLUE, 0.7)  # Reset mug color when ingredient exits
		# You can add more logic here, like resetting flags
