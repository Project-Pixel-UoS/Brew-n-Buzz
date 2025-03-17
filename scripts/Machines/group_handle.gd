extends Node2D

var draggable = false
var is_inside_valid_drop = false
var is_inside_bin = false
var body_ref
var offset: Vector2
var initialPos: Vector2
var being_dragged = false
var has_ground_coffee = false
var respawnPos
@onready var grinder = get_node_or_null("../Grinder")
@onready var coffeeMachine = get_node_or_null("../CoffeeMachine")

func _ready() -> void:
	initialPos = global_position
	respawnPos = global_position
	Input.set_use_accumulated_input(false)
	
func _process(delta: float) -> void:
	has_ground_coffee = grinder.is_coffee_grinded()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var tween = get_tree().create_tween()
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
			if is_inside_valid_drop and body_ref and has_ground_coffee:
				print('in')
				if body_ref.get_parent().name == "CoffeeMachine":
					tween.tween_property(self, "global_position", Vector2(730,377), 0.2).set_ease(Tween.EASE_OUT)
					await tween.finished  # Wait until the animation finishes
					grinder.remove_coffee()
					coffeeMachine.is_group_handle_in_machine(true)
			elif is_inside_bin and body_ref:
				print("hi2")
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
				await tween.finished
				queue_free()  
				replenish_group_handle()
			else:
				print("hi3")
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
								
	elif event is InputEventScreenDrag and being_dragged:
		global_position = event.position - offset	
		

func _on_area_2d_area_entered(body: Node2D) -> void:
	if check_valid_drop(body) && being_dragged:
		is_inside_valid_drop = true
		body_ref = body  
	elif body.is_in_group('bin'):
		is_inside_bin = true
		body_ref = body
		
func check_valid_drop(body: Node2D) -> bool:
	for shape in body.get_children():
		if shape.is_in_group("groupHandle"):
			return true
	return false		
	
func _on_area_2d_area_exited(body: Node2D) -> void:
	is_inside_valid_drop = false
	is_inside_bin = false
	
func replenish_group_handle() -> void:
	var handle_scene = load(scene_file_path)  # Dynamically load the correct ingredient scene
	var new_handle= handle_scene.instantiate()
	new_handle.global_position = respawnPos
	get_parent().add_child(new_handle)
	new_handle.name = "GroupHandle"
