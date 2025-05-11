extends Control
@onready var levelManager = get_tree().root.get_node("Level1")
var upgrade_positions

func _ready() -> void:
	upgrade_positions = [get_node('shop/upgrade_1'),get_node('shop/upgrade_2'),get_node('shop/upgrade_3')]
	var level_upgrades = GameManager.get_level_upgrades(1)
	var upgrade_counter = 0
	for upgrade_key in level_upgrades:
		var upgrade_name = GameManager.get_upgrade_name_from_key(upgrade_key)
		print(upgrade_name)
		var preload_string = 'res://scenes/kitchen_panel/upgrades/' + upgrade_name + '_upgrade.tscn'
		var upgrade_resource = load(preload_string).instantiate()
		upgrade_positions[upgrade_counter].add_child(upgrade_resource)
		upgrade_counter += 1
		
		#preload the buy button
	#TODO create each upgrade and position them on the right spot
	
func _on_exit_level_button_pressed() -> void:
	get_tree().change_scene_to_file("scenes/main_menu.tscn")
	Engine.time_scale = 1

func _on_next_level_button_pressed() -> void:
	get_tree().change_scene_to_file("scenes/level_2.tscn")
	Engine.time_scale = 1

func _process(delta: float) -> void:
	get_node('money_made/money_label').text = 'Money made: ' + str(levelManager.get_level_money())
	get_node('drinks_served/drinks_label').text = 'Drinks served: ' + str(levelManager.get_drinks_served())
	get_node('money_left/money_left_label').text = 'Total money: ' + str(GameManager.get_money())

func _on_replay_level_button_pressed() -> void:
	get_tree().change_scene_to_file("scenes/level_1.tscn")
	Engine.time_scale = 1
