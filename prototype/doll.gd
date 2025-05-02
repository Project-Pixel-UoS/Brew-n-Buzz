extends Node2D

@export var customer: CustomerData

func set_customer(new_customer, is_special):
	customer = new_customer
	if is_special:
		pass
	update_customer_appearance()
	say_dialogue()
	
	
func update_customer_appearance():
	if customer == null:
		push_warning("Customer is null in Doll.gd!")
		return
	print("in")
	print(customer.head_texture)
	$head.texture = customer.head_texture
	$body.texture = customer.body_texture
	$face.texture = customer.face_texture
	$hair.texture = customer.hair_texture
	$full_body.texture = customer.fullbody_texture
	
func say_dialogue():
	# format dialogue
	var drink = customer.drink
	var order_line = customer.order_line
	var article = "a"
	if drink[0] == "a" or drink[0] == "e" or drink[0] == "i" or drink[0] == "o" or drink[0] == "u":
		article = "an"
	order_line = order_line.replace("ORDER", customer.drink)
	order_line = order_line.replace("ART", article)
	# set text
	%DialogueLabel.text = order_line

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
