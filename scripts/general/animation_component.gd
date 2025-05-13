
## @brief Adds a shrinking animation to each button
class_name AnimationComponent extends Node

var target : Control
var default_scale : Vector2

@export var from_center : bool = true
var shrink_scale : Vector2
@export var time : float = 0.2
@export var transition_type: Tween.TransitionType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_parent()
	
	if from_center:
		target.pivot_offset = target.size / 2
	default_scale = target.scale
	shrink_scale = Vector2(default_scale[0] * 5/6, default_scale[1] * 5/6)

func add_tween(property : String, value, seconds: float) -> Tween:
	var tween = get_tree().create_tween()
	tween.tween_property(target,property,value,seconds).set_trans(transition_type)
	return tween

func _finished_press():
	add_tween("scale",default_scale,time)

func button_press() -> void:
	if from_center:
		target.pivot_offset = target.size / 2
	default_scale = target.scale
	var tween = add_tween("scale",shrink_scale,time)
	tween.finished.connect(_finished_press)
