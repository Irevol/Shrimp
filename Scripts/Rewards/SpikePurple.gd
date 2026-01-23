extends Reward

@export var counter = 0


func before_pickup():
	sprite.sprite_frames = load("res://Animations/long.tres")
	sprite.play("default")
	sprite.modulate = game_control.colors["purple"]
	set_description("Amethyst Spike","""Gain 1 Bubble for every 5 [color=purple]Purple[/color] 
enemies defeated""")
	

func on_pickup():
	pass


func on_kill(color):
	if color == "purple":
		counter += 1
		if counter == 5:
			counter = 0
			player.health += 1
			shake_timer = shake_duration
			game_control.healthbar.display_hearts(player.health)
		label.text = str(counter)
