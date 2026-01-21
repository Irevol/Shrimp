extends AudioStreamPlayer2D

@export var win: AudioStream
@export var death: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

func play_reward_map_sound():
	stream = win
	play()
	
func play_death():
	stream = death
	play()
