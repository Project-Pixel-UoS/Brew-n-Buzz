extends Node2D

@export var customer: Customer

func set_customer(new_customer):
	customer = new_customer
	update_customer_appearance()
	say_dialogue()
	
func get_customer() -> Customer:
	return customer
	
	
func update_customer_appearance():
	$head.texture = customer.head_texture
	$body.texture = customer.body_texture
	$face.texture = customer.face_texture
	$hair.texture = customer.hair_texture
	
func say_dialogue():
	# format dialogue
	var drink_name = customer.drink.name
	var order_line = customer.order_line
	var article = "a"
	if drink_name[0] == "a" or drink_name[0] == "e" or drink_name[0] == "i" or drink_name[0] == "o" or drink_name[0] == "u":
		article = "an"
	order_line = order_line.replace("ORDER", drink_name)
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
