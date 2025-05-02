extends Node2D

@export var customer: Customer
@onready var customer_scene = get_tree().root.get_node(".")
@export var spawn_position: Vector2
@export var max_customers: int = 5
@export var possible_heads: Array[Texture2D]
@export var possible_bodies: Array[Texture2D]
@export var possible_faces: Array[Texture2D]
@export var possible_hairs: Array[Texture2D]

@export var possible_order_lines: Array[String]

var customer_queue: Array = []
var current_customer: Node = null
var is_spawning: bool = false


@export var drinks: Array[Drink]

#  Function to pick a random drink
func get_random_drink() -> Drink:
	return drinks[randi() % drinks.size()]

func _ready():
	if customer_scene == null:
		push_error("Customer scene is not assigned!")
		return
	for i in range(max_customers):
		customer_queue.append(create_customer())  # Now appending actual customers
	spawn_next_customer()  # Start spawning the first customer

func spawn_next_customer():
	if is_spawning:
		return

	if customer_queue.is_empty():
		print("No more customers in queue!")
		return  # No more customers to spawn

	is_spawning = true

	if customer_scene:
		# Pop the next customer from the queue
		customer = customer_queue.pop_front()
		%Doll.set_customer(customer)
		print("successfully popped new customer")
		
		var patience_meter = %PatienceMeter
		patience_meter.connect("customer_angry", Callable(self, "_on_customer_angry"))
		patience_meter.call_deferred("start_meter", self)
	else:
		push_error("Customer scene is not assigned!")

	is_spawning = false


func create_customer() -> Customer:
	var new_customer = Customer.new(
		randf_range(15.0, 30.0),  # Random patience between 15–30s
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
	#TODO a walk away animation will need to be put in
	%Doll.reset_sprites()
	#current_customer.queue_free()
	customer = null
	await get_tree().create_timer(1.0).timeout
	spawn_next_customer()
