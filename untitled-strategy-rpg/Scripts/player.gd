extends Node3D

var selected = false
var path_follow : PathFollow3D
var selected_tile = null
@onready var game_manager = get_node("/root/BattleMap")
@onready var hud_character_info = get_tree().root.get_node("BattleMap/CanvasLayer/HUD/Panel/TileInfo")
var path_total_length: float = 0.0
var go = false
var move_range = 5
var player_grid_position = Vector2(0,0)

func _ready():
	path_follow = $RigidBody3D/Path3D/PathFollow3D

func on_tile_clicked(tile):
	if selected and tile.is_highlighted():
		move_player_to_tile(tile)

func move_player_to_tile(tile):
	var tile_position = tile.global_transform.origin
	move_to_position(tile_position)
	remove_all_highlights()
	
func remove_all_highlights():
	var all_tiles = get_tree().get_nodes_in_group("tiles")
	for tile in all_tiles:
		tile.remove_highlight()

func move_to_position(destination: Vector3):
	var path = $RigidBody3D/Path3D.curve
	path.clear_points()
	path.add_point(global_transform.origin)
	path.add_point(destination)  

	path_total_length = $RigidBody3D/Path3D.curve.get_baked_length()/2
	path_follow.loop = false  
	go = true
	print("Moving to: ", destination)

func _process(delta):
	if selected and path_follow and go:
		path_follow.progress += 10 * delta
		global_transform.origin = path_follow.position
		print("Progress: ", path_follow.progress)
		print("Total length: ", path_total_length)
		if path_follow.progress >= path_total_length:
			print("unit should stop")
			selected = false 
			game_manager.call("select_unit", null)
			go = false
			path_follow.progress = path_total_length


func _on_rigid_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		game_manager.call("select_unit", self)
		selected = true
		highlight_tiles_in_range()
	
func highlight_tiles_in_range():
	var all_tiles = get_tree().get_nodes_in_group("tiles")
	for tile in all_tiles:
		var tile_coords = tile.grid_coordinates
		var distance = calculate_manhattan_distance(player_grid_position,tile_coords)
		if distance <= move_range:
			tile.highlight()
		else: tile.remove_highlight()
	
		
func calculate_manhattan_distance(start_coords:Vector2, target_coords:Vector2)-> int:
	return abs(start_coords.x - target_coords.x) + abs(start_coords.y - target_coords.y)
