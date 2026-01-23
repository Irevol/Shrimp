extends Node2D


@export var reward_script: Script
var reward_scene: PackedScene = load("res://Scenes/reward.tscn")
@export var rune_num: int


func _ready():
	var cur = reward_scene.instantiate()
	cur.set_script(reward_script)
	add_child(cur)
	cur.z_index = 20
	if cur is Rune:
		cur.rune_num = rune_num
		cur.before_pickup()
