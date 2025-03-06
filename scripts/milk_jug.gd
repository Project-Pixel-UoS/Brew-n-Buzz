extends Node2D

var has_milk = false
var steamed_milk = false
var frothed_milk = false
var draggable = false
var is_inside_object = false
var is_inside_valid_drop = false
var body_ref
var offset: Vector2
var initialPos: Vector2
var is_inside_bin = false
var initial_milk_jug_position = Vector2(1291,487)
var valid_drops = ['frother','steamWand','ingredient']
var mugObject
func _ready() -> void:
	pass # Replace with function body.

func add_ingredient(name):
	has_milk = true
	print("added milk to milk jug")

func _process(delta: float) -> void:
	for child in get_parent().get_children():
		if child.name.begins_with("Mug"):
			mugObject = child
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
			if is_inside_valid_drop and body_ref && has_milk:
				## @brief if object is dropped in box then move item to box
				if steamed_milk && body_ref.is_in_group("ingredient"):
					queue_free()
					replenish_milk_jug()
					print("Dropping steamed milk into mug")
					body_ref.get_parent().add_ingredient("Steamed Milk")
				elif frothed_milk && body_ref.is_in_group("ingredient"):
					queue_free()
					replenish_milk_jug()
					print("Dropping steamed milk into mug")
					body_ref.get_parent().add_ingredient("Frothed Milk")
				elif body_ref.get_parent().name == "Frother":
					print("Dropping into object at position: ", body_ref.global_position)
					tween.tween_property(self, "global_position", Vector2(1285,730), 0.2).set_ease(Tween.EASE_OUT)
					body_ref.get_parent().froth_milk()
					frothed_milk = true
				elif !steamed_milk:
					print("bam")
					body_ref.get_parent().steam_milk(self)
			elif is_inside_bin and body_ref:
				print("Mug dropped into bin! Destroying...")
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
				queue_free()
				replenish_milk_jug()
			else:
				## @brief if object is dropped in an invalid position then return back to original position
				print("Invalid drop, returning to initial position")
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)

func replenish_milk_jug():
	if scene_file_path != "":
		var ingredient_scene = load(scene_file_path)  # Dynamically load the correct ingredient scene
		var new_ingredient = ingredient_scene.instantiate()
		new_ingredient.global_position = initial_milk_jug_position
		get_parent().add_child(new_ingredient)
		new_ingredient.name = "MilkJug"
		print("replenished milk jug!")
	else:
		print("Error: scene_file_path is empty, cannot replenish ingredient")
	pass
	
func set_steamed_milk(truth_value):
	steamed_milk = truth_value
	
func check_valid_drop(body: Node2D) -> bool:
	for group in valid_drops:
		if body.is_in_group(group):
			return true
	return false
	
func _on_area_2d_area_entered(body: Node2D) -> void:
	if check_valid_drop(body):
		is_inside_valid_drop = true
		body.modulate = Color(Color.DARK_BLUE, 1)
		body_ref = body  
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
