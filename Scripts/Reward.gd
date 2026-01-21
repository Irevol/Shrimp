@abstract
extends Node2D
class_name Reward

var shake_intensity: float = 25.0
var shake_duration: float = 0.5
var shake_timer: float = -10
var id: String
var game_control: GameControl
var player: Player
var unique := false
var floating := true
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $AnimatedSprite2D/PointLight2D

signal shake_done


func _ready():
	game_control = get_tree().current_scene
	if unique:
		game_control.reward_map.cur_rewards.erase(get_script())
	light.show()
	before_pickup()
	
func _process(delta: float):
	if shake_timer == -10:
		return
	if shake_timer > 0:
		shake_timer -= delta
		var current_strength = (shake_timer / shake_duration) * shake_intensity
		sprite.offset = Vector2(randf_range(-current_strength, current_strength),randf_range(-current_strength, current_strength))
	else:
		shake_timer = -10
		shake_done.emit()
		sprite.offset = Vector2.ZERO
		

func set_description(title, description):
	$Tooltip.text = title+'\n'+"[font_size=64]"+description+"[/font_size]"
	
	
func on_pickup_init():
	var rewardbar = game_control.get_node("UI/Rewardbar")
	player = game_control.player # here cause putting it in _ready() is too quick
	reparent(rewardbar)
	game_control.current_rewards.append(self)
	game_control.position_rewards()
	sprite.offset = Vector2.ZERO
	sprite.position = Vector2(0,0)
	sprite.scale = Vector2.ONE * 0.5
	# $Area2D.queue_free(), needed for tooltip
	shake_timer = shake_duration
	if not floating: game_control.exit_rewards()
	player.move.connect(on_move)
	player.kill.connect(on_kill)
	on_pickup()
	
	
func remove_reward():
	shake_timer = shake_duration
	await shake_done
	game_control.current_rewards.erase(self)
	game_control.position_rewards()
	queue_free()
	
	
## Set init properties here
func before_pickup():
	pass
	
	
func on_pickup():
	pass
	
	
func on_move(dir: Vector2):
	pass


func on_kill(color: String):
	pass
