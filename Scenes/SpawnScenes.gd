extends TileMapLayer

var seaweed: PackedScene = load("res://Scenes/seaweed.tscn")
var fish: PackedScene = load("res://Scenes/fish.tscn")
var jelly: PackedScene = load("res://Scenes/jelly.tscn")
var octo: PackedScene = load("res://Scenes/octo.tscn")


func _ready():
	replace_tiles(50, seaweed)
	replace_tiles(101, fish)
	replace_tiles(102, octo)
	replace_tiles(103, jelly)


func replace_tiles(id, scene):
	var matching_cells = get_used_cells_by_id(id, Vector2.ZERO)
	for cell in matching_cells:
		var instance = scene.instantiate()
		instance.position = map_to_local(cell)
		add_child(instance)
		set_cell(cell, -1) 
