extends CanvasLayer
## @brief transitions a group of child menu objects

func _on_menu_button_pressed(menu_name: String) -> void:
	for menu in self.get_children():
		menu.transition(menu.name == menu_name)
