extends Node2D

@export var customer: Customer

func set_customer(new_customer):
	customer = new_customer
	update_customer_appearance()
	
func update_customer_appearance():
	$head.texture = customer.head_texture
	$body.texture = customer.body_texture
	$face.texture = customer.face_texture
	$hair.texture = customer.hair_texture

func react_to_drink(correct: bool):
	if correct:
		%AnimationPlayer.play("happy")
	else:
		%AnimationPlayer.play("angry")
		
func reset_sprites():
	$head.texture = null
	$body.texture = null
	$face.texture = null
	$hair.texture = null
