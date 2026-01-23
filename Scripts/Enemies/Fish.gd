extends Enemy
class_name Fish

var cycle = false

func init_enemy():
	var shader: ShaderMaterial = $AnimatedSprite2D.material
	shader.set_shader_parameter("target_color", game_control.colors[color])
	
	
# move towards player, but don't suicide
func on_enemy_turn():
	var diff = player.position - position
	var dir = Vector2.DOWN
	var dis = dis_to_player()
	print(dis)
	if dis <= 2 and dis > 1:
		print("avoiding")
		if diff.x == 0:
			if cycle:
				dir = Vector2.UP
			else:
				dir = Vector2.DOWN
		else:
			if cycle:
				dir = Vector2.RIGHT
			else:
				dir = Vector2.LEFT
		cycle = not cycle
	else:
		if abs(diff.x) > abs(diff.y):
			dir = Vector2(sign(diff.x), 0)
		else:
			dir = Vector2(0, sign(diff.y))
			
		for i in range(3):
			if is_walkable(dir_to_pos(dir)):
				break
			dir = dir.rotated(PI/2)
	await move_in_dir(dir)
	end_turn()
