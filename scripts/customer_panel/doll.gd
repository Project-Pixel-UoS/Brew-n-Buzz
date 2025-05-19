extends Node2D

@export var customer: CustomerData
var old_position 
var new_position
var leaving_queue = false
var end_position 
var reset_position
signal movement_finished
var finished_moving =  false
var order_line

func _ready() -> void:
	reset_position = Vector2(-22,90)
	
func reset_pos():
	self.position = reset_position
		
func enter_animation():
	var tween = get_tree().create_tween()
	old_position = self.position
	new_position = Vector2(old_position.x+7, old_position.y+2)
	end_position = Vector2(old_position.x+14, old_position.y)
	tween.tween_property(self, "position", new_position, 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", end_position, 0.3).set_ease(Tween.EASE_OUT)
	await tween.finished
	
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
	if customer.name == 'Chef Bruno':
		$full_body.hframes = 4
		$full_body.vframes = 2
	else:
		$full_body.hframes = 4
		$full_body.vframes = 3
	
func say_dialogue():
	# format dialogue
	var drink_name = customer.drink.name
	order_line = customer.order_line
	var article = "a"
	if drink_name[0] == "a" or drink_name[0] == "e" or drink_name[0] == "i" or drink_name[0] == "o" or drink_name[0] == "u":
		article = "an"
	order_line = order_line.replace("ORDER", drink_name)
	order_line = order_line.replace("ART", article)
	# set text
	
	old_position = self.position
	if customer.idle_body_texture == null:
		new_position = Vector2(old_position.x, old_position.y +2)
		%DialogueLabel.text = order_line
		while not leaving_queue:
			await NPC_animation()
		emit_signal("movement_finished")
	else:
		say_special_dialogue()
		if customer.name == 'Chef Bruno':
			$full_body.hframes = 4
			$full_body.vframes = 2
		else:
			$full_body.hframes = 4
			$full_body.vframes = 3
		%AnimationPlayer.play('special')
		await %AnimationPlayer.animation_finished
		while not leaving_queue:
			var random_val = randi() % 100
			if random_val < 80:
				$full_body.texture = customer.idle_body_texture
				if customer.name == 'Chef Bruno':
					$full_body.hframes = 4
					$full_body.vframes = 2
				else:
					$full_body.hframes = 5
					$full_body.vframes = 3
				%AnimationPlayer.play('idle')
			else:
				$full_body.texture = customer.special_body_texture
				if customer.name == 'Chef Bruno':
					$full_body.hframes = 4
					$full_body.vframes = 2
				else:
					$full_body.hframes = 4
					$full_body.vframes = 3
				%AnimationPlayer.play('special')
			await %AnimationPlayer.animation_finished
		emit_signal("movement_finished")
		
func repeat_order_line():
	%DialogueLabel.text = order_line

func get_dialogue_time(line):
	var time = 0
	if line.length() > 60:
		time = 3
	else:
		time = 2
	return time
	
func say_special_dialogue():
	for line in customer.special_order_lines:
		var time = get_dialogue_time(line)
		%DialogueLabel.text = line
		await get_tree().create_timer(time).timeout
		
func enter_queue():
	leaving_queue = false
	finished_moving = false
	var counter = 0
	while counter != 4:
		await exit_animation()
		counter += 1
		
func exit_queue():
	leaving_queue = true
	if not finished_moving:
		await self.movement_finished
		finished_moving = true
	var counter = 0
	while counter != 6:
		await exit_animation()
		counter += 1
	reset_sprites()
		
func reset_sprites():
	$head.texture = null
	$body.texture = null
	$face.texture = null
	$hair.texture = null
	$full_body.texture = null
