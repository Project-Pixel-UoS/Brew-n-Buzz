extends Node2D
# Called when the node enters the scene tree for the first time.
@onready var animationPlayer = %AnimationPlayer

var ingredients: Array[String] = []
var draggable = true
var is_inside_valid_drop = false
var body_ref
var initialPos: Vector2
var last_frame_x
var is_inside_bin = false
var respawnPos
var being_dragged = false
var x_change
var customer_panel
var touchpos
var counter 

signal entered_counter

func _ready() -> void:
	initialPos = global_position
	respawnPos = global_position
	last_frame_x = global_position.x
	Input.set_use_accumulated_input(false)
	customer_panel = get_node("../CustomerPanel")
	counter = get_node('../Counter')
	self.connect("entered_counter", Callable(counter, "_check_recipe"))
	
func _unhandled_input(event):
	if being_dragged and event is InputEventScreenTouch and not event.pressed:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
		determine_animation(x_change)
		animationPlayer.play('idle')
		being_dragged = false
		
func _process(delta: float) -> void: 
	x_change = global_position.x - last_frame_x
	last_frame_x = global_position.x
	if being_dragged:
		global_position = touchpos
		
func stop_animation():
	animationPlayer.set_process(false)
	
func remove_numbers(input_string: String) -> String:
	var result = ""
	for char in input_string:
		if not (char >= "0" and char <= "9"):
			result += char 
	return result

func add_ingredient(ingredient: String) -> void:
	ingredients.append(remove_numbers(ingredient))
	
func get_ingredients() -> Array[String]:
	return ingredients
	
func determine_animation(x_change) -> void:
	if x_change < -10:
		animationPlayer.play("move_left")
	elif x_change > 10:
		animationPlayer.play("move_right")

func set_draggable(value):
	draggable = value	
			
func has_child_with_name(parent: Node, child_name: String) -> bool:
	for child in parent.get_children():
		if child.name == child_name:
			return true
	return false

func check_valid_drop(body: Node2D) -> bool:
	for shape in body.get_children():
		if shape.is_in_group("mug"):
			is_inside_valid_drop = true
			body_ref = body
			return true
	return false
	
func _on_area_2d_area_entered(body: Node2D) -> void:
	if being_dragged:
		if check_valid_drop(body):
			is_inside_valid_drop = true
			body_ref = body  
		elif (body.get_parent()).name == 'Counter':
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
			GameManager.is_dragging = true
			scale = Vector2(1.05,1.05)  
			being_dragged = true
			touchpos = event.position
			determine_animation(x_change)
		elif not event.pressed: 
			being_dragged = false
			GameManager.is_dragging = false
			scale = Vector2(1,1)
			await get_tree().physics_frame
			var tween = get_tree().create_tween()
			if is_inside_valid_drop and body_ref:
	
				if body_ref.get_parent().name == "CoffeeMachine":
					if has_child_with_name(body_ref, "MugWaterCollision") and self.position.x > 900:
						tween.tween_property(self, "global_position", Vector2(973,502), 0.2).set_ease(Tween.EASE_OUT)
						body_ref.get_parent().add_water()
						is_inside_valid_drop = false
						initialPos = global_position
					else:
						body_ref.get_parent().is_mug_in_machine(true)
						tween.tween_property(self, "global_position", Vector2(719,497), 0.2).set_ease(Tween.EASE_OUT)
				elif body_ref.get_parent().name == "Counter":
					if customer_panel.get_node('CustomerQueueManager').is_customer_ready():
						tween.tween_property(self, "global_position", Vector2(210,980), 0.2).set_ease(Tween.EASE_OUT)
						await tween.finished
						emit_signal('entered_counter')
					else:
						tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
						determine_animation(x_change)
						animationPlayer.play("idle")
				elif body_ref.get_parent().name == "MugRing":
					tween.tween_property(self, "global_position", Vector2(1064,771), 0.2).set_ease(Tween.EASE_OUT)
				else:
					tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
				animationPlayer.play("idle")
				initialPos = body_ref.global_position
			elif is_inside_bin and body_ref:
				queue_free()  
			else:
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
				determine_animation(x_change)
				animationPlayer.play("idle")
							
	elif event is InputEventScreenDrag and being_dragged:
		touchpos = event.position
		determine_animation(x_change)
