extends Node2D

@export var customer: CustomerData

func set_customer():
	update_customer_appearance()
	say_dialogue()
	if customer.idle_body_texture == null:
		pass
		#do NPC lerping animation
	else:
		%AnimationPlayer.play('special')
	
func get_customer() -> CustomerData:
	return customer
	
	
func update_customer_appearance():
	if customer == null:
		push_warning("Customer is null in Doll.gd!")
		return
	$head.texture = customer.head_texture
	$body.texture = customer.body_texture
	$face.texture = customer.face_texture
	$hair.texture = customer.hair_texture
	$full_body.texture = customer.special_body_texture
	
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
