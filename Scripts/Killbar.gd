extends Sprite2D
class_name Killbar
	

func _ready():
	$Mask/Meter.play("default")
	

func update(new_value):
	$Mask/Meter.offset.y = 245 + new_value*(-260)
	
	
