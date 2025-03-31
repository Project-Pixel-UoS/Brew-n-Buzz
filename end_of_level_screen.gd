extends Control
@onready var levelManager = get_tree().root.get_node("Level1")

func _on_exit_level_button_pressed() -> void:
	levelManager.save_level()
	print("saving level...")
	get_tree().change_scene_to_file("scenes/main_menu.tscn")

func _on_next_level_button_pressed() -> void:
	levelManager.save_level()
	print("saving level...")
	get_tree().change_scene_to_file("scenes/level_2.tscn")
