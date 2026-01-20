extends Enemy
class_name Octo


var is_shooting := false
var scared := false

func init_enemy():
	pass
	

func move():
	var diff = player.position - position
	var dir = Vector2.DOWN
	
	if abs(diff.x) > abs(diff.y):
		dir = Vector2(sign(diff.x), 0)
	else:
		dir = Vector2(0, sign(diff.y))
	
	for i in range(3):
		if is_walkable(dir_to_pos(dir)):
			break
		dir = dir.rotated(PI/2)
		
	if scared:
		dir = -dir
	
	await move_in_dir(dir)
	end_turn()
	

func on_enemy_turn():
	scared = position.distance_to(player.position) < 1.5 * 288
	if scared:
		move()
	else:
		if position.x == player.position.x and not scared:
			await game_control.fire_bullet(position, Vector2(0, sign(-position.y+player.position.y)))
			end_turn()
		elif position.y == player.position.y and not scared:
			await game_control.fire_bullet(position, Vector2(sign(-position.x+player.position.x), 0))
			end_turn()
		else:
			move()
