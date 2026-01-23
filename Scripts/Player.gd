extends Node2D
class_name Player

@onready var game_control: GameControl = get_tree().current_scene #just gets root node
@export var health: int = 5
@export var max_health: int = 6
@export var starting_position := Vector2(0,0)
var can_press_key = true
var reward_walker = false
var reward_pos: Vector2
@export var max_kills_on_reset = 8
var max_kills: int
var kills: float
@export var invincible := false
@export var brightness := 0.5

@export var shake_intensity: float = 25.0
@export var shake_duration: float = 0.5
var shake_timer: float = 0.0
var bug_patch: bool = false
var tooltip_active: bool = false

signal move(dir: Vector2)
signal kill(color: String)


func _ready():
	starting_position = position
	
	
func reset():
	position = starting_position
	health = max_health
	max_kills = max_kills_on_reset
	update_killbar()
	game_control.healthbar.display_hearts(health)
	$AnimatedSprite2D.play("idle")
	game_control.reset()
	
	var tween = create_tween()
	tween.tween_property($PointLight2D, "energy", brightness, 1)


# purely for shake effect atm
func _process(delta: float):
	if shake_timer > 0:
		shake_timer -= delta
		var current_strength = (shake_timer / shake_duration) * shake_intensity
		$AnimatedSprite2D.offset = Vector2(randf_range(-current_strength, current_strength),randf_range(-current_strength, current_strength))
	else:
		shake_timer = 0
		$AnimatedSprite2D.offset = Vector2.ZERO
		

#func _physics_process(_delta):
	#if can_press_key and health > 0:
		#var input_dir = Vector2.ZERO
		#if Input.is_action_pressed("ui_right"):
			#input_dir = Vector2.RIGHT
		#elif Input.is_action_pressed("ui_left"):
			#input_dir = Vector2.LEFT
		#elif Input.is_action_pressed("ui_up"):
			#input_dir = Vector2.UP
		#elif Input.is_action_pressed("ui_down"):
			#input_dir = Vector2.DOWN
		#if input_dir != Vector2.ZERO:
			#print("registered")
			#can_press_key = false
			#move_in_dir(input_dir)
			#print("DONT DOUBLE TRIGGER")
			#move.emit(input_dir)
			

#reworked input, LETS HOPE THERE'S NOT MORE JITTER, EVER (((:::
func _input(event: InputEvent) -> void:
	if not can_press_key: return
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right") or event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		
		#kinda janky to put this here, put don't want to have to write naother input func
		if game_control.game_over:
			var tween := create_tween()
			tween.tween_property($PointLight2D, "energy", 0, 1)
			game_control.get_node("DeathScreen/Tooltip").undisplay()
			await tween.finished
			await get_tree().create_timer(0.7).timeout
			get_tree().reload_current_scene()
			return
			
		var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		move_in_dir(dir)
		can_press_key = false
			

# called AFTER kill signal
func after_kill():
	kills += 1
	if kills == max_kills:
		game_control.summon_rewards()
	update_killbar()


func update_killbar():
	var killbar = game_control.get_node("UI/Killbar")
	killbar.update(kills/max_kills)
		
		
func take_damage(amnt = 1):
	if reward_walker or game_control.game_over or invincible: return
	apply_shake()
	game_control.sound_effects.play_sound("hurt.mp3")
	health -= amnt
	game_control.healthbar.display_hearts(health)
	if health <= 0:
		can_press_key = false
		$AnimatedSprite2D.play("dead")
		game_control.on_die()
		

func apply_shake():
	shake_timer = shake_duration
		
		
func play_animation(anim_name: String):
	$AnimatedSprite2D.play(anim_name)
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("idle")
	
	
func change_light_mask(num):
	$PointLight2D.range_item_cull_mask = num
	

func move_in_dir(dir):
	
	var target_pos = position + (dir * game_control.tile_size)
	var allow_move = false
	var prevent_move = false
	var redo_turn = false
	var there_is_tooltip = false
	var detected_nodes = $DetectTile.detect_tile(target_pos)
	
	if dir.x == 1:
		$AnimatedSprite2D.flip_h = true
	elif dir.x == -1:
		$AnimatedSprite2D.flip_h = false
		
	if not reward_walker:
		move.emit(dir)
		
	if detected_nodes:
		for node: Node2D in detected_nodes:
			
			#print(node.name)
			if reward_walker:
				print("reward walking")
				if node.is_in_group("reward_walkable"):
					allow_move = true
				if node is Reward and not node.floating:
					node.on_pickup_init()
					return #game control handles restarting flow here
			else:
				if node.is_in_group("walkable"):
					allow_move = true
				if node.is_in_group("unwalkable"):
					prevent_move = true
					redo_turn = true
				if node is Seaweed:
					play_animation("attack")
					game_control.init_slash(node.position)
					prevent_move = true
					redo_turn = false #you can stall on this!
					node.queue_free()
				if node is Reward:
					node.on_pickup_init()
					prevent_move = false
				if node is Gate:
					prevent_move = not node.attempt_open()
				if node is Enemy:
					node.take_damage()
					play_animation("attack")
					game_control.init_slash(node.position)
					prevent_move = true
			if node is TooltipTrigger and (not prevent_move and allow_move):
				there_is_tooltip = true
				if not tooltip_active:
					tooltip_active = true
					$"../UI/Tooltip".display(node.text)
	
	if not there_is_tooltip and tooltip_active:
		tooltip_active = false
		$"../UI/Tooltip".undisplay()
	if not prevent_move and allow_move:
		play_animation("move")
		await $Move.move_to_pos(target_pos)
	else:
		game_control.sound_effects.play_sound("hurt.mp3")
		$Move.move_speed *= 2
		await $Move.move_to_pos(position + (dir * 32))
		await $Move.move_to_pos(position - (dir * 32))
		$Move.move_speed /= 2
		
	if not allow_move or redo_turn:
		can_press_key = true
	else:
		game_control.start_enemy_turn()


	
