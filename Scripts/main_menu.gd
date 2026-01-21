extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# COMMENT ME OUT!
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	

func _exit_tree():
	$AudioStreamPlayer.stop()
