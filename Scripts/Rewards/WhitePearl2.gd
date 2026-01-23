extends Reward


func before_pickup():
	sprite.sprite_frames = load("res://Animations/pearl.tres")
	sprite.play("default")
	sprite.modulate = Color("#ffff00")
	unique = true
	set_description("Gold Pearl","Gain 4 Bubbles")


func on_pickup():
	player.health += 4
	game_control.healthbar.display_hearts(player.health)
