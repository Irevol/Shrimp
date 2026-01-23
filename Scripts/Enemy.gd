@abstract
extends Node2D
class_name Enemy

@export var color: String
@onready var game_control: GameControl = get_tree().current_scene #just gets root node
@onready var player: Player = game_control.get_node("Player")
var requests_to_move_here: Enemy
var requested_dir: Vector2
var request_handled := false
var turn_ended #just here for debugging
@export var max_turns = 1
var turns


func _ready():
	color = "purple" #["green","orange","purple"].pick_random()
	game_control.total_enemies += 1
	turns = max_turns
	$AnimatedSprite2D.play("default")
	#$Move.move_speed = 4.5
	set_owner(game_control)
	game_control.enemy_turn.connect(take_turn_if_allowed)
	$AnimatedSprite2D.modulate = game_control.colors[color]
	if color == "dark":
		max_turns = 2
	if get_parent() is Enemy:
		printerr("Enemy had child!")
	init_enemy()
	

func take_turn_if_allowed():
	var allowed = false
	turn_ended = false
	
	if (abs(player.global_position.x - global_position.x) < (288 * 5)) and (abs(player.global_position.y - global_position.y) < (288 * 4)):
		allowed = true
	if game_control.frozen.has(color):
		allowed = false
		
	if allowed: 
		on_enemy_turn()
	else:
		end_turn()


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


func is_walkable(pos):
	var detected_nodes = $DetectTile.detect_tile(pos)
	var flag = false
	if detected_nodes:
		for node: Node2D in detected_nodes:
			if node.is_in_group("walkable"):
				flag = true
			if node.is_in_group("unwalkable"):
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
	turns -= 1
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
	if target_pos in game_control.claimed_positions: 
		return movement_rules
	if detected_nodes:
		for node: Node2D in detected_nodes:
			if node.is_in_group("walkable"):
				movement_rules.allow_move = true
			if node.is_in_group("unwalkable"):
				movement_rules.prevent_move = true
			if node is Enemy or node is Gate:
				movement_rules.prevent_move = true
			movement_rules = handle_collision(movement_rules, node) #custom movement rules
	return movement_rules


func dir_to_pos(dir):
	return position + (dir * game_control.tile_size)


func move_in_dir(dir):
	#print("moved called")
	if dir.x == -1:
		$AnimatedSprite2D.flip_h = true
	elif dir.x == 1:
		$AnimatedSprite2D.flip_h = false
	
	var target_pos = dir_to_pos(dir)
	var movement_rules = can_move_in_dir(dir)
	
	if movement_rules.allow_move and not movement_rules.prevent_move:
		game_control.claimed_positions.append(target_pos)
	else:
		game_control.claimed_positions.append(position)
		
	#if requests_to_move_here != null:
		#requests_to_move_here.request_handled = true
		#requests_to_move_here.move_in_dir(requested_dir)
		
	if movement_rules.allow_move and not movement_rules.prevent_move:
		await $Move.move_to_pos(target_pos)
	else:
		$Move.move_speed *= 2
		await $Move.move_to_pos(position + (dir * 32))
		await $Move.move_to_pos(position - (dir * 32))
		$Move.move_speed /= 2
		
	return
