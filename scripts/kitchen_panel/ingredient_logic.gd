extends Node2D

var draggable = false
var is_inside_valid_drop = false
var is_inside_bin = false
var body_ref
var being_dragged = false
var mugObject: Node2D
var select_sound
var deselect_sound
var offset: Vector2
var respawnPos
var is_inside_grinder = true
var touchpos
func _ready() -> void:
	select_sound = load('res://assets/audio/sfx/pick_up_select.wav')
	deselect_sound = load('res://assets/audio/sfx/put_down_deselect.wav')
	respawnPos = position
	Input.set_use_accumulated_input(false)

func _process(delta: float) -> void:
	for child in get_tree().root.get_children():
		if child.name == ("Mug"):
			mugObject = child
	if being_dragged:
		global_position = touchpos
		
func _unhandled_input(event):
	if being_dragged and event is InputEventScreenTouch and not event.pressed:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", respawnPos, 0.2).set_ease(Tween.EASE_OUT)
		being_dragged = false
func set_respawn_position():
	respawnPos = Vector2(self.position.x, self.position.y)
	
func check_valid_drop(body: Node2D) -> bool:
	if name.contains('Coffee'):
		if body.is_in_group('grinder'):
			is_inside_grinder = true
			return true
	elif body.is_in_group('ingredient'):
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
			is_inside_grinder = false
			is_inside_bin = false

func replenish_ingredient(ingredient_name) -> void:
	var ingredient_scene = load(scene_file_path) 
	var new_ingredient = ingredient_scene.instantiate()
	get_parent().add_child(new_ingredient)
	new_ingredient.name = ingredient_name
	if new_ingredient.get_parent().name == 'TeaDrawer':
		new_ingredient.position = respawnPos
		new_ingredient.set_respawn_position()
	else:
		new_ingredient.position = respawnPos
		new_ingredient.set_respawn_position()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			offset = global_position - event.position
			GameManager.is_dragging = true 
			being_dragged = true
			touchpos = event.position
			z_index = 20
			AudioManager.set_stream(select_sound)
			AudioManager.play()
		elif not event.pressed:
			being_dragged = false
			GameManager.is_dragging = false
			AudioManager.set_stream(deselect_sound)
			AudioManager.play()

			await get_tree().physics_frame
			if is_inside_valid_drop and body_ref and not is_inside_bin:
				if body_ref.get_parent().name == 'Grinder':
					body_ref.get_parent().fill_grinder()
				else:
					body_ref.get_parent().add_ingredient(name)
				queue_free()
				replenish_ingredient(name)
			elif is_inside_bin and body_ref:
				queue_free() 
				replenish_ingredient(name)
			else:
				var tween = get_tree().create_tween()
				tween.tween_property(self, "position", respawnPos, 0.2).set_ease(Tween.EASE_OUT)
			z_index = 0	
								
	elif event is InputEventScreenDrag and being_dragged:
		touchpos = event.position
