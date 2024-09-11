extends Node3D

var selected = false
var path_follow : PathFollow3D
@onready var game_manager = get_node("/root/BattleMap")
var path_total_length: float = 0.0
var go = false

func _ready():
	path_follow = $RigidBody3D/Path3D/PathFollow3D

func move_to_position(destination: Vector3):
	# Generate the path from the player's current position to the destination
	var path = $RigidBody3D/Path3D.curve
	path.clear_points()
	path.add_point(global_transform.origin)  # Start from the current player position
	path.add_point(destination)  # End at the clicked tile position
	# Start moving along the path
	#path_follow.set_offset(0)  # Reset the path follow position
	path_total_length = $RigidBody3D/Path3D.curve.get_baked_length()/2
	path_follow.loop = false  # Disable looping if necessary
	# Optionally: Use an animation or tweens to move the player along the path
	# We'll move the player manually in the process function
	go = true
	print("Moving to: ", destination)

func _process(delta):
	# Move the player along the path
	if selected and path_follow and go:
		path_follow.progress += 10 * delta  # Adjust speed as needed
		global_transform.origin = path_follow.position
		print("Progress: ", path_follow.progress)
		print("Total length: ", path_total_length)
		if path_follow.progress >= path_total_length:
			print("unit should stop")
			selected = false  # Deselect when the movement is complete
			game_manager.call("select_unit", null)
			go = false
			path_follow.progress = path_total_length


func _on_rigid_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		game_manager.call("select_unit", self)
		selected = true
