@abstract
extends Node2D
class_name Reward

var shake_intensity: float = 25.0
var shake_duration: float = 0.5
var shake_timer: float = -1
var id: String
var game_control: GameControl
var player: Player
const spacing = 128


func _ready():
	game_control = get_tree().current_scene
	player = game_control.player
	player.move.connect(on_move)
	player.kill.connect(on_kill)
	
	
func _process(delta: float):
	if shake_timer == -1:
		return
	if shake_timer > 0:
		shake_timer -= delta
		var current_strength = (shake_timer / shake_duration) * shake_intensity
		$AnimatedSprite2D.offset = Vector2(randf_range(-current_strength, current_strength),randf_range(-current_strength, current_strength))
	else:
		shake_timer = 0
		$AnimatedSprite2D.offset = Vector2.ZERO
	
	
func on_pickup_init():
	var rewardbar = game_control.get_node("UI/Rewardbar")
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	reparent(rewardbar)
	position = Vector2(spacing * game_control.current_rewards.size(), 0)
	game_control.current_rewards.append(self)
	sprite.offset = Vector2.ZERO
	sprite.scale = Vector2.ONE * 0.5
	$Area2D.queue_free()
	shake_timer = shake_duration
	game_control.exit_rewards()
	on_pickup()
	
	
func on_pickup():
	pass
	
	
func on_move(dir: Vector2):
	pass


func on_kill(color: String):
	pass
