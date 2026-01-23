extends Reward

@export var counter = 0


func before_pickup():
	sprite.sprite_frames = load("res://Animations/shell.tres")
	sprite.play("default")
	sprite.modulate = game_control.colors["orange"]
	set_description("Topaz Shell","""Every 4th turn, purple enemies are frozen 
""")
	

func on_pickup():
	pass


func on_move(_dir):
	counter += 1
	if counter == 4:
		shake_timer = shake_duration
		counter = 0
		game_control.frozen.append("orange")
	label.text = str(counter)
