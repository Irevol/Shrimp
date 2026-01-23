extends Node2D
class_name Tooltip

@onready var label: RichTextLabel = $"PanelContainer/MarginContainer/RichTextLabel"

func _ready():
	label.text = ""


func display(text: String):
	print("display called")
	label.text = "[wave amp=30.0 freq=5.0 connected=0]"+text+"[/wave]"
	label.visible_ratio = 0
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "visible_ratio", 1, label.text.length()*0.01)
	return await tween.finished
	
	
func undisplay():
	var tween: Tween = get_tree().create_tween()
	print("undisplay called")
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(label, "visible_ratio", 0, label.text.length()*0.01)
