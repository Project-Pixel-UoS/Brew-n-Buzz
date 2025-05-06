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
func _on_area_2d_area_entered(body: Node2D) -> void:
	# Get the ingredients of the drink and determine its name
	print("Mug landed on counter")
	# Find the mug object in the parent node
	var ingredients: Array[String]
	for child in get_parent().get_children():
		if child.name.begins_with("Mug"):
			ingredients = child.get_ingredients()
			
	var customer_panel = %CustomerPanel
	print(customer_panel)
	var drink = customer_panel.get_doll().get_customer().drink
	print("Created drink:", drink.name)

	var is_correct = drink.isValidIngredients(ingredients)
	var customerManager = levelManager.find_child("CustomerQueueManager", true, false)

	print("Ingredients in mug: ", ingredients)
	print("Is drink correct: ", is_correct)

	# Handle correct and incorrect recipes
	if is_correct:
		levelManager.increment_correct_recipe()
		levelManager.add_payment(2)
		mugObject.stop_animation()
		mugObject.get_node('Sprite2D').hframes = 1
		mugObject.get_node('Sprite2D').vframes = 1
		await get_tree().process_frame
		mugObject.get_node("Sprite2D").texture = drink.image
	else:
		levelManager.increment_incorrect_recipe()
		print("incorrect recipe")

	# Tell the customer manager that a drink was served
	if customerManager:
		print("CustomerManager found:", customerManager.name)
		customerManager.customer_served(is_correct)
	else:
		print("Customer manager not found!")

	# Free the mug object after serving the customer
	#mugObject.queue_free()
