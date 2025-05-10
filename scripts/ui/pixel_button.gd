extends TextureButton

@export var credits_page: Control


func _on_pressed(make_visible: bool) -> void:
	credits_page.visible = make_visible
