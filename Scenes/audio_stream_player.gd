extends AudioStreamPlayer

@export var rainwater_music: AudioStream
@export var bells_music: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func play_reward_map_music():
	stream = bells_music
	play()
	
func play_normal_map_music():
	stream = rainwater_music
	play()
	
