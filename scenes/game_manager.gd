extends Node

var total_money = 0

func add_money(money):
	total_money += money
	
func get_money():
	return total_money
