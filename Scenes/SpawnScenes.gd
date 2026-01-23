extends TileMapLayer

var seaweed: PackedScene = load("res://Scenes/seaweed.tscn")
var fish: PackedScene = load("res://Scenes/fish.tscn")
var jelly: PackedScene = load("res://Scenes/jelly.tscn")
var octo: PackedScene = load("res://Scenes/octo.tscn")
var only_one = false

 
func _init():
	replace_tiles(103, load("res://Scenes/jelly.tscn"))
	replace_tiles(50, load("res://Scenes/seaweed.tscn"))
	replace_tiles(101, load("res://Scenes/fish.tscn"))
	replace_tiles(102, load("res://Scenes/octo.tscn"))


func replace_tiles(id, scene):
	var matching_cells = get_used_cells_by_id(id, Vector2.ZERO)
	for cell in matching_cells:
		var instance = scene.instantiate()
		instance.position = map_to_local(cell)
		if instance.get("color"):
			instance.color = "unassigned"
		add_child(instance)
		set_cell(cell, -1) 
