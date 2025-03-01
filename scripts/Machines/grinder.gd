extends Node

var max_amount
var amount_left
var coffee = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass ## need to code how to catch teh object when falls into script, idk how :( plz help fanks


func fill_grinder(coffee_entered: bool) -> void:
	if coffee_entered == true:
		amount_left = max_amount
