class_name Customer extends Resource

@export var patience: float
@export var body: Body
@export var drink: Resource

func _init(p_patience = 20, p_body = null, p_drink = null):
	patience = p_patience
	body = p_body
	drink = p_drink
