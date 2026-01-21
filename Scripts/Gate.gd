extends Node2D
class_name Gate

@export var rune_num: int = 0
var time = 0
var freq = 2*PI*0.3
var two_pi = 2*PI
@onready var game_control: GameControl = get_tree().current_scene
var open := false


func _process(delta: float):
	if not open:
		time += freq*delta
		if time > two_pi:
			time -= two_pi
		$Rune.offset.y = sin(time) * 16


func _ready():
	$Rune.sprite_frames = game_control.rune_anims[rune_num]
	$AnimatedSprite2D.animation = "close"
	$AnimatedSprite2D.frame = 4
	
	
func attempt_open():
	if open: return true
	for reward: Reward in game_control.current_rewards:
		if reward is Rune and reward.rune_num == rune_num:
			open = true
			open_gate_with(reward)
	return false
	
	
func open_gate_with(reward: Reward):
	$AnimatedSprite2D.frame = 4
	$AnimatedSprite2D.play("open")
	
	await $AnimatedSprite2D.animation_finished
	
	var tween = create_tween()
	tween.tween_property($Rune, "modulate:a", 0, 0.75)
	tween.tween_property($Rune/PointLight2D, "energy", 0, 0.5)
	await tween.finished
	reward.remove_reward()
	$Rune.queue_free()
	
