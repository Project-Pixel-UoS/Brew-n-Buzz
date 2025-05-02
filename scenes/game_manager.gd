extends Node

@onready var levelManager: Node2D = get_tree().root.get_node("Level1")
var total_money = 0
var upgrades = [['Grinder', 0]]
var level_queue = [[1,0,0]]
## @brief for when an object is in a 'dragging state'
var is_dragging = false

func get_level_queue(level_number):
	return level_queue[level_number-1]
	
func add_money(money):
	total_money += money
	
func remove_money(money):
	total_money -= money
	
func get_money():
	return total_money

func update_level():
	pass

func add_upgrade(machineName):
	upgrades[upgrades.find(machineName)][1] = upgrades[upgrades.find(machineName)][1] + 1
	print(upgrades[upgrades.find(machineName)][1])

func get_number_upgrades(machineName):
	return upgrades[upgrades.find(machineName)][1]
	
