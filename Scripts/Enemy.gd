@abstract
extends Node2D
class_name Enemy

@onready var game_control: GameControl = get_tree().current_scene #just gets root node
@onready var player: Player = game_control.get_node("Player")
var max_turns = 1
var turns


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
	game_control.enemies_killed += 1
	end_turn()
	queue_free()


## given dict with .allow_move and .prevent_move and node collided with
func handle_collision(movement_rules: Dictionary, node: Node2D) -> Dictionary:
	if node is Player:
		player.take_damage()
		movement_rules.prevent_move = true
	if node.is_in_group("walkable"):
		movement_rules.allow_move = true
	if node is Enemy: # this has problems... it's difficult
		movement_rules.prevent_move = true
	return movement_rules
	

func end_turn():
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
	if target_pos in game_control.claimed_positions: return false
	if detected_nodes:
		for node: Node2D in detected_nodes:
			movement_rules = handle_collision(movement_rules, node)
	return movement_rules.allow_move and not movement_rules.prevent_move


func move_in_dir(dir):
	if dir.x == 1:
		$AnimatedSprite2D.flip_h = true
	elif dir.x == -1:
		$AnimatedSprite2D.flip_h = false
				
	if can_move_in_dir(dir):
		var target_pos = position + (dir * game_control.tile_size)
		game_control.claimed_positions.append(target_pos)
		await $Move.move_to_pos(target_pos)
	else:
		game_control.claimed_positions.append(position)
		await $Move.move_to_pos(position + (dir * 32))
		await $Move.move_to_pos(position - (dir * 32))
		
	end_turn()
