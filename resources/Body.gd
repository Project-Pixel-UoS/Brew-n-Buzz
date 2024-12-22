class_name Body extends Resource

@export var head: Texture2D
@export var hair: Texture2D
@export var face: Texture2D
@export var body: Texture2D

func _init(p_head, p_hair, p_body, p_face):
	head = p_head
	hair = p_hair
	body = p_body
	face = p_face
