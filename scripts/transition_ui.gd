extends Control
## @brief controls how the menu is tweened

@export var start_position: Vector2
@export var is_active: bool
@export var duration: float = 1.0
@export var transition_type: Tween.TransitionType = Tween.TRANS_CUBIC
@export var ease_type: Tween.EaseType = Tween.EASE_IN_OUT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_active:
		start_position = position


func transition(going_in: bool = true):
	var target_pos: Vector2 = Vector2() if (going_in) else start_position
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", target_pos, duration).set_ease(
			ease_type).set_trans(transition_type)
