extends Node2D

@export var customer: Customer
@onready var customer_scene = get_tree().root.get_node(".")
@export var spawn_position: Vector2
@export var max_customers: int = 5
@export var possible_heads: Array[Texture2D]
@export var possible_bodies: Array[Texture2D]
@export var possible_faces: Array[Texture2D]
@export var possible_hairs: Array[Texture2D]

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

#  Function to pick a random drink
func get_random_drink() -> String:
	return drinks[randi() % drinks.size()]

func _ready():
	if customer_scene == null:
		push_error("Customer scene is not assigned!")
		return
	for i in range(max_customers):
		#potentially append seed for customer? TODO
		customer_queue.append("1")
	spawn_next_customer()

func spawn_next_customer():
	if is_spawning:
		return

	is_spawning = true

	if customer_scene:
		customer = create_customer()
		#customer.positon = Vector2(0.0,0.0)
		var doll = %Doll
		doll.set_customer(customer)
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
		possible_hairs.pick_random()
	)
	return new_customer
	
func _on_customer_angry():
	if current_customer:
		current_customer.get_node("Doll").react_to_drink(false)
		await get_tree().create_timer(1.0).timeout
		remove_customer()

func customer_served(correct: bool):
	if current_customer:
		current_customer.get_node("Doll").react_to_drink(correct)
		await get_tree().create_timer(1.0).timeout
		remove_customer()

func remove_customer():
	if current_customer:
		current_customer.queue_free()
		current_customer = null
		spawn_next_customer()
