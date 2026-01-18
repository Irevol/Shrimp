extends Node2D
class_name Player

@onready var game_control: GameControl = get_tree().current_scene #just gets root node
@export var health: int
@export var max_health: int
var can_press_key = true

@export var shake_intensity: float = 25.0
@export var shake_duration: float = 0.5
var shake_timer: float = 0.0


func _ready():
	$AnimatedSprite2D.play("idle")


# purely for shake effect atm
func _process(delta: float):
	if shake_timer > 0:
		shake_timer -= delta
		var current_strength = (shake_timer / shake_duration) * shake_intensity
		$AnimatedSprite2D.offset = Vector2(randf_range(-current_strength, current_strength),randf_range(-current_strength, current_strength))
	else:
		shake_timer = 0
		$AnimatedSprite2D.offset = Vector2.ZERO
		

func _physics_process(_delta):
	if can_press_key:
		var input_dir = Vector2.ZERO
		if Input.is_action_pressed("ui_right"):
			input_dir = Vector2.RIGHT
		elif Input.is_action_pressed("ui_left"):
			input_dir = Vector2.LEFT
		elif Input.is_action_pressed("ui_up"):
			input_dir = Vector2.UP
		elif Input.is_action_pressed("ui_down"):
			input_dir = Vector2.DOWN
		if input_dir != Vector2.ZERO:
			can_press_key = false
			move_in_dir(input_dir)
		
		
func take_damage():
	print("damaged")
	apply_shake()
	if health == 1:
		# die 
		pass
	else:
		health -= 1
		

func apply_shake():
	shake_timer = shake_duration
		
		
func play_animation(anim_name: String):
	$AnimatedSprite2D.play(anim_name)
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("idle")
	

func move_in_dir(dir):
	var target_pos = position + (dir * game_control.tile_size)
	var allow_move = false
	var prevent_move = false
	var detected_nodes = $DetectTile.detect_tile(target_pos)
	
	if dir.x == 1:
		$AnimatedSprite2D.flip_h = true
	elif dir.x == -1:
		$AnimatedSprite2D.flip_h = false
	
	if detected_nodes:
		for node: Node2D in detected_nodes:
			print(node.name)
			if node is Enemy:
				node.take_damage()
				prevent_move = true
			if node.is_in_group("walkable"):
				allow_move = true
				
	if not prevent_move and allow_move:
		await $Move.move_to_pos(target_pos)
	else:
		await $Move.move_to_pos(position + (dir * 32))
		await $Move.move_to_pos(position - (dir * 32))

	game_control.start_enemy_turn()
