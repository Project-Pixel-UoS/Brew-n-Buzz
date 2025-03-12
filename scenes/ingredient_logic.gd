extends Node2D

var draggable = false
var is_inside_valid_drop = false
var is_inside_bin = false
var body_ref
var initialPos: Vector2 
var being_dragged = false
var mugObject: Node2D
var select_sound
var deselect_sound
var offset: Vector2
var respawnPos
var is_inside_grinder = true

func _ready() -> void:
	select_sound = load('res://audio/sfx/pick_up_select.wav')
	deselect_sound = load('res://audio/sfx/put_down_deselect.wav')
	initialPos = global_position
	respawnPos = global_position
	Input.set_use_accumulated_input(false)

func _process(delta: float) -> void:
	var tween = get_tree().create_tween()
	for child in get_parent().get_children():
		if child.name.begins_with("Mug"):
			mugObject = child

		
func check_valid_drop(body: Node2D) -> bool:
	if name.contains('Coffee'):
		if body.is_in_group('grinder'):
			is_inside_grinder = true
			return true
	elif body.is_in_group('ingredient'):
		return true
	return false
			
func _on_area_2d_area_entered(body: Node2D) -> void:
	if check_valid_drop(body) && being_dragged:
		print("s")
		is_inside_valid_drop = true
		body_ref = body  
		print(is_inside_valid_drop)

	elif body.is_in_group('bin'):
		is_inside_bin = true
		body_ref = body
		
func _on_area_2d_area_exited(body: Node2D) -> void:
	if not being_dragged:
		is_inside_valid_drop = false
		is_inside_grinder = false
		is_inside_bin = false

func replenish_ingredient(ingredient_name) -> void:
	var ingredient_scene = load(scene_file_path) 
	var new_ingredient = ingredient_scene.instantiate()
	new_ingredient.global_position = respawnPos
	get_parent().add_child(new_ingredient)
	new_ingredient.name = ingredient_name
		
func get_node_at_touch_position(position: Vector2) -> Node:
	var query = PhysicsPointQueryParameters2D.new()
	query.position = position
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var space_state = get_world_2d().direct_space_state
	
	var result = space_state.intersect_point(query)
	
	if result.size() > 0:
		return result[0]["collider"]
	return null


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			offset = global_position - event.position
			GameManager.is_dragging = true
			scale = Vector2(1.05,1.05)  
			being_dragged = true
			AudioManager.set_stream(select_sound)
			AudioManager.play()
		elif not event.pressed: 
			being_dragged = false
			GameManager.is_dragging = false
			scale = Vector2(1,1)
			AudioManager.set_stream(deselect_sound)
			AudioManager.play()
			var tween = get_tree().create_tween()
			print(is_inside_valid_drop)
			print(body_ref)
			if is_inside_valid_drop and body_ref:
				print("h")
				if body_ref.get_parent().name == 'Grinder':
					body_ref.get_parent().fill_grinder()
				else:
					body_ref.get_parent().add_ingredient(name)
				print("hi1")
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
				await tween.finished
				queue_free()
				replenish_ingredient(name)
				initialPos = body_ref.global_position
			elif is_inside_bin and body_ref:
				print("hi2")
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
				queue_free()  
				replenish_ingredient(name)
			else:
				print("hi3")
				
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
								
	elif event is InputEventScreenDrag and being_dragged:
		global_position = event.position - offset
