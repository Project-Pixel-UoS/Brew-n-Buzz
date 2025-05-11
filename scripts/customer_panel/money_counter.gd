extends Control

@onready var money_label: Label = $"."

func _process(delta: float) -> void:
	money_label.text=str(GameManager.get_money())
	
