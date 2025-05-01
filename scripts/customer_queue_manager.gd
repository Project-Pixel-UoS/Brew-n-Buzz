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
@export var named_customers: Array[PackedScene]

@export var possible_order_lines: Array[String]

var customer_queue: Array = []
var current_customer: Node = null
var is_spawning: bool = false

var drinks = [
	"espresso",
	"latte",
	"americano",
	"mocha",
	"cappuccino"
]

func get_random_drink() -> String:
	return drinks[randi() % drinks.size()]

func _ready():
	var vip_named_count = 0
	
	# Add VIP
	if vip_customers.size() > 0:
		var vip_instance = vip_customers[0].instantiate()
		customer_queue.append(vip_instance)
		vip_named_count += 1
	
	# Add named
	if named_customers.size() > 0:
		var named_instance = named_customers[0].instantiate()
		customer_queue.append(named_instance)
		vip_named_count += 1
	
	# Fill rest with random customers
	for i in range(max_customers - vip_named_count):
		customer_queue.append(create_customer())

	spawn_next_customer()

func spawn_next_customer():
	if is_spawning or customer_queue.is_empty():
		return
	
	is_spawning = true
	var next = customer_queue.pop_front()
	
	if next is Node:  # VIP or Named customer scene
		add_child(next)
		customer = next.get("customer")  # assumes node has exported Customer resource
		%Doll.set_customer(customer, true)  # true = is special
	else:  # Normal customer
		customer = next
		%Doll.set_customer(customer, false)

	%PatienceMeter.connect("customer_angry", Callable(self, "_on_customer_angry"))
	%PatienceMeter.call_deferred("start_meter", self)

	is_spawning = false

func create_customer() -> Customer:
	var new_customer = Customer.new(
		randf_range(15.0, 30.0),
		null,
		get_random_drink(),
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
