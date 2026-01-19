extends Node2D
class_name GameControl

var tile_size = 288
@onready var player: Player = $Player
@onready var reward_map = $RewardMap
@onready var healthbar: Healthbar = $UI/Healthbar
var total_enemies: int = 0
var enemies_finised: int = 0
var enemies_killed: int = 0 # used to update total_enemies, not running count
var claimed_positions := []
var current_rewards: Array[Reward]
var summon_requested: bool = false
const light_level = 0.2
signal enemy_turn
signal enemy_finished


func _ready():
	enemy_finished.connect(start_player_turn)
	set_lighting(light_level)
	await get_tree().create_timer(1).timeout
	#summon_rewards()
	
	
func start_enemy_turn():
		
	await get_tree().create_timer(0.2).timeout
	
	if summon_requested:
		summmon_rewards_for_real()
	if total_enemies == 0 or player.reward_walker:
		start_player_turn() 
		return
		
	start_player_turn()
	claimed_positions.clear()
	enemy_turn.emit()
	
	
func start_player_turn():
	
	if total_enemies - enemies_killed > enemies_finised and not player.reward_walker: return
	
	if not player.reward_walker:
		enemies_finised = 0
		total_enemies -= enemies_killed
		enemies_killed = 0
		if total_enemies == 0:
			#win?
			pass
			
	player.can_press_key = true
	
	
func set_lighting(ratio: float):
	var darkness: CanvasModulate = $Darkness
	var color = Color.WHITE.darkened(ratio)
	darkness.color = color
	$Background/Darkness.color = color
	
	
func summon_rewards():
	summon_requested = true
	
	
func summmon_rewards_for_real():
	summon_requested = false
	reward_map.global_position = player.position
	reward_map.generate_rewards()
	reward_map.show()
	player.change_light_mask(2)
	player.reward_walker = true
	
	var tween: Tween = create_tween()
	tween.set_trans(tween.TRANS_CUBIC)
	tween.tween_method(set_lighting, light_level, 0.9, 1)
	
	
func exit_rewards():
	player.can_press_key = false
	reward_map.hide()
	player.change_light_mask(1)
	var move: Move = player.get_node("Move")
	await move.move_to_pos(reward_map.global_position)
	player.reward_walker = false
	player.can_press_key = true
	
	var tween: Tween = create_tween()
	tween.set_trans(tween.TRANS_CUBIC)
	tween.tween_method(set_lighting, 0.9, light_level, 1)
	
	
func on_die():
	$UI/Rewardbar.hide()
	var tween: Tween = create_tween()
	tween.set_trans(tween.TRANS_CUBIC)
	tween.tween_method(set_lighting, light_level, 0.9, 1)
	
