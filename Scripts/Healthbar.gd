extends Node2D
class_name Healthbar

@export var heart: PackedScene
var hearts: Array[AnimatedSprite2D] = []
const spacing = 128


func display_hearts(amnt: int):
	var cur_amnt = hearts.size()
	if amnt < 0:
		return
	if cur_amnt == amnt:
		return
	elif cur_amnt > amnt:
		for i in range(cur_amnt-amnt):
			hearts.pop_back().pop()
	else:
		for i in range(amnt-cur_amnt):
			var new_heart = heart.instantiate()
			add_child(new_heart)
			new_heart.position.x = (cur_amnt + i) * spacing
			hearts.append(new_heart)
			
