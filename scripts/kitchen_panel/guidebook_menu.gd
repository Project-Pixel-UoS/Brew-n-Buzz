extends Control
@onready var guidebook_layer = %guidebook_layer
@onready var guidebook_menu = %guidebook_menu
var pages = []
var current_page_index = 0
@export var page_sounds = []
var path = "res://assets/audio/sfx/guidebook sounds/page sounds/"
var dir_access = DirAccess.open(path)
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	var files = dir_access.get_files()
	for file in files:
		if file.ends_with(".import"):
			continue
		else:
			var loaded_resource = load(path + file)
			page_sounds.append(loaded_resource)
	var button = guidebook_menu.get_node("TextureButton")
	button.connect("pressed", Callable(self, "_on_button_pressed"))	
	pages = get_node("Pages").get_children()
	for child in pages:
		child.visible = false
	
func _on_button_pressed(): #back button
	AudioManager.set_stream(load('res://assets/audio/sfx/guidebook sounds/book_close.wav'))
	AudioManager.play()
	guidebook_layer.visible = false
	
func get_current_page_index():
	return current_page_index
	
func show_correct_page(number):
	pages[current_page_index].visible = false
	pages[number].visible = true
	current_page_index = number
	if current_page_index == 0:
		guidebook_menu.get_node("LeftButton").visible = false
		guidebook_menu.get_node("RightButton").visible = true
	elif current_page_index == pages.size() - 1:
		guidebook_menu.get_node("RightButton").visible = false
		guidebook_menu.get_node("LeftButton").visible = true
	else:
		guidebook_menu.get_node("RightButton").visible = true
		guidebook_menu.get_node("LeftButton").visible = true
		
func get_next_right_page():
	var number = rng.randi_range(0,page_sounds.size()-1)
	AudioManager.set_stream(page_sounds[number])
	AudioManager.play()
	await get_tree().create_timer(0.3).timeout
	show_correct_page(get_next_page("right"))
	
func get_next_left_page():
	var number = rng.randi_range(0,page_sounds.size()-1)
	AudioManager.set_stream(page_sounds[number])
	AudioManager.play()
	await get_tree().create_timer(0.3).timeout
	show_correct_page(get_next_page("left"))
	
func get_next_page(value) -> int:
	if value == "right" && current_page_index + 1 < pages.size():
		return current_page_index + 1
	elif value == "left" && current_page_index -1 != -1:
		return current_page_index - 1
	else:
		return current_page_index
	
