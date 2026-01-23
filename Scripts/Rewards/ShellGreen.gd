extends Reward

@export var counter = 0


func before_pickup():
	sprite.sprite_frames = load("res://Animations/shell.tres")
	sprite.play("default")
	sprite.modulate = game_control.colors["green"]
	set_description("Emerald Shell","""Every 4th turn, green enemies are frozen
""")
	

func on_pickup():
	pass


func on_move(_dir):
	counter += 1
	if counter == 4:
		shake_timer = shake_duration
		counter = 0
		game_control.frozen.append("green")
	label.text = str(counter)
