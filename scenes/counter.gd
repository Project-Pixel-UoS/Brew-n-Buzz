# counter.gd
extends Node2D

var mugObject: Node2D
@onready var levelManager: Node2D = get_tree().root.get_node("Level1")
@onready var counter = %Counter

## @brief Called when the scene is ready. Initializes the counter and mug object.
func _ready() -> void:
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)
	mugObject = get_parent().get_node("Mug")
	var area2d = counter.get_node("Area2D")

## @brief Compares the ingredients in the mug with the correct recipe, and determines whether the drink is correct.
## @details This function is called when the mug is placed on the counter. It checks the drink ingredients and notifies the customer manager.
func check_recipe():
	# Find the mug object in the parent node
	for child in get_parent().get_children():
		if child.name.begins_with("Mug"):
			mugObject = child

	# Get the ingredients of the drink and determine its name
	var ingredients = mugObject.get_ingredients()
	var drink_name = levelManager.get_drink_name(ingredients)
	print("Created drink:", drink_name)

	# Check if the drink name is valid and whether the recipe is correct
	var is_correct = drink_name != "" and drink_name != "unknown"
	var customerManager = levelManager.find_child("CustomerQueueManager", true, false)

	print("Ingredients in mug: ", ingredients)
	print("Detected drink: ", drink_name)

	# Handle correct and incorrect recipes
	if is_correct:
		levelManager.add_correct_recipe()
		levelManager.add_payment(2)
		print("correct recipe: ", drink_name)
		mugObject.stop_animation()
		mugObject.get_node('Sprite2D').hframes = 1
		mugObject.get_node('Sprite2D').vframes = 1
		await get_tree().process_frame
		mugObject.get_node("Sprite2D").texture = load('res://images/kitchen panel/mug sprites/bnb_' + drink_name + ".png")
	else:
		levelManager.add_incorrect_recipe()
		print("incorrect recipe")

	# Tell the customer manager that a drink was served
	if customerManager:
		print("CustomerManager found:", customerManager.name)
		customerManager.customer_served(is_correct)
	else:
		print("Customer manager not found!")

	# Free the mug object after serving the customer
	mugObject.queue_free()

## @brief Called when a body enters the Area2D node on the counter.
## @param body The body that entered the area. This is used to trigger the recipe check.
func _on_area_2d_area_entered(body: Node2D) -> void:
	check_recipe()
