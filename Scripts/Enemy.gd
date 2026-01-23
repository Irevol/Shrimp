@abstract
extends Node2D
class_name Enemy

@export var color: String = "unassigned"
@onready var game_control: GameControl = get_tree().current_scene #just gets root node
@onready var player: Player = game_control.get_node("Player")
var requests_to_move_here: Enemy
var requested_dir: Vector2
var request_handled := false
var turn_ended #just here for debugging
@export var blocked: Array[Vector2] = []
var max_turns = 1
var turns = 1


func _ready():
	if color == "unassigned":
		color = ["green","orange","purple"].pick_random()
		
	game_control.total_enemies += 1
	
	$AnimatedSprite2D.play("default")
	#$Move.move_speed = 4.5
	set_owner(game_control)
	game_control.enemy_turn.connect(take_turn_if_allowed)
	$AnimatedSprite2D.modulate = game_control.colors[color].clamp(Color.BLACK, Color("#959595"))
	if color == "dark":
		max_turns = 2
	turns = max_turns
	if get_parent() is Enemy:
		printerr("Enemy had child!")
	init_enemy()
	

func take_turn_if_allowed():
	var allowed = false
	turn_ended = false
	
	if (abs(player.global_position.x - global_position.x) < (288 * 6)) and (abs(player.global_position.y - global_position.y) < (288 * 4)):
		allowed = true
	if game_control.frozen.has(color):
		allowed = false
		
	#update blocked tiles
	blocked.clear()
	for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		if not is_walkable(dir_to_pos(dir)):
			blocked.append(dir)
		
	if allowed: 
		$AnimatedSprite2D.play("default")
		on_enemy_turn()
	else:
		$AnimatedSprite2D.stop()
		end_turn()


func purge(vec: Vector2):
	return snapped(vec, Vector2(0.1,0.1))


@abstract 
func init_enemy()


@abstract 
func on_enemy_turn()


## override me!
func take_damage():
	die()
	
	
func die():
	hide()
	# await get_tree().create_timer(0.5).timeout
	game_control.enemies_killed += 1
	player.kill.emit(color)
	player.after_kill()
	queue_free()


func dis_to_player():
	return snappedf(position.distance_to(player.position)/288, 0.1)


func is_walkable(pos: Vector2):
	var detected_nodes = $DetectTile.detect_tile(pos)
	var flag = false
	#no suicide (:
	if color != "dark":
		var dis = snapped(pos.distance_to(player.position), 0.01)
		if dis <= 288 and dis > 100:
			return false
	#normal stuff
	if detected_nodes:
		for node: Node2D in detected_nodes:
			if node.is_in_group("walkable"):
				flag = true
			if node.is_in_group("unwalkable") or node is Enemy or node is Gate:
				return false
	return flag


## given dict with .allow_move and .prevent_move and node collided with
func handle_collision(movement_rules: Dictionary, node: Node2D) -> Dictionary:
	if node is Player:
		player.take_damage()
		play_animation("attack")
		game_control.init_slash(player.position)
		movement_rules.prevent_move = true
	return movement_rules
	
	
func play_animation(anim_name: String):
	if not $AnimatedSprite2D.sprite_frames.has_animation(anim_name): return
	$AnimatedSprite2D.play(anim_name)
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("default")
	
	

func end_turn():
	#print("turn ended")
	turn_ended = true
	turns = turns - 1
	if turns == 0:
		turns = max_turns
		game_control.enemies_finised += 1
		game_control.enemy_finished.emit()
	else:
		on_enemy_turn()
		
		
func can_move_in_dir(dir):
	var target_pos = position + (dir * game_control.tile_size)
	var detected_nodes = $DetectTile.detect_tile(target_pos)
	var movement_rules := {"allow_move": false, "prevent_move": false}
	if game_control.claimed_positions.has(purge(target_pos)):
		movement_rules.prevent_move = true
		return movement_rules
	if detected_nodes:
		for node: Node2D in detected_nodes:
			print(node.name)
			if node.is_in_group("walkable"):
				movement_rules.allow_move = true
			if node.is_in_group("unwalkable"):
				movement_rules.prevent_move = true
			if node is Enemy or node is Gate:
				movement_rules.prevent_move = true
			movement_rules = handle_collision(movement_rules, node) #custom movement rules
	return movement_rules


func dir_to_pos(dir):
	return position + (Vector2(dir) * 288)


func move_in_dir(dir):
	#print("moved called")
	if dir.x == -1:
		$AnimatedSprite2D.flip_h = true
	elif dir.x == 1:
		$AnimatedSprite2D.flip_h = false
	
	var target_pos = dir_to_pos(dir)
	var movement_rules = can_move_in_dir(dir)
	
	#REALLY be safe, idk
	if game_control.claimed_positions.has(purge(target_pos)):
		movement_rules.prevent_move = true
		
	if movement_rules.allow_move and not movement_rules.prevent_move:
		game_control.claimed_positions.append(purge(target_pos))
		await $Move.move_to_pos(target_pos)
	else:
		game_control.claimed_positions.append(purge(position))
		$Move.move_speed *= 2
		await $Move.move_to_pos(position + (dir * 32))
		await $Move.move_to_pos(position - (dir * 32))
		$Move.move_speed /= 2
		
	return
