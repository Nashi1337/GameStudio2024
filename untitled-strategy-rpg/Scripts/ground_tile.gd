extends Node3D

var grid_position : Vector2
var selected_player: Node3D
var original_color : Color
var highlight_color : Color = Color(0.5,0.8,0.5)
var in_range_color : Color = Color(0.278,0.522,0.959)
var border_material : StandardMaterial3D
var type : String
var grid_coordinates = Vector2()
var mouse_over = false
var in_range = false
@onready var border : MeshInstance3D
@onready var game_manager = get_node("/root/BattleMap")
@onready var tree_scene = preload("res://Scenes/tree.tscn")
@onready var label = get_tree().root.get_node("BattleMap/CanvasLayer/HUD/TileInfo")
@onready var camera = get_viewport().get_camera_3d()

func _ready() -> void:
	type = "Grass"
	maybe_spawn_tree()
	setup_border()
	label.visible = false

func setup_border():
	border = $Border
	border_material = StandardMaterial3D.new()
	original_color = Color(0.1,0.1,0.1)
	border_material.albedo_color = original_color
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

func set_coordinates(coords: Vector2):
	grid_coordinates = coords

func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if Input.is_action_just_pressed("ui_leftMouseClick"):
		if game_manager.call("get_selected_unit")!=null:
			selected_player = game_manager.call("get_selected_unit")
			var destination = global_transform.origin
			selected_player.call("move_to_position", destination)
			print("Tile clicked at: ", grid_position)


func _on_static_body_3d_mouse_entered() -> void:
	mouse_over = true
	border_material.albedo_color = highlight_color
	label.text = type
	label.visible = true
	
func _on_static_body_3d_mouse_exited() -> void:
	if mouse_over and not in_range:
		remove_highlight()
		label.visible = false
		mouse_over=false
	elif mouse_over and in_range:
		label.visible = false
		mouse_over = false
		highlight()

func highlight():
	in_range = true
	border_material.albedo_color = in_range_color

func remove_highlight():
	border_material.albedo_color = original_color
