extends TextureButton
@onready var settingsLayer = %SettingsLayer

func _ready() -> void:
	settingsLayer.visible = false
		
func open_settings():
	var button = settingsLayer.get_node('settings_menu/BackButton')
	button.position = Vector2(1250,650)
	settingsLayer.visible = true
	Engine.time_scale = 0
