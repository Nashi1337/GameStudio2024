extends Node3D

var grid_position : Vector2
var selected_player: Node3D
@onready var border : MeshInstance3D
@onready var game_manager = get_node("/root/BattleMap")
@onready var tree_scene = preload("res://Scenes/tree.tscn")

func _ready() -> void:
	maybe_spawn_tree()
	#setup_border()

func setup_border():
	border = $Border
	#border.scale = Vector3()
	var border_material = StandardMaterial3D.new()
	border_material.albedo_color = Color(0.1,0.1,0.1)
	border.material_override = border_material

func maybe_spawn_tree():
	if randi() % 3 == 0:
		var tree_instance = tree_scene.instantiate()
		
		var tree_sprite = tree_instance.get_node("Sprite3D")
		tree_sprite.frame = randi() % 5 
		
		add_child(tree_instance)
		
		tree_instance.scale = Vector3(1,50,1)
		var random_pos = Vector3(randf() * 1.0 -0.5, 0, randf() * 1.0 - 0.5)
		tree_instance.position = Vector3(random_pos.x,33,random_pos.z)
		
		print("Tree spawned with frame: ", tree_sprite.frame)

func set_coordinates(pos : Vector2):
	grid_position = pos

func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if Input.is_action_just_pressed("ui_leftMouseClick"):
		if game_manager.call("get_selected_unit")!=null:
			selected_player = game_manager.call("get_selected_unit")
			var destination = global_transform.origin
			selected_player.call("move_to_position", destination)
			print("Tile clicked at: ", grid_position)
