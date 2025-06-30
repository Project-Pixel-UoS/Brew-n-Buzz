extends Node2D

var draggable = false
var is_inside_valid_drop = false
var is_inside_bin = false
var body_ref
var initialPos: Vector2
var being_dragged = false
var has_ground_coffee = false
var respawnPos
var can_be_dragged = true

@onready var grinder = get_node_or_null("../Grinder")
@onready var coffeeMachine = get_node_or_null("../CoffeeMachine")
@export var ingredient: Ingredient

func set_dragged(value):
	can_be_dragged = value
	
func _ready() -> void:
	initialPos = position
	respawnPos = position
	Input.set_use_accumulated_input(false)
	
func _unhandled_input(event):
	if being_dragged and event is InputEventScreenDrag:
		global_position = event.position
	elif being_dragged and event is InputEventScreenTouch and not event.pressed:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
		being_dragged = false	
		
func _process(delta: float) -> void:
	has_ground_coffee = grinder.is_coffee_grinded()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenTouch and can_be_dragged:
		if event.pressed:
			GameManager.is_dragging = true
			scale = Vector2(1.05,1.05)  
			being_dragged = true
			global_position = event.position
			z_index = 20
		elif not event.pressed:
			being_dragged = false
			GameManager.is_dragging = false
			scale = Vector2(1,1)
			await get_tree().physics_frame
			if is_inside_valid_drop and body_ref and has_ground_coffee:
				print("group handle good !")
				if body_ref.get_parent().name == "CoffeeMachine":
					var new_position = Vector2(95,360)
					print(new_position)
					var tween = get_tree().create_tween()
					tween.tween_property(self, "position", new_position, 0.2).set_ease(Tween.EASE_OUT)
					await tween.finished 
					grinder.remove_coffee()
					coffeeMachine.is_group_handle_in_machine(true)
				elif body_ref.get_parent().name == "Mug":
					body_ref.get_parent().add_ingredient(ingredient)
			elif is_inside_bin and body_ref:
				queue_free()  
				replenish_group_handle()
			else:
				print("hi3")
				var tween = get_tree().create_tween()
				tween.tween_property(self, "position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
			z_index = 0				
	elif event is InputEventScreenDrag and being_dragged:
		global_position = event.position
		

func _on_area_2d_area_entered(body: Node2D) -> void:
	if being_dragged:
		if check_valid_drop(body):
			is_inside_valid_drop = true
			body_ref = body  
		elif body.is_in_group('bin'):
			is_inside_bin = true
			body_ref = body
		elif body.is_in_group('ingredient'):
			is_inside_valid_drop = true
		
func check_valid_drop(body: Node2D) -> bool:
	for shape in body.get_children():
		if shape.is_in_group("groupHandle"):
			return true
	return false		
	
func _on_area_2d_area_exited(body: Node2D) -> void:
	if body_ref:
		if body.get_parent() == body_ref.get_parent():
			is_inside_valid_drop = false
			is_inside_bin = false
			
func replenish_group_handle() -> void:
	var handle_scene = load(scene_file_path)
	var new_handle= handle_scene.instantiate()
	new_handle.position = respawnPos
	get_parent().add_child(new_handle)
	new_handle.name = "GroupHandle"
