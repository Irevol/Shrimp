extends Reward
class_name Win


func before_pickup():
	sprite.sprite_frames = load("res://Animations/rice.tres")
	sprite.play("default")
	set_description("Shrimp Fried Rice","""You've beat the game!\nEnjoy a delicious treat""")
	

func on_pickup():
	game_control.on_win()
