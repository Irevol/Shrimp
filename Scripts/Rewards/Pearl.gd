extends Reward


func before_pickup():
	sprite.sprite_frames = load("res://Animations/pearl.tres")
	sprite.play("default")
	sprite.modulate = Color.AQUAMARINE
	set_description("Emerald Pearl","Gain 3 Bubbles")
	

func on_pickup():
	player.health += 3
