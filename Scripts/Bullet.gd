extends Node2D
class_name Bullet

var dir := Vector2.UP
var damage := 1
var damage_enemies := false
var ignore_count = 1
@onready var notifier: VisibleOnScreenNotifier2D = $Notifier


func _ready():
	$AnimatedSprite2D.play("default")
	if dir == Vector2.ZERO:
		queue_free()


func _process(delta):
	global_position += dir * 288 * 6 * delta
	if not notifier.is_on_screen():
		queue_free()


func _on_area_2d_area_entered(area: Area2D):
	if ignore_count > 0: #to stop it from hitting whatever spawned it
		ignore_count -= 1
		return
	var parent: Node2D = area.get_parent()
	if parent is Player or parent is Enemy:
		if (damage_enemies) or (parent is Player):
			for i in range(damage+1):
				parent.take_damage()
				print("damaged!")
		print(parent.name)
		queue_free()
	elif not parent.is_in_group("walkable"):
		queue_free()
