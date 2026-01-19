extends Node2D
class_name DetectTiles
## Detects nodes at a position via detect_tile

@onready var query := PhysicsPointQueryParameters2D.new()


func _ready():
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	
func detect_tile(pos: Vector2):
	var found_nodes: Array
	var space_state = get_world_2d().direct_space_state
	query.position = pos
	var results = space_state.intersect_point(query, 10)
	query.canvas_instance_id = 0
	for result in results:
		if result.collider is Area2D:
			result.collider = result.collider.get_parent()
		found_nodes.append(result.collider)
	return found_nodes
