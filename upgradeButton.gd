extends TextureButton

var machineName = name.split("Button")[0]
var current_price = 0
var shader

func _ready() -> void:
	shader = preload("res://scenes/ingredient_scenes/greyscale.gdshader") 
	
func _process(delta: float) -> void:
	if current_price > GameManager.get_money():
		self.disabled = true
		self.set_material(ShaderMaterial.new())
		self.get_material().shader = shader
		var money_icon = get_node('Coins')
		money_icon.set_material(ShaderMaterial.new())
		money_icon.get_material().shader = shader
		
func _on_pressed() -> void:
	GameManager.remove_money(current_price)
	GameManager.add_upgrade(machineName)
	
func set_price(price):
	current_price = price
