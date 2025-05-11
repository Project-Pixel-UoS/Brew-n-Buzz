extends AudioStreamPlayer2D


var audio_player: AudioStreamPlayer2D

func _ready():
	audio_player = AudioStreamPlayer2D.new()
	add_child(audio_player)
 
