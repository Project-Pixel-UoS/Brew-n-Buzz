extends Node

var total_money = 0
var upgrades = [['Grinder',0,1]] 
var shop_upgrade_dictionary = {'A': "grinder", 'B': "coffee_machine"} #Changed naming to work better with scene finding
var level_upgrade_dictionary = {1: ['A']}
var level_queue = [[0,0,0]]
var is_dragging = false

func get_level_upgrades(level_number):
	return level_upgrade_dictionary[level_number]
	
func get_upgrade_name_from_key(key):
	return shop_upgrade_dictionary[key]
  
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

func get_max_upgrades(machineName):
	return upgrades[upgrades.find(machineName)][2]
