extends Node2D

@export var character: Customer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$head._on_button_pressed()
	$body._on_button_pressed()
	$face._on_button_pressed()
	$hair._on_button_pressed()

func _on_button_pressed() -> void:
	_ready()
