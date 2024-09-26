extends Node3D

@onready var tree_sprite = $Sprite3D
var units_behind_tree = []

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("units"): 
		print("there is someone here")
		units_behind_tree.append(area)
		update_tree_opacity()


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("units"):
		units_behind_tree.erase(area)
		update_tree_opacity()

func update_tree_opacity():
	if units_behind_tree.size() > 0:
		make_tree_transparent()
	else:
		make_tree_opaque()

func make_tree_transparent():
	tree_sprite.modulate.a = 0.2

func make_tree_opaque():
	tree_sprite.modulate.a = 1.0

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("units"): 
		print("there is someone here")
		units_behind_tree.append(body)
		update_tree_opacity()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("units"):
		print("exit")
		units_behind_tree.erase(body)
		update_tree_opacity()
