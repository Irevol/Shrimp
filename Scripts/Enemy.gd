@abstract
extends Node2D
class_name Enemy

@onready var game_control: GameControl = get_tree().current_scene #just gets root node
@onready var player: Player = game_control.get_node("Player")
var requests_to_move_here: Enemy
var requested_dir: Vector2
var request_handled := false
var max_turns = 1
var turns
var color: String


func _ready():
	game_control.enemy_turn.connect(on_enemy_turn)
	game_control.total_enemies += 1
	turns = max_turns
	$AnimatedSprite2D.play("idle")


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
	queue_free()


## given dict with .allow_move and .prevent_move and node collided with
func handle_collision(movement_rules: Dictionary, node: Node2D) -> Dictionary:
	if node is Player:
		player.take_damage()
		movement_rules.prevent_move = true
	return movement_rules
	

func end_turn():
	request_handled = false
	requests_to_move_here = null
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
	var movement_rules := {"allow_move": false, "prevent_move": false, "defer": false}
	if target_pos in game_control.claimed_positions: return movement_rules
	if detected_nodes:
		for node: Node2D in detected_nodes:
			if node.is_in_group("walkable"):
				movement_rules.allow_move = true
			if node is Enemy:
				movement_rules.prevent_move = true
				#print(request_handled)
				#if not request_handled and node.requests_to_move_here == null:
					#node.requests_to_move_here = self # if enemy moves out of way, it will move this enemy
					#node.requested_dir = dir
					#movement_rules.defer = true
			movement_rules = handle_collision(movement_rules, node) #custom movement rules
	return movement_rules


func move_in_dir(dir):
	if dir.x == 1:
		$AnimatedSprite2D.flip_h = true
	elif dir.x == -1:
		$AnimatedSprite2D.flip_h = false
	
	var target_pos = position + (dir * game_control.tile_size)
	var movement_rules = can_move_in_dir(dir)
	
	if movement_rules.defer:
		return
	if movement_rules.allow_move and not movement_rules.prevent_move:
		game_control.claimed_positions.append(target_pos)
	else:
		game_control.claimed_positions.append(position)
		
	#if requests_to_move_here != null:
		#print("I tried...")
		#requests_to_move_here.request_handled = true
		#requests_to_move_here.move_in_dir(requested_dir)
		
	if movement_rules.allow_move and not movement_rules.prevent_move:
		await $Move.move_to_pos(target_pos)
	else:
		await $Move.move_to_pos(position + (dir * 32))
		await $Move.move_to_pos(position - (dir * 32))
		
	end_turn()
