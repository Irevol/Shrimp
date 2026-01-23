extends Reward


func before_pickup():
	sprite.sprite_frames = load("res://Animations/conch.tres")
	sprite.play("default")
	sprite.modulate = game_control.colors["purple"]
	unique = true
	set_description("Amethyst Conch","Gain extra [color=yellow]karma[/color] from purple enemies")
	

func on_kill(color):
	if color == "purple":
		player.kills += 0.5
		shake_timer = shake_duration
