extends TextureButton
@onready var settingsLayer = %SettingsLayer

func _ready() -> void:
	settingsLayer.visible = false
		
func open_settings():
	settingsLayer.visible = true
