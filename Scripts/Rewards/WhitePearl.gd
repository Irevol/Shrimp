extends Reward


func before_pickup():
	sprite.sprite_frames = load("res://Animations/pearl.tres")
	sprite.play("default")
	unique = true
	set_description("White Pearl","Gain 2 Bubbles")
	

func on_pickup():
	player.health += 2
	game_control.healthbar.display_hearts(player.health)
