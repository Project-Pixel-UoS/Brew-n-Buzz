extends Node2D

@export var customer: CustomerData
var old_position 
var new_position
var finished_animation = false
var leaving_queue = false
var end_position 

func set_customer():
	update_customer_appearance()
	old_position = self.position
	say_dialogue()
	if customer.idle_body_texture == null:
		new_position = Vector2(old_position.x, old_position.y +2)
		while not finished_animation and not leaving_queue:
			await NPC_animation()
	else:
		%AnimationPlayer.play('special')
		
func exit_animation():
	var tween = get_tree().create_tween()
	old_position = self.position
	new_position = Vector2(old_position.x+10, old_position.y+2)
	end_position = Vector2(old_position.x+20, old_position.y)
	tween.tween_property(self, "position", new_position, 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", end_position, 0.3).set_ease(Tween.EASE_OUT)
	await tween.finished

func NPC_animation():
	var tween = get_tree().create_tween()
	if leaving_queue:
		old_position = self.position
		new_position = Vector2(old_position.x, old_position.y+2)
	tween.tween_property(self, "position", new_position, 1).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", old_position, 1).set_ease(Tween.EASE_OUT)
	await tween.finished
	
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
	
func exit_queue():
	leaving_queue = true
	while old_position.x < 150:
		await exit_animation()
	reset_sprites()
		
func reset_sprites():
	$head.texture = null
	$body.texture = null
	$face.texture = null
	$hair.texture = null
	$full_body.texture = null
