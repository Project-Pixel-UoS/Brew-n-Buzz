extends Node

@onready var levelManager: Node2D = get_tree().root.get_node("Level1")
var total_money = 0

## @brief for when an object is in a 'dragging state'
var is_dragging = false

func add_money(money):
	total_money += money
	
func get_money():
	return total_money

func update_level():
	pass
