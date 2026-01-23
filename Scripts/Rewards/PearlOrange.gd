extends Reward


func before_pickup():
	sprite.sprite_frames = load("res://Animations/pearl.tres")
	sprite.play("default")
	sprite.modulate = game_control.colors["orange"]
	unique = true
	set_description("Topaz Pearl","Release a ranged attack when\nmoving to the left")
	

func on_move(dir):
	if dir == Vector2.LEFT:
		shake()
		game_control.fire_bullet(self, player.position, Vector2.LEFT, true)
