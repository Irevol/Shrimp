extends Reward


func before_pickup():
	sprite.sprite_frames = load("res://Animations/conch.tres")
	sprite.play("default")
	sprite.modulate = game_control.colors["orange"]
	set_description("Topaz Conch","Gain extra [color=yellow]karma[/color] from orange enemies")
	

func on_kill(color):
	if color == "orange":
		player.kills += 0.5
		shake_timer = shake_duration
