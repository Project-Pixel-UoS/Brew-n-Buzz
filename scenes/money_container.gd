extends Panel

@onready var levelManager: Node2D = get_tree().root.get_node("Level1")
@onready var money_label = %MoneyLabel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	money_label.text = str(levelManager.get_level_money())
