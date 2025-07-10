class_name saved_game
extends Resource
## Represents the saved game state (e.g., money, level, upgrades)

const SAVE_GAME_PATH := "res://resources/save_files/save_file.tres"

@export var level_completed: int = 0
@export var total_money: int = 0
@export var upgrades: Array = []
@export var correct_recipes: int = 0

func write_savegame() -> void:
	var err = ResourceSaver.save(self, SAVE_GAME_PATH)
	if err != OK:
		print("Failed to save game: ", err)

static func load_savegame() -> saved_game:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		var loaded = ResourceLoader.load(SAVE_GAME_PATH)
		if loaded is saved_game:
			return loaded
		else:
			print("Loaded resource is not a SavedGame!")
	return null
