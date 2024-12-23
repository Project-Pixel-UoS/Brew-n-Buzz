extends Node2D

@export var character: Customer

## @brief sets up the customer
func _ready() -> void:
	$head.texture = character.body.head
	$body.texture = character.body.body
	$face.texture = character.body.face
	$hair.texture = character.body.hair

func _on_button_pressed() -> void:
	# randomly assigns texture
	$head._on_button_pressed()
	$body._on_button_pressed()
	$face._on_button_pressed()
	$hair._on_button_pressed()
