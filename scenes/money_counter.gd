extends Control

@onready var money_label: Label = $"."
@onready var game_manager: Node = $"../../../../GameManager"

func _process(delta: float) -> void:
	money_label.text=str(game_manager.get_money())
	
