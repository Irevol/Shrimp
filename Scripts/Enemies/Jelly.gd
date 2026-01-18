extends Enemy
class_name Jelly


func init_enemy():
	pass

# move towards player
func on_enemy_turn():
	var diff = player.position - position
	var dir = Vector2.DOWN
	if abs(diff.x) > abs(diff.y):
		dir = Vector2(sign(diff.x), 0)
	else:
		dir = Vector2(0, sign(diff.y))
		
	move_in_dir(dir)
