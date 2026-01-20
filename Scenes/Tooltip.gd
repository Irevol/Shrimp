extends Node2D
class_name Tooltip

@onready var label: RichTextLabel = $"PanelContainer/MarginContainer/RichTextLabel"


func display(text: String):
	label.text = text
	label.visible_ratio = 0
	var tween: Tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1, text.length()*0.1)
	return await tween.finished
	
	
func undisplay():
	var tween: Tween = create_tween()
	tween.tween_property(label, "visible_ratio", 0, label.text.length()*0.1)
