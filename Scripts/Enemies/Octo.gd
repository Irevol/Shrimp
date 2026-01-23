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
	if scared:
		dir = -dir
	
	for i in range(4):
		if blocked.has(purge(dir)):
			dir = dir.rotated(PI/2)
		else:
			break
	
	await move_in_dir(dir)
	end_turn()
	

func on_enemy_turn():
	scared = dis_to_player() <= 1.5
	if scared:
		move()
	else:
		if position.x == player.position.x:
			game_control.claimed_positions.append(position)
			await game_control.fire_bullet(self, position, Vector2(0, sign(-position.y+player.position.y)))
			end_turn()
		elif position.y == player.position.y:
			game_control.claimed_positions.append(position)
			await game_control.fire_bullet(self, position, Vector2(sign(-position.x+player.position.x), 0))
			end_turn()
		else:
			move()
