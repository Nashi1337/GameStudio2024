extends Node3D

# Grid dimensions
var grid_size = Vector2(10, 10)
var tile_spacing = 6.0  # The space between each tile

# Tile mesh (can be set in the editor or loaded via script)
#@onready var tile_scene : PackedScene = preload("res://Scenes/ground_tile.tscn")
#@onready var unit_scene : PackedScene = preload("res://Scenes/unit.tscn")
var selected_unit : Node3D = null
@onready var hud_character_info = get_tree().root.get_node("BattleMap/CanvasLayer/HUD/InfoBar/CharacterInfo")

func create_grid():
	var tile_scene : PackedScene = preload("res://Scenes/ground_tile.tscn")
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var tile_instance = tile_scene.instantiate()
			add_child.call_deferred(tile_instance)
			tile_instance.add_to_group("tiles")
			
			tile_instance.transform.origin = Vector3(x * tile_spacing, 0, y * tile_spacing)

			if tile_instance.has_method("set_coordinates"):
				tile_instance.call("set_coordinates", Vector2(x, y))

func select_unit(unit:Node3D):
	selected_unit = unit
	print("Selected Unit: ", unit)
	if(unit!=null):
		hud_character_info.text = selected_unit.name
	else:
		hud_character_info.text = ""
	
func get_selected_unit():
	return selected_unit

func place_units() -> void:
	var unit_scene : PackedScene = preload("res://Scenes/unit.tscn")
	var unit = unit_scene.instantiate()
	unit.position = Vector3(6,1.5,0)
	get_tree().root.get_node("BattleMap/Units").add_child(unit)
	unit.scale = Vector3(0.25,0.25,0.25)
	unit.add_to_group("units")
	unit.give_name("Lizard")
	unit.set_initiative(randi() % 10)
	unit.set_move_range(randi() % 5)
	unit.set_is_enemy(true)
