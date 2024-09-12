extends Node3D

# Grid dimensions
var grid_size = Vector2(10, 10)
var tile_spacing = 6.0  # The space between each tile

# Tile mesh (can be set in the editor or loaded via script)
var tile_scene : PackedScene
var selected_unit : Node3D = null

func _ready():
	tile_scene = preload("res://Scenes/ground_tile.tscn")  # Load a tile scene (create a separate scene for a single tile)
	create_grid()

func create_grid():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var tile_instance = tile_scene.instantiate()  # Create an instance of the tile
			add_child(tile_instance)  # Add the tile to the scene
			tile_instance.add_to_group("tiles")
			# Position the tile
			tile_instance.transform.origin = Vector3(x * tile_spacing, 0, y * tile_spacing)

			# Assign tile coordinates to its script (if necessary)
			if tile_instance.has_method("set_coordinates"):
				tile_instance.call("set_coordinates", Vector2(x, y))

func select_unit(unit:Node3D):
	selected_unit = unit
	print("Selected Unit: ", unit)
	
func get_selected_unit():
	return selected_unit
