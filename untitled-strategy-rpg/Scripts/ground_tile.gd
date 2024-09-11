extends Node3D

var grid_position : Vector2
var selected_player: Node3D
@onready var game_manager = get_node("/root/BattleMap")

func set_coordinates(pos : Vector2):
	grid_position = pos

func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if Input.is_action_just_pressed("ui_leftMouseClick"):
		if game_manager.call("get_selected_unit")!=null:
			selected_player = game_manager.call("get_selected_unit")
			var destination = global_transform.origin
			selected_player.call("move_to_position", destination)
			print("Tile clicked at: ", grid_position)
