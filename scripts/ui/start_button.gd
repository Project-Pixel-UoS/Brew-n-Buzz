extends TextureButton

@export var continueSprite: Texture2D
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	$"../../../SaverLoader".load_game()
	if ($"../../../SaverLoader".has_saved_game):
		texture_normal = continueSprite
	
