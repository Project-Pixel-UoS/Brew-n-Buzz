extends Node2D

var draggable = false
var is_inside_mug = false
var body_ref
var offset: Vector2
var initialPos: Vector2


func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("click"):
			## @brief maintain position of where mouse clicked on object through using an offset
			## @brief if i hold object from bottom left it will maintain that
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			GameManager.is_dragging = true
		if Input.is_action_pressed("click"):
			## @brief when clicked on object make object pos same as cursor
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			GameManager.is_dragging = false
			var tween = get_tree().create_tween()
			print(is_inside_mug);
			if is_inside_mug and body_ref:
				## @brief if object is dropped in box then move item to box
				print("Dropping into mug at position: ", body_ref.global_position)
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				## @brief if object is dropped in an invalid position then return back to original position
				print("Invalid drop, returning to initial position")
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)


func _on_area_2d_area_entered(body: Node2D) -> void:
	print("Body entered:", body.name)  # Debugging line
	if body.is_in_group('mug'):
		print("Ingredient entered mug!")  # Debugging line
		print("Ingredient Path:", get_path())  
		print("Mug Path:", body.get_path())  
		is_inside_mug = true
		body.modulate = Color(Color.DARK_BLUE, 1)
		body_ref = body  




func _on_area_2d_area_exited(body: Node2D) -> void:
	## @brief if object is not hovering over the box go back to normal size
	if body.is_in_group('mug'):
		print("Ingredient exited mug!")
		is_inside_mug = false
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
