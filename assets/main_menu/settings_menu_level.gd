extends Control

@onready var settingsMenu = %settings_menu
@onready var settingsLayer = %SettingsLayer

func _ready():
	var button = settingsMenu.get_node("BackButton")
	button.connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed():
	settingsLayer.visible = false
	Engine.time_scale = 1
