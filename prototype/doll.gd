extends Node2D

@export var customer: Customer

func set_customer(new_customer, is_special):
	customer = new_customer
	if is_special:
		pass
	update_customer_appearance()
	
func update_customer_appearance():
	if customer == null:
		push_warning("Customer is null in Doll.gd!")
		return
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
