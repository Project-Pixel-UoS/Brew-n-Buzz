extends Node2D

var has_milk = false
var steamed_milk = false
var frothed_milk = false
var is_inside_valid_drop = false
var body_ref
var offset: Vector2
var initialPos: Vector2
var is_inside_bin = false
var respawnPos
var being_dragged = false

func _ready() -> void:
	respawnPos = global_position
	initialPos = global_position
	
func add_ingredient(name):
	has_milk = true
	print("added milk to milk jug")

func replenish_milk_jug():
		var milk_jug_scene = load(scene_file_path)
		var new_milk_jug = milk_jug_scene.instantiate()
		new_milk_jug.global_position = respawnPos
		get_parent().add_child(new_milk_jug)
		new_milk_jug.name = "MilkJug"
		print("replenished milk jug!")
	
func set_steamed_milk(truth_value):
	steamed_milk = truth_value

func check_valid_drop(body: Node2D) -> bool:
	if body.is_in_group('ingredient') or body.is_in_group('frother') or body.is_in_group('steamWand'):
		return true
	return false
	
func _on_area_2d_area_entered(body: Node2D) -> void:
	if being_dragged:
		if check_valid_drop(body):
			is_inside_valid_drop = true
			body_ref = body  
		elif body.is_in_group('bin'):
			is_inside_bin = true
			body_ref = body
		
func _on_area_2d_area_exited(body: Node2D) -> void:
	if body_ref:
		if body.get_parent() == body_ref.get_parent():
			is_inside_valid_drop = false
			is_inside_bin = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			offset = global_position - event.position
			GameManager.is_dragging = true
			scale = Vector2(1.05,1.05)  
			being_dragged = true
		elif not event.pressed: 
			being_dragged = false
			GameManager.is_dragging = false
			scale = Vector2(1,1)
			await get_tree().physics_frame
			var tween = get_tree().create_tween()
			if is_inside_valid_drop and body_ref and has_milk and not is_inside_bin:
				if steamed_milk && body_ref.is_in_group("ingredient"):
					queue_free()
					replenish_milk_jug()
					print("Dropping steamed milk into milk jug")
					body_ref.get_parent().add_ingredient("Steamed Milk")
				elif frothed_milk && body_ref.is_in_group("ingredient"):
					queue_free()
					replenish_milk_jug()
					print("Dropping frothed milk into milk jug")
					body_ref.get_parent().add_ingredient("Frothed Milk")
				elif body_ref.is_in_group("frother"):
					print("Dropping into object at position: ", body_ref.global_position)
					tween.tween_property(self, "global_position",body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
					await tween.finished
					body_ref.get_parent().froth_milk()
					frothed_milk = true
					initialPos = body_ref.global_position
				elif !steamed_milk:
					body_ref.get_parent().steam_milk(self)
					initialPos = body_ref.global_position
			elif is_inside_bin and body_ref:
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
				await tween.finished
				queue_free()  
				replenish_milk_jug()
			else:
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
								
	elif event is InputEventScreenDrag and being_dragged:
		global_position = event.position - offset
