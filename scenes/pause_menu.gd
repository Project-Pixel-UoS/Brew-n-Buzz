extends Control
@onready var pauseLayer = %PauseLayer
@onready var pause_menu = %pause_menu
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button = pause_menu.get_node("Button")
	button.connect("pressed", Callable(self, "_on_button_pressed"))	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_button_pressed():
	pauseLayer.visible = false
	Engine.time_scale = 1
