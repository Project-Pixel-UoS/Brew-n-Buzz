extends Label

const max_chars_per_line = 12
const pixel_height_per_line = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "This is some awesome text"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Temporary, when dialogue system is built this will only be
	# updated when text changes
	size.y = 24 + (text.length() / max_chars_per_line * pixel_height_per_line)
	pass
