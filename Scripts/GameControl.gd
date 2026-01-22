extends Node2D
class_name GameControl

var tile_size = 288
@onready var player: Player = $Player
@onready var reward_map: RewardMap = $RewardMap
@onready var healthbar: Healthbar = $UI/Healthbar
@onready var sound_effects: SoundEffects = $SoundEffects
@export var slash: PackedScene
@export var bullet: PackedScene
@export var rune_anims: Array[SpriteFrames]
var total_enemies: int = 0
var enemies_finised: int = 0
var enemies_killed: int = 0 # used to update total_enemies, not running count
var claimed_positions := []
var current_rewards: Array[Reward]
var summon_requested: bool = false
var game_over = false
var darken_ui = false
var frozen = []
const light_level = 0.2
var colors: Dictionary[String, Color] = {
	"purple": Color("7952de"),
	"green": Color("64c200"),
	"orange": Color("fa7f26"),
	"dark": Color("363a37"),
}
signal enemy_turn
signal enemy_finished
signal kill_lights


func _ready():
	enemy_finished.connect(start_player_turn)
	set_lighting(1)
	#$Map/Walkable.modulate.a = 100/255.0
	player.reset()
	await get_tree().create_timer(1).timeout
	# summon_rewards()
	
	
func reset():
	$UI/Tooltip.undisplay()
	game_over = false
	
	for child in $UI/Rewardbar.get_children():
		child.queue_free()
	current_rewards.clear()
	player.kills = 0
	player.update_killbar()
	
	var tween: Tween = create_tween()
	darken_ui = true
	tween.tween_method(set_lighting, 1.0, light_level, 1.5)
	await tween.finished
	darken_ui = false
	$UI/Darkness.modulate = Color.WHITE
	
	
	
func start_enemy_turn():
	
	if total_enemies == 0 or player.reward_walker:
		start_player_turn() 
		return
	
	await get_tree().create_timer(0.2).timeout
	
	if summon_requested:
		summmon_rewards_for_real()
		
	start_player_turn()
	claimed_positions.clear()
	print("enemy turn started")
	enemy_turn.emit()
	
	
func start_player_turn():
	if total_enemies - enemies_killed > enemies_finised and not player.reward_walker: return
	
	frozen.clear()
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
	if darken_ui: $UI/Darkness.color = color
	
	
func summon_rewards():
	summon_requested = true
	
func summmon_rewards_for_real():
	summon_requested = false
	sound_effects.play_sound("win.mp3")
	reward_map.global_position = player.position
	reward_map.generate_rewards()
	player.change_light_mask(2)
	reward_map.transition_in()
	player.reward_walker = true
	player.z_index += 10
	
	#var tween: Tween = create_tween()
	#tween.set_trans(tween.TRANS_CUBIC)
	#tween.tween_method(set_lighting, light_level, 0.9, 1)
	
func exit_rewards():
	player.can_press_key = false
	player.kills = 0
	player.z_index -= 10
	$UI/Tooltip.undisplay()
	player.change_light_mask(1)
	var move: Move = player.get_node("Move")
	reward_map.transition_out()
	await move.move_to_pos(reward_map.global_position)
	#reward_map.position = Vector2(0,10000)
	player.reward_walker = false
	player.can_press_key = true
	
	#var tween: Tween = create_tween()
	#tween.set_trans(tween.TRANS_CUBIC)
	#tween.tween_method(set_lighting, 0.9, light_level, 1)
	#await tween.finished
	
	healthbar.display_hearts(player.health)
	player.update_killbar()
	
	$Music.play_normal_map_music()

	
func init_slash(pos: Vector2):
	var cur_slash = slash.instantiate()
	cur_slash.position = pos
	add_child(cur_slash)
	
	
# probably shouldnt be in game control? idk player and enmeies need access, too lazy
func fire_bullet(pos: Vector2, dir: Vector2, dmg_enemy = false, dmg = 0):
	var cur_bullet: Bullet = bullet.instantiate()
	cur_bullet.position = pos
	cur_bullet.dir = dir
	cur_bullet.damage = dmg
	cur_bullet.damage_enemies = dmg_enemy
	add_child(cur_bullet)
	return await cur_bullet.tree_exited
	

func position_rewards():
	for i in range(current_rewards.size()):
		current_rewards[i].position = Vector2(128 * i, 0)
	
	
func on_die():
	darken_ui = true
	kill_lights.emit()
	sound_effects.play_sound("ded.mp3")
	var tween: Tween = create_tween()
	tween.set_trans(tween.TRANS_CUBIC)
	tween.tween_method(set_lighting, light_level, 1, 1)
	await tween.finished
	darken_ui = false
	
	$UI/Tooltip.display("You died ):")
	game_over = true
	#flow handed to player
	
