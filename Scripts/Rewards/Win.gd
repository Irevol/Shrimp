extends Reward
class_name Win

@export var rune_num = 1
var time = 0
var freq = 2*PI*0.3
var two_pi = 2*PI
const names = ["Cryptic Rune", "Mystic Rune", "Arcane Rune"]


func before_pickup():
	set_description("Shrimp Fried Rice\n''You're telling me a Shrimp fried this rice?''","You won the game!\nEnjoy some delicious fried rice")
	print(rune_num)
	light.energy = 0.6
	light.color = Color.WHITE
	modulate = Color.WHITE
	sprite.sprite_frames = load("res://Animations/rice.tres")
	
		
func on_pickup():
	game_control.on_win()
