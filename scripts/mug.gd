extends Node2D
# Called when the node enters the scene tree for the first time.
@onready var animationPlayer = %AnimationPlayer


var ingredients = []
var draggable = false
var is_inside_object = false
var body_ref
var offset: Vector2
var initialPos: Vector2
var last_frame_x = global_position.x
var is_inside_bin = false
var initial_mug_position = Vector2(1081,715)

func remove_numbers(input_string: String) -> String:
	var result = ""
	for char in input_string:
		if not (char >= "0" and char <= "9"):  # Check if the character is not a digit
			result += char  # Add the character to result if it's not a digi
	return result

func add_ingredient(ingredient: String) -> void:
	print(remove_numbers(ingredient))
	ingredients.append(remove_numbers(ingredient))
	print("added " + remove_numbers(ingredient))
	
func get_ingredients() -> Array:
	return ingredients
	
func determine_animation(x_change) -> void:
	if x_change < -4:
		animationPlayer.play("move_left")
	elif x_change > 4:
		animationPlayer.play("move_right")
		
func _process(delta: float) -> void:
	var initial_x = global_position.x
	var x_change = initial_x - last_frame_x
	if draggable:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			## @brief maintain position of where mouse clicked on object through using an offset
			## @brief if i hold object from bottom left it will maintain that
			offset = get_global_mouse_position() - global_position
			GameManager.is_dragging = true
			determine_animation(x_change)
		if Input.is_action_pressed("click"):
			## @brief when clicked on object make object pos same as cursor
			global_position = get_global_mouse_position() - offset
			determine_animation(x_change)
		elif Input.is_action_just_released("click"):
			GameManager.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_object and body_ref:
				## @brief if object is dropped in box then move item to box
				print("Dropping into object at position: ", body_ref.global_position)
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
				animationPlayer.play("idle")
			elif is_inside_bin and body_ref:
				print("Mug dropped into bin! Destroying...")
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
				body_ref.get_parent().play_sound()
				queue_free()
				replenish_mug()
			else:
				## @brief if object is dropped in an invalid position then return back to original position
				print("Invalid drop, returning to initial position")
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
				
				determine_animation(x_change)
				animationPlayer.play("idle")
		last_frame_x = initial_x

func replenish_mug():
	if scene_file_path != "":
		var mug_scene = load(scene_file_path) 
		var new_mug = mug_scene.instantiate()
		new_mug.global_position = initial_mug_position
		get_parent().add_child(new_mug)
		new_mug.name = "Mug"
	else:
		print("Error: scene_file_path is empty, cannot replenish mug")

func _on_area_2d_area_entered(body: Node2D) -> void:
	if body.is_in_group('mug'):
		is_inside_object = true
		body.modulate = Color(Color.DARK_BLUE, 1)
		body_ref = body  
	elif body.is_in_group('bin'):
		is_inside_bin = true
		body_ref = body
		
func _on_area_2d_area_exited(body: Node2D) -> void:
	## @brief if object is not hovering over the box go back to normal size
	if body.is_in_group('mug'):
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
