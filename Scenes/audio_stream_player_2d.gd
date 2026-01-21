extends AudioStreamPlayer2D

@export var sound_effect: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

func play_reward_map_sound():
	stream = sound_effect
	play()
	
