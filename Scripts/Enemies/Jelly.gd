extends Enemy
class_name Jelly

var cur_dir := Vector2.DOWN
const signs := [-1,1]


func init_enemy():
	pass

# move towards player
func on_enemy_turn():
	if dis_to_player() <= 1:
		await move_in_dir(sign(player.position - position))
	else:
		var rand_sign = signs.pick_random()
		for i in range(3):
			if is_walkable(dir_to_pos(cur_dir)):
				break
			cur_dir = cur_dir.rotated(rand_sign*PI/2)
		await move_in_dir(cur_dir)
	end_turn()
