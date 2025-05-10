extends TextureButton
@onready var pauseLayer = %PauseLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pauseLayer.visible = false # Replace with function body.

func _on_pressed() -> void:
	pauseLayer.visible = true
	Engine.time_scale = 0
