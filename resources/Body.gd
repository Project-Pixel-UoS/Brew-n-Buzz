class_name Body extends Resource

## @brief holds data for customer' attributess body attributes'
@export var head: Texture2D
@export var hair: Texture2D
@export var face: Texture2D
@export var body: Texture2D

func _init(p_head = null, p_hair = null, p_body = null, p_face = null):
	head = p_head
	hair = p_hair
	body = p_body
	face = p_face
