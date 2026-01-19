extends Node2D
class_name RewardMap
##map area that appears to grant upgrades

@export var rewards: Array[Script]
@export var reward: PackedScene


func _ready():
	hide()
	
	
func generate_rewards():
	for i in range(3):
		var reward_script = rewards.pick_random()
		var new_reward = reward.instantiate()
		new_reward.set_script(reward_script)
		get_node("Reward Stand "+str(i)).add_child(new_reward)
	
