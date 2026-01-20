extends TextureProgressBar
class_name Killbar
##unused

var time = 0
var freq = 2*PI*0.25
var true_value = 60
var two_pi = 2*PI
var shifting: int = 0
	

func _process(delta: float):
	if shifting == 1:
		value += 25 * delta
		if value >= true_value:
			value = true_value
			shifting = 0
	elif shifting == -1:
		value -= 25 * delta
		if value <= true_value:
			value = true_value
			shifting = 0	
	else:
		time += freq*delta
		if time > two_pi:
			time -= two_pi
		value = true_value + sin(time) * 3
	

func update(new_value):
	shifting = sign(new_value-true_value)
	true_value = new_value
	
	
