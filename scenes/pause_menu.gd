extends Control
@onready var pauseLayer = %PauseLayer
@onready var pause_menu = %pause_menu
@onready var levelManager = %LevelManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button = pause_menu.get_node("Button")
	button.connect("pressed", Callable(self, "_on_button_pressed"))	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_back_button_pressed():
	pauseLayer.visible = false
	Engine.time_scale = 1

func exit_without_saving_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("scenes/main_menu.tscn")
	
func exit_with_saving_pressed():
	levelManager.save_level()
	Engine.time_scale = 1
	print("saving level...")
	get_tree().change_scene_to_file("scenes/main_menu.tscn")
