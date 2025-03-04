extends HFlowContainer
## @brief populates the levels menu with level buttons

@export var number_of_levels: int
@export var level_button: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(number_of_levels):
		var instance: TextureButton = level_button.instantiate() # Replace with function body.
		instance.level_number = i+1
		add_child(instance)
