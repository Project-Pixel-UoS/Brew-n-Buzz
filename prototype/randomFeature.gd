extends Sprite2D

@export var sprites : Array[Texture2D] = []

func _on_button_pressed() -> void:
	texture = sprites[randi() % len(sprites)]
