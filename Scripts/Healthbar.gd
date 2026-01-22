extends Node2D
class_name Healthbar

@export var heart: PackedScene
var hearts: Array[AnimatedSprite2D] = []
const spacing = 128
var freq = 2*PI*0.3
var true_value = 60
var two_pi = 2*PI
var time: float = 0

func _process(delta: float):
	time += freq*delta
	if time > two_pi:
		time -= two_pi
	for i in range(hearts.size()):
		hearts[i].offset.y = sin(time+i*0.75) * 20
		

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
			var new_heart: Heart = heart.instantiate()
			add_child(new_heart)
			new_heart.position.x = (cur_amnt + i) * spacing
			hearts.append(new_heart)
			
