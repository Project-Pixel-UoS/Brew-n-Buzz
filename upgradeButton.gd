extends TextureButton

var machineName = name.split("Button")[0]
var current_price = 0
func _on_pressed() -> void:
	GameManager.remove_money(current_price)
	GameManager.add_upgrade(machineName)
	
func set_price(price):
	current_price = price
