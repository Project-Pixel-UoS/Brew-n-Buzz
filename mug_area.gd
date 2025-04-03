extends Node2D

var has_mug

func is_there_mug():
	if get_tree().get_nodes_in_group('ingredient').size() > 1:
		return true
	return false
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	has_mug = is_there_mug()
	if event is InputEventScreenTouch and not has_mug:
		replenish_mug()
		

func replenish_mug():
	var mug_scene = load("res://scenes/ingredient_scenes/Mug.tscn") 
	var new_mug = mug_scene.instantiate()
	new_mug.global_position = position
	get_parent().add_child(new_mug)
	new_mug.name = "Mug"
