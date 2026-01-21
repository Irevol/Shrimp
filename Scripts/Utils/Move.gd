extends Node2D
class_name Move
## Use "move_to_pos" to move parent

@export var move_speed = 3
var tween_trans = Tween.TRANS_QUAD
var tween_ease = Tween.EASE_OUT
var tween: Tween


func move_to_pos(pos):
	if tween: tween.kill()
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_ease(tween_ease)
	tween.set_trans(tween_trans)
	tween.tween_property(get_parent(), "global_position", pos, 1.0 / move_speed)
	return await tween.finished
