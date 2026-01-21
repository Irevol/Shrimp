extends AudioStreamPlayer
class_name SoundEffects


func play_sound(sound_name: String):
	stream = load("res://Sound_Effects/"+sound_name)
	play()
