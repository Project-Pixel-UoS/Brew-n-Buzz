extends Node2D

var mugObject: Node2D


var draggable = false
var is_inside_valid_drop = false
var is_inside_bin = false
var body_ref
var offset: Vector2
var initialPos: Vector2
var being_dragged = false
var valid_drops = ['ingredient','milkJug']
@export var ingredient: Ingredient
var select_sound
var deselect_sound

func _ready() -> void:
	select_sound = load('res://assets/audio/sfx/pick_up_select.wav')
	deselect_sound = load('res://assets/audio/sfx/put_down_deselect.wav')
	initialPos = position

func _process(delta: float) -> void:
	for child in get_parent().get_children():
		if child.name.begins_with("Mug"):
			mugObject = child
	if draggable:
		if Input.is_action_just_pressed("click"):
			## @brief maintain position of where mouse clicked on object through using an offset
			## @brief if i hold object from bottom left it will maintain that
			#initialPos = position
			offset = get_global_mouse_position() - position
			GameManager.is_dragging = true
			being_dragged = true
			AudioManager.set_stream(select_sound)
			AudioManager.play()
		if Input.is_action_pressed("click"):
			## @brief when clicked on object make object pos same as cursor
			position = get_global_mouse_position() - offset
			being_dragged = true
		elif Input.is_action_just_released("click"):
			GameManager.is_dragging = false
			AudioManager.set_stream(deselect_sound)
			AudioManager.play()
			if is_inside_valid_drop and body_ref:
				## @brief if object is dropped in box then move item to box
				print("Dropping into mug at position: ", body_ref.position)
				var tween = get_tree().create_tween()
				tween.tween_property(self, "position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
				await tween.finished  # Wait until the animation finishes
				queue_free()
				
				replenish_ingredient(name)  # Recreate the ingredient at the original position
				  # Remove the old ingredient from the scene
			elif is_inside_bin and body_ref:
				print("Ingredient dropped into bin! Destroying...")
				var tween = get_tree().create_tween()
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
				queue_free()  
				replenish_ingredient(name)
				# Remove the ingredient from the scene
			else:
				## @brief if object is dropped in an invalid position then return back to original position
				var tween = get_tree().create_tween()
				tween.tween_property(self, "position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
			being_dragged = false

func check_valid_drop(body: Node2D) -> bool:
	for group in valid_drops:
		if body.is_in_group(group):
			return true
	return false
	
func _on_area_2d_area_entered(body: Node2D) -> void:
	if check_valid_drop(body) && being_dragged:
		is_inside_valid_drop = true
		body_ref = body  
		if body_ref and body_ref.get_parent().has_method("add_ingredient"):
			body_ref.get_parent().add_ingredient(ingredient)  # Add ingredient to mug
			#mugObject.add_ingredient(ingredient)
		else:
			print("Error: body_ref is null or missing add_ingredient method")
	# Check if the object is a bin and destroy the ingredient
	elif body.is_in_group('bin'):
		is_inside_bin = true
		body_ref = body
		
func _on_area_2d_area_exited(body: Node2D) -> void:
	## @brief if object is not hovering over the box go back to normal size
	if check_valid_drop(body):
		is_inside_valid_drop = false


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
		new_ingredient.position = initialPos
		get_parent().add_child(new_ingredient)
		new_ingredient.name = ingredient_name
	else:
		print("Error: scene_file_path is empty, cannot replenish ingredient")
