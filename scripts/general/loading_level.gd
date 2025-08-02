extends Node

var level_name: String
var game_manager: Node
var load_status: int

func _ready() -> void:
	SignalBus.connect("load_level", enable_loading_bar)
	set_process(false)

func enable_loading_bar(scene_name) -> void:
	level_name = scene_name
	ResourceLoader.load_threaded_request(level_name)
	self.visible = true
	set_process(true)

func _process(_delta) -> void:
	var progress = []
	load_status = ResourceLoader.load_threaded_get_status(level_name, progress)
	$ProgressBar.value = progress[0] * 100
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		SignalBus.emit_signal("load_level_complete")
		var new_scene = ResourceLoader.load_threaded_get(level_name)
		get_tree().change_scene_to_packed(new_scene)
