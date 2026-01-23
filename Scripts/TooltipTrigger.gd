extends Node2D
class_name TooltipTrigger

@export var text := "text"
@onready var game_control = get_tree().current_scene
@export var floating := true


#func _on_area_2d_mouse_entered() -> void:
	#print("hi")
	#game_control.get_node("UI/Tooltip").display(text)
#
#
#func _on_area_2d_mouse_exited() -> void:
	#game_control.get_node("UI/Tooltip").undisplay()
