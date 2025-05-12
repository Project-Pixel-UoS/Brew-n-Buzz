extends Control

@onready var money_label: RichTextLabel = $"."

func _process(delta: float) -> void:
	money_label.text='[center]' + str(GameManager.get_money())
	
