extends TextureButton
@onready var guideBookLayer = %guidebook_layer
func _ready() -> void:
	guideBookLayer.visible = false
		
func open_guideBook():
	guideBookLayer.visible = true
	guideBookLayer.get_node("guidebook_menu").show_correct_page(0)
	
