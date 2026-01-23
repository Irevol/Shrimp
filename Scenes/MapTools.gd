@tool
extends Node2D

func _notification(what):
	if Engine.is_editor_hint():
		if what == NOTIFICATION_PARENTED:
			call_deferred("_auto_reparent")

func _auto_reparent():
	var target_parent_name = "Other"
	var scene_root = get_tree().edited_scene_root
	if scene_root is Enemy:
		target_parent_name = "Enemies"
	elif scene_root.name == "FloatingReward":
		target_parent_name = "Keys"
	
	if scene_root:
		var target = scene_root.find_child(target_parent_name, true, false)
		if target and get_parent() != target:
			# Reparent the node
			get_parent().remove_child(self)
			target.add_child(self)
			# Crucial: Set owner so it saves with the scene
			self.owner = scene_root 
