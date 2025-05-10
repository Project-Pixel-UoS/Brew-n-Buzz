extends Node2D

var milk_steamed = true
@onready var animationPlayer = %AnimationPlayer


func steam_milk(milk_jug_node):
	print("milk being steamed!")
	milk_jug_node.get_node("Area2D").get_node("CollisionShape2D").set_deferred("disabled", true)  # Disable collision
	AudioManager.set_stream(load('res://assets/audio/sfx/machine sounds/steamer_v_3.wav'))
	AudioManager.play()
	animationPlayer.play('steaming')
	await get_tree().create_timer(2.3).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(AudioManager, "volume_db", -80, 1).set_ease(Tween.EASE_OUT)
	await tween.finished  
	AudioManager.stop()   
	AudioManager.volume_db = 0  

	animationPlayer.stop()
	milk_steamed = true
	milk_jug_node.set_steamed_milk(true)
	print("finished steaming milk")
	milk_jug_node.get_node("Area2D").get_node("CollisionShape2D").set_deferred("disabled", false)  # Disable collision
