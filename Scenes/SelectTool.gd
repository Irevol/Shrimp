@tool
extends Node

@export var target_node: Node = null

func _unhandled_input(event):
	if event.is_action_pressed("select_other"):
		target_node = get_tree().edited_scene_root.get_node("Other")
		if target_node != null:
			print("Selected node: ", target_node.name)
			if target_node is Control:
				target_node.grab_focus()
			get_viewport().set_input_as_handled()
		else:
			print("huh")
	if event.is_action_pressed("select_enemy"):
		target_node = get_tree().edited_scene_root.get_node("Enemy")
		if target_node != null:
			print("Selected node: ", target_node.name)
			if target_node is Control:
				target_node.grab_focus()
			get_viewport().set_input_as_handled()
	if event.is_action_pressed("select_keys"):
		target_node = get_tree().edited_scene_root.get_node("Keys")
		if target_node != null:
			print("Selected node: ", target_node.name)
			if target_node is Control:
				target_node.grab_focus()
			get_viewport().set_input_as_handled()
