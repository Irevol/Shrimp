extends Reward


func before_pickup():
	sprite.sprite_frames = load("res://Animations/conch.tres")
	sprite.play("default")
	sprite.modulate = Color.AQUAMARINE
	set_description("Emerald Conch","[color=yellow]Karma[/color] meter fills faster")
	

func on_pickup():
	player.max_kills -= 1
