extends Node2D

var draggable = false
var is_inside_object = false
var body_ref
var offset: Vector2
var initialPos: Vector2
var is_inside_bin = false
var initial_frother_position = Vector2(1586,722)
var valid_drops = ['ingredient']

var milk_frothed = false

func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			## @brief maintain position of where mouse clicked on object through using an offset
			## @brief if i hold object from bottom left it will maintain that
			offset = get_global_mouse_position() - global_position
			GameManager.is_dragging = true
		if Input.is_action_pressed("click"):
			## @brief when clicked on object make object pos same as cursor
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			GameManager.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_object and body_ref and milk_frothed:
				## @brief if object is dropped in box then move item to box
				print("Dropping into object at position: ", body_ref.global_position)
				body_ref.get_parent().add_ingredient("Frothed Milk")
				queue_free()
				replenish_frother()
				#tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
			elif is_inside_bin and body_ref:
				print("Mug dropped into bin! Destroying...")
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
				queue_free()
				replenish_frother()
			else:
				## @brief if object is dropped in an invalid position then return back to original position
				print("Invalid drop, returning to initial position")
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_area_entered(body: Node2D) -> void:
	if body.is_in_group('ingredient'):
		is_inside_object = true
		body.modulate = Color(Color.DARK_BLUE, 1)
		body_ref = body  
	elif body.is_in_group('bin'):
		is_inside_bin = true
		body_ref = body
		
func _on_area_2d_area_exited(body: Node2D) -> void:
	## @brief if object is not hovering over the box go back to normal size
	if body.is_in_group('ingredient'):
		is_inside_object = false
		body.modulate = Color(Color.MEDIUM_BLUE, 0.7)


func _on_area_2d_mouse_entered() -> void:
	## @brief when mouse hovers over object it increase in size
	if not GameManager.is_dragging:
		draggable = true
		scale = Vector2(1.05,1.05)

func _on_area_2d_mouse_exited() -> void:
	## @brief when mouse hovers off object it goes back to original size
	if not GameManager.is_dragging:
		draggable = false
		scale = Vector2(1,1)

func replenish_frother():
	if scene_file_path != "":
		var ingredient_scene = load(scene_file_path)  # Dynamically load the correct ingredient scene
		var new_ingredient = ingredient_scene.instantiate()
		new_ingredient.global_position = initial_frother_position
		get_parent().add_child(new_ingredient)
		new_ingredient.name = "Frother"
		print("replenished frother!")
	else:
		print("Error: scene_file_path is empty, cannot replenish ingredient")
	pass

func check_valid_drop(body: Node2D) -> bool:
	for group in valid_drops:
		if body.is_in_group(group):
			return true
	return false
	
func froth_milk():
	print("milk being frothed!")
	get_node("Area2D").get_node("CollisionShape2D").set_deferred("disabled", true)  # Disable collision
	
	await get_tree().create_timer(3.0).timeout
	get_node("Area2D").get_node("CollisionShape2D").set_deferred("disabled", false)  # Disable collision
	
	milk_frothed = true
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)
