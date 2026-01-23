extends Reward


func before_pickup():
	sprite.sprite_frames = load("res://Animations/pearl.tres")
	sprite.play("default")
	sprite.modulate = game_control.colors["green"]
	unique = true
	set_description("Emerald Pearl","Release a ranged attack when\nmoving right")
	

func on_move(dir):
	if dir == Vector2.RIGHT:
		shake()
		game_control.fire_bullet(self, player.position, Vector2.RIGHT, true)
