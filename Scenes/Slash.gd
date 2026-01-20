extends AnimatedSprite2D
class_name Slash


func _ready():
	play("default")
	await animation_finished
	queue_free()
