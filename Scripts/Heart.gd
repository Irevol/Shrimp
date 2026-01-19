extends AnimatedSprite2D
class_name Heart


func _ready():
	play("pop")
	await animation_finished
	play("default")
	stop() #cause no actual idle anim


func pop():
	play("pop")
	await animation_finished
	queue_free()
