extends Node2D

@export var customer: Customer
@onready var customer_scene = get_tree().root.get_node(".")
@export var spawn_position: Vector2
@export var max_customers: int = 5
@export var possible_heads: Array[Texture2D]
@export var possible_bodies: Array[Texture2D]
@export var possible_faces: Array[Texture2D]
@export var possible_hairs: Array[Texture2D]
@export var vip_customers: Array[PackedScene]
@export var named_customers: Array[Resource]

@export var possible_order_lines: Array[String]

var customer_queue: Array = []
var current_customer: Node = null
var is_spawning: bool = false


@export var drinks: Array[Drink]

#  Function to pick a random drink
func get_random_drink() -> Drink:
	return drinks[randi() % drinks.size()]

func _ready():
	queue_numbers = GameManager.get_level_queue(1)
	var vip_named_count = 0
	for i in range(0,queue_numbers[0]):
		customer_queue.append(create_NPC_data())
	for i in range(0,queue_numbers[1]):
		customer_queue.append(named_customers[i])
	for i in range(0,queue_numbers[2]):
		customer_queue.append(vip_customers[i])
	customer_queue.shuffle()
	spawn_next_customer()
	
func create_NPC_data():
	var new_customer_data = CustomerData.new()
	new_customer_data.patience = randf_range(15.0, 30.0)
	new_customer_data.drink = get_random_drink()
	new_customer_data.head_texture = possible_heads.pick_random()
	new_customer_data.body_texture = possible_bodies.pick_random()
	new_customer_data.face_texture = possible_faces.pick_random()
	new_customer_data.hair_texture = possible_hairs.pick_random()
	new_customer_data.order_line = possible_order_lines.pick_random()
	new_customer_data.tip_value = 0
	return new_customer_data
func spawn_next_customer():
	if is_spawning or customer_queue.is_empty():
		return
	
	is_spawning = true
	var next = customer_queue.pop_front()
	%Doll.customer = next 
	%PatienceMeter.connect("customer_angry", Callable(self, "_on_customer_angry"))
	%PatienceMeter.call_deferred("start_meter", self)
	is_spawning = false
	%Doll.set_customer()
	
func create_customer() -> Customer:
	var new_customer = Customer.new(
		randf_range(15.0, 30.0),
		null,
		get_random_drink(),
		#TODO could modulate the colours? 
		possible_heads.pick_random(),
		possible_bodies.pick_random(),
		possible_faces.pick_random(),
		possible_hairs.pick_random(),
		possible_order_lines.pick_random()
	)
	return new_customer

func _on_customer_angry():
	%Doll.react_to_drink(false)
	await get_tree().create_timer(1.0).timeout
	remove_customer()

func customer_served(correct: bool):
	if not correct:
		%PatienceMeter.timer.stop()
		%PatienceMeter.out_of_patience = true
		%PatienceMeter.animationPlayer.play("angry")
		await get_tree().create_timer(0.5).timeout

	%Doll.react_to_drink(correct)
	await get_tree().create_timer(1.0).timeout
	remove_customer()

func remove_customer():
	%Doll.reset_sprites()
	customer = null
	await get_tree().create_timer(1.0).timeout
	spawn_next_customer()
