extends PointLight2D
class_name LightControl

@onready var game_control: GameControl = get_tree().current_scene


func _ready():
	game_control.kill_lights.connect(hide)
