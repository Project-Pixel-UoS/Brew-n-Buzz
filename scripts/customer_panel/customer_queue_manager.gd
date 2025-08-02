extends Node2D

@export var customer: CustomerData
@onready var customer_scene = get_tree().root.get_node(".")
@export var spawn_position: Vector2
@export var max_customers: int = 0
@export var possible_heads: Array[Texture2D]
@export var possible_bodies: Array[Texture2D]
@export var possible_faces: Array[Texture2D]
@export var possible_hairs: Array[Texture2D]
@export var vip_customers: Array[Resource]
@export var named_customers: Array[Resource]

@export var possible_correct_drink_lines: Array[String]
@export var possible_first_incorrect_drink_lines: Array[String]
@export var possible_second_incorrect_drink_lines: Array[String]
@export var possible_third_incorrect_drink_lines: Array[String]
@export var possible_order_lines: Array[String]
@export var drinks: Array[Resource]

var customer_queue: Array = []
var queue_numbers
var customer_ready
var queue_empty = false
var doll
var strikes = 0

#  Function to pick a random drink
func get_random_drink() -> Drink:
	return drinks[randi() % drinks.size()]

func is_customer_ready():
	return customer_ready
	
func _ready():
	customer_ready = false
	queue_numbers = GameManager.get_level_queue(1)
	var vip_named_count = 0
	for i in range(0,queue_numbers[0]):
		customer_queue.append(create_NPC_data())
	for i in range(0,queue_numbers[1]):
		customer_queue.append(named_customers[i])
	for i in range(0,queue_numbers[2]):
		customer_queue.append(vip_customers[i])
	customer_queue.shuffle()
	# To fill out rest of level with NPCs
	while customer_queue.size() < max_customers:
		customer_queue.append(create_NPC_data())
	%PatienceMeter.connect("customer_angry", Callable(self, "_on_customer_angry"))
	spawn_next_customer()
	
func create_NPC_data():
	var new_customer_data = CustomerData.new()
	new_customer_data.patience = 40 #randf_range(15.0, 30.0)
	new_customer_data.drink = get_random_drink()
	new_customer_data.head_texture = possible_heads.pick_random()
	new_customer_data.body_texture = possible_bodies.pick_random()
	new_customer_data.face_texture = possible_faces.pick_random()
	new_customer_data.hair_texture = possible_hairs.pick_random()
	new_customer_data.order_line = possible_order_lines.pick_random()
	new_customer_data.correct_drink_line = possible_correct_drink_lines.pick_random()
	new_customer_data.incorrect_drink_lines = pick_incorrect_drink_lines()
	new_customer_data.tip_value = 0
	return new_customer_data

func pick_incorrect_drink_lines():
	var line_array: Array[String] = []
	line_array.append(possible_first_incorrect_drink_lines.pick_random())
	line_array.append(possible_second_incorrect_drink_lines.pick_random())
	line_array.append(possible_third_incorrect_drink_lines.pick_random())
	return line_array
	
func is_queue_empty():
	return queue_empty	
	
func spawn_next_customer():
	if customer_queue.is_empty():
		queue_empty = true
	strikes = 0
	await respawn_doll()
	doll.reset_pos()
	var next = customer_queue.pop_front()
	doll.customer = next 
	await doll.update_customer_appearance()
	await doll.enter_queue()
	%PatienceMeter.get_node('Sprite2D').visible = true
	%DialogueLabel.visible = true
	%PatienceMeter.call_deferred("start_meter", self, next.patience)
	doll.say_dialogue()
	customer_ready = true

func _on_customer_angry():
	react_to_drink(false)
	await get_tree().create_timer(1.0).timeout
	remove_customer()

func customer_served(correct: bool):
	await react_to_drink(correct)
	if strikes == 3 or correct or %PatienceMeter.is_out_of_patience():
		customer_ready = false
		%PatienceMeter.get_node('Timer').stop()
		%PatienceMeter.animationPlayer.play("angry")
		remove_customer()
	else:
		doll.repeat_order_line()

func remove_customer():
	%PatienceMeter.get_node('Sprite2D').visible = false
	%DialogueLabel.visible = false
	await doll.exit_queue()
	customer = null
	doll.queue_free()
	spawn_next_customer()
	
func react_to_drink(correct: bool):
	if correct:
		%PatienceMeter.get_node('Timer').stop()
		%PatienceMeter.animationPlayer.play("happy")
		var time = doll.get_dialogue_time(doll.customer.correct_drink_line)
		%DialogueLabel.text =  doll.customer.correct_drink_line
		await get_tree().create_timer(1.5).timeout
	elif %PatienceMeter.is_out_of_patience():
		var line = doll.customer.incorrect_drink_lines[2]
		var time = doll.get_dialogue_time(line)
		%DialogueLabel.text = line
		await get_tree().create_timer(time).timeout
	else:
		var line = doll.customer.incorrect_drink_lines[strikes]
		var time = doll.get_dialogue_time(line)
		%DialogueLabel.text = line
		strikes += 1
		await get_tree().create_timer(1.5).timeout

func respawn_doll():
	var doll_scene = load("res://scenes/customer_panel/doll.tscn") 
	var new_doll = doll_scene.instantiate()
	get_parent().call_deferred("add_child", new_doll)
	await new_doll.doll_ready
	new_doll.name = "Doll"
	get_parent().move_child(new_doll, 0)
	doll = new_doll
	
