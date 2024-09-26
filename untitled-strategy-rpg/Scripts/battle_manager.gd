extends Control

var active_character = null;
var turn_order = []
@onready var active_unit_label = get_node("/root/BattleMap/CanvasLayer/HUD/TopBar/ActiveCharacter")
@onready var battle_map = get_node("/root/BattleMap")

func _ready() -> void:
	battle_map.create_grid()
	battle_map.place_units()
	determine_turn_order()

func determine_turn_order() -> void:
	turn_order.clear()
	
	var units = get_node("/root/BattleMap/Units").get_children()
	print(units)
	for unit in units:
		if unit.has_method("get_initiative"):
			turn_order.append(unit)
			
	turn_order.sort_custom(compare_initiative)
	
	active_character=turn_order[0]
	active_unit_label.text = active_character.get_unit_name() + "'s turn"
	print(turn_order)
	
func compare_initiative(unit1, unit2) -> int:
	var initiative1 = unit1.get_initiative()
	var initiative2 = unit2.get_initiative()
		
	return initiative2 - initiative1
	
func next_turn() -> void:
	var current_unit = turn_order.pop_front()
	turn_order.append(current_unit)
	
	active_character = turn_order[0]
	active_unit_label.text = active_character.get_unit_name() + "'s turn"
	print("Next active character: ", active_character.name)
