extends Node

var max_amount = 5 
var amount_in 
var coffee_grinded = false
var path = "res://images/kitchen panel/machines/grinder sprites/"
var dir_access = DirAccess.open(path)
var grinder_sprites = []

func _ready() -> void:
	amount_in = 0
	var files = dir_access.get_files()
	for file in files:
		if file.ends_with(".import"):
			continue
		else:
			var loaded_resource = load(path + file)
			grinder_sprites.append(loaded_resource)
	get_node("Sprite2D").texture = grinder_sprites[0]

func remove_coffee():
	get_node("Sprite2D").texture = grinder_sprites[amount_in-1]

func add_coffee():
	get_node("Sprite2D").texture = grinder_sprites[amount_in]

func fill_grinder() -> void:
	amount_in += 1
	print(amount_in)
	#run animation here
	if amount_in > max_amount:
		print("Grinder is already full!")
	else:
		add_coffee()
		coffee_grinded = true
	#auto grinding???
	
func get_amount() -> int:
	return amount_in

func is_coffee_grinded() -> bool:
	return coffee_grinded
