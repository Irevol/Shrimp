extends Reward
class_name Rune

@export var rune_num = 0
var time = 0
var freq = 2*PI*0.3
var two_pi = 2*PI
const names = ["Cryptic Rune", "Mystic Rune", "Arcane Rune"]


func _process(delta: float):
	super(delta)
	time += freq*delta
	if time > two_pi:
		time -= two_pi
	sprite.offset.y = sin(time) * 16


func before_pickup():
	set_description(names[rune_num], "An odd symbol...")
	light.show()
	sprite.sprite_frames = game_control.rune_anims[rune_num]
	
		
func on_pickup():
	pass
	
