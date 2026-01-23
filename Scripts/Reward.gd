@abstract
extends Node2D
class_name Reward

var shake_intensity: float = 25.0
var shake_duration: float = 0.5
var shake_timer: float = -10
var id: String
@onready var game_control: GameControl = get_tree().current_scene
var player: Player
var unique := false
var floating := true
@onready var text_display: Tooltip = game_control.get_node("UI/Tooltip")
@onready var area2d: Area2D = $Area2D
@export var debug = false
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $AnimatedSprite2D/PointLight2D
@onready var label: RichTextLabel = $AnimatedSprite2D/RichTextLabel

signal shake_done


func _ready():
	await get_tree().process_frame
	if unique:
		game_control.reward_map.cur_rewards.erase(get_script())
	print(light)
	light.show()
	#area2d.mouse_entered.connect(mouse_entered)
	#area2d.mouse_exited.connect(mouse_exited)
	before_pickup()
	if debug:
		await get_tree().process_frame
		await get_tree().process_frame
		on_pickup_init()
	
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
		
		
func mouse_entered():
	pass
	#text_display.display($Tooltip.text)
	
	 
func mouse_exited():
	pass
	#text_display.undisplay()
		

func set_description(title, description):
	$Tooltip.text = title+'\n'+"[font_size=64]\n"+description+"[/font_size]"
	
	
func on_pickup_init():
	var rewardbar = game_control.get_node("UI/Rewardbar")
	player = game_control.player # here cause putting it in _ready() is too quick
	reparent(rewardbar)
	game_control.current_rewards.append(self)
	game_control.position_rewards()
	sprite.offset = Vector2.ZERO
	sprite.position = Vector2(0,0)
	sprite.scale = Vector2.ONE * 0.5
	$Tooltip/Area2D.queue_free()
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
	
	
func shake():
	shake_timer = shake_duration
	
	
## Set init properties here
func before_pickup():
	pass
	
	
func on_pickup():
	pass
	
	
func on_move(_dir: Vector2):
	pass


func on_kill(_color: String):
	pass
