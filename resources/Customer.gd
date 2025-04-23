class_name Customer
extends Resource

## @brief holds data for customer attributes
@export var patience: float
@export var body: Body
@export var drink: String #TODO can become a resource later on
# Texture properties for the doll customization
@export var head_texture: Texture2D
@export var body_texture: Texture2D
@export var face_texture: Texture2D
@export var hair_texture: Texture2D

func _init(p_patience = 20, p_body = null, p_drink = null, 
		  p_head: Texture2D = null, p_body_tex: Texture2D = null,
		  p_face: Texture2D = null, p_hair: Texture2D = null):
	patience = p_patience
	body = p_body
	drink = p_drink
	head_texture = p_head
	body_texture = p_body_tex
	face_texture = p_face
	hair_texture = p_hair
	
