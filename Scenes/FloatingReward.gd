extends Node2D


@export var reward_script: Script
@export var rune_num: int


func _ready():
	$Reward.set_script(reward_script)
	if $Reward is Rune:
		$Reward.rune_num = rune_num
		$Reward.before_pickup()
