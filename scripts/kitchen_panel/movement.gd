extends Node2D

var offset: Vector2
var initialPos: Vector2
var moving_node
var being_dragged = false
var touch_position: Vector2
func _ready() -> void:
	moving_node = get_parent()
	
func _input(event):
	var node1 = get_node_at_touch_position(event.position)
	if node1 != null and node1.get_parent().name == get_parent().name:
		if event is InputEventScreenTouch:
			if event.pressed:
				initialPos = moving_node.global_position
				offset = event.position - initialPos
				GameManager.is_dragging = true
				moving_node.scale = Vector2(1.05,1.05)  
				being_dragged = true
			elif not event.pressed:  # Touch released
				being_dragged = false
				GameManager.is_dragging = false
				moving_node.scale = Vector2(1,1)
				touch_position = Vector2()
	elif event is InputEventScreenDrag and being_dragged:
		moving_node.position = event.position - offset
		touch_position = event.position

func _process(delta):
	if being_dragged:  # Capture touch position in world space
		moving_node.position = touch_position - offset  # Move the node based on the touch position

func get_node_at_touch_position(position: Vector2) -> Node:
	# Create a PhysicsPointQueryParameters2D object to pass to intersect_point()
	var query = PhysicsPointQueryParameters2D.new()
	query.position = position
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	# Get the space state for 2D physics
	var space_state = get_world_2d().direct_space_state
	
	# Perform the point intersection check
	var result = space_state.intersect_point(query)
	
	# If the result array is not empty, return the first collider (node) that was hit
	if result.size() > 0:
		return result[0]["collider"]  # Return the node that was hit by the touch
	return null  # No node was touched
