extends Sprite2D
class_name Killbar
	

func _ready():
	$Mask/Meter.play("default")
	

func update(new_value):
	$Mask/Meter.offset.y = 235 + new_value*(-255)
	
	
