extends RichTextLabel

@onready var levelManager = get_tree().root.get_node("Level1")
var machine
@onready var parent_node = get_parent().get_parent()
var buyButton
var upgrades = 0
func _ready() -> void:
	var machine_name = name.split('_')[0]
	machine = levelManager.get_node('Machines/' + machine_name)
	buyButton = parent_node.get_node('Buy')
		
func _process(delta: float) -> void:
	upgrades = GameManager.get_number_upgrades(machine.name)
	var beginning_time = machine.get_current_time()

	self.text = '[center]' + str(beginning_time) + " -> " + str(beginning_time-0.25)
	buyButton.get_node('Price').text = '[center]' + str(10 + (2*upgrades))
	buyButton.set_price(10+(2*upgrades))
