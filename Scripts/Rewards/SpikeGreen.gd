extends Reward

@export var counter = 0


func before_pickup():
	sprite.sprite_frames = load("res://Animations/long.tres")
	sprite.play("default")
	sprite.modulate = game_control.colors["green"]
	set_description("Emerald Spike","""Gain 1 Bubble for every 6 [color=green]green[/color] 
enemies defeated""")
	

func on_pickup():
	pass


func on_kill(color):
	if color == "green":
		shake_timer = shake_duration
		counter += 1
		if counter == 6:
			counter = 0
			player.health += 1
			game_control.healthbar.display_hearts(player.health)
		label.text = str(counter)
