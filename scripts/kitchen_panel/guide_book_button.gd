extends TextureButton
@onready var guideBookLayer = %guidebook_layer
func _ready() -> void:
	guideBookLayer.visible = false
		
func open_guideBook():
	AudioManager.set_stream(load('res://assets/audio/sfx/guidebook sounds/book_open.wav'))
	AudioManager.play()
	await get_tree().create_timer(0.2).timeout
	guideBookLayer.visible = true
	guideBookLayer.get_node("guidebook_menu").show_correct_page(0)
	Engine.time_scale = 0
	
