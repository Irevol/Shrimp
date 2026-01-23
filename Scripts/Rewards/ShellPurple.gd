extends Reward

@export var counter = 0


func before_pickup():
	sprite.sprite_frames = load("res://Animations/shell.tres")
	sprite.play("default")
	sprite.modulate = game_control.colors["purple"]
	set_description("Amethyst Shell","""Every 4th turn, purple enemies are frozen
""")
	
 
func on_pickup():
	pass
	

func on_move(_dir):
	counter += 1
	if counter == 4:
		shake_timer = shake_duration
		counter = 0
		game_control.frozen.append("purple")
	label.text = str(counter)
