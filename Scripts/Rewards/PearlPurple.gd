extends Reward


func before_pickup():
	sprite.sprite_frames = load("res://Animations/pearl.tres")
	sprite.play("default")
	sprite.modulate = game_control.colors["purple"]
	unique = true
	set_description("Amethyst Pearl","Release a ranged attack when\nmoving down")
	

func on_move(dir):
	if dir == Vector2.DOWN:
		shake()
		game_control.fire_bullet(player.position, Vector2.DOWN, true)
