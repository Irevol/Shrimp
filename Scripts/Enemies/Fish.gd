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
		
	dir = player_dir
	for i in range(4):
		if i == 3:
			dir = player_dir
		if blocked.has(purge(dir)):
			dir = dir.rotated(PI/2*cycle)
		else:
			break
			
	await move_in_dir(dir)
	end_turn()
