extends Reward


func before_pickup():
	sprite.sprite_frames = load("res://Animations/conch.tres")
	sprite.play("default")
	sprite.modulate = game_control.colors["green"]
	unique = true
	set_description("Emerald Conch","Gain extra [color=yellow]karma[/color] from green enemies")
	

func on_kill(color):
	if color == "green":
		player.kills += 0.5
		shake_timer = shake_duration
