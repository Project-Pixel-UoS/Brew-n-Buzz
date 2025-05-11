extends Node2D

@export var bin_sounds = []
var path = "res://assets/audio/sfx/bin sounds/"
var dir_access = DirAccess.open(path)
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	var files = dir_access.get_files()
	for file in files:
		if file.ends_with(".import"):
			continue
		else:
			var loaded_resource = load(path + file)
			bin_sounds.append(loaded_resource)
	
func play_sound():
	var number = rng.randi_range(0,bin_sounds.size()-1)
	AudioManager.set_stream(bin_sounds[number])
	AudioManager.play()
	print("playing")
