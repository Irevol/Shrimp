extends Node2D
class_name GameControl

var tile_size = 288
@onready var player: Player = $Player
var total_enemies: int = 0
var enemies_finised: int = 0
var enemies_killed: int = 0 # used to update total_enemies, not running count
var claimed_positions := []
signal enemy_turn
signal enemy_finished


func _ready():
	enemy_finished.connect(start_player_turn)
	
	
func start_enemy_turn():
	if total_enemies == 0: # there's no enemies to take a turn!
		start_player_turn() 
		return
		
	await get_tree().create_timer(0.3).timeout
	
	claimed_positions.clear()
	enemy_turn.emit()
	
	
func start_player_turn():
	if total_enemies > enemies_finised: return
	
	await get_tree().create_timer(0.1).timeout
	
	enemies_finised = 0
	total_enemies -= enemies_killed
	enemies_killed = 0
	if total_enemies == 0:
		#win?
		pass
	player.can_press_key = true
