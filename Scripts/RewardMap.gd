extends Node2D
class_name RewardMap
##map area that appears to grant upgrades

@export var rewards: Array[Script]
@onready var cur_rewards: Array[Script] = rewards
@export var reward: PackedScene
var reward_nodes: Array[Reward]


func _ready():
	$Opacity.modulate.a = 0
	
	
func tween_shader_method(node: CanvasItem, param: String, start: float, end: float, duration: float):
	var mat = node.material
	var tw = create_tween()
	tw.tween_method(mat.set_shader_parameter.bind(param), start, end, duration)
	
	
func transition_in():
	$Opacity/Distort.show()
	var tween = create_tween()
	tween.tween_property($Opacity, "modulate:a", 1.0, 1)
	return await tween.finished
	


func transition_out():
	$Opacity/Distort.hide()
	await get_tree().create_timer(0.5).timeout
	for node in reward_nodes:
		if node.get_parent().get_parent().get_parent() == self: node.queue_free()
	reward_nodes.clear()
	var tween = create_tween()
	tween.tween_property($Opacity, "modulate:a", 0.0, 1)
	await tween.finished
	
	
func generate_rewards():
	for i in range(3):
		var reward_script = cur_rewards.pick_random()
		var new_reward = reward.instantiate()
		new_reward.set_script(reward_script)
		new_reward.floating = false
		reward_nodes.append(new_reward)
		get_node("Opacity/Reward Stand "+str(i)).add_child(new_reward)
	
