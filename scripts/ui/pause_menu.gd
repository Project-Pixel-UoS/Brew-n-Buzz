extends Control
@onready var pauseLayer = %PauseLayer
@onready var pause_menu = %pause_menu
@onready var levelManager = get_tree().root.get_node("Level1")


func _on_back_button_pressed():
	pauseLayer.visible = false
	Engine.time_scale = 1

func _on_exit_level_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("scenes/main_menu/main_menu.tscn")
	

#func exit_with_saving_pressed():
	#levelManager.save_level()
	#Engine.time_scale = 1
	#print("saving level...")
	#get_tree().change_scene_to_file("scenes/main_menu/main_menu.tscn")
