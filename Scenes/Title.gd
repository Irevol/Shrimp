extends Node2D
class_name Title



func fade():
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
	await tween.finished
	queue_free()
