extends Enemy
class_name Fish

var cycle = 1

func init_enemy():
	var shader: ShaderMaterial = $AnimatedSprite2D.material
	shader.set_shader_parameter("target_color", game_control.colors[color])
	
	
# move towards player, but don't suicide
func on_enemy_turn():
	var diff = player.position - position
	var dir = Vector2.DOWN
	var player_dir = Vector2.DOWN
	cycle *= -1
	
	if abs(diff.x) > abs(diff.y):
		player_dir = Vector2(sign(diff.x), 0)
	else:
		player_dir = Vector2(0, sign(diff.y))
		
	dir = purge(player_dir)
	
	var flag := false
	for i in range(7):
		if i >= 4:
			if blocked.has(dir): 
				dir = purge(dir.rotated(PI/2.0*cycle))
			else:
				flag = true
			print("suicide")
		else:
			if blocked.has(dir) or suicide.has(dir):
				dir = purge(dir.rotated(PI/2.0*cycle))
			else:
				flag = true
		if flag:
			break
			
	print(dis_to_player())
	await move_in_dir(dir)
	end_turn()
