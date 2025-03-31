extends TextureButton

var machineName = name.split("Button")[0]

func _on_pressed() -> void:
	GameManager.remove_money(10)
	GameManager.add_upgrade(machineName)
