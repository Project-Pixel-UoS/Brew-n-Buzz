extends Node2D

@export var customer: Customer

func _ready() -> void:
	if customer:
		# Set all body part textures
		$head.texture = customer.head_texture
		$body.texture = customer.body_texture
		$face.texture = customer.face_texture
		$hair.texture = customer.hair_texture
		
		# If you want to keep the random button functionality
		randomize_appearance()

func randomize_appearance():
	# This can be called manually if you want randomization
	$head._on_button_pressed()
	$body._on_button_pressed()
	$face._on_button_pressed()
	$hair._on_button_pressed()

func react_to_drink(correct: bool):
	if correct:
		$AnimationPlayer.play("happy")
	else:
		$AnimationPlayer.play("angry")
