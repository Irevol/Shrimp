extends Enemy
class_name Jelly

var dir := Vector2.DOWN
var cycle = 1
const signs := [-1,1]


func init_enemy():
	pass

# move towards player
func on_enemy_turn():
	var diff = player.position - position
	var dis = dis_to_player()
	var player_dir: Vector2
	cycle *= -1
	
	if abs(diff.x) > abs(diff.y):
		player_dir = Vector2(sign(diff.x), 0)
	else:
		player_dir = Vector2(0, sign(diff.y))
		
	# attack if you can
	if dis <= 1:
		dir = player_dir
	
	for i in range(7):
		if i >= 4:
			if blocked.has(purge(dir)):
				dir = dir.rotated(PI/2*cycle)
			else:
				break
		else:
			if blocked.has(purge(dir)) or suicide.has(purge(dir)):
				dir = dir.rotated(PI/2*cycle)
			else:
				break
			
	await move_in_dir(dir)
	end_turn()
