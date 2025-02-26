extends Control
@onready var guidebook_layer = %guidebook_layer
@onready var guidebook_menu = %guidebook_menu
var pages = []
var current_page_index = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button = guidebook_menu.get_node("Button")
	button.connect("pressed", Callable(self, "_on_button_pressed"))	
	pages = get_node("Pages").get_children()
	for child in pages:
		child.visible = false
	print(pages)
func _on_button_pressed(): #back button
	guidebook_layer.visible = false
	
func get_current_page_index():
	return current_page_index
	
func show_correct_page(number):
	print(number)
	print(current_page_index)
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
	show_correct_page(get_next_page("right"))
	
func get_next_left_page():
	show_correct_page(get_next_page("left"))
	
func get_next_page(value) -> int:
	if value == "right" && current_page_index + 1 < pages.size():
		return current_page_index + 1
	elif value == "left" && current_page_index -1 != -1:
		return current_page_index - 1
	else:
		return current_page_index
	
