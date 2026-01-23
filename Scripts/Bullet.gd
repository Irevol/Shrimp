extends Node2D
class_name Bullet

var dir := Vector2.UP
var damage := 1
var damage_enemies := false
var firer: Node2D
var not_on_screen = 0
@onready var notifier: VisibleOnScreenNotifier2D = $Notifier


func _ready():
	$AnimatedSprite2D.play("default")
	print("huh?")
	if dir == Vector2.ZERO:
		queue_free()


func _physics_process(delta: float):
	global_position += dir * 288 * 5 * delta
	if not notifier.is_on_screen():
		if not_on_screen < 10:
			not_on_screen += 1
		else:
			queue_free()


func _on_area_2d_area_entered(area: Area2D):
	var parent: Node2D = area.get_parent()
	if parent == firer: 
		return
	if (parent is Player and not damage_enemies) or (parent is Enemy and damage_enemies):
		for i in range(damage):
			if firer is Player:
				firer.play_animation("attack")
				firer.kills -= 0.5
			parent.take_damage()
			get_tree().current_scene.init_slash(position) #game control
		queue_free()
	elif parent is Seaweed:
		parent.queue_free()
		queue_free()
	elif parent.is_in_group("unwalkable"):
		queue_free()


func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("unwalkable"):
		queue_free()
