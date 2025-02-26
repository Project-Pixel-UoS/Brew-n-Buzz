extends Node2D


@onready var mugObject: Node2D =  %Mug


var draggable = false
var is_inside_mug = false
var is_inside_bin = false
var body_ref
var offset: Vector2
var initialPos: Vector2
var being_dragged = false

func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("click"):
			## @brief maintain position of where mouse clicked on object through using an offset
			## @brief if i hold object from bottom left it will maintain that
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			GameManager.is_dragging = true
			being_dragged = true
		if Input.is_action_pressed("click"):
			## @brief when clicked on object make object pos same as cursor
			global_position = get_global_mouse_position() - offset
			being_dragged = true
		elif Input.is_action_just_released("click"):
			GameManager.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_mug and body_ref:
				## @brief if object is dropped in box then move item to box
				print("Dropping into mug at position: ", body_ref.global_position)
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
				await tween.finished  # Wait until the animation finishes
				queue_free()
				replenish_ingredient(name)  # Recreate the ingredient at the original position
				  # Remove the old ingredient from the scene
			elif is_inside_bin and body_ref:
				print("Ingredient dropped into bin! Destroying...")
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
				queue_free()  
				replenish_ingredient(name)
				# Remove the ingredient from the scene
			else:
				## @brief if object is dropped in an invalid position then return back to original position
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
			being_dragged = false

func _on_area_2d_area_entered(body: Node2D) -> void:
	if body.is_in_group('ingredient') && being_dragged:
		is_inside_mug = true
		body_ref = body  
		if body_ref and body_ref.get_parent().has_method("add_ingredient"):
			print(body_ref)
			body_ref.get_parent().add_ingredient(name)  # Add ingredient to mug
		else:
			print("Error: body_ref is null or missing add_ingredient method")
	# Check if the object is a bin and destroy the ingredient
	elif body.is_in_group('bin'):
		is_inside_bin = true
		body_ref = body
		

func _on_area_2d_area_exited(body: Node2D) -> void:
	## @brief if object is not hovering over the box go back to normal size
	if body.is_in_group('ingredient'):
		is_inside_mug = false


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
		
func replenish_ingredient(ingredient_name) -> void:
	if scene_file_path != "":
		var ingredient_scene = load(scene_file_path)  # Dynamically load the correct ingredient scene
		var new_ingredient = ingredient_scene.instantiate()
		new_ingredient.global_position = initialPos
		get_parent().add_child(new_ingredient)
		new_ingredient.name = ingredient_name
	else:
		print("Error: scene_file_path is empty, cannot replenish ingredient")
