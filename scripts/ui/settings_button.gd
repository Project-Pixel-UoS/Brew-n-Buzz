extends TextureButton
@onready var settingsLayer = %SettingsLayer

func _ready() -> void:
	settingsLayer.visible = false
		
func open_settings():
	var coord_scale = get_viewport().get_visible_rect().size.x / 320
	var button = settingsLayer.get_node('settings_menu/BackButton')
	button.position = Vector2(208,108)*coord_scale
	settingsLayer.visible = true
	Engine.time_scale = 0
