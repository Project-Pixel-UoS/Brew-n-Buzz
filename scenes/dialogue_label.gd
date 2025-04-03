extends Label

const max_chars_per_line = 12.0
const pixel_height_per_line = 8
var time_elapsed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "This is some text"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	#Temporary, when dialogue system is built this will only be
	# updated when text changes
	#size.y = 24 + (ceili(text.length() / max_chars_per_line) * pixel_height_per_line)
	
	if time_elapsed > 0.3:
		time_elapsed = 0.0
		text += "p"
	
