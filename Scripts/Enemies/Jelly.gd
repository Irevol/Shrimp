extends Enemy
class_name Jelly

var cur_dir := Vector2.DOWN


func init_enemy():
	pass

# move towards player
func on_enemy_turn():
	for i in range(3):
		if is_walkable(dir_to_pos(cur_dir)):
			break
		cur_dir = cur_dir.rotated(PI/2)
	move_in_dir(cur_dir)
